//
//  WC2AccelerationSnapshot.h
//  wc2-sdk
//
//  Created by Morgan Davis on 12/22/14.
//  Copyright (c) 2014 Plantronics. All rights reserved.
//

#import "WC2ServiceSnapshot.h"


typedef struct {
	double x;
	double y;
	double z;
} WC2Acceleration;


NSString *NSStringFromWC2Acceleration(WC2Acceleration acceleration);


@interface WC2AccelerationSnapshot : WC2ServiceSnapshot

@property(nonatomic,readonly)	WC2Acceleration	acceleration;

@end
