//
//  DSWelcomViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/10/18.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSAppDelegate.h"
#import "DSAuthViewController.h"
#import "DSLoginViewController.h"
#import "DSSignUpViewController.h"


#import <Parse/Parse.h>

@interface DSAuthViewController ()
<DSLoginViewControllerDelegate,
PFSignUpViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@end

@implementation DSAuthViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.registButton.clipsToBounds      = YES;
    self.registButton.layer.cornerRadius = 3.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)tappedRegistButton:(id)sender {
    LOGTrace;
    DSSignUpViewController *signUpViewController = [[DSSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate

    [self presentViewController:signUpViewController animated:YES completion:nil];
}
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    LOGTrace;
    [self.delegate authController:self didLoginUser:user];
}
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    LOGTrace;
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)tappedLoginButton:(id)sender {
    LOGTrace;
    DSLoginViewController *logInController = [[DSLoginViewController alloc] init];
    logInController.loginDelegate = self;

    [self presentViewController:logInController animated:YES completion:nil];
}


- (void)logInViewController:(DSLoginViewController *)controller didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate authController:self didLoginUser:user];
    }];
}

- (void)logInViewControllerDidCancel:(DSLoginViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
