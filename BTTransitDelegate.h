//
//  BTTransitDelegate.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTransit.h"
#import "BTFeedLoader.h"
#import "BTScheduleViewController.h"
#import "BTPredictionViewController.h"
#import "BTTripViewController.h"
#import "BTRouteCell.h"

@interface BTTransitDelegate : UIResponder
<UIApplicationDelegate, UIAlertViewDelegate>
{
	UIWindow *window;
	UITabBarController *tabBarController;
	
	BTTransit *transit;
	BTFeedLoader *feedLoader;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (strong) IBOutlet BTTransit *transit;
@property (strong) IBOutlet BTFeedLoader *feedLoader;

// Create view controllers
- (BTPredictionViewController *)createPredictionViewController;
- (BTScheduleViewController *)createScheduleViewController;
- (BTTripViewController *)createTripViewController;
- (BTRouteCell *)createRouteCellWithIdentifier:(NSString *)CellIdentifier;

@end
