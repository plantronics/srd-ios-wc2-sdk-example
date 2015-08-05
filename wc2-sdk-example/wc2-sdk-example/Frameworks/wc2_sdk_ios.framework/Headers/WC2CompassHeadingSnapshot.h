//
//  WC2CompassHeadingSnapshot.h
//  wc2-sdk
//
//  Created by Morgan Davis on 12/22/14.
//  Copyright (c) 2014 Plantronics. All rights reserved.
//

#import "WC2ServiceSnapshot.h"


typedef double WC2CompassHeading;


@interface WC2CompassHeadingSnapshot : WC2ServiceSnapshot

@property(nonatomic,readonly)	WC2CompassHeading	heading;
@property(nonatomic,readonly)	BOOL                isInternallyCalibrated;

@end
