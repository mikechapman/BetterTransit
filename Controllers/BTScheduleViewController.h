//
//  BTScheduleViewController.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/19/10.
//  Copyright 2010 HappenApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRoute.h"

@interface BTScheduleViewController : UIViewController 
{
	BTRoute * route;
}

@property (nonatomic, strong) BTRoute * route;

@end
