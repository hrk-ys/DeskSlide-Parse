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
    [self setupParse];
    
    [self.controller updateMenuItem];
}

- (void)setupParse
{
    [Parse setApplicationId:@"pFG9MpdcFCveSEsE7sD3gHQPa1UeH2ikIOeg2vFS"
                  clientKey:@"HiymDpcIsmQCXoYrWEgv89kAYvLbkjMn2p15gmlX"];
    
    PFACL *defaultACL = [PFACL ACL];
    // Enable public read access by default, with any newly created PFObjects belonging to the current user
    // [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
}

@end
