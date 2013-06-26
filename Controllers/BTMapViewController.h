//
//  BTMapViewController.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BTTransit.h"
#import "BTPredictionViewController.h"

@interface BTMapViewController : UIViewController <MKMapViewDelegate>
{
	BTTransit *transit;
	NSArray *stops;
	
	MKMapView *mapView;
	NSMutableArray *annotations;
	NSMutableArray *lastVisibleTiles;
	
	UIBarButtonItem *locationUpdateButton;
	UIBarButtonItem *activityIndicator;
	UIActivityIndicatorView *activityIndicatorView;
}

@property (nonatomic, strong) NSArray *stops;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSMutableArray *lastVisibleTiles;
@property (nonatomic, strong) UIBarButtonItem *locationUpdateButton;
@property (nonatomic, strong) UIBarButtonItem *activityIndicator;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (void)setCenterLocation:(CLLocation *)location;
- (void)updateAnnotations;
- (void)addAnnotations;
- (void)removeAnnotations;

@end
