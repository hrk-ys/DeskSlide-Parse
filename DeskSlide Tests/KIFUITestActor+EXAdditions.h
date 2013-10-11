//
//  KIFUITestActor+EXAdditions.h
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/10/11.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import <KIF/KIF.h>

@interface KIFUITestActor (EXAdditions)
- (void)navigateToLoginPage;
- (void)returnToLoggedOutHomeScreen;

@end
