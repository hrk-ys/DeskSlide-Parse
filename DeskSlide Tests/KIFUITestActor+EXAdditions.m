//
//  KIFUITestActor+EXAdditions.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/10/11.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "KIFUITestActor+EXAdditions.h"

@implementation KIFUITestActor (EXAdditions)

- (void)navigateToLoginPage
{
    [self tapViewWithAccessibilityLabel:@"Login/Sign Up"];
    [self tapViewWithAccessibilityLabel:@"Skip this ad"];
}

- (void)returnToLoggedOutHomeScreen
{
    [self tapViewWithAccessibilityLabel:@"Logout"];
    [self tapViewWithAccessibilityLabel:@"Logout"]; // Dismiss alert.
}

@end
