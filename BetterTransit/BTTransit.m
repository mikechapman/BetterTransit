//
//  BTTransit.m
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import "BTTransit.h"
#import "BTTrip.h"
#import "BTAppSettings.h"


@implementation BTTransit

@synthesize db, routes, routeIds, routeNames, routesToDisplay;
@synthesize stops, stopIds, tiles, nearbyStops, favoriteStops;


#pragma mark -
#pragma mark Initialization

- (id)init
{
    self = [super init];
	if (self) {
		routes = [[NSMutableArray alloc] initWithCapacity:NUM_ROUTES];
		routeIds = [[NSMutableDictionary alloc] initWithCapacity:NUM_ROUTES];
        routeNames = [[NSMutableDictionary alloc] initWithCapacity:NUM_ROUTES];
		routesToDisplay = nil;
		stops = [[NSMutableArray alloc] initWithCapacity:NUM_STOPS];
		stopIds = [[NSMutableDictionary alloc] initWithCapacity:NUM_STOPS];
		
#if NUM_TILES > 1
		tiles = [[NSMutableArray alloc] initWithCapacity:NUM_TILES];
		for (int i=0; i<NUM_TILES; i++) {
			NSMutableArray *tile = [[NSMutableArray alloc] initWithCapacity:20];
			[tiles addObject:tile];
		}
#else
		tiles = nil;
#endif
			
		nearbyStops = [[NSMutableArray alloc] init];
		favoriteStops = [[NSMutableArray alloc] init];
		
		[self loadData];
		
		// Observe notifications
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(didUpdateToLocation:)
													 name:kDidUpdateToLocationNotification
												   object:nil];
	}
	return self;
}

- (void)loadData
{
	// Load data from database
	NSString *path = [[NSBundle mainBundle] pathForResource:MAIN_DB ofType:@"db"];
	self.db = [FMDatabase databaseWithPath:path];
	if (![db open]) {
		NSLog(@"Could not open db.");
	}
	
	[self loadRoutesFromDB];
	[self loadRoutesToDisplayFromPlist:@"routesToDisplay"];
	[self loadScheduleForRoutes];
	[self loadStopsFromDB];
	[self loadFavoriteStops];
}

- (void)loadRoutesFromDB
{	
	FMResultSet *rs = [db executeQuery:@"select * from routes"];
	while ([rs next]) {
		BTRoute *route = [[BTRoute alloc] init];
		route.routeId = [rs stringForColumn:@"route_id"];
		route.agencyId = [rs stringForColumn:@"agency_id"];
        route.shortName = [rs stringForColumn:@"route_short_name"];
		route.longName = [rs stringForColumn:@"route_long_name"];
		[self.routes addObject:route];
		[self.routeIds setObject:route forKey:route.routeId];
        [self.routeNames setObject:route forKey:route.shortName];
	}
	[rs close];
}

- (void)loadStopsFromDB
{
	FMResultSet *rs = [db executeQuery:@"select * from stops"];
	while ([rs next]) {
		BTStop *stop = [[BTStop alloc] init];
		stop.stopId = [rs stringForColumn:@"stop_id"];
        stop.stopCode = [rs stringForColumn:@"stop_code"];
        stop.stopName = [rs stringForColumn:@"stop_name"];
        stop.latitude = [rs doubleForColumn:@"stop_lat"];
        stop.longitude = [rs doubleForColumn:@"stop_lon"];
		[self.stops addObject:stop];
		[self.stopIds setObject:stop forKey:stop.stopId];
		
#if NUM_TILES > 1
		stop.tileNumber = [rs intForColumn:@"tile"];
		NSMutableArray *tile = [tiles objectAtIndex:stop.tileNumber];
		[tile addObject:stop];
#endif
	}
	[rs close];
}

- (void)loadRoutesToDisplayFromPlist:(NSString *)fileName
{
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
	self.routesToDisplay = [[NSDictionary alloc] initWithContentsOfFile:path];
}

- (void)loadScheduleForRoutes
{
	// implement this method in subclass if necessary
}

- (void)loadFavoriteStops
{	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSArray *p = [prefs objectForKey:@"favorites"];
    
	if (p != nil) {
		for (NSString *stopCode in p) {
			BTStop *stop = [self stopWithCode:stopCode];
            if (stop == nil) continue;
			stop.favorite = YES;
			[self.favoriteStops addObject:stop];
		}
	}
}

