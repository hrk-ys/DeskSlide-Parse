//
//  DSSettingViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/23.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSSettingViewController.h"

#import "DSAppDelegate.h"

typedef enum {
	kDSSettingTableRowWebURL,
	kDSSettingTableRowLogout,
} kDSSettingTableRows;

@interface DSSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet DSToolView *toolView;
@end

@implementation DSSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    UIView* toolView = self.tableView.tableFooterView;
    self.tableView.tableFooterView = nil;
    toolView.frame = CGRectMake(20, self.view.height - 12 - toolView.height, 280, 44);
    [self.view addSubview:toolView];
    
    //FAKIconRemoveCircle, FAKIconRemoveSign
    [self.toolView setupToolButton:self.closeButton icon:FAKIconRemove];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOGTrace;
    
    switch (indexPath.row) {
        case kDSSettingTableRowWebURL:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://desk-slide.parseapp.com/"]];
        }
            break;
        case kDSSettingTableRowLogout:
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                [(DSAppDelegate*)[[UIApplication sharedApplication] delegate] logOut];
            }];
        }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)tappedCloseButton:(id)sender {
    LOGTrace;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end