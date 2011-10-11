//
//  BTTrip.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/18/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTRoute;

@interface BTTrip : NSObject {
}

@property (nonatomic, retain) BTRoute * route;
@property (nonatomic, assign) NSInteger directionId;
@property (nonatomic, retain) NSString * headsign;
@property (nonatomic, retain) NSMutableArray * stops;

@end
