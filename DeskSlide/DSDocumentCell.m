//
//  DSDocumentCell.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/24.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSDocumentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DSDocumentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDocument:(PFObject*)object
{
    if ([[object objectForKey:kDSDocumentTypeKey] isEqualToString:kDSDocumentTypeText]) {
        NSDictionary* attributes = @{FAKImageAttributeForegroundColor: [UIColor colorWithWhite:0.400 alpha:1.000]};
        self.bgImageView.image = [FontAwesomeKit imageForIcon:FAKIconFileText
                                                     imageSize:CGSizeMake(70, 70)
                                                      fontSize:70
                                                    attributes:attributes];
    } else if ([[object objectForKey:kDSDocumentTypeKey] isEqualToString:kDSDocumentTypeFile]){
        PFFile *file = [object objectForKey:kDSDocumentFileKey];
        [self.bgImageView setImageWithURL:[NSURL URLWithString:file.url] placeholderImage:nil options:SDWebImageRetryFailed];
    }
    self.textLabel.text = [object objectForKey:kDSDocumentTextKey];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
