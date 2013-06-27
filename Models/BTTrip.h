//
//  BTTrip.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/18/09.
//  Copyright 2009 HappenApps, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTRoute;

@interface BTTrip : NSObject {
}

@property (nonatomic, strong) BTRoute * route;
@property (nonatomic, assign) NSInteger directionId;
@property (nonatomic, strong) NSString * headsign;
@property (nonatomic, strong) NSMutableArray * stops;

@end
