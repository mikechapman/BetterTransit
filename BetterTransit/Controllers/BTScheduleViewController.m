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


#pragma mark -
#pragma mark Initialization

- (id)init
{
	self = [super initWithNibName:@"BTScheduleViewController" bundle:[NSBundle mainBundle]];
	if (self) {
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}


#pragma mark -
#pragma mark View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up backdrop
    backdrop = [[UIImageView alloc] initWithFrame:self.view.bounds];
	backdrop.image = [UIImage imageNamed:@"backdrop.png"];
	[self.view insertSubview:backdrop atIndex:0];
	backdrop.alpha = 1.0;
    
//    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
//    self.navigationItem.leftBarButtonItem = doneButton;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
#ifdef FLURRY_KEY
	NSDictionary *flurryDict = @{@"routeID": route.shortName};
	[FlurryAnalytics logEvent:@"DID_SHOW_SCHEDULE" withParameters:flurryDict];
#endif
}


#pragma mark -
#pragma mark Memory management

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
    backdrop = nil;
}


#pragma mark -
#pragma mark UI actions

- (void)done:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
