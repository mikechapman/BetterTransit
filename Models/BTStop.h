//
//  BTStop.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTRoute;

@interface BTStop : NSObject {
}

@property (nonatomic, strong) NSString * stopId;
@property (nonatomic, strong) NSString * stopCode;
@property (nonatomic, strong) NSString * stopName;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) int stopSource; // Data source for retrieving ALL bus routes arrival times
@property (nonatomic, assign) int stopColor;  // Color of stop icon
@property (nonatomic, assign) NSUInteger tileNumber;
@property double distance;
@property BOOL favorite;

// stop has a selected route when invoked from the Trip View
@property (nonatomic, strong) BTRoute * selectedRoute;

@end
