//
//  ThumbnailManager.m
//  VideoThumbnails
//
//  Created by Daniel Nagel on 20.10.13.
//  Copyright (c) 2013 PGGB. All rights reserved.
//

#import "ThumbnailManager.h"

@implementation ThumbnailManager

+ (ThumbnailManager *)sharedInstance
{
    static ThumbnailManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [ThumbnailManager new];
    });

    return shared;
}

- (void)createThumbnailForURL:(NSURL *)url image:(CGImageRef)image
{
    
}

@end
