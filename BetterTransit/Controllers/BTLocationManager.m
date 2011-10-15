//
//  BTLocationManager.m
//  BetterTransit
//
//  Created by Yaogang Lian on 2/4/11.
//  Copyright 2011 Happen Next. All rights reserved.
//

#import "BTLocationManager.h"

#ifdef FLURRY_KEY
#import "FlurryAPI.h"
#endif


@implementation BTLocationManager

@synthesize locationManager, isUpdatingLocation, locationFound, currentLocation;


static BTLocationManager *sharedInstance = nil;
+ (BTLocationManager *)sharedInstance
{
	if (sharedInstance == nil) {
		sharedInstance = [[BTLocationManager alloc] init];
	}
	return sharedInstance;
}


#pragma mark -
#pragma mark Object life cycle

- (id)init
{
    self = [super init];
	if (self) {
		locationManager = [[CLLocationManager alloc] init];
		[locationManager setDelegate:self]; // send location update to self
		[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
		isUpdatingLocation = NO;
		locationFound = NO;
		currentLocation = nil;
	}
	return self;
}

- (void)dealloc
{
	locationManager.delegate = nil;
	[locationManager release], locationManager = nil;
	[currentLocation release], currentLocation = nil;
	[super dealloc];
}

- (CLLocation *)currentLocation
{
	if (currentLocation == nil) {
		currentLocation = [[CLLocation alloc] initWithLatitude:CENTER_LATITUDE longitude:CENTER_LONGITUDE];
	}
	return currentLocation;
}


#pragma mark -
#pragma mark Location management

- (void)startUpdatingLocation 
{
	if (isUpdatingLocation) return;
	
	isUpdatingLocation = YES;
  	[locationManager startUpdatingLocation];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kStartUpdatingLocationNotification
														object:self
													  userInfo:nil];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation 
{
	[locationManager stopUpdatingLocation];
	isUpdatingLocation = NO;
	locationFound = YES;
	
	// If the user's location didn't change much, don't bother sending out notifications
	if (fabs([newLocation getDistanceFrom:self.currentLocation]) < 100) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kLocationDidNotChangeNotification
															object:self
														  userInfo:nil];
	} else {
#ifdef PRODUCTION_READY
		self.currentLocation = newLocation;
#endif
        
#ifdef FLURRY_KEY
        [FlurryAPI setLatitude:newLocation.coordinate.latitude
                     longitude:newLocation.coordinate.longitude
            horizontalAccuracy:newLocation.horizontalAccuracy
              verticalAccuracy:newLocation.verticalAccuracy];
#endif
		
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.currentLocation forKey:@"location"];
		[[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateToLocationNotification
															object:self
														  userInfo:userInfo];
	}
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	[manager stopUpdatingLocation];
	isUpdatingLocation = NO;
	locationFound = NO;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kDidFailToUpdateLocationNotification 
														object:self
													  userInfo:nil];
	
	// NSLog(@"location manager failed");
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:@"Your location could not be determined."
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
	 */
}

@end
