//
//  DSSignUpViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/10/19.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSSignUpViewController.h"

@interface DSSignUpViewController ()
<PFSignUpViewControllerDelegate>

@end

@implementation DSSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"bg"];
    [self.view insertSubview:imageView atIndex:0];
    
    self.signUpView.logo = [self _makeLogoWithFrame:self.signUpView.logo.frame];
    self.signUpView.usernameField.placeholder = @"ユーザ名";
    self.signUpView.passwordField.placeholder = @"パスワード";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [DSTracker trackView:@"sign_up"];
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
    
    UILabel* title2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 280, 45)];
    title2.text = @"ユーザ名、パスワードを入力してください。";
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

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
    LOGTrace;
    [DSTracker trackEvent:@"tapped sign up button"];
    
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
    [DSTracker trackEvent:@"sign up success"];
    [self.signUpDelegate signUpViewController:self didLogInUser:user];
}
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    LOGTrace;
    [DSTracker trackEvent:@"sign up cancel"];
    [self.signUpDelegate signUpViewControllerDidCancel:self];
}

@end
