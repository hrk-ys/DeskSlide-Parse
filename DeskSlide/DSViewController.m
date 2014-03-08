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

#import <Mixpanel.h>
#import <SVProgressHUD.h>
#import <Social/Social.h>
#import <iAd/iAd.h>

@interface DSViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate,
UIAlertViewDelegate,
ADBannerViewDelegate,
GADBannerViewDelegate
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@property (weak, nonatomic) IBOutlet DSToolView *toolView;
@property (weak, nonatomic) IBOutlet UIButton   *textButton;
@property (weak, nonatomic) IBOutlet UIButton   *libraryButton;
@property (weak, nonatomic) IBOutlet UIButton   *settingButton;
@property (weak, nonatomic) IBOutlet UIButton   *refreshButton;

@property (weak, nonatomic) IBOutlet GADBannerView *adMobView;
@property (nonatomic) BOOL                          adMobIsVisible;
@property (weak, nonatomic) IBOutlet UIView *adDisableView;
@property (weak, nonatomic) IBOutlet UIButton *adDisableButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adDisableViewHeight;


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

- (BOOL)finishedTutorial
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kFinishedTutorial"];
}
- (void)setFinishedTutorial
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kFinishedTutorial"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.dataSource = @[].mutableCopy;
    self.shouldReloadOnAppear = YES;
    
#ifdef DEBUG
    [[DSConfig sharedInstance] setDisableAd:NO];
#endif
    
    if (! [[DSConfig sharedInstance] disableAd]) {
        
        if (! [[[DSConfig sharedInstance] configForKey:@"ad_disable_btn"] isEqualToString:@"1"]) {
            self.adDisableViewHeight.constant = 0;
        }
        [self.adDisableButton setBackgroundImage:[[UIImage imageNamed:@"btn_w"] stretchableImageWithLeftCapWidth:12 topCapHeight:10]  forState:UIControlStateNormal];
        
        self.adMobView.delegate           = self;
        self.adMobView.adUnitID           = ADMOB_UNIT_ID;
        self.adMobView.rootViewController = self;
        self.adMobView.adSize             = kGADAdSizeSmartBannerPortrait;
        GADRequest *request = [GADRequest request];
#ifdef DEBUG
        request.testDevices = [NSArray arrayWithObjects:
                               GAD_SIMULATOR_ID,
                               nil];
#endif
        [self.adMobView loadRequest:request];
    }
    
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
    if (![self finishedTutorial]) {
        [self setFinishedTutorial];
        
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorialView"];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    
    [DSTracker trackView:@"main"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutTutorialView
{
    self.tutorialView.hidden = self.dataSource.count > 4;
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
            
            [self layoutTutorialView];
            
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

- (IBAction)tappedTextButton:(id)sender
{
    LOGTrace;
    
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
        
        [DSTracker trackEvent:@"create doc" properties:@{ @"docType": @"text"}];
        [DSTracker increment:@"doc count" by:@1];
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [self.dataSource insertObject:doc atIndex:0];
        [self.collectionView insertItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:0 inSection:0] ]];
        
        [self layoutTutorialView];
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
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    [self uploadImageFile:imageFile];
}

- (void)uploadImageFile:(PFFile *)imageFile
{
    LOGTrace;
    
    // HUD creation here (see example for code)
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFObject *doc = [PFObject objectWithClassName:kDSDocumentClassKey];
            [doc setObject:kDSDocumentTypeFile forKey:kDSDocumentTypeKey];
            [doc setObject:imageFile forKey:kDSDocumentFileKey];
            
            [doc saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [SVProgressHUD showSuccessWithStatus:@"Success"];
                if (!error) {
                    [DSTracker trackEvent:@"create doc" properties:@{ @"docType": @"image"}];
                    [DSTracker increment:@"doc count" by:@1];
                    
                    [self.dataSource insertObject:doc atIndex:0];
                    [self.collectionView insertItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:0 inSection:0] ]];
                    [self layoutTutorialView];
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
//        [SVProgressHUD showProgress:percentDone];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    LOGInfoTrace;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL* imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    NSString *path = imageURL.path;
    PFFile   *imageFile;
    if ([[path uppercaseString] hasSuffix:@"PNG"]) {
        NSData *imageData = UIImagePNGRepresentation(image);
        
        imageFile = [PFFile fileWithName:@"Image.png" data:imageData];
    } else {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
        
        imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self uploadImageFile:imageFile];
    }];
    
    // Upload image
//    [self uploadImage:imageData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    LOGInfoTrace;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tappedDisableAd:(id)sender {
    
    [DSTracker trackView:@"tapped disable ad link"];
    NSString* message = [[DSConfig sharedInstance] configForKey:@"twitter_invite_message"];
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [controller setInitialText:message];
    [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
            [[DSConfig sharedInstance] setDisableAd:YES];
            [DSTracker trackView:@"twitter share"];
            
            [UIAlertView showMessage:@"ツイートありがとうございます。\n次回から広告が非表示になります。\n※反映に少し時間がかかる場合がございます。"];
        } else if (result == SLComposeViewControllerResultCancelled) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark admod

- (void)adViewDidReceiveAd:(GADBannerView *)banner
{
    LOGTrace;
    if (self.adMobIsVisible) { return; }
    
    self.adMobIsVisible = YES;
    
    banner.frame = CGRectOffset(banner.frame, 0, -(banner.frame.size.height + self.adDisableView.height));
    self.adDisableView.originY = banner.originY + banner.height;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         banner.hidden = NO;
                         banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height + self.adDisableView.height);
                         self.adDisableView.hidden = NO;
                         self.adDisableView.originY = banner.originY + banner.height;
                         self.collectionView.originY = CGRectGetMaxY(self.adDisableView.frame);
                     } completion:^(BOOL finished) {
                         self.collectionTopLaytou.constant = banner.height+self.adDisableView.height;
                     }];
}

- (void)adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error
{
    LOGTrace;
    if (!self.adMobIsVisible) { return; }
    self.adMobIsVisible = NO;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         banner.frame = CGRectOffset(banner.frame, 0, -(banner.frame.size.height + self.adDisableView.height));
                         self.adDisableView.originY = CGRectGetMaxY(banner.frame);
                         self.collectionView.originY = 0;
                     }
     
                     completion:^(BOOL finished) {
                         banner.hidden = YES;
                         self.adDisableView.hidden = YES;
                         self.collectionTopLaytou.constant = 0;
                     }];
}

@end
