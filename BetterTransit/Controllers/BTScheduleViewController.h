//
//  BTScheduleViewController.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/19/10.
//  Copyright 2010 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRoute.h"

@interface BTScheduleViewController : UIViewController 
{
	BTRoute * route;
}

@property (nonatomic, strong) BTRoute * route;

- (void)done:(id)sender;

@end
