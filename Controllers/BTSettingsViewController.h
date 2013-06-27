//
//  BTSettingsViewController.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/17/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTransit.h"
#import "HAListViewController.h"
#import "HAAboutViewController.h"

@interface BTSettingsViewController : HAAboutViewController
<HAListViewControllerDelegate>
{
	BTTransit *transit;
}

@property (nonatomic, strong) NSArray *startupScreenOptions;
@property (nonatomic, strong) NSArray *maxNumNearbyStopsOptions;

@end
