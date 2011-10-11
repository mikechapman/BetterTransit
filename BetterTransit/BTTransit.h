//
//  BTTransit.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BTRoute.h"
#import "BTStop.h"
#import "FMDatabase.h"

@interface BTTransit : NSObject {
}

// Database
@property (nonatomic, retain) FMDatabase *db;

@property (nonatomic, retain) NSMutableArray *routes;

// a dictionary for fast lookup of routes using short names
@property (nonatomic, retain) NSMutableDictionary *routesDict;

// for RoutesView tab, organized in sections
@property (nonatomic, retain) NSDictionary *routesToDisplay;

@property (nonatomic, retain) NSMutableArray *stops;

// a dictionary for fast lookup of stops using stopCodes
@property (nonatomic, retain) NSMutableDictionary *stopsDict;

// use tiles to quickly load annotations onto the map
@property (nonatomic, retain) NSMutableArray *tiles;

@property (nonatomic, retain) NSMutableArray *nearbyStops;
@property (nonatomic, retain) NSMutableArray *favoriteStops;

- (void)loadData;
- (void)loadRoutesFromDB;
- (void)loadStopsFromDB;
- (void)loadRoutesToDisplayFromPlist:(NSString *)fileName;
- (void)loadStopListsForRoute:(BTRoute *)route;
- (void)loadFavoriteStops;
- (void)loadScheduleForRoutes;

- (BTRoute *)routeWithId:(NSString *)routeId;
- (BTStop *)stopWithCode:(NSString *)stopCode;
- (NSArray *)routeShortNamesAtStop:(BTStop *)s;

- (void)updateNearbyStops;
- (void)sortStops:(NSMutableArray *)ss ByDistanceFrom:(CLLocation *)location;

@end
