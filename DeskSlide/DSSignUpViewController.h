//
//  DSSignUpViewController.h
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/10/19.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import <Parse/Parse.h>

@protocol DSSignUpViewControllerDelegate;
@interface DSSignUpViewController : PFSignUpViewController

@property (nonatomic, assign) id<DSSignUpViewControllerDelegate>signUpDelegate;

@end

@protocol DSSignUpViewControllerDelegate <NSObject>

- (void)signUpViewController:(DSSignUpViewController *)controller didLogInUser:(PFUser *)user;
- (void)signUpViewControllerDidCancel:(DSSignUpViewController *)controller;

@end