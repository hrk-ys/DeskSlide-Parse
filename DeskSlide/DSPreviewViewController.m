//
//  DSPreviewViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/30.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSPreviewViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface DSPreviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet DSToolView *toolView;
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
    
    
    [self.toolView setupToolButton:self.closeButton icon:FAKIconRemove];
    
    if ([[self.object objectForKey:kDSDocumentTypeKey] isEqualToString:kDSDocumentTypeText]) {
        
        self.textView.text = [self.object objectForKey:kDSDocumentTypeText];
        NSDictionary* attributes = @{FAKImageAttributeForegroundColor: [UIColor colorWithWhite:0.400 alpha:1.000]};
        self.imageView.image = [FontAwesomeKit imageForIcon:FAKIconFileText
                                                     imageSize:CGSizeMake(320, 320)
                                                      fontSize:320
                                                   attributes:attributes];
    } else if ([[self.object objectForKey:kDSDocumentTypeKey] isEqualToString:kDSDocumentTypeFile]) {
        
        PFFile *file = [self.object objectForKey:kDSDocumentFileKey];
        [self.imageView setImageWithURL:[NSURL URLWithString:file.url]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tappedCloseButton:(id)sender {
    LOGInfoTrace;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
