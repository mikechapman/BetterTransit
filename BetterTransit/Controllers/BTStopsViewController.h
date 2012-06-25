//
//  BTStopsViewController.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTransit.h"
#import "BTStopCell.h"
#import "BTPredictionViewController.h"

@interface BTStopsViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>
{
	BTTransit *transit;
	NSArray *stops;
	
    UIImageView * backdrop;
	UITableView *mainTableView;
    UIActivityIndicatorView * loadingSpinner;
	UIImageView *addToFavsView;
	UIImageView *noNearbyStopsView;
	UISegmentedControl *segmentedControl;
	UIBarButtonItem *locationUpdateButton;
	UIBarButtonItem *spinnerBarItem;
	UIActivityIndicatorView *spinner;
	
	BOOL isEditing;
	UIBarButtonItem *editButton;
	UIBarButtonItem *doneButton;
	
	BOOL viewIsShown;
}

@property (nonatomic, strong) NSArray *stops;
@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) UIActivityIndicatorView * loadingSpinner;
@property (nonatomic, strong) UIImageView *addToFavsView;
@property (nonatomic, strong) UIImageView *noNearbyStopsView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIBarButtonItem *locationUpdateButton;
@property (nonatomic, strong) UIBarButtonItem *spinnerBarItem;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, assign) BOOL viewIsShown;

- (IBAction)updateLocation:(id)sender;
- (void)segmentAction:(id)sender;
- (void)refreshView;
- (void)editFavs:(id)sender;
- (void)saveFavs;
- (void)checkNumberOfNearbyStops;

@end
