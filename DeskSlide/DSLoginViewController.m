//
//  DSLogiViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/23.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSLoginViewController.h"

@interface DSLoginViewController ()
<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@end

@implementation DSLoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.delegate = self;
        
        self.fields = PFLogInFieldsUsernameAndPassword
        | PFLogInFieldsLogInButton
        | PFLogInFieldsSignUpButton
//        | PFLogInFieldsFacebook
//        | PFLogInFieldsTwitter
        | PFLogInFieldsPasswordForgotten
        ;
        
        self.logInView.logo = [self _makeLogoWithFrame:self.logInView.logo.frame];
        
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        signUpViewController.signUpView.logo = [self _makeLogoWithFrame:signUpViewController.signUpView.logo.frame];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        [self setSignUpController:signUpViewController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)_makeLogoWithFrame:(CGRect)frame
{
    UILabel* title = [[UILabel alloc] initWithFrame:frame];
    title.text = APP_NAME;
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:18.0f];
    return title;
}


- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [UIAlertView showTitle:@"入力エラー" message:@"ユーザ名、パスワードを入力してください"];
    
    return NO; // Interrupt login process
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self.loginDelegate logInViewController:self didLogInUser:user];
}
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [self.loginDelegate logInViewControllerDidCancel:self];
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
    LOGTrace;
    NSString* username = info[@"username"];
    NSString* password = info[@"password"];
    
    if (username && password && username.length != 0 && password.length != 0) {
        return YES;
    }
    [UIAlertView showTitle:@"入力エラー" message:@"ユーザ名、パスワードを入力してください"];

    return NO;
}
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    LOGTrace;
    [self.loginDelegate logInViewController:self didLogInUser:user];
}
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    LOGTrace;
    [self.loginDelegate logInViewControllerDidCancel:self];
}

@end
