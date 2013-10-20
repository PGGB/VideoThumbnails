//
//  ThumbnailManager.h
//  VideoThumbnails
//
//  Created by Daniel Nagel on 20.10.13.
//  Copyright (c) 2013 PGGB. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CreateThumbnail
- (void)createThumbnailForURL:(NSURL *)url image:(CGImageRef)image;
@end

@interface ThumbnailManager : NSObject <CreateThumbnail, NSXPCListenerDelegate>
+ (ThumbnailManager *)sharedInstance;
@end
