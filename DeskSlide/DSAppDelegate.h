//
//  DSAppDelegate.h
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/23.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;



// parse login
- (void)presentLoginViewController:(UIViewController*)controller animated:(BOOL)animated;
- (void)logOut;


@end
