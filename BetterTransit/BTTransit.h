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
@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) NSMutableArray *routes;

// a dictionary for fast lookup of routes using routeId
@property (nonatomic, strong) NSMutableDictionary * routeIds;

// a dictionary for fast lookup of routes using short name (may not be unique)
@property (nonatomic, strong) NSMutableDictionary * routeNames;

// for RoutesView tab, organized in sections
@property (nonatomic, strong) NSDictionary * routesToDisplay;

@property (nonatomic, strong) NSMutableArray *stops;

// a dictionary for fast lookup of stops using stopId
@property (nonatomic, strong) NSMutableDictionary * stopIds;

// use tiles to quickly load annotations onto the map
@property (nonatomic, strong) NSMutableArray *tiles;

@property (nonatomic, strong) NSMutableArray *nearbyStops;
@property (nonatomic, strong) NSMutableArray *favoriteStops;

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
