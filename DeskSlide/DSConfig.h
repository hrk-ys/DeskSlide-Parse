//
//  DSConfig.h
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2014/03/02.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSConfig : NSObject

+(instancetype)sharedInstance;

- (void)updateConfig;

- (id)configForKey:(NSString*)key;

- (void)setDisableAd:(BOOL)flg;
- (BOOL)disableAd;

@end
