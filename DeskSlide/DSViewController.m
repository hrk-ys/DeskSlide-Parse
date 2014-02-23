//
//  DSViewController.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/23.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSViewController.h"

#import "DSAppDelegate.h"
#import "DSDocumentCell.h"
#import "DSPreviewViewController.h"

#import "GADBannerView.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <iAd/iAd.h>
#import <SVProgressHUD.h>
#import <Mixpanel.h>

@interface DSViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate,
UIAlertViewDelegate,
ADBannerViewDelegate,
GADBannerViewDelegate,
MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet DSToolView *toolView;
@property (weak, nonatomic) IBOutlet UIButton   *textButton;
@property (weak, nonatomic) IBOutlet UIButton   *libraryButton;
@property (weak, nonatomic) IBOutlet UIButton   *settingButton;
@property (weak, nonatomic) IBOutlet UIButton   *refreshButton;

@property (weak, nonatomic) IBOutlet ADBannerView  *banner;
@property (nonatomic) BOOL                          bannerIsVisible;
@property (weak, nonatomic) IBOutlet GADBannerView *adMobView;
@property (nonatomic) BOOL                          adMobIsVisible;


// tutorial
@property (weak, nonatomic) IBOutlet UIView *tutorialView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTopLaytou;

@property (nonatomic) BOOL            shouldReloadOnAppear;
@property (nonatomic) NSMutableArray *dataSource;

@property (nonatomic) NSDate* lastUpdateAt;
@end

@implementation DSViewController

static NSDate* documentUpdatedAt = nil;
+ (void)updateDocument
{
    LOGTrace;
    documentUpdatedAt = [NSDate date];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.shouldReloadOnAppear = YES;
    
    self.adMobView.delegate           = self;
    self.adMobView.adUnitID           = ADMOB_UNIT_ID;
    self.adMobView.rootViewController = self;
    self.adMobView.adSize             = kGADAdSizeSmartBannerPortrait;
    
    [self.toolView setupToolButton:self.textButton icon:FAKIconPaperClip];
    [self.toolView setupToolButton:self.libraryButton icon:FAKIconFolderOpen];
    //    [self setupToolButton:self.libraryButton icon:FAKIconPicture];
    [self.libraryButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [self.toolView setupToolButton:self.settingButton icon:FAKIconCog];
    [self.settingButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    
    
    [self.toolView setupToolButton:self.refreshButton icon:FAKIconRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    LOGTrace;
    [super viewWillAppear:animated];
    
    // If not logged in, present login view controller
    if (![PFUser currentUser]) {
        [(DSAppDelegate *) [[UIApplication sharedApplication] delegate] presentLoginViewController : self animated : NO];
        
        return;
    }
    
    if (!self.lastUpdateAt || ![self.lastUpdateAt isEqualToDate:documentUpdatedAt]) {
        [self loadObjects];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [DSTracker trackView:@"main"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadObjects
{
    LOGTrace;
    
    PFQuery *query = [PFQuery queryWithClassName:kDSDocumentClassKey];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.dataSource = objects.mutableCopy;
            [self.collectionView reloadData];
            
            self.tutorialView.hidden = self.dataSource.count > 0;
            
            [self.class updateDocument];
            self.lastUpdateAt = documentUpdatedAt;
            
            [[Mixpanel sharedInstance].people set:@"doc count" to:@(self.dataSource.count)];
        } else {
            [error show];
        }
    }];
}

#pragma mark - collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    LOGTrace;
    
    DSDocumentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSDocumentCell"
                                                                     forIndexPath:indexPath];
    [cell setDocument:self.dataSource[indexPath.item]];
    
    return cell;
}


#pragma mark - action

- (IBAction)tappedLinkButton:(id)sender {
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




- (IBAction)tappedTextButton:(id)sender
{
    LOGTrace;
    
    UIPasteboard *pastebd = [UIPasteboard generalPasteboard];
    
    NSString *text = [pastebd valueForPasteboardType:@"public.utf8-plain-text"];
    LOG(@"%@", text);
    
    if (!text || text.length == 0) {
        [UIAlertView showMessage:@"クリップボードにテキストがありません"];
        
        return;
    }
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"登録しますか？" message:text delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    LOGTrace;
    
    if (buttonIndex == 0) { return; }
    
    [self sendText:alertView.message];
}

- (void)sendText:(NSString *)text
{
    LOGTrace;
    
    [SVProgressHUD show];
    
    PFObject *doc = [PFObject objectWithClassName:kDSDocumentClassKey];
    [doc setObject:kDSDocumentTypeText forKey:kDSDocumentTypeKey];
    [doc setObject:text forKey:kDSDocumentTextKey];
    
    [doc saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [error show];
            
            return;
        }
        
        [DSTracker trackEvent:@"create doc" properties:@{ @"docType": @"text"}];
        [DSTracker increment:@"doc count" by:@1];
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [self.dataSource insertObject:doc atIndex:0];
        [self.collectionView insertItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:0 inSection:0] ]];
    }];
}

