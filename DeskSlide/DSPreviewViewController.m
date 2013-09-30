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

@end

@implementation DSPreviewViewController

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
    
    
    [self.toolView setupToolButton:self.saveButton icon:FAKIconSave];
    [self.saveButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [self.toolView setupToolButton:self.closeButton icon:FAKIconRemove];

    
    if ([DSUtils isTextObject:self.object]) {
        
        self.textView.text = [self.object objectForKey:kDSDocumentTypeText];
        NSDictionary* attributes = @{FAKImageAttributeForegroundColor: [UIColor colorWithWhite:0.400 alpha:1.000]};
        self.imageView.image = [FontAwesomeKit imageForIcon:FAKIconFileText
                                                     imageSize:CGSizeMake(320, 320)
                                                      fontSize:320
                                                   attributes:attributes];
        self.saveButton.hidden = YES;
    } else if ([DSUtils isFileObject:self.object]) {
        
        PFFile *file = [self.object objectForKey:kDSDocumentFileKey];
        [self.imageView setImageWithURL:[NSURL URLWithString:file.url]];
        
        self.saveButton.hidden = NO;
    }
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


- (IBAction)tappedCloseButton:(id)sender {
    LOGInfoTrace;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
