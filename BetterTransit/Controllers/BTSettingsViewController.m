//
//  BTSettingsViewController.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/17/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTSettingsViewController.h"
#import "BTTransitDelegate.h"
#import "HAListViewController.h"
#import "Utility.h"
#import "BTAppSettings.h"

#ifdef FLURRY_KEY
#import "FlurryAnalytics.h"
#endif

@implementation BTSettingsViewController

@synthesize startupScreenOptions, maxNumNearbyStopsOptions;


#pragma mark -
#pragma mark View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Settings", @"");
    
    self.sectionOffset = 1;
	
	transit = [AppDelegate transit];
	
	self.startupScreenOptions = [NSArray arrayWithObjects:@"Nearby", @"Favorites", @"Map", @"Routes", @"Search", nil];
	self.maxNumNearbyStopsOptions = [NSArray arrayWithObjects:@"10", @"20", @"30", @"50", @"100", @"No Limit", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mainTableView reloadData];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	DDLogVerbose(@">>> %s <<<", __PRETTY_FUNCTION__);
	[startupScreenOptions release], startupScreenOptions = nil;
	[maxNumNearbyStopsOptions release], maxNumNearbyStopsOptions = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
	int numberOfRows;
    if (section == 0) {
		numberOfRows = 2;
	} else {
		numberOfRows = [super tableView:tv numberOfRowsInSection:section];
	}
	
	return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (section == 0) {
        return @"Application Settings";
    } else {
        return [super tableView:tableView titleForHeaderInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *BTSettingsCellIdentifier = @"BTSettingsCell";
	
	UITableViewCell *cell;
	if (indexPath.section == 0)
	{
		cell = [tableView dequeueReusableCellWithIdentifier:BTSettingsCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BTSettingsCellIdentifier] autorelease];
		}
		
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"Startup Screen";
				cell.detailTextLabel.text = [BTAppSettings startupScreen];
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				break;
			case 1:
				cell.textLabel.text = @"Max No. of Nearby Stops";
				cell.detailTextLabel.text = [BTAppSettings maxNumNearbyStops];
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				break;
			default:
				break;
		}
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 0)
	{
		HAListViewController *controller = [[HAListViewController alloc] init];
		switch (indexPath.row) {
			case 0:
				controller.list = self.startupScreenOptions;
				controller.selectedIndex = [self.startupScreenOptions indexOfObject:[BTAppSettings startupScreen]];
				controller.title = @"Startup Screen";
				controller.tag = TAG_LIST_STARTUP_SCREEN;
				break;
			case 1:
				controller.list = self.maxNumNearbyStopsOptions;
				controller.selectedIndex = [self.maxNumNearbyStopsOptions indexOfObject:[BTAppSettings maxNumNearbyStops]];
				controller.title = @"Max Number of Stops";
				controller.tag = TAG_LIST_MAX_NUM_NEARBY_STOPS;
				break;
			default:
				break;
		}
		controller.delegate = self;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
    else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark -
#pragma mark ListViewControllerDelegate methods

- (void)setSelectedIndex:(NSUInteger)index inList:(NSInteger)tag
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    switch (tag) {
        case TAG_LIST_STARTUP_SCREEN:
        {
            NSString *s = [self.startupScreenOptions objectAtIndex:index];
            [prefs setObject:s forKey:KEY_STARTUP_SCREEN];
        }
            break;
            
        case TAG_LIST_MAX_NUM_NEARBY_STOPS:
        {
            NSString *s = [self.maxNumNearbyStopsOptions objectAtIndex:index];
            [prefs setObject:s forKey:KEY_MAX_NUM_NEARBY_STOPS];
        }
            break;
            
        default:
            break;
    }
	[prefs synchronize];
}

@end
