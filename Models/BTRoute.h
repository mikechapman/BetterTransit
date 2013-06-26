//
//  BTRoute.h
//  BetterTransit
//
//  Created by Yaogang Lian on 10/16/09.
//  Copyright 2009 Happen Next. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BTRoute : NSObject {
}

@property (nonatomic, strong) NSString * routeId;
@property (nonatomic, strong) NSString * agencyId;
@property (nonatomic, strong) NSString * shortName;
@property (nonatomic, strong) NSString * longName;
@property (nonatomic, assign) BOOL hasSchedule;

- (NSComparisonResult)sortByShortName:(BTRoute *)other;

@end
