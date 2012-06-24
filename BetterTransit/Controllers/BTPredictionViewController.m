//
//  BTPredictionViewController.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTPredictionViewController.h"
#import "BTAnnotation.h"
#import "BTPredictionEntry.h"
#import "BTTransitDelegate.h"
#import "Utility.h"
#import "TitleViewLabel.h"
#import "LoadingCell.h"
#import "ErrorCell.h"

#ifdef FLURRY_KEY
#import "FlurryAnalytics.h"
#endif

@implementation BTPredictionViewController

@synthesize stop, prediction;
@synthesize mainTableView, stopInfoView, _refreshHeaderView, mapView;
@synthesize stopDescLabel, stopIdLabel, stopDistanceLabel, favButton;
@synthesize timer;
@synthesize errorMessage;


#pragma mark - Initialization

- (id)init
{
    self = [super initWithNibName:@"BTPredictionViewController" bundle:[NSBundle mainBundle]];
	if (self) {
        downloadStatus = DOWNLOAD_STATUS_INIT;
        self.errorMessage = nil;
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	transit = [AppDelegate transit];
	
	mainTableView.backgroundColor = [UIColor clearColor];
	mainTableView.separatorColor = COLOR_TABLE_VIEW_SEPARATOR;
	mainTableView.rowHeight = 72;
	
    // Setup title view
    TitleViewLabel *label = [[TitleViewLabel alloc] initWithText:stop.stopName];
    self.navigationItem.titleView = label;
    
	// mapView settings
	[mapView setMapType:MKMapTypeStandard];
	[mapView setUserInteractionEnabled:NO];
    
    // Pull to refresh header
	if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *v = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - mainTableView.bounds.size.height, self.view.frame.size.width, mainTableView.bounds.size.height)];
		v.delegate = self;
		[v refreshLastUpdatedDate];
		[self.mainTableView addSubview:v];
		self._refreshHeaderView = v;
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	// Make sure navigation bar will be shown
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.frame = CGRectMake(0, 0, 320, 416);
    [super viewWillAppear:animated];
	
	stopDescLabel.text = stop.stopName;
	stopIdLabel.text = [NSString stringWithFormat:@"Bus stop #%@", stop.stopCode];
	if (stop.distance > -1.0) {
		stopDistanceLabel.text = [Utility formattedStringForDistance:stop.distance];
	} else { // don't display distance if user location is not found
		stopDistanceLabel.text = @"";
	}
	
	if (stop.favorite) {
        [self.favButton setImage:[UIImage imageNamed:@"favorite_icon.png"] forState:UIControlStateNormal];
        [self.favButton setImage:[UIImage imageNamed:@"favorite_icon.png"] forState:UIControlStateHighlighted];
	} else {
        [self.favButton setImage:[UIImage imageNamed:@"favorite_icon_gray.png"] forState:UIControlStateNormal];
        [self.favButton setImage:[UIImage imageNamed:@"favorite_icon_gray.png"] forState:UIControlStateHighlighted];
	}
	
	// reset annotation to that of current selected stop
	NSArray *annotations = mapView.annotations;
	if (annotations) {
		[mapView removeAnnotations:annotations];
	}
    
	BTAnnotation *annotation = [[BTAnnotation alloc] init];
	annotation.title = stop.stopName;
	annotation.subtitle = [NSString stringWithFormat:@"Bus stop #%@", stop.stopCode];
	CLLocationCoordinate2D coordinate = {0,0};
	coordinate.latitude = stop.latitude;
	coordinate.longitude = stop.longitude;
	annotation.coordinate = coordinate;
	annotation.stop = stop;
	[mapView addAnnotation:annotation];
	
	// set map view region
	MKCoordinateRegion region = {{0.0, 0.0}, {0.0, 0.0}};
	region.center = coordinate;
	region.span.longitudeDelta = 0.003;
	region.span.latitudeDelta = 0.003;
	[mapView setRegion:region animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
    [self checkBusArrival];
	[self startTimer];
	
#ifdef FLURRY_KEY
	NSDictionary *flurryDict = [NSDictionary dictionaryWithObjectsAndKeys:stop.stopCode, @"stopID", nil];
	[FlurryAnalytics logEvent:@"DID_SHOW_PREDICTION_VIEW" withParameters:flurryDict];
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.timer invalidate];
    [[AppDelegate feedLoader] cancelAllDownloads];
	[[AppDelegate feedLoader] setDelegate:nil];
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
    [_refreshHeaderView setDelegate:nil];
    self._refreshHeaderView = nil;
	self.mapView = nil;
	self.stopDescLabel = nil;
	self.stopIdLabel = nil;
	self.stopDistanceLabel = nil;
	self.favButton = nil;
}

- (void)dealloc
{
    [_refreshHeaderView setDelegate:nil];
}


#pragma mark - UI methods

