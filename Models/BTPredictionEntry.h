//
//  BTPredictionEntry.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTRoute.h"
#import "BTStop.h"

@interface BTPredictionEntry : NSObject
{
	BTRoute *route;
	BTStop *stop;
	
	NSString *destination;
	NSString *eta; // estimated time for arrival
	
	BOOL shouldDownloadData; // download data for this route
	BOOL isUpdating; // is downloading data
	NSString *info; // extra information
    NSUInteger retryCount;
}

@property (nonatomic, strong) BTRoute *route;
@property (nonatomic, strong) BTStop *stop;
@property (nonatomic, copy) NSString *destination;
@property (nonatomic, copy) NSString *eta;
@property (assign) BOOL shouldDownloadData;
@property (assign) BOOL isUpdating;
@property (nonatomic, copy) NSString *info;
@property (assign) NSUInteger retryCount;

@end
