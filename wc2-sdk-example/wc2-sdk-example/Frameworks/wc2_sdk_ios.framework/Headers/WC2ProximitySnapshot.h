//
//  WC2ProximitySnapshot.h
//  wc2-sdk
//
//  Created by Morgan Davis on 9/10/13.
//  Copyright (c) 2013 Plantronics, Inc. All rights reserved.
//

#import "WC2ServiceSnapshot.h"


typedef NS_ENUM(NSUInteger, WC2Proximity) {
	WC2ProximityFar = 0,
    WC2ProximityNear = 1,
	WC2ProximityUnknown = 2
};


NSString *NSStringFromWC2Proximity(WC2Proximity proximity);


@interface WC2ProximitySnapshot : WC2ServiceSnapshot

@property(nonatomic,readonly)	WC2Proximity	localProximity;
@property(nonatomic,readonly)	WC2Proximity	remoteProximity;

@end