- (IBAction)setFav:(id)sender
{
	stop.favorite = !stop.favorite;
	
	if (stop.favorite) {
		[self.favButton setImage:[UIImage imageNamed:@"favorite_icon.png"] forState:UIControlStateNormal];
		[self.favButton setImage:[UIImage imageNamed:@"favorite_icon.png"] forState:UIControlStateHighlighted];
		[transit.favoriteStops addObject:self.stop];
	} else {
		[self.favButton setImage:[UIImage imageNamed:@"favorite_icon_gray.png"] forState:UIControlStateNormal];
		[self.favButton setImage:[UIImage imageNamed:@"favorite_icon_gray.png"] forState:UIControlStateHighlighted];
		[transit.favoriteStops removeObject:self.stop];
	}
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSMutableArray *favs = [NSMutableArray array];
	for (BTStop *s in transit.favoriteStops) {
		[favs addObject:s.stopCode];
	}
	[prefs setObject:favs forKey:@"favorites"];
	[prefs synchronize];
}

- (void)checkBusArrival
{
    if (_reloading) return;
    _reloading = YES;
    
	[[AppDelegate feedLoader] setDelegate:self];
	[[AppDelegate feedLoader] getPredictionForStop:self.stop];
}

- (void)moveFavsToTop
{
	// subclass will override
}

- (void)startTimer
{
	// refresh time table every 20 seconds as long as this page stays open
	self.timer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_INTERVAL target:self selector:@selector(checkBusArrival) userInfo:nil repeats:YES];
}


#pragma mark - BTFeedLoaderDelegate methods

- (void)updatePrediction:(id)info
{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainTableView];
	
	if (info != nil && [info isKindOfClass:[NSArray class]]) {
		self.prediction = (NSMutableArray *)info;
		[self moveFavsToTop];
        
		if ([self.prediction count] > 0) {
            downloadStatus = DOWNLOAD_STATUS_SUCCEEDED;
            self.errorMessage = nil;
		} else {
            downloadStatus = DOWNLOAD_STATUS_FAILED;
            self.errorMessage = @"No bus is coming in the next 30 mins.";
		}
		
	} else {
        downloadStatus = DOWNLOAD_STATUS_FAILED;
        self.errorMessage = (info ? info : @"Failed to download data");
	}
    
    [self.mainTableView reloadData];
}


#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (downloadStatus == DOWNLOAD_STATUS_INIT || downloadStatus == DOWNLOAD_STATUS_FAILED) {
        return 2;
    } else {
        return [self.prediction count] + 1;
    }
}

- (BTPredictionCell *)createNewCell
{
	BTPredictionCell *newCell = nil;
	NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:@"BTPredictionCell"
													  owner:self options:nil];
	for (NSObject *nibItem in nibItems) {
		if ([nibItem isKindOfClass:[BTPredictionCell class]]) {
			newCell = (BTPredictionCell *)nibItem;
			break;
		}
	}
	return newCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *StopInfoCellIdentifier = @"StopInfoCellIdentifier";
    static NSString *PredictionCellIdentifier = @"PredictionCellIdentifier";
    static NSString *LoadingCellIdentifier = @"LoadingCellIdentifier";
    static NSString *ErrorCellIdentifier = @"ErrorCellIdentifier";
    
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StopInfoCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StopInfoCellIdentifier];
            [cell.contentView addSubview:stopInfoView];
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fiber_paper.png"]];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (downloadStatus == DOWNLOAD_STATUS_INIT && indexPath.row == 1)
    {
        LoadingCell *cell = (LoadingCell *)[tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
        if (cell == nil) {
            cell = [[LoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadingCellIdentifier];
        }
        
        [cell setText:@"Loading bus arrival times..."];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
    
    if (downloadStatus == DOWNLOAD_STATUS_FAILED && indexPath.row == 1)
    {
        ErrorCell *cell = (ErrorCell *)[tableView dequeueReusableCellWithIdentifier:ErrorCellIdentifier];
		if (cell == nil) {
			cell = [[ErrorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ErrorCellIdentifier];
		}
        cell.label = self.errorMessage;
		cell.image = [UIImage imageNamed:@"icn_warning.png"];
        cell.backgroundColor = [UIColor clearColor];
        
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
    
    BTPredictionCell *cell = (BTPredictionCell *)[tableView dequeueReusableCellWithIdentifier:PredictionCellIdentifier];
    if (cell == nil) {
		cell = [self createNewCell];
		// turn off selection use
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    cell.backgroundColor = [UIColor clearColor];
    
	BTPredictionEntry *entry = [self.prediction objectAtIndex:indexPath.row-1];
	cell.routeLabel.text = entry.route.longName;
	cell.destinationLabel.text = entry.destination;
	cell.estimateLabel.text = entry.eta;
	
	NSString *imageName = [NSString stringWithFormat:@"%@.png", entry.route.shortName];
	UIImage *routeImage = [UIImage imageNamed:imageName];
	if (routeImage) {
		[cell.imageView setImage:routeImage];
	} else {
		cell.idLabel.hidden = NO;
		cell.idLabel.text = entry.route.shortName;
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return 130.0f;
    else return 72.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)v
{
    downloadStatus = DOWNLOAD_STATUS_INIT;
    [self checkBusArrival];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)v
{	
	return _reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)v
{
    return [NSDate date];
}

@end
