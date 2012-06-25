//
//  BTTripViewController.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTTripViewController.h"
#import "BTTrip.h"
#import "Utility.h"
#import "BTScheduleViewController.h"
#import "BTTransitDelegate.h"

@implementation BTTripViewController

@synthesize route;
@synthesize trips, stops, mainTableView, segmentedControl;
@synthesize titleImageView;
@synthesize routeDestView, destLabel, destImageView, destIdLabel;


#pragma mark -
#pragma mark Initialization

- (id)init
{
	self = [super initWithNibName:@"BTTripViewController" bundle:[NSBundle mainBundle]];
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
	
	transit = [AppDelegate transit];
    
    // Load trips if necessary
    if (trips == nil) {
        self.trips = [transit tripsForRoute:route];
    }
	
    // Set up backdrop
    backdrop = [[UIImageView alloc] initWithFrame:self.view.bounds];
	backdrop.image = [UIImage imageNamed:@"backdrop.png"];
	[self.view insertSubview:backdrop atIndex:0];
	backdrop.alpha = 1.0;
    
    // Set up mainTableView
	mainTableView.backgroundColor = [UIColor clearColor];
	mainTableView.separatorColor = COLOR_TABLE_VIEW_SEPARATOR;
	mainTableView.rowHeight = 60;
	
    if (route.hasSchedule) {
		UIButton *scheduleButton = [UIButton buttonWithType:UIButtonTypeCustom];
		scheduleButton.frame = CGRectMake(0, 0, 44, 44);
		scheduleButton.showsTouchWhenHighlighted = YES;
		[scheduleButton setImage:[UIImage imageNamed:@"schedule.png"] forState:UIControlStateNormal];
		[scheduleButton addTarget:self action:@selector(showSchedule:) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *scheduleBarButton = [[UIBarButtonItem alloc] initWithCustomView:scheduleButton];
		self.navigationItem.rightBarButtonItem = scheduleBarButton;
	}
    
    self.navigationItem.title = [NSString stringWithFormat:@"Route %@", route.shortName];
	NSString *imageName = [NSString stringWithFormat:@"%@_white.png", route.shortName];
	UIImage *titleImage = [UIImage imageNamed:imageName];
	if (titleImage) {
		titleImageView = [[UIImageView alloc] initWithImage:titleImage];
	} else {
		titleImageView = nil;
	}
	
	NSArray *items = [NSArray arrayWithObjects:@"", @"", nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
	segmentedControl.frame = CGRectMake(0, 0, 160, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.selectedSegmentIndex = 0;
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	BTTrip * trip = [self.trips objectAtIndex:0];
	self.stops = trip.stops;
	
	if ([self.trips count] > 1) {
		for (int i=0; i<2; i++) {
            NSString * segmentTitle = (i==0 ? @"Inbound" : @"Outbound");
			[segmentedControl setTitle:segmentTitle forSegmentAtIndex:i];
		}
		self.navigationItem.titleView = segmentedControl;
		
		NSString *imageName = [NSString stringWithFormat:@"%@_white.png", route.shortName];
		UIImage *routeImage = [UIImage imageNamed:imageName];
		if (routeImage) {
			[destImageView setImage:routeImage];
		} else {
			destImageView = nil;
			destIdLabel.hidden = NO;
			destIdLabel.text = route.shortName;
		}
		
		destLabel.text = [NSString stringWithFormat:@"To %@", [[trips objectAtIndex:0] headsign]];
		[self.view addSubview:routeDestView];
		
		CGFloat destViewHeight = routeDestView.frame.size.height;
		CGRect tableViewBounds = mainTableView.frame;
		mainTableView.frame = CGRectMake(CGRectGetMinX(tableViewBounds),
									 CGRectGetMinY(tableViewBounds) + destViewHeight,
									 CGRectGetWidth(tableViewBounds),
									 CGRectGetHeight(tableViewBounds) - destViewHeight);
	} else {
		self.navigationItem.titleView = titleImageView;
	}
}


#pragma mark -
#pragma mark Memmory management

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
	
	self.mainTableView = nil;
	self.routeDestView = nil;
	self.destLabel = nil;
	self.destImageView = nil;
	self.destIdLabel = nil;
    backdrop = nil;
}

- (void)dealloc
{
	DDLogVerbose(@">>> %s <<<", __PRETTY_FUNCTION__);

}


#pragma mark -
#pragma mark UI methods

- (void)segmentAction:(id)sender
{
	int i = [sender selectedSegmentIndex];
	BTTrip * trip = [self.trips objectAtIndex:i];
	self.stops = trip.stops;
	destLabel.text = [NSString stringWithFormat:@"To %@", [[trips objectAtIndex:i] headsign]];
	[self.mainTableView reloadData];
}

- (void)showSchedule:(id)sender
{
	BTScheduleViewController *controller = [AppDelegate createScheduleViewController];
	if (controller != nil) {
		controller.route = route;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:controller];
        nav.navigationBar.tintColor = COLOR_NAV_BAR_BG;
		[self.navigationController presentModalViewController:nav animated:YES];
	}
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.stops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BTStopCellID";
    
    BTStopCell *cell = (BTStopCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[BTStopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	BTStop *stop = [self.stops objectAtIndex:indexPath.row];
	cell.stop = stop;
	
	NSString *imageName = [NSString stringWithFormat:@"%@_rail.png", route.shortName];
	UIImage *railImage = [UIImage imageNamed:imageName];
	if (railImage != nil) {
		cell.iconImage = railImage;
	} else {
		cell.iconImage = [UIImage imageNamed:@"default_rail.png"];
	}
	
	[cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	BTStop *selectedStop = [self.stops objectAtIndex:indexPath.row];
	selectedStop.selectedRoute = self.route;
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	BTPredictionViewController *controller = [AppDelegate createPredictionViewController];
	controller.stop = selectedStop;
	controller.prediction = nil;
	[self.navigationController pushViewController:controller animated:YES];
}

@end
