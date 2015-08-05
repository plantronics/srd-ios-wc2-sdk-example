//
//  WC2TapsSnapshot.h
//  wc2-sdk
//
//  Created by Morgan Davis on 9/10/13.
//  Copyright (c) 2013 Plantronics, Inc. All rights reserved.
//

#import "WC2ServiceSnapshot.h"


typedef NS_ENUM(uint8_t, WC2TapDirection) {
    WC2TapDirectionXUp = 1,
    WC2TapDirectionXDown,
    WC2TapDirectionYUp,
    WC2TapDirectionYDown,
    WC2TapDirectionZUp,
    WC2TapDirectionZDown
};


NSString *NSStringFromWC2TapDirection(WC2TapDirection direction);


@interface WC2TapsSnapshot : WC2ServiceSnapshot

@property(nonatomic,readonly)	WC2TapDirection     direction;
@property(nonatomic,readonly)	NSUInteger          count;

@end
