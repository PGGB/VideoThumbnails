//
//  ThumbnailerManager.h
//  VideoThumbnails
//
//  Created by Daniel Nagel on 21.10.13.
//  Copyright (c) 2013 PGGB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@interface ThumbnailerManager : NSObject
+ (ThumbnailerManager *)sharedInstance;
- (CGImageRef)createThumbnailWithRequest:(QLThumbnailRequestRef)request;
- (CGImageRef)createPreviewWithRequest:(QLPreviewRequestRef)request;
@end
