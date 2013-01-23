//
//  BTScheduleViewController.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/19/10.
//  Copyright 2010 Happen Next. All rights reserved.
//

#import "BTScheduleViewController.h"

#ifdef FLURRY_KEY
#import "FlurryAnalytics.h"
#endif


@implementation BTScheduleViewController

@synthesize route;


#pragma mark - Initialization

- (id)init
{
	self = [super initWithNibName:@"BTScheduleViewController" bundle:[NSBundle mainBundle]];
	if (self) {
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}


#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
#ifdef FLURRY_KEY
	NSDictionary *flurryDict = @{@"routeID": route.shortName};
	[FlurryAnalytics logEvent:@"DID_SHOW_SCHEDULE" withParameters:flurryDict];
#endif
}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	DDLogVerbose(@">>> %s <<<", __PRETTY_FUNCTION__);
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	DDLogVerbose(@">>> %s <<<", __PRETTY_FUNCTION__);
    [super viewDidUnload];
}

@end
