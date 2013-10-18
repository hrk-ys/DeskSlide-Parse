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
//        | PFLogInFieldsSignUpButton
//        | PFLogInFieldsFacebook
//        | PFLogInFieldsTwitter
        | PFLogInFieldsPasswordForgotten
        | PFLogInFieldsDismissButton
        ;
        
        self.logInView.logo = [self _makeLogoWithFrame:self.logInView.logo.frame];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"bg"];
    [self.view insertSubview:imageView atIndex:0];
	// Do any additional setup after loading the view.

//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
//    self.logInView.usernameField.backgroundColor = [UIColor grayColor];
//    self.logInView.usernameField.textColor = [UIColor blackColor];
    self.logInView.usernameField.placeholder = @"ユーザ名";
    self.logInView.passwordField.placeholder = @"パスワード";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)_makeLogoWithFrame:(CGRect)frame
{
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    title.text = APP_NAME;
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18.0f];
    
    UILabel* title2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    title2.text = @"以前登録したユーザ名、パスワードを入力してください";
    title2.numberOfLines = 0;
    title2.textColor = [UIColor whiteColor];
    title2.backgroundColor = [UIColor clearColor];
    title2.font = [UIFont systemFontOfSize:11.0f];
    title2.textAlignment = NSTextAlignmentCenter;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [view addSubview:title];
    [view addSubview:title2];
    
    return view;
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
