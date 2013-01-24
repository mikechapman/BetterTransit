//
//  BTStopsViewController.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTStopsViewController.h"
#import "BTTransitDelegate.h"
#import "HALocationManager.h"
#import "HAUtils.h"
#import "BTAppSettings.h"

#ifdef FLURRY_KEY
#import "FlurryAnalytics.h"
#endif

@implementation BTStopsViewController
 
@synthesize stops;
@synthesize mainTableView, noNearbyStopsView, addToFavsView, addToFavsImage, loadingSpinner, segmentedControl;
@synthesize locationUpdateButton, spinnerBarItem, spinner;
@synthesize isEditing, editButton, doneButton;
@synthesize viewIsShown;


#pragma mark - View life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"Stops", @"");
	
	transit = [AppDelegate transit];
    
    // Set up mainTableView
	mainTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backdrop.png"]];
	mainTableView.separatorColor = COLOR_TABLE_VIEW_SEPARATOR;
	mainTableView.rowHeight = 60;
	
	self.viewIsShown = NO;
	self.stops = @[];
	self.isEditing = NO;
    
    // Setup the loading spinner in the middle of page
    self.loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingSpinner.center = CGPointMake(160, 180);
    loadingSpinner.hidesWhenStopped = YES;
    [self.view addSubview:loadingSpinner];
	
	// Setup segmented control
	NSArray *items = @[NSLocalizedString(@"Nearby", @""),
					  NSLocalizedString(@"Favorites", @"")];
	self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 166, 30);
	
	NSString *s = [BTAppSettings startupScreen];
	if ([s isEqualToString:@"Favorites"]) {
		[segmentedControl setSelectedSegmentIndex:1];
	} else {
		[segmentedControl setSelectedSegmentIndex:0];
	}
	
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = segmentedControl;
	
	// Setup locate button
	UIButton *locateButton = [UIButton buttonWithType:UIButtonTypeCustom];
	locateButton.frame = CGRectMake(0, 0, 34, 28);
	[locateButton setImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
	[locateButton addTarget:self action:@selector(updateLocation:) forControlEvents:UIControlEventTouchUpInside];
	locationUpdateButton = [[UIBarButtonItem alloc] initWithCustomView:locateButton];
	
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	spinner.hidesWhenStopped = YES;
	
	spinnerBarItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	self.navigationItem.rightBarButtonItem = locationUpdateButton;
	
	self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
																	target:self 
																	action:@selector(editFavs:)];
	
	self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																	target:self
																	action:@selector(editFavs:)];
	
	// An illustration showing how to add a bus stop to favorites
    addToFavsImage = [UIImage imageNamed:ADD_TO_FAVS_PNG];
	addToFavsView.hidden = YES;
	
	// An illustration showing that no nearby stops are found.
    noNearbyStopsView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self refreshView];
	self.viewIsShown = YES;

#ifdef FLURRY_KEY
	[FlurryAnalytics logEvent:@"DID_SHOW_STATION_VIEW"];
#endif
	
	// Observe notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(startUpdatingLocation:)
												 name:kStartUpdatingLocationNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(didUpdateToLocation:)
												 name:kDidUpdateToLocationNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(didFailToUpdateLocation:)
												 name:kDidFailToUpdateLocationNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(locationDidNotChange:)
												 name:kLocationDidNotChangeNotification
											   object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	self.viewIsShown = NO;
	if (isEditing)
	{
		[mainTableView setEditing:NO animated:NO];
		isEditing = NO;
		[self saveFavs];
	}
}
 
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */


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
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.mainTableView = nil;
    self.loadingSpinner = nil;
	self.addToFavsView = nil;
	self.noNearbyStopsView = nil;
	self.segmentedControl = nil;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UI methods

