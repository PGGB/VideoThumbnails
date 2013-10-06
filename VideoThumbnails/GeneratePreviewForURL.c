#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    CGRect rect = CGRectMake(0, 0, 500, 500);
    CGContextRef cgContext = QLPreviewRequestCreateContext(preview, rect.size, true, nil);
    if(cgContext)
    {
        CGContextSetRGBFillColor(cgContext, 1.0, 0.0, 0.0, 1.0);
        CGContextFillRect(cgContext, rect);
        QLPreviewRequestFlushContext(preview, cgContext);
        CFRelease(cgContext);
    }

    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
