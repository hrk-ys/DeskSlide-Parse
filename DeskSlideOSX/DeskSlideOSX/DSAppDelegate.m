//
//  DSAppDelegate.m
//  DeskSlideOSX
//
//  Created by Hiroki Yoshifuji on 2014/02/27.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSAppDelegate.h"

#import <ParseOSX/Parse.h>

@implementation DSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [Parse setApplicationId:@"pFG9MpdcFCveSEsE7sD3gHQPa1UeH2ikIOeg2vFS"
                  clientKey:@"HiymDpcIsmQCXoYrWEgv89kAYvLbkjMn2p15gmlX"];
    
    [self.controller updateMenuItem];
}

@end
