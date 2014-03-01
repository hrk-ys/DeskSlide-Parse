//
//  DSAppDelegate.h
//  DeskSlideOSX
//
//  Created by Hiroki Yoshifuji on 2014/02/27.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DSController.h"

@interface DSAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet DSController *controller;

@end
