//
//  main.m
//  ThumbnailService
//
//  Created by Daniel Nagel on 20.10.13.
//  Copyright (c) 2013 PGGB. All rights reserved.
//

#include <xpc/xpc.h>
#include <Foundation/Foundation.h>

#import "ThumbnailManager.h"

int main(int argc, const char *argv[])
{
    NSXPCListener *serviceListener = [NSXPCListener serviceListener];

    ThumbnailManager *sharedManager = [ThumbnailManager sharedInstance];

    serviceListener.delegate = sharedManager;
    [serviceListener resume];

    exit(EXIT_FAILURE);
}
