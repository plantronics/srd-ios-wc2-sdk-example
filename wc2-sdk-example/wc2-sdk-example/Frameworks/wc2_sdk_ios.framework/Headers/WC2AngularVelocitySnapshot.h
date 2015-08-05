//
//  WC2AngularVelocitySnapshot.h
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
} WC2AngularVelocity;


NSString *NSStringFromWC2AngularVelocity(WC2AngularVelocity angularVelocity);


@interface WC2AngularVelocitySnapshot : WC2ServiceSnapshot

@property(nonatomic,readonly)	WC2AngularVelocity	angularVelocity;
@property(nonatomic,readonly)	BOOL				isInternallyCalibrated;

@end
