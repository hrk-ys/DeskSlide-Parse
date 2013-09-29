//
//  DSDocumentCell.h
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/24.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSDocumentCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

- (void)setDocument:(PFObject*)object;

@end
