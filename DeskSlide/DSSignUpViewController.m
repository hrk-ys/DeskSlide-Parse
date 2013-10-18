//
//  DSSignUpViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/10/19.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSSignUpViewController.h"

@interface DSSignUpViewController ()

@end

@implementation DSSignUpViewController

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
	// Do any additional setup after loading the view.
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"bg"];
    [self.view insertSubview:imageView atIndex:0];
    
    self.signUpView.logo = [self _makeLogoWithFrame:self.signUpView.logo.frame];
    self.signUpView.usernameField.placeholder = @"ユーザ名";
    self.signUpView.passwordField.placeholder = @"パスワード";
    self.signUpView.emailField.placeholder = @"Eメール";
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
    
    UILabel* title2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 280, 45)];
    title2.text = @"ユーザ名、パスワードを入力してください。\nEメールはパスワードを忘れた場合に再登録するために使用します。";
    title2.numberOfLines = 0;
    title2.textColor = [UIColor whiteColor];
    title2.backgroundColor = [UIColor clearColor];
    title2.font = [UIFont systemFontOfSize:11.0f];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [view addSubview:title];
    [view addSubview:title2];
    
    return view;
}
@end