- (IBAction)tappedRefreshButton:(id)sender
{
    [self loadObjects];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[DSDocumentCell class]]) {
        NSIndexPath             *indexPath = [self.collectionView indexPathForCell:sender];
        PFObject                *object    = [self.dataSource objectAtIndex:indexPath.item];
        DSPreviewViewController *preview   = segue.destinationViewController;
        preview.object = object;
    }
}

- (IBAction)tappedLibrary:(id)sender
{
    LOGTrace;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)uploadImage:(NSData *)data
{
    LOGTrace;
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    
    // HUD creation here (see example for code)
    [SVProgressHUD show];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFObject *doc = [PFObject objectWithClassName:kDSDocumentClassKey];
            [doc setObject:kDSDocumentTypeFile forKey:kDSDocumentTypeKey];
            [doc setObject:imageFile forKey:kDSDocumentFileKey];
            
            [doc saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [SVProgressHUD dismiss];
                if (!error) {
                    [DSTracker trackEvent:@"create doc" properties:@{ @"docType": @"image"}];
                    [DSTracker increment:@"doc count" by:@1];
                    
                    [self.dataSource insertObject:doc atIndex:0];
                    [self.collectionView insertItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:0 inSection:0] ]];
                }
                else {
                    // Log details of the failure
                    [error show];
                }
            }];
        }
        else {
            [SVProgressHUD dismiss];
            [error show];
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        [SVProgressHUD showProgress:(int) percentDone / 100];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    LOGInfoTrace;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self uploadImage:imageData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    LOGInfoTrace;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    LOGTrace;
    return;
    if (self.bannerIsVisible) { return; }
    
    self.bannerIsVisible = YES;
    
    banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         banner.hidden = NO;
                         banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
                         
                         self.collectionView.originY = CGRectGetMaxY(banner.frame);
                     } completion:^(BOOL finished) {
                         self.collectionTopLaytou.constant = CGRectGetHeight(banner.frame);
                         
                         if (self.adMobIsVisible) {
                             self.adMobIsVisible = NO;
                             self.adMobView.hidden = YES;
                         }
                     }];
}

- (void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error
{
    LOGTrace;
    
    if (self.bannerIsVisible)
    {
        self.bannerIsVisible = NO;
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
                             self.collectionView.originY = 0;
                         }
         
                         completion:^(BOOL finished) {
                             banner.hidden = YES;
                             self.collectionTopLaytou.constant = 0;
                         }];
    }
    
    GADRequest *request = [GADRequest request];
#ifdef DEBUG
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,
                           nil];
#endif
    
    [self.adMobView loadRequest:request];
}

#pragma mark -
#pragma mark admod

- (void)adViewDidReceiveAd:(GADBannerView *)banner
{
    LOGTrace;
    if (self.bannerIsVisible) { return; }
    if (self.adMobIsVisible) { return; }
    
    self.adMobIsVisible = YES;
    
    banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
    [UIView animateWithDuration:0.3f
                     animations:^{
                         banner.hidden = NO;
                         banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
                         self.collectionView.originY = CGRectGetMaxY(banner.frame);
                     } completion:^(BOOL finished) {
                         self.collectionTopLaytou.constant = banner.height;
                     }];
}

- (void)adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error
{
    LOGTrace;
    if (!self.adMobIsVisible) { return; }
    self.adMobIsVisible = NO;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
                         self.collectionView.originY = 0;
                     }
     
                     completion:^(BOOL finished) {
                         banner.hidden = YES;
                         self.collectionTopLaytou.constant = 0;
                     }];
}

@end
