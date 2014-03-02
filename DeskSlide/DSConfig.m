//
//  DSConfig.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2014/03/02.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSConfig.h"

@interface DSConfig ()
@property (nonatomic) NSMutableDictionary* config;
@end

@implementation DSConfig

+(instancetype)sharedInstance
{
    static DSConfig* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DSConfig alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.config = @{
                        @"twitter_invite_message":@"DeskSlide スマホ、PC間の簡単データ転送 https://itunes.apple.com/us/app/deskslide-sumaho-pc-jianno/id718222782?mt=8",
                        }.mutableCopy;
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSUserDefaults* ns = [NSUserDefaults standardUserDefaults];
    if ([ns objectForKey:@"kConfig"]) {
        [self.config addEntriesFromDictionary:[ns objectForKey:@"kConfig"]];
    }
}

- (void)saveConfig
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSDictionary dictionaryWithDictionary:self.config] forKey:@"kConfig"];
    [ud synchronize];
}

- (void)updateConfig
{
    [PFCloud callFunctionInBackground:@"config"
                       withParameters:@{}
                                block:^(NSDictionary *result, NSError *error) {
                                    if (!error) {
                                        [self.config addEntriesFromDictionary:result];
                                        [self saveConfig];
                                    }
                                }];
}

- (id)configForKey:(NSString *)key
{
    return [self.config objectForKey:key];
}

- (void)setDisableAd:(BOOL)flg
{
    [self.config setObject:@(flg) forKey:@"kDisableAd"];
    [self saveConfig];
}

- (BOOL)disableAd
{
    return [[self configForKey:@"kDisableAd"] boolValue];
}


@end
