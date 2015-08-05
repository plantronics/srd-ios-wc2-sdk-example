//
//  WC2FreeFallSnapshot.h
//  wc2-sdk
//
//  Created by Morgan Davis on 9/10/13.
//  Copyright (c) 2013 Plantronics, Inc. All rights reserved.
//

#import "WC2ServiceSnapshot.h"


@interface WC2FreeFallSnapshot : WC2ServiceSnapshot

@property(nonatomic,readonly)	BOOL	isInFreeFall;

@end
