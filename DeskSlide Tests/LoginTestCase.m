//
//  LoginTestCase.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/10/11.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "LoginTestCase.h"
#import "KIFUITestActor+EXAdditions.h"

@implementation LoginTestCase

- (void)beforeEach
{
//    [tester navigateToLoginPage];
    [tester waitForTimeInterval:0.25];
}

- (void)afterEach
{
//    [tester returnToLoggedOutHomeScreen];
}

- (void)testSuccessfulLogin
{
    [tester tapViewWithAccessibilityLabel:@"Setting"];
    
    // Verify that the login succeeded
    [tester waitForViewWithAccessibilityLabel:@"DeskSlideとは"];
}

@end
