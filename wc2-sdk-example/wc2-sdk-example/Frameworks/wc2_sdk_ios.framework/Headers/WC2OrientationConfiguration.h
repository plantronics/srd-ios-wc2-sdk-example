//
//  WC2OrientationConfiguration.h
//  wc2-sdk
//
//  Created by Morgan Davis on 4/22/15.
//  Copyright (c) 2015 Plantronics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WC2ServiceConfiguration.h"
#import "WC2OrientationSnapshot.h"


typedef NS_ENUM(NSUInteger, WC2OrientationReferenceType) {
	WC2OrientationReferenceTypeWorld = 0,
	WC2OrientationReferenceTypeBody = 1
};


@interface WC2OrientationConfiguration : WC2ServiceConfiguration

// setting a nil referenceSnapshot will set reference to current orientation
+ (WC2OrientationConfiguration *)configurationWithReferenceSnapshot:(WC2OrientationSnapshot *)referenceSnapshot type:(WC2OrientationReferenceType)type;
+ (WC2OrientationConfiguration *)configurationWithReferenceQuaternion:(WC2Quaternion)referenceQuaternion type:(WC2OrientationReferenceType)type;
+ (WC2OrientationConfiguration *)configurationWithReferenceEulerAngles:(WC2EulerAngles )eulerAngles type:(WC2OrientationReferenceType)type;

@property(nonatomic,assign)	WC2Quaternion				referenceQuaternion;
@property(nonatomic,assign)	WC2EulerAngles				referenceEulerAngles;
@property(nonatomic,assign)	WC2OrientationReferenceType	referenceType;

@end
