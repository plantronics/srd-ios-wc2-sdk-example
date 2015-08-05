//
//  WC2StepCountConfiguration.h
//  wc2-sdk
//
//  Created by Morgan Davis on 4/22/15.
//  Copyright (c) 2015 Plantronics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WC2ServiceConfiguration.h"


@class WC2StepCountSnapshot;


@interface WC2StepCountConfiguration : WC2ServiceConfiguration

// setting a nil offsetSnapshot will set offset to current step count
+ (WC2StepCountConfiguration *)configurationWithOffsetSnapshot:(WC2StepCountSnapshot *)offsetSnapshot;
+ (WC2StepCountConfiguration *)configurationWithOffsetSteps:(NSUInteger)stepOffset;

@property(nonatomic,assign)	NSUInteger		stepOffset;

@end
