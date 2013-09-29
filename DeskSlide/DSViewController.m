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

@interface DSViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet DSToolView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;


@property (nonatomic) BOOL shouldReloadOnAppear;
@property (nonatomic) NSMutableArray* dataSource;
@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.shouldReloadOnAppear = YES;
    

    [self.toolView setupToolButton:self.textButton icon:FAKIconPaperClip];
    [self.toolView setupToolButton:self.libraryButton icon:FAKIconFolderOpen];
//    [self setupToolButton:self.libraryButton icon:FAKIconPicture];
    [self.libraryButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [self.toolView setupToolButton:self.settingButton icon:FAKIconCog];
    [self.settingButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    
    
    [self.toolView setupToolButton:self.refreshButton icon:FAKIconRefresh];
    
}

- (void)viewWillAppear:(BOOL)animated {
    LOGTrace;
    [super viewWillAppear:animated];
    
    // If not logged in, present login view controller
    if (![PFUser currentUser]) {
        [(DSAppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewController:self animated:NO];
        return;
    }

    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }

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
    
    DSDocumentCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSDocumentCell"
                                                                     forIndexPath:indexPath];
    [cell setDocument:self.dataSource[indexPath.item]];
    
    return cell;
}

- (IBAction)tappedTextButton:(id)sender {
    LOGTrace;
    
    UIPasteboard *pastebd = [UIPasteboard generalPasteboard];

    NSString* text = [pastebd valueForPasteboardType:@"public.utf8-plain-text"];
    LOG(@"%@", text);
    
    if (!text || text.length == 0) {
        [UIAlertView showMessage:@"クリップボードにテキストがありません"];
        return;
    }
    
    [self sendText:text];
}



- (void)sendText:(NSString*)text
{
    LOGTrace;
    
    PFObject *doc = [PFObject objectWithClassName:kDSDocumentClassKey];
//    [photo setObject:[PFUser currentUser] forKey:kPAPPhotoUserKey];
    [doc setObject:kDSDocumentTypeText forKey:kDSDocumentTypeKey];
    [doc setObject:text forKey:kDSDocumentTextKey];
 
    [doc saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [error show];
        }
    }];
}

- (IBAction)tappedRefreshButton:(id)sender {
    
    [self loadObjects];
 
}



@end