- (BTRoute *)routeWithId:(NSString *)routeId
{
    if (routeId == nil) return nil;
    return [self.routeIds objectForKey:routeId];
}

- (BTRoute *)routeWithShortName:(NSString *)shortName
{
    if (shortName == nil) return nil;
    return [self.routeNames objectForKey:shortName];
}

- (BTStop *)stopWithId:(NSString *)stopId
{
    if (stopId == nil) return nil;
    return [self.stopIds objectForKey:stopId];
}

- (BTStop *)stopWithCode:(NSString *)stopCode
{
    FMResultSet * rs = [db executeQuery:@"select stop_id from stops where stop_code = ? limit 1", stopCode];
    NSString * stopId = nil;
    while ([rs next]) {
        stopId = [rs stringForColumn:@"stop_id"];
    }
    
    if (stopId != nil) {
        return [self stopWithId:stopId];
    } else {
        return nil;
    }
}

- (NSArray *)tripsForRoute:(BTRoute *)route
{
    NSMutableArray * trips = [NSMutableArray array];
    
    FMResultSet * rs = [db executeQuery:@"select * from distinct_trips where route_id = ? order by direction_id ASC, stop_sequence ASC", route.routeId];
    
    BTTrip * trip = nil;
    while ([rs next]) {
        int directionId = [rs intForColumn:@"direction_id"];
        NSString * headsign = [rs stringForColumn:@"trip_headsign"];
        
        if (trip == nil) {
            // Create a new trip
            trip = [[BTTrip alloc] init];
            trip.route = route;
            trip.directionId = directionId;
            trip.headsign = headsign;
        }
        else if (directionId != trip.directionId) {
            // Save the old trip first
            [trips addObject:trip];
            
            // Create a new trip
            trip = [[BTTrip alloc] init];
            trip.route = route;
            trip.directionId = directionId;
            trip.headsign = headsign;
        }
        
        NSString * stopId = [rs stringForColumn:@"stop_id"];
        BTStop * stop = [self stopWithId:stopId];
        [trip.stops addObject:stop];
    }
    
    // Save the trip
    [trips addObject:trip];
    
    // Close the fetch cursor
    [rs close];
    
    return trips;
}

- (NSArray *)routesAtStop:(BTStop *)stop
{
    NSMutableSet * finalSet = [NSMutableSet setWithCapacity:10];
	
	FMResultSet *rs = [db executeQuery:@"select * from distinct_trips where stop_id = ?", stop.stopId];
    
	while ([rs next]) {
		NSString * routeId = [rs stringForColumn:@"route_id"];
        BTRoute * route = [routeIds objectForKey:routeId];
        [finalSet addObject:route];
	}
    
    // Close the fetch cursor
    [rs close];
    
    NSMutableArray * finalArray = [NSMutableArray arrayWithArray:[finalSet allObjects]];
    [finalArray sortUsingSelector:@selector(sortByShortName:)];
    return [NSArray arrayWithArray:finalArray];
}

- (void)updateNearbyStops
{
	[self.nearbyStops removeAllObjects];
	
	int maxNumberOfNearbyStops;
	if ([[BTAppSettings maxNumNearbyStops] isEqualToString:@"No Limit"]) {
		maxNumberOfNearbyStops = [self.stops count];
	} else {
		maxNumberOfNearbyStops = [[BTAppSettings maxNumNearbyStops] intValue];
	}
	
	int count = 0;
	for (int i=0; i<[self.stops count]; i++) {
		BTStop *stop = [self.stops objectAtIndex:i];
		if (stop.distance > -1) {
			[self.nearbyStops addObject:stop];
			count++;
			if (count >= maxNumberOfNearbyStops) break;
		}
	}
}

- (void)sortStops:(NSMutableArray *)ss ByDistanceFrom:(CLLocation *)location
{
	BTStop *stop;
	CLLocation *stopLocation;
	for (stop in ss) {
		stopLocation = [[CLLocation alloc] initWithLatitude:stop.latitude longitude:stop.longitude];
		stop.distance = [stopLocation distanceFromLocation:location]; // in meters
	}
	
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
	[ss sortUsingDescriptors:@[sort]];
}

- (void)dealloc
{
	[db close], db = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Location updates

- (void)didUpdateToLocation:(NSNotification *)notification
{
	CLLocation *newLocation = [[notification userInfo] objectForKey:@"location"];
	[self sortStops:stops ByDistanceFrom:newLocation];
	[self updateNearbyStops];
}

@end
