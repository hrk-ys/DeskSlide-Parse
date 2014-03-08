//
//  DSTutorial3ViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2014/03/07.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSTutorial3ViewController.h"
#import "DSPreviewViewController.h"

@interface DSTutorial3ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *docImageView;
@property (weak, nonatomic) IBOutlet UILabel     *docTextView;

@end

@implementation DSTutorial3ViewController

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
    
    self.title = @"ステップ3";
    
    NSDictionary *attributes = @{ FAKImageAttributeForegroundColor: [UIColor colorWithWhite:0.400 alpha:1.000] };
    self.docImageView.image = [FontAwesomeKit imageForIcon:FAKIconFileText
                                                 imageSize:CGSizeMake(100, 100)
                                                  fontSize:100
                                                attributes:attributes];
    self.docTextView.text = [self.textDoc objectForKey:kDSDocumentTextKey];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [DSTracker trackView:@"tutorial3"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"preview"]) {
        DSPreviewViewController *preview   = segue.destinationViewController;
        preview.object = self.textDoc;
    }
}

@end
