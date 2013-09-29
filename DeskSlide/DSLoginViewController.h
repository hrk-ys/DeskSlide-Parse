//
//  DSLogiViewController.h
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/23.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import <Parse/Parse.h>

@protocol DSLoginViewControllerDelegate;
@interface DSLoginViewController : PFLogInViewController

@property (nonatomic) id<DSLoginViewControllerDelegate> loginDelegate;

@end

@protocol DSLoginViewControllerDelegate <NSObject>

- (void)logInViewController:(DSLoginViewController *)controller didLogInUser:(PFUser *)user;
- (void)logInViewControllerDidCancel:(DSLoginViewController *)controller;

@end