//
//  WC2ServiceSnapshot.h
//  wc2-sdk
//
//  Created by Morgan Davis on 9/9/13.
//  Copyright (c) 2013 Plantronics, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

	
typedef NS_ENUM(NSUInteger, WC2ServiceSnapshotType) {
	WC2ServiceSnapshotTypeSubscription =		0,
	WC2ServiceSnapshotTypeQuery =			1,
	WC2ServiceSnapshotTypeCached =			2
};


@class WC2Device;
@class WC2ServiceConfiguration;

@interface WC2ServiceSnapshot : NSObject

@property(nonatomic,readonly)	WC2ServiceSnapshotType      type;
@property(nonatomic,readonly)	NSDate                      *timestamp;
@property(nonatomic,readonly)	WC2ServiceConfiguration     *configuration;

@end
