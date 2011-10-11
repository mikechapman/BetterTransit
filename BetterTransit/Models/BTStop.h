//
//  BTStop.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTRoute;

@interface BTStop : NSObject {
}

@property (nonatomic, retain) NSString * stopId;
@property (nonatomic, retain) NSString * stopCode;
@property (nonatomic, retain) NSString * stopName;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) int owner;
@property (nonatomic, assign) NSUInteger tileNumber;
@property double distance;
@property BOOL favorite;

// stop has a selected route when invoked from RailView
@property (nonatomic, retain) BTRoute *selectedRoute;

@end
