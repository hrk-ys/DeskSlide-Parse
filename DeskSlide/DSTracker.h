//
//  DSTracker.h
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2014/02/23.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSTracker : NSObject

+ (DSTracker*)sharedInstance;

+ (void)reset;
+ (void)setUserId:(NSString*)userId;
+ (void)updateUserId:(NSString*)userId;

+ (void)trackView:(NSString*)screenName;
+ (void)trackEvent:(NSString*)eventName;
+ (void)trackEvent:(NSString*)eventName properties:(NSDictionary *)properties;
+ (void)increment:(NSString *)property by:(NSNumber *)amount;

@end
