//
//  Thumbnailer.h
//  VideoThumbnails
//
//  Created by Daniel Nagel on 14.10.13.
//  Copyright (c) 2013 PGGB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickLook/QuickLook.h>

#include <vlc/vlc.h>

@interface Thumbnailer : NSObject

- (instancetype)initWithThumbnailRequest:(QLThumbnailRequestRef)thumbnailRequest;
- (instancetype)initWithPreviewRequest:(QLPreviewRequestRef)previewRequest;
- (void)createThumbnail;
- (void)didFetchImage;
- (BOOL)requestIsCancelled;
- (void)setInstance:(libvlc_instance_t *)instance;

@property(readonly) void *pixels;
@property(readonly) dispatch_semaphore_t thumbnailerSemaphore;
@property(readonly) CGImageRef thumbnail;
@property(readonly) NSSize size;

@end
