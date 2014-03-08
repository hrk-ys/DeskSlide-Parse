//
//  DSTutorial2ViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2014/03/07.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSTutorial2ViewController.h"
#import "DSTutorial3ViewController.h"

@interface DSTutorial2ViewController ()

@end

@implementation DSTutorial2ViewController

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
    self.title = @"ステップ2";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [DSTracker trackView:@"tutorial2"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"tutorial3   "]) {
        DSTutorial3ViewController* vc = segue.destinationViewController;
        vc.textDoc = self.textDoc;
    }
}

@end
