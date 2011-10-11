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

@interface BTTransit : NSObject
{
	NSMutableArray *routes;
	NSMutableDictionary *routesDict; // a dictionary for fast lookup of routes
	NSDictionary *routesToDisplay; // for RoutesView tab, organized in sections
	NSMutableArray *stations;
	NSMutableDictionary *stationsDict; // a dictionary for fast lookup of stations
	NSMutableArray *tiles; // use tiles to quickly load annotations onto the map
	NSMutableArray *nearbyStops;
	NSMutableArray *favoriteStops;
	
	// Database
	FMDatabase *db;
}

@property (nonatomic, retain) NSMutableArray *routes;
@property (nonatomic, retain) NSMutableDictionary *routesDict;
@property (nonatomic, retain) NSDictionary *routesToDisplay;
@property (nonatomic, retain) NSMutableArray *stations;
@property (nonatomic, retain) NSMutableDictionary *stationsDict;
@property (nonatomic, retain) NSMutableArray *tiles;
@property (nonatomic, retain) NSMutableArray *nearbyStops;
@property (nonatomic, retain) NSMutableArray *favoriteStops;
@property (nonatomic, retain) FMDatabase *db;

- (void)loadData;
- (void)loadRoutesFromDB;
- (void)loadStopsFromDB;
- (void)loadRoutesToDisplayFromPlist:(NSString *)fileName;
- (void)loadStopListsForRoute:(BTRoute *)route;
- (NSArray *)routeIdsAtStop:(BTStop *)s;
- (void)loadFavoriteStops;
- (void)updateNearbyStops;
- (void)loadScheduleForRoutes;
- (BTStop *)stationWithId:(NSString *)stationId;
- (BTRoute *)routeWithId:(NSString *)routeId;
- (void)sortStops:(NSMutableArray *)ss ByDistanceFrom:(CLLocation *)location;
- (NSArray *)filterStops:(NSArray *)ss;
- (BOOL)checkStop:(BTStop *)s;
- (NSDictionary *)filterRoutes:(NSDictionary *)rs;
- (NSMutableArray *)filterPrediction:(NSMutableArray *)p;

@end
