//
//  DSTutorialViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2014/03/06.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSTutorialViewController.h"
#import "DSTutorial2ViewController.h"
#import "DSViewController.h"

#import <SVProgressHUD.h>

@interface DSTutorialViewController ()

@property (weak, nonatomic) IBOutlet DSToolView *toolView;
@property (weak, nonatomic) IBOutlet UIButton   *textButton;
@property (weak, nonatomic) IBOutlet UIButton   *libraryButton;
@property (weak, nonatomic) IBOutlet UIButton   *settingButton;
@property (weak, nonatomic) IBOutlet UIButton   *refreshButton;

@end

@implementation DSTutorialViewController
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
	// Do any additional setup after loading the view.
    self.title = @"使い方 ステップ1";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(tappedCloseButton:)];
   
    [self.toolView setupToolButton:self.textButton icon:FAKIconPaperClip];
    [self.toolView setupToolButton:self.libraryButton icon:FAKIconFolderOpen];
    //    [self setupToolButton:self.libraryButton icon:FAKIconPicture];
    [self.libraryButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [self.toolView setupToolButton:self.settingButton icon:FAKIconCog];
    [self.settingButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    
    [self.toolView setupToolButton:self.refreshButton icon:FAKIconRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [DSTracker trackView:@"tutorial1"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNextStep
{
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorialView2"];
    ((DSTutorial2ViewController*)vc).textDoc = self.textDoc;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showTextInputAlert
{
    UIAlertView *av =
    [[UIAlertView alloc] initWithTitle:@"テキスト登録"
                               message:@"登録するテキストを入力してください"
                              delegate:self
                     cancelButtonTitle:@"キャンセル"
                     otherButtonTitles:@"登録", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    LOGTrace;
    
    if (buttonIndex == 0) { return; }
    if (buttonIndex == 2) { [self showTextInputAlert]; return; }
    
    NSString* message;
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
        message = [[alertView textFieldAtIndex:0] text];
    } else {
        message = alertView.message;
    }
    
    [self sendText:message];
}

- (void)sendText:(NSString *)text
{
    LOGTrace;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    PFObject *doc = [DSUtils createObjectWithText:text];
   
    [doc saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [error show];
            
            return;
        }
        
        [DSViewController updateDocument];
        
        [DSTracker trackEvent:@"create doc" properties:@{ @"docType": @"text"}];
        [DSTracker increment:@"doc count" by:@1];
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
       
        self.textDoc = doc;
        [self showNextStep];

    }];
}

- (IBAction)tappedTextButton:(id)sender
{
    LOGTrace;
    if (self.textDoc) {
        [self showNextStep];
        return;
    }
    
    [DSTracker trackEvent:@"tapped send text"];
    
    UIPasteboard *pastebd = [UIPasteboard generalPasteboard];
    
    NSString *text = [pastebd valueForPasteboardType:@"public.utf8-plain-text"];
    
    // クリップボードにテキストがある場合
    if (text || text.length > 0) {
        UIAlertView *av =
        [[UIAlertView alloc] initWithTitle:@"テキストを登録しますか？"
                                   message:text
                                  delegate:self
                         cancelButtonTitle:@"キャンセル"
                         otherButtonTitles:@"登録", nil];
        [av show];
        
    } else {
        [self showTextInputAlert];
    }
}

- (IBAction)tappedCloseButton:(id)sender {
    [DSTracker trackEvent:@"tutorial close button"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
