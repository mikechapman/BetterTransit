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
#import "UIViewControllerWithAd.h"
#endif

@interface BTPredictionViewController :
#ifdef SHOW_ADS
UIViewControllerWithAd
#else
UIViewController
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

@property (nonatomic, strong) BTStop *stop;
@property (nonatomic, strong) NSMutableArray *prediction;
@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) IBOutlet UIView *stopInfoView;
@property (nonatomic, strong) EGORefreshTableHeaderView *_refreshHeaderView;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UILabel *stopDescLabel;
@property (nonatomic, strong) IBOutlet UILabel *stopIdLabel;
@property (nonatomic, strong) IBOutlet UILabel *stopDistanceLabel;
@property (nonatomic, strong) IBOutlet UIButton *favButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *errorMessage;

- (IBAction)setFav:(id)sender;
- (void)checkBusArrival;
- (void)moveFavsToTop;
- (void)startTimer;

- (BTPredictionCell *)createNewCell;

@end
