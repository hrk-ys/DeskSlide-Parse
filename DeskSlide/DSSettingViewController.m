//
//  DSSettingViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/23.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSSettingViewController.h"

#import "DSAppDelegate.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Helpshift.h>

typedef enum {
   	kDSSettingTableRowContact,
	kDSSettingTableRowVersion,
	kDSSettingTableRowLogout,
} kDSSettingTableRows;

@interface DSSettingViewController ()
<MFMailComposeViewControllerDelegate>
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
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.view.backgroundColor = [UIColor whiteColor];
    } else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_w"]];
    }
    
    UIView* toolView = self.tableView.tableFooterView;
    self.tableView.tableFooterView = nil;
    toolView.frame = CGRectMake(20, self.view.height - 12 - toolView.height, 280, 44);
    [self.view addSubview:toolView];
    
    //FAKIconRemoveCircle, FAKIconRemoveSign
    [self.toolView setupToolButton:self.closeButton icon:FAKIconRemove
                             color:[UIColor blackColor]
                    highlightColor:[UIColor lightGrayColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:NSStringFromClass(self.class)];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOGTrace;
    
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case kDSSettingTableRowContact:
        {
            NSInteger count = [[Helpshift sharedInstance] getNotificationCountFromRemote:NO];
            if (count > 0) {
                cell.textLabel.text = S(@"ご意見・ご要望 (%d)", count);
            } else {
                cell.textLabel.text = @"ご意見・ご要望";
            }
        }
            break;
        case kDSSettingTableRowVersion:
        {
            cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)
                                         kCFBundleVersionKey];
        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOGTrace;
    
    switch (indexPath.row) {
        case kDSSettingTableRowContact:
        {
            [[Helpshift sharedInstance] showConversation:self withOptions:@{ @"name": [[PFUser currentUser] username]}];
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
- (IBAction)tappedLinkButton:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        
        controller.mailComposeDelegate = self;
        [controller setSubject:@"DeskSlide PCブラウザ用URL"];
        [controller setMessageBody:@"http://desk-slide.hrk-ys.net/" isHTML:NO];
        
        [self presentViewController:controller animated:YES completion:nil];

    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://desk-slide.hrk-ys.net/"]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (error) [error show];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)tappedCloseButton:(id)sender {
    LOGTrace;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
