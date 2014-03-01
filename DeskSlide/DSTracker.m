//
//  DSTracker.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2014/02/23.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSTracker.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import <Mixpanel.h>

@implementation DSTracker

+(DSTracker*)sharedInstance
{
    static DSTracker* tracker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tracker = [[DSTracker alloc] init];
    });
    return tracker;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupGoogleAnalytics];
        [self setupMixpanel];
    }
    return self;
}

- (void)setupGoogleAnalytics
{
     // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
#ifdef DEBUG
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] setDryRun:YES];
#else
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
#endif
    
    // Initialize tracker.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-42236549-2"];
}

- (void)setupMixpanel
{
    Mixpanel* mixpanel = [Mixpanel sharedInstanceWithToken:@"61871337d5301da2039fed897c5f7e6f"];
    [mixpanel identify:mixpanel.distinctId];
    
#ifdef DEBUG
    mixpanel.flushInterval = 10;
#endif
}

+ (void)reset
{
    [[Mixpanel sharedInstance] reset];
}

+ (void)setUserId:(NSString *)userId
{
    Mixpanel* mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:userId];
}

+ (void)updateUserId:(NSString *)userId
{
    Mixpanel* mixpanel = [Mixpanel sharedInstance];
    [mixpanel createAlias:userId
            forDistinctID:mixpanel.distinctId];
    [mixpanel identify:mixpanel.distinctId];
    
    [mixpanel.people set:@{ @"username": userId }];
}

+ (void)trackView:(NSString*)screenName
{
    NSString* track = S(@"%@ view", screenName);
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:track];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [[Mixpanel sharedInstance] track:track];
}

+ (void)trackEvent:(NSString*)eventName
{
    [self trackEvent:eventName properties:nil];
}
+ (void)trackEvent:(NSString*)eventName properties:(NSDictionary *)properties
{
    
    [[Mixpanel sharedInstance] track:eventName properties:properties];
}

+ (void)increment:(NSString *)property by:(NSNumber *)amount;
{
    [[Mixpanel sharedInstance].people increment:property by:amount];
}
@end
