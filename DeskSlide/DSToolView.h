//
//  DSToolView.h
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/23.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSToolView : UIView

- (UIImage*)buttonImage:(NSString*)icon;
- (UIImage*)buttonImage:(NSString*)icon
                  color:(UIColor*)color;
- (void)setupToolButton:(UIButton*)button
                   icon:(NSString*)icon;
- (void)setupToolButton:(UIButton*)button
                   icon:(NSString*)icon
                  color:(UIColor*)color
         highlightColor:(UIColor*)highlightColor;

@end
