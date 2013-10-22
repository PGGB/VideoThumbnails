//
//  ThumbnailerManager.m
//  VideoThumbnails
//
//  Created by Daniel Nagel on 21.10.13.
//  Copyright (c) 2013 PGGB. All rights reserved.
//

#import "ThumbnailerManager.h"
#import "Thumbnailer.h"

#include <vlc/vlc.h>

@interface ThumbnailerManager ()
@property libvlc_instance_t *vlc_instance;
@end

@implementation ThumbnailerManager

+ (ThumbnailerManager *)sharedInstance
{
    static ThumbnailerManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [ThumbnailerManager new];
    });

    return shared;
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        _vlc_instance = libvlc_new (0, NULL);
    }

    return self;
}

- (void)dealloc
{
    libvlc_release(_vlc_instance);
}

- (CGImageRef)createThumbnailWithRequest:(QLThumbnailRequestRef)request
{
    Thumbnailer *thumbnailer = [[Thumbnailer alloc] initWithThumbnailRequest:request];
    [thumbnailer setInstance:_vlc_instance];

    [thumbnailer createThumbnail];

    return [thumbnailer thumbnail];
}

- (CGImageRef)createPreviewWithRequest:(QLPreviewRequestRef)request
{
    return NULL;
}

@end
