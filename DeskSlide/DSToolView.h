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
- (void)setupToolButton:(UIButton*)button icon:(NSString*)icon;

@end
