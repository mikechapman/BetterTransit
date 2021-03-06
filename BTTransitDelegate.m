//
//  BTTransitDelegate.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import "BTTransitDelegate.h"
#import "HALocationManager.h"
#import "BTAppSettings.h"
#import "HAUtils.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

#ifdef FLURRY_KEY
#import "Flurry.h"
#endif

@implementation BTTransitDelegate

@synthesize window, tabBarController;
@synthesize transit, feedLoader;


#pragma mark -
#pragma mark Customizable controllers

- (BTPredictionViewController *)createPredictionViewController
{
	return [[BTPredictionViewController alloc] init];
}

- (BTScheduleViewController *)createScheduleViewController
{
	return nil;
}

- (BTTripViewController *)createTripViewController
{
	return [[BTTripViewController alloc] init];
}	

- (BTRouteCell *)createRouteCellWithIdentifier:(NSString *)CellIdentifier
{
	return [[BTRouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
}


#pragma mark -
#pragma mark Application life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = tabBarController;
	[self.window makeKeyAndVisible];
    
    // Set up logging
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // log to Apple System Logger
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // log to Xcode console
	
	// Show startup tab
	NSString *tabTitle = [BTAppSettings startupScreen];
	if ([tabTitle isEqualToString:@"Nearby"] || [tabTitle isEqualToString:@"Favorites"]) {
		tabTitle = @"Stops";
	}
	
	UINavigationController *nc;
	for (nc in tabBarController.viewControllers) {
		nc.navigationBar.tintColor = COLOR_NAV_BAR_BG;
		if ([nc.title isEqualToString:tabTitle]) {
			[tabBarController setSelectedViewController:nc];
		}
	}
    
    // Enable the AFNetworkActivityIndicatorManager
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
#ifdef FLURRY_KEY
	[Flurry startSession:FLURRY_KEY];
    [Flurry setCrashReportingEnabled:YES];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"TRACKING_NEW_USERS"]) {
        // Log Flurry event to track the number of new users
        NSDictionary *flurryDict = @{@"device_model": [[UIDevice currentDevice] model],
                                    @"device_type": [HAUtils deviceType]};
        [Flurry logEvent:@"TRACKING_NEW_USERS" withParameters:flurryDict];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TRACKING_NEW_USERS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
#endif
	
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)applicationWillResignActive:(UIApplication *)application
{	
	// Turn off timer and reset feed loader's delegate if predicition view is visisble
	UINavigationController *nc = (UINavigationController *)[tabBarController selectedViewController];
	UIViewController *vc = [nc visibleViewController];
	
	if ( [vc isKindOfClass:[BTPredictionViewController class]] ) {
		[self.feedLoader setDelegate:nil];
		[((BTPredictionViewController *)vc).timer invalidate];
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Update current location
	[[HALocationManager defaultManager] startUpdatingLocation];
	
	UINavigationController *nc = (UINavigationController *)[tabBarController selectedViewController];
	UIViewController *vc = [nc visibleViewController];
	
	if ([vc isKindOfClass:[BTPredictionViewController class]]) {
		BTPredictionViewController *c = (BTPredictionViewController *)vc;
		[c checkBusArrival];
		[c startTimer];
	}
}
	
@end
