//
//  DSAppDelegate.m
//  DeskSlide
//
//  Created by Hiroki Yoshifuji on 2013/09/23.
//  Copyright (c) 2013年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSAppDelegate.h"

#import "DSPreviewViewController.h"
#import "DSAuthViewController.h"


#import <Crashlytics/Crashlytics.h>

#import <DDFileLogger.h>
#import <DDTTYLogger.h>
#import <Helpshift.h>
#import <Mixpanel.h>

@interface DSAppDelegate ()
<DSAuthViewControllerDelegate>
@end

@implementation DSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [Crashlytics startWithAPIKey:CRASHLYTICS_API_KEY];
    
    [HYLog setupLogger];
#ifdef DEBUG
    [HYLog updateLogLevel:LOG_LEVEL_VERBOSE];
#else
    [HYLog updateLogLevel:LOG_LEVEL_OFF];
#endif
    
    [DSTracker sharedInstance];
    [self setupParse:launchOptions];
    [self setupHelpshift:launchOptions];

    
    if ([PFUser currentUser]) {
        [DSTracker setUserId:[[PFUser currentUser] username]];
        [self registNotification];
    }
    
    [self receiveNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    
    [[DSConfig sharedInstance] updateConfig];
    
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
    if (!deviceToken) return;
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
    [currentInstallation saveInBackground];
    
    
    [[Helpshift sharedInstance] registerDeviceToken:deviceToken];
    [[Mixpanel sharedInstance].people addPushDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    LOGTrace;
    [self receiveNotification:userInfo];
}

- (void)registNotification
{
    LOGTrace;
    // Register for push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
}

- (void)receiveNotification:(NSDictionary*)userInfo
{
    LOGTrace;
    if (!userInfo) return;
    
    //Helpshift::handle notification from APN
    if ([[userInfo objectForKey:@"origin"] isEqualToString:@"helpshift"]) {
        [[Helpshift sharedInstance] handleRemoteNotification:userInfo withController:self.window.rootViewController];
        return;
    }

    NSURL* url = [NSURL URLWithString:userInfo[@"aps"][@"alert"]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return;
    }
    
    if (![userInfo enableValue:@"o"]) {
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



- (void)setupParse:(NSDictionary*)launchOptions
{
    [Parse setApplicationId:PARSE_APP_ID
                  clientKey:PARSE_CLIENT_KEY];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    
    PFACL *defaultACL = [PFACL ACL];
    // Enable public read access by default, with any newly created PFObjects belonging to the current user
    // [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];

}

- (void)setupHelpshift:(NSDictionary*)launchOptions
{
    [Helpshift installForApiKey:HELPSHIFT_API_KEY
                     domainName:HELPSHIFT_DOMAIN_NAME
                          appID:HELPSHIFT_APP_ID];
}

- (void)presentLoginViewController:(UIViewController*)controller animated:(BOOL)animated {
    DSAuthViewController* welcomController = [[DSAuthViewController alloc] init];
    welcomController.delegate = self;
    [controller presentViewController:welcomController animated:animated completion:nil];
}

- (void)authController:(DSAuthViewController *)controller didLoginUser:(PFUser *)user
{
    LOGTrace;
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [DSTracker updateUserId:[[PFUser currentUser] username]];
    [self registNotification];
}

- (void)logOut {
    LOGTrace;
    
    // Log out
    [PFUser logOut];
    [DSTracker reset];
    
    [self presentLoginViewController:self.window.rootViewController animated:YES];
}


@end
