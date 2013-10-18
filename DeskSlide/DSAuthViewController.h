//
//  DSWelcomViewController.h
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/10/18.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSAuthViewControllerDelegate;
@interface DSAuthViewController : UIViewController

@property (nonatomic) id <DSAuthViewControllerDelegate> delegate;

@end

@protocol DSAuthViewControllerDelegate <NSObject>

- (void)authController:(DSAuthViewController*)controller didLoginUser:(PFUser*)user;

@end
