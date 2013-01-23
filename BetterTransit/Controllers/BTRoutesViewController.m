//
//  BTRoutesViewController.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTRoutesViewController.h"
#import "BTTripViewController.h"
#import "BTTransitDelegate.h"
#import "BTRouteCell.h"

#ifdef FLURRY_KEY
#import "FlurryAnalytics.h"
#endif

@implementation BTRoutesViewController

@synthesize mainTableView;
@synthesize routesToDisplay, sectionNames;


#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Routes", @"");
	
	transit = [AppDelegate transit];
    
    // Set up backdrop
    backdrop = [[UIImageView alloc] initWithFrame:self.view.bounds];
	backdrop.image = [UIImage imageNamed:@"backdrop.png"];
	[self.view insertSubview:backdrop atIndex:0];
	backdrop.alpha = 1.0;
	
    // Set up mainTableView
	mainTableView.backgroundColor = [UIColor clearColor];
	mainTableView.separatorColor = COLOR_TABLE_VIEW_SEPARATOR;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	self.routesToDisplay= transit.routesToDisplay;
	self.sectionNames = [self.routesToDisplay objectForKey:@"SectionNames"];
	[mainTableView reloadData];

#ifdef FLURRY_KEY
	[FlurryAnalytics logEvent:@"DID_SHOW_ROUTES_VIEW"];
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
	self.mainTableView = nil;
    backdrop = nil;
}

- (void)dealloc
{
	DDLogVerbose(@">>> %s <<<", __PRETTY_FUNCTION__);
}


#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.sectionNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSString *key = [self.sectionNames objectAtIndex:section];
	NSArray *routesInSection = [self.routesToDisplay objectForKey:key];
	return [routesInSection count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"RouteCellID";
	
	BTRouteCell *cell = (BTRouteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [AppDelegate createRouteCellWithIdentifier:CellIdentifier];
	}
	
	NSString *key = [self.sectionNames objectAtIndex:indexPath.section];
	NSArray *routesInSection = [self.routesToDisplay objectForKey:key];
	NSString *routeId = [routesInSection objectAtIndex:indexPath.row];
	BTRoute *route = [transit routeWithId:routeId];
	cell.route = route;
	
	cell.iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", route.shortName]];
	[cell setNeedsDisplay];
    
    // Hide the disclosure button if the index titles are shown
    if ([self.sectionNames count] >= 8) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ([self.sectionNames count] > 1) {
		return [self.sectionNames objectAtIndex:section];
	} else {
		return nil;
	}
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if ([self.sectionNames count] >= 8) {
		return self.sectionNames;
	} else {
		return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	NSString *key = [self.sectionNames objectAtIndex:indexPath.section];
	NSArray *routesInSection = [self.routesToDisplay objectForKey:key];
	NSString *routeId = [routesInSection objectAtIndex:indexPath.row];
	BTRoute *selectedRoute = [transit routeWithId:routeId];
	
	BTTripViewController *controller = [AppDelegate createTripViewController];
	controller.route = selectedRoute;
	[self.navigationController pushViewController:controller animated:YES];
}

@end
