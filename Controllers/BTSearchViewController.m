//
//  BTSearchViewController.m
//  BetterTransit
//
//  Created by Yaogang Lian on 11/10/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import "BTSearchViewController.h"
#import "HAUtils.h"
#import "BTTransitDelegate.h"

#ifdef FLURRY_KEY
#import "Flurry.h"
#endif

@implementation BTSearchViewController

@synthesize stops;
@synthesize searchBar, mainTableView;

#define KEYBOARD_HEIGHT 216
#define TAB_BAR_HEIGHT 49

#pragma mark - View life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"Search", @"");
	
	transit = [AppDelegate transit];
    
    // Set up mainTableView
	mainTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backdrop.png"]];
	mainTableView.separatorColor = COLOR_TABLE_VIEW_SEPARATOR;
	mainTableView.rowHeight = 60;
	
	self.stops = nil;
	
	CGRect rect = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-20-44-KEYBOARD_HEIGHT);
	bigCancelButton = [[UIButton alloc] initWithFrame:rect];
	[bigCancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchDown];
	bigCancelButton.alpha = 1.0;
	bigCancelButtonIsShown = NO;
	
	noResultsLabel = [[UILabel alloc] initWithFrame:rect];
	noResultsLabel.font = [UIFont boldSystemFontOfSize:19];
	noResultsLabel.text = @"No Results";
	noResultsLabel.textColor = [UIColor darkGrayColor];
	noResultsLabel.backgroundColor = [UIColor clearColor];
	noResultsLabel.textAlignment = UITextAlignmentCenter;
	noResultsLabelIsShown = NO;
	
	// change label text on search keyboard to "Done"
	for (UIView *searchBarSubview in [searchBar subviews]) {
		if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
			@try {
				[(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
			}
			@catch (NSException * e) {
				// ignore exception
			}
		}
	}
	
	[self registerForKeyboardNotifications];
	[searchBar becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    
#ifdef FLURRY_KEY
	[Flurry logEvent:@"DID_SHOW_SEARCH_VIEW"];
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
	self.searchBar = nil;
}

- (void)dealloc
{
	bigCancelButton = nil;
	noResultsLabel = nil;
}


#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.stops count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BTStopSearchCellID";
    
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[searchBar resignFirstResponder];
	return indexPath;
}


#pragma mark - UISearchBarDelegate Methods 

- (void)searchBar:(UISearchBar *)sb textDidChange:(NSString *)searchText
{
	[self handleSearchForTerm:searchText];
	[mainTableView reloadData];
	
	// Show "No Results" if search text is not empty but stop list is empty after search
	if ([searchText length] > 0 && [self.stops count] == 0) {
		if (!noResultsLabelIsShown) {
			[self.view addSubview:noResultsLabel];
			noResultsLabelIsShown = YES;
		}
	} else {
		if (noResultsLabelIsShown) {
			[noResultsLabel removeFromSuperview];
			noResultsLabelIsShown = NO;
		}
	}
	
	// Show the invisible big cancel button as long as stop list is empty and keyboard is on
	if ([self.stops count] == 0  && !bigCancelButtonIsShown) {
		[self.view addSubview:bigCancelButton];
		bigCancelButtonIsShown = YES;
	} else if ([self.stops count] > 0 && bigCancelButtonIsShown) {
		[bigCancelButton removeFromSuperview];
		bigCancelButtonIsShown = NO;
	}
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sb
{
	NSString *searchText = [sb text];
	[self handleSearchForTerm:searchText];
	[mainTableView reloadData];
	[sb resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)sb
{
	sb.text = @"";
	self.stops = nil;
	[mainTableView reloadData];
	[sb resignFirstResponder];
}

- (void)handleSearchForTerm:(NSString *)term
{
	if ([term length] > 0) {
        // Use a dictionary here to deduplicate stops with the same stop code. This can happen when we combine two GTFS datasets.
        NSMutableDictionary * foundStopsDict = [NSMutableDictionary dictionary];
		for (BTStop *stop in transit.stops) {
			NSRange range1 = [stop.stopName rangeOfString:term options:NSCaseInsensitiveSearch];
			NSRange range2 = [stop.stopCode rangeOfString:term options:NSCaseInsensitiveSearch];
			if (range1.location != NSNotFound || range2.location != NSNotFound) {
                [foundStopsDict setObject:stop forKey:stop.stopCode];
			}
		}
		self.stops = [foundStopsDict allValues];
	} else {
		self.stops = nil;
	}
}

#pragma mark - Hide/Show keyboard

- (void)registerForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardDidShow:) 
												 name:UIKeyboardDidShowNotification 
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

- (void)keyboardDidShow:(NSNotification*)aNotification
{
	// Show the invisible big cancel button as long as stop list is empty and keyboard is on
	if ([self.stops count] == 0 && !bigCancelButtonIsShown) {
		[self.view addSubview:bigCancelButton];
		bigCancelButtonIsShown = YES;
	}
	mainTableView.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height+TAB_BAR_HEIGHT-44-KEYBOARD_HEIGHT);
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
	// Remove the invisible big cancel button when keyboard hides
	if (bigCancelButtonIsShown) {
		[bigCancelButton removeFromSuperview];
		bigCancelButtonIsShown = NO;
	}
	mainTableView.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44);
}

- (void)cancel:(id)sender
{
	[searchBar resignFirstResponder];
}

@end
