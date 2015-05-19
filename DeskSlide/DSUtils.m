//
//  DSUtils.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/30.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSUtils.h"

@implementation DSUtils

+ (BOOL)isTextObject:(PFObject*)object
{
    return [[object objectForKey:kDSDocumentTypeKey] isEqualToString:kDSDocumentTypeText];
}
+ (BOOL)isFileObject:(PFObject*)object
{
    return [[object objectForKey:kDSDocumentTypeKey] isEqualToString:kDSDocumentTypeFile];
}

+ (PFObject*)createObjectWithText:(NSString*)text
{
    PFObject *doc = [PFObject objectWithClassName:kDSDocumentClassKey];
    [doc setObject:kDSDocumentTypeText forKey:kDSDocumentTypeKey];
    [doc setObject:text forKey:kDSDocumentTextKey];
    return doc;
}

@end
