//
//  DSUtils.h
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/30.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSUtils : NSObject

+ (BOOL)isTextObject:(PFObject*)object;
+ (BOOL)isFileObject:(PFObject*)object;

@end