- (void)segmentAction:(id)sender
{
	if (isEditing) {
		[mainTableView setEditing:NO animated:NO];
		isEditing = NO;
		[self saveFavs];
	}
	
	[self refreshView];
	[mainTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)refreshView
{
	switch ([segmentedControl selectedSegmentIndex]) {
		case 0:
            noNearbyStopsView.hidden = NO;
            loadingSpinner.hidden = NO;
            addToFavsView.hidden = YES;
			[self.navigationItem setRightBarButtonItem:locationUpdateButton animated:NO];
            
            if ([[HALocationManager defaultManager] isUpdatingLocation])
            {
                // Show the loading spinner
                [loadingSpinner startAnimating];
                [self.view bringSubviewToFront:loadingSpinner];
                
                // Hide the illustration for no nearby stops
                noNearbyStopsView.hidden = YES;
            }
            else if ([[HALocationManager defaultManager] locationFound])
            {
				[transit updateNearbyStops];
				self.stops = transit.nearbyStops;
                noNearbyStopsView.hidden = YES;
                [loadingSpinner stopAnimating];
			}
            else
            {
				noNearbyStopsView.hidden = NO;
                [self.view bringSubviewToFront:noNearbyStopsView];
                [loadingSpinner stopAnimating];
			}

#ifdef FLURRY_KEY
			[FlurryAnalytics logEvent:@"CLICKED_NEARBY"];
#endif
			break;
		case 1:
            noNearbyStopsView.hidden = YES;
            loadingSpinner.hidden = YES;
            addToFavsView.hidden = NO;
            
			self.stops = transit.favoriteStops;
			if ([self.stops count] == 0) {
				addToFavsView.hidden = NO;
				[self.view bringSubviewToFront:addToFavsView];
				addToFavsView.alpha = 0.0;
				
				[UIView beginAnimations:nil context:nil];
				[UIView setAnimationDuration:0.3];
				addToFavsView.alpha = 1.0;
				[UIView commitAnimations];
				
				[self.navigationItem setRightBarButtonItem:nil animated:YES];
			} else {
				addToFavsView.hidden = YES;
				[self.navigationItem setRightBarButtonItem:editButton animated:NO];
			}

#ifdef FLURRY_KEY
			[FlurryAnalytics logEvent:@"CLICKED_FAVS"];
#endif
			break;
		default:
			break;
	}
	[mainTableView reloadData];
}

- (void)editFavs:(id)sender
{
	if (isEditing) { // Done button pressed
		[mainTableView setEditing:NO animated:YES];
		isEditing = NO;
		[self.navigationItem setRightBarButtonItem:editButton animated:NO];
		[self saveFavs];
		
	} else { // Edit button pressed
		[mainTableView setEditing:YES animated:YES];
		isEditing = YES;
		[self.navigationItem setRightBarButtonItem:doneButton animated:NO];
	}
}

- (void)saveFavs
{
	// Save the favorites
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *favs = [NSMutableArray array];
	for (BTStop *s in transit.favoriteStops) {
		[favs addObject:s.stopCode];
	}
	[prefs setObject:favs forKey:@"favorites"];
	[prefs synchronize];
}

- (void)checkNumberOfNearbyStops
{
	if (self.viewIsShown && segmentedControl.selectedSegmentIndex == 0 
		&& [transit.nearbyStops count] == 0) {
		noNearbyStopsView.hidden = NO;
		[self.view bringSubviewToFront:noNearbyStopsView];
	} else {
		noNearbyStopsView.hidden = YES;
	}
}

- (IBAction)updateLocation:(id)sender
{
	[[HALocationManager defaultManager] startUpdatingLocation];
}


#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.stops count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BTStopCellID";
	
	BTStopCell *cell = (BTStopCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[BTStopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	BTStop *stop = [self.stops objectAtIndex:indexPath.row];
	cell.stop = stop;
	
	NSString *imageName = [NSString stringWithFormat:@"stop_%d.png", stop.stopColor];
	UIImage *stopImage = [UIImage imageNamed:imageName];
	if (stopImage != nil) {
		cell.iconImage = stopImage;
	} else {
		cell.iconImage = [UIImage imageNamed:@"default_stop.png"];
	}
	
	[cell setNeedsDisplay];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	BTStop *selectedStop = [self.stops objectAtIndex:indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	BTPredictionViewController *controller = [AppDelegate createPredictionViewController];
	controller.stop = selectedStop;
	controller.prediction = nil;
	[self.navigationController pushViewController:controller animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellEditingStyle style;
	if (segmentedControl.selectedSegmentIndex == 0) {
		style = UITableViewCellEditingStyleNone;
	} else {
		style = UITableViewCellEditingStyleDelete;
	}
	return style;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		BTStop *stop = [stops objectAtIndex:indexPath.row];
		stop.favorite = NO;
		[transit.favoriteStops removeObject:stop];
        [self saveFavs];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
		if ([transit.favoriteStops count] == 0) {
			[mainTableView setEditing:NO animated:YES];
			isEditing = NO;
			[self refreshView];
		}
	}
}

// The following two methods are required for reordering rows
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	BTStop *stop = [stops objectAtIndex:fromIndexPath.row];
	[transit.favoriteStops removeObject:stop];
	[transit.favoriteStops insertObject:stop atIndex:toIndexPath.row];
}


#pragma mark - Location updates

- (void)startUpdatingLocation:(NSNotification *)notification
{
	if (segmentedControl.selectedSegmentIndex == 0) {
		self.navigationItem.rightBarButtonItem = spinnerBarItem;
	}
	[self.spinner startAnimating];
}

- (void)didUpdateToLocation:(NSNotification *)notification
{
	[self checkNumberOfNearbyStops];
	[self refreshView];
	[self.spinner stopAnimating];
	if (segmentedControl.selectedSegmentIndex == 0) {
		self.navigationItem.rightBarButtonItem = locationUpdateButton;
	}
}

- (void)didFailToUpdateLocation:(NSNotification *)notification
{
	[self.spinner stopAnimating];
    [self refreshView];
	if (segmentedControl.selectedSegmentIndex == 0) {
		self.navigationItem.rightBarButtonItem = locationUpdateButton;
	}
}

- (void)locationDidNotChange:(NSNotification *)notification
{
	[self.spinner stopAnimating];
	if (segmentedControl.selectedSegmentIndex == 0) {
		self.navigationItem.rightBarButtonItem = locationUpdateButton;
	}
}	

@end
