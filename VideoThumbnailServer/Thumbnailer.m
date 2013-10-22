//
//  Thumbnailer.m
//  VideoThumbnails
//
//  Created by Daniel Nagel on 14.10.13.
//  Copyright (c) 2013 PGGB. All rights reserved.
//

#import "Thumbnailer.h"

static const float thumbnailerSeekPosition = 0.5f;

static void *lock(void *opaque, void **pixels)
{
    Thumbnailer *thumbnailer = (__bridge Thumbnailer *)(opaque);

    *pixels = [thumbnailer pixels];

    return NULL;
}

static void unlock(void *opaque, void *picture, void *const *p_pixels)
{
    Thumbnailer *thumbnailer = (__bridge Thumbnailer *)(opaque);

    if ([thumbnailer thumbnail])
        return;

    [thumbnailer performSelectorOnMainThread:@selector(didFetchImage) withObject:nil waitUntilDone:YES];
}


@interface Thumbnailer ()
{
    libvlc_instance_t     *_vlc_instance;
    libvlc_media_player_t *_vlc_media_player;
    libvlc_media_t        *_vlc_media;
}

@property NSURL *url;

@property QLThumbnailRequestRef thumbnailRequest;
@property QLPreviewRequestRef   previewRequest;

@property unsigned int receivedFrames;

@end


@implementation Thumbnailer

- (instancetype)initWithThumbnailRequest:(QLThumbnailRequestRef)thumbnailRequest
{
    self = [self init];

    if(self)
    {
        _url = (__bridge NSURL *)(QLThumbnailRequestCopyURL(thumbnailRequest));
        _size = QLThumbnailRequestGetMaximumSize(thumbnailRequest);
        _thumbnailRequest = thumbnailRequest;
        _thumbnailerSemaphore = dispatch_semaphore_create(0);
    }

    return self;
}

- (instancetype)initWithPreviewRequest:(QLPreviewRequestRef)previewRequest
{
    self = [self init];

    if(self)
    {
        _url = (__bridge NSURL *)(QLPreviewRequestCopyURL(previewRequest));
        _previewRequest = previewRequest;
        _thumbnailerSemaphore = dispatch_semaphore_create(0);
    }

    return self;
}

- (void)dealloc
{
    libvlc_media_release(_vlc_media);
    _vlc_media = NULL;
    libvlc_media_player_release (_vlc_media_player);
    _vlc_media_player = NULL;
}

- (void)createThumbnail
{
    _vlc_media = libvlc_media_new_location(_vlc_instance, [[_url absoluteString] UTF8String]);
    libvlc_media_add_option(_vlc_media, "no-audio");
    libvlc_media_parse(_vlc_media);

    libvlc_media_track_t **vlc_tracks;
    libvlc_video_track_t *video_track = NULL;
    unsigned int trackNumber = libvlc_media_tracks_get(_vlc_media, &vlc_tracks);

    // Find the video track
    for(int i = 0; i<trackNumber; ++i)
    {
        if(vlc_tracks[i]->i_type == libvlc_track_video)
        {
            video_track = vlc_tracks[i]->video;
            break;
        }
    }

    if(video_track)
    {
        int videoWidth  = video_track->i_width;
        int videoHeight = video_track->i_height;

        if(_size.width && _size.height)
        {
            if(_size.width / videoWidth < _size.height / videoHeight)
                _size.height = round(_size.width / videoWidth * videoHeight);
            else
                _size.width  = round(_size.height / videoHeight * videoWidth);
        }
        else
        {
            _size.width  = videoWidth;
            _size.height = videoHeight;
        }
    }
    _pixels = calloc(1, _size.width * _size.height * 4);

    _vlc_media_player = libvlc_media_player_new_from_media(_vlc_media);
    libvlc_video_set_format(_vlc_media_player, "RGBA", _size.width, _size.height, _size.width * 4);
    libvlc_video_set_callbacks(_vlc_media_player, lock, unlock, NULL, (__bridge void *)(self));

    libvlc_media_player_play(_vlc_media_player);
    libvlc_media_player_set_position(_vlc_media_player, thumbnailerSeekPosition);

    while(dispatch_semaphore_wait(_thumbnailerSemaphore, dispatch_time(DISPATCH_TIME_NOW, 1E09)))
    {
        if([self requestIsCancelled]) break;
    }

    libvlc_media_player_stop(_vlc_media_player);
}

- (void)didFetchImage
{
    ++_receivedFrames;

    if(libvlc_media_player_get_position(_vlc_media_player) < thumbnailerSeekPosition
       && libvlc_media_player_get_length(_vlc_media_player) > 1000
       && _receivedFrames < 10)
        return;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    const CGFloat width  = _size.width;
    const CGFloat height = _size.height;
    const CGFloat pitch  = 4 * width;
    CGContextRef bitmap = CGBitmapContextCreate(_pixels,
                                                width,
                                                height,
                                                8,
                                                pitch,
                                                colorSpace,
                                                kCGImageAlphaNoneSkipLast);

    CGColorSpaceRelease(colorSpace);
    _thumbnail = CGBitmapContextCreateImage(bitmap);
    CGContextRelease(bitmap);

    dispatch_semaphore_signal(_thumbnailerSemaphore);
}

- (BOOL)requestIsCancelled
{
    if(_thumbnailRequest)
        return QLThumbnailRequestIsCancelled(_thumbnailRequest);

    if(_previewRequest)
        return QLPreviewRequestIsCancelled(_previewRequest);

    return YES;
}

- (void)setInstance:(libvlc_instance_t *)instance
{
    _vlc_instance = instance;
}

@end
