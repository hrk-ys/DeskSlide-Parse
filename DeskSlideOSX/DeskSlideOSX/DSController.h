//
//  DSController.h
//  DeskSlideOSX
//
//  Created by Hiroki Yoshifuji on 2014/02/27.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSController : NSObject
<NSMenuDelegate>

@property (weak) IBOutlet NSMenu           *statusMenu;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic) CGRect                barItemFrame;


@property (weak) IBOutlet NSMenuItem *loginMenuItem;
@property (weak) IBOutlet NSMenuItem *logoutMenuItem;
@property (weak) IBOutlet NSMenuItem *sendTextMenuItem;
@property (weak) IBOutlet NSMenuItem *sendImageMenuItem;
@property (weak) IBOutlet NSMenuItem *selectFileMenuItem;



@property (unsafe_unretained) IBOutlet NSWindow *loginWindow;
@property (weak) IBOutlet NSTextField           *usernameField;
@property (weak) IBOutlet NSSecureTextField     *passwordField;


- (void)updateMenuItem;

@end
