//
//  WC2OrientationSnapshot.h
//  wc2-sdk
//
//  Created by Morgan Davis on 9/9/13.
//  Copyright (c) 2013 Plantronics, Inc. All rights reserved.
//

#import "WC2ServiceSnapshot.h"


#define WC2_QUATERNION_ZERO	(WC2Quaternion){0, 0, 0, 0}


typedef struct {
	double x;
	double y;
	double z;
} WC2EulerAngles;

typedef struct {
	double w;
	double x;
	double y;
	double z;
} WC2Quaternion;


WC2EulerAngles WC2EulerAnglesFromWC2Quaternion(WC2Quaternion quaternion);
WC2Quaternion WC2QuaternionFromWC2EulerAngles(WC2EulerAngles eulerAngles);
NSString *NSStringFromWC2EulerAngles(WC2EulerAngles angles);
NSString *NSStringFromWC2Quaternion(WC2Quaternion quaternion);


@interface WC2OrientationSnapshot : WC2ServiceSnapshot

@property(nonatomic,readonly)	WC2EulerAngles	eulerAngles;
@property(nonatomic,readonly)	WC2Quaternion	quaternion;
@property(nonatomic,readonly)	BOOL			isInternallyCalibrated;

@end
