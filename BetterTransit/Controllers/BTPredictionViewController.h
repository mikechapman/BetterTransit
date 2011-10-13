//
//  BTPredictionViewController.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BTTransit.h"
#import "BTStop.h"
#import "BTPredictionCell.h"
#import "BTFeedLoader.h"
#import "EGORefreshTableHeaderView.h"

#ifdef SHOW_ADS
#import "BTUIViewControllerWithAd.h"
#else
#import "BTUIViewController.h"
#endif

@interface BTPredictionViewController :
#ifdef SHOW_ADS
BTUIViewControllerWithAd
#else
BTUIViewController
#endif
<UITableViewDelegate, UITableViewDataSource, 
BTFeedLoaderDelegate, EGORefreshTableHeaderDelegate>
{
	BTTransit *transit;
	BTStop *stop;
	NSMutableArray *prediction;
	
	UITableView *mainTableView;
    UIView *stopInfoView;
	MKMapView *mapView;
	UILabel *stopDescLabel;
	UILabel *stopIdLabel;
	UILabel *stopDistanceLabel;
	UIButton *favButton;
	
	NSTimer *timer;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    NSUInteger downloadStatus;
    NSString *errorMessage;
}

@property (nonatomic, retain) BTStop *stop;
@property (nonatomic, retain) NSMutableArray *prediction;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet UIView *stopInfoView;
@property (nonatomic, retain) EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UILabel *stopDescLabel;
@property (nonatomic, retain) IBOutlet UILabel *stopIdLabel;
@property (nonatomic, retain) IBOutlet UILabel *stopDistanceLabel;
@property (nonatomic, retain) IBOutlet UIButton *favButton;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSString *errorMessage;

- (IBAction)setFav:(id)sender;
- (void)checkBusArrival;
- (void)moveFavsToTop;
- (void)startTimer;

- (BTPredictionCell *)createNewCell;

@end
