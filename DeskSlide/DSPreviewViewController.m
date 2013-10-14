//
//  DSPreviewViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/30.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSPreviewViewController.h"

#import <SVProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface DSPreviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet DSToolView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@property (nonatomic) BOOL fullScreen;

@end

@implementation DSPreviewViewController

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
    self.screenName = NSStringFromClass(self.class);
    
    [self.toolView setupToolButton:self.saveButton
                              icon:FAKIconSave
                             color:[UIColor blackColor]
                    highlightColor:[UIColor darkGrayColor]];
    [self.saveButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    
    [self.toolView setupToolButton:self.closeButton
                              icon:FAKIconRemove
                             color:[UIColor blackColor]
                    highlightColor:[UIColor darkGrayColor]];
    

    [self.toolView setupToolButton:self.deleteButton
                              icon:FAKIconTrash
                             color:[UIColor blackColor]
                    highlightColor:[UIColor darkGrayColor]];

    
    if ([DSUtils isTextObject:self.object]) {
        
        self.textView.text = [self.object objectForKey:kDSDocumentTypeText];
        NSDictionary* attributes = @{FAKImageAttributeForegroundColor: [UIColor colorWithWhite:0.800 alpha:1.000]};
        self.imageView.image = [FontAwesomeKit imageForIcon:FAKIconFileText
                                                     imageSize:CGSizeMake(320, 320)
                                                      fontSize:320
                                                   attributes:attributes];
        self.saveButton.hidden = YES;
        
        float statusBarHeight =[[UIApplication sharedApplication] statusBarFrame].size.height;
        self.textView.contentInset = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0);
        self.textView.contentOffset = CGPointMake(20, -statusBarHeight);
        
    } else if ([DSUtils isFileObject:self.object]) {
        
        PFFile *file = [self.object objectForKey:kDSDocumentFileKey];
        [self.imageView setImageWithURL:[NSURL URLWithString:file.url]];
        
        self.textView.hidden = YES;
        self.saveButton.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.wantsFullScreenLayout = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.wantsFullScreenLayout = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tappedSaveButton:(id)sender {
    LOGInfoTrace;
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
    [SVProgressHUD show];
}

// 完了を知らせる
- (void) savingImageIsFinished:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error){
        [SVProgressHUD dismiss];
        [error show];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"Success"];
    }
}

- (IBAction)tappedDeleteButton:(id)sender {
    LOGInfoTrace;
    
    [SVProgressHUD show];
    [self.object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [error show];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (IBAction)tappedCloseButton:(id)sender {
    LOGInfoTrace;
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return self.fullScreen;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}


- (IBAction)tappedImageView:(id)sender {
    LOGTrace;
    self.fullScreen = !self.fullScreen;
    self.toolView.hidden = self.fullScreen;
    [[UIApplication sharedApplication] setStatusBarHidden:self.fullScreen withAnimation:YES];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

@end
