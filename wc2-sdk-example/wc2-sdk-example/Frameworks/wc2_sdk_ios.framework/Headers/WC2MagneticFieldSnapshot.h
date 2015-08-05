//
//  WC2MagneticFieldSnapshot.h
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
} WC2MagneticField;


NSString *NSStringFromWC2MagneticField(WC2MagneticField magneticField);

@interface WC2MagneticFieldSnapshot : WC2ServiceSnapshot

@property(nonatomic,readonly)	WC2MagneticField    magneticField;
@property(nonatomic,readonly)	BOOL				isInternallyCalibrated;

@end
