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

// a dictionary for fast lookup of routes using routeId
@property (nonatomic, retain) NSMutableDictionary * routeIds;

// a dictionary for fast lookup of routes using short name (may not be unique)
@property (nonatomic, retain) NSMutableDictionary * routeNames;

// for RoutesView tab, organized in sections
@property (nonatomic, retain) NSDictionary * routesToDisplay;

@property (nonatomic, retain) NSMutableArray *stops;

// a dictionary for fast lookup of stops using stopId
@property (nonatomic, retain) NSMutableDictionary * stopIds;

// use tiles to quickly load annotations onto the map
@property (nonatomic, retain) NSMutableArray *tiles;

@property (nonatomic, retain) NSMutableArray *nearbyStops;
@property (nonatomic, retain) NSMutableArray *favoriteStops;

- (void)loadData;
- (void)loadRoutesFromDB;
- (void)loadStopsFromDB;
- (void)loadRoutesToDisplayFromPlist:(NSString *)fileName;
- (void)loadFavoriteStops;
- (void)loadScheduleForRoutes;

- (BTRoute *)routeWithId:(NSString *)routeId;
- (BTRoute *)routeWithShortName:(NSString *)shortName;
- (BTStop *)stopWithId:(NSString *)stopId;
- (BTStop *)stopWithCode:(NSString *)stopCode;

- (NSArray *)tripsForRoute:(BTRoute *)route;
- (NSArray *)routesAtStop:(BTStop *)stop;

- (void)updateNearbyStops;
- (void)sortStops:(NSMutableArray *)ss ByDistanceFrom:(CLLocation *)location;

@end
