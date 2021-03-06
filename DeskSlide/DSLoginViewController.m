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
//        | PFLogInFieldsPasswordForgotten
        | PFLogInFieldsDismissButton
        ;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"bg"];
    [self.view insertSubview:imageView atIndex:0];
    
    self.logInView.logo = [self _makeLogoWithFrame:self.logInView.logo.frame];

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
    
    [DSTracker trackView:@"login"];
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
    title.font = [UIFont systemFontOfSize:24.0f];
    
    UILabel* title2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 24, 280, 40)];
    title2.text = @"以前登録したユーザ名、パスワードを入力してください";
    title2.numberOfLines = 0;
    title2.textColor = [UIColor whiteColor];
    title2.backgroundColor = [UIColor clearColor];
    title2.font = [UIFont systemFontOfSize:16.0f];
    title2.textAlignment = NSTextAlignmentCenter;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [view addSubview:title];
    [view addSubview:title2];
    
    return view;
}


- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    
    [DSTracker trackEvent:@"tapped login button"];
    
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [UIAlertView showTitle:@"入力エラー" message:@"ユーザ名、パスワードを入力してください"];
    
    return NO; // Interrupt login process
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
    [DSTracker trackEvent:@"login success"];
    [self.loginDelegate logInViewController:self didLogInUser:user];
}
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [DSTracker trackEvent:@"login cancel"];
    [self.loginDelegate logInViewControllerDidCancel:self];
}




@end
