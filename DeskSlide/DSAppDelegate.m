//
//  DSAppDelegate.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/23.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSAppDelegate.h"

#import "DSLoginViewController.h"
#import "DSPreviewViewController.h"


#import <Crashlytics/Crashlytics.h>

#import <DDFileLogger.h>
#import <DDTTYLogger.h>

@interface DSAppDelegate ()
<DSLoginViewControllerDelegate>
@end

@implementation DSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [Crashlytics startWithAPIKey:@"b23780728daaf4165202578d33fcddfe13bf2bef"];
    [self setupLogger];
    [self setupTracker];
    [self setupParse:launchOptions];
    
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    [self receiveNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    LOGTrace;
    [self receiveNotification:userInfo];
}

- (void)receiveNotification:(NSDictionary*)userInfo
{
    LOGTrace;
    if (!userInfo) return;
    
    NSURL* url = [NSURL URLWithString:userInfo[@"aps"][@"alert"]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return;
    }
    
    // Create a pointer to the Photo object
    NSString *objectId = [userInfo objectForKey:@"o"];
    PFObject *doc = [PFObject objectWithoutDataWithClassName:@"Document"
                                                            objectId:objectId];
    
    // Fetch photo object
    [doc fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        // Show photo view controller
        if (!error && [PFUser currentUser]) {
            LOGTrace;
            
            DSPreviewViewController* preview = [[[self.window rootViewController] storyboard] instantiateViewControllerWithIdentifier:@"preview"];
            preview.object = object;
            [[self.window rootViewController] presentViewController:preview animated:YES completion:nil];
        }
    }];

    
}


- (void)setupLogger
{
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency                       = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [fileLogger setLogFormatter:[[LogFormatter alloc] init]];
    [DDLog addLogger:fileLogger];
    
    DDTTYLogger *logger = [DDTTYLogger sharedInstance];
    [logger setLogFormatter:[[LogFormatter alloc] init]];
    [logger setColorsEnabled:YES];
    [logger setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:
     LOG_FLAG_ERROR];
    [logger setForegroundColor:[UIColor orangeColor] backgroundColor:nil forFlag:
     LOG_FLAG_WARN];
    [logger setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:
     LOG_FLAG_INFO];
    
    [DDLog addLogger:logger];
}


- (void)setupParse:(NSDictionary*)launchOptions
{
    [Parse setApplicationId:@"pFG9MpdcFCveSEsE7sD3gHQPa1UeH2ikIOeg2vFS"
                  clientKey:@"HiymDpcIsmQCXoYrWEgv89kAYvLbkjMn2p15gmlX"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    
    PFACL *defaultACL = [PFACL ACL];
    // Enable public read access by default, with any newly created PFObjects belonging to the current user
    // [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];

}

- (void)presentLoginViewController:(UIViewController*)controller animated:(BOOL)animated {
    DSLoginViewController *logInController = [[DSLoginViewController alloc] init];
    logInController.loginDelegate = self;

    [controller presentViewController:logInController animated:animated completion:nil];
}

- (void)logInViewController:(DSLoginViewController *)controller didLogInUser:(PFUser *)user
{
    LOGTrace;
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancel:(DSLoginViewController *)controller
{
    LOGTrace;
//    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)logOut {
    LOGTrace;
    
    // Log out
    [PFUser logOut];
    
    [self presentLoginViewController:self.window.rootViewController animated:YES];
}


- (void)setupTracker
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

@end
