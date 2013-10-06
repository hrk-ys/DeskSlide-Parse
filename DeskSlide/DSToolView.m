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
    return [self buttonImage:icon color:[UIColor whiteColor]];
}

- (UIImage*)buttonImage:(NSString*)icon color:(UIColor*)color
{
    return [FontAwesomeKit imageForIcon:icon
                              imageSize:CGSizeMake(15, 15)
                               fontSize:15
                             attributes:
            @{ FAKImageAttributeForegroundColor : color }];
}

- (void)setupToolButton:(UIButton*)button
                   icon:(NSString*)icon
{
    [self setupToolButton:button
                     icon:icon
                    color:[UIColor whiteColor]
           highlightColor:[UIColor grayColor]];
}

- (void)setupToolButton:(UIButton*)button
                   icon:(NSString*)icon
                  color:(UIColor*)color
         highlightColor:(UIColor*)highlightColor
{
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:highlightColor forState:UIControlStateHighlighted];
    
    [button setImage:[self buttonImage:icon color:color]
            forState:UIControlStateNormal];
    [button setImage:[self buttonImage:icon color:highlightColor]
            forState:UIControlStateHighlighted];
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1.0f;
}


@end
