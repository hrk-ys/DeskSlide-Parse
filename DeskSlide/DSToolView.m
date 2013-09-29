//
//  DSToolView.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/23.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSToolView.h"

@implementation DSToolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self _init];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _init];
}

- (void)_init
{
    self.clipsToBounds      = YES;
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 1.5f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (UIImage*)buttonImage:(NSString*)icon
{
    return [FontAwesomeKit imageForIcon:icon
                              imageSize:CGSizeMake(15, 15)
                               fontSize:15
                             attributes:
            @{ FAKImageAttributeForegroundColor : [UIColor whiteColor] }];
}

- (void)setupToolButton:(UIButton*)button icon:(NSString*)icon
{
    [button setImage:[self buttonImage:icon]
            forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1.0f;
}

@end
