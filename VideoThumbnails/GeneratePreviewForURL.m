#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

#import <Thumbnailer.h>

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    @autoreleasepool
    {
        Thumbnailer *thumbnailer = [[Thumbnailer alloc] initWithPreviewRequest:preview];
        [thumbnailer createThumbnail];

        NSSize size = [thumbnailer size];
        //NSSize size = NSMakeSize(1920, 1080);
        QLPreviewRequestSetDataRepresentation(preview, (CFDataRef)[thumbnailer thumbnail], kUTTypeVideo, NULL);
/*
        CGContextRef context = QLPreviewRequestCreateContext(preview, size, YES, NULL);
        if(context)
        {
            //CGContextDrawImage(context, NSMakeRect(0, 0, size.width, size.height), [thumbnailer thumbnail]);
            //QLPreviewRequestFlushContext(preview, context);

            CFRelease(context);
        }*/
    }
    
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
