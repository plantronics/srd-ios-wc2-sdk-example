//
//  WC2Device.h
//  wc2-sdk
//
//  Created by Morgan Davis on 9/9/13.
//  Copyright (c) 2013 Plantronics, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WC2ServiceConfiguration;
@class WC2ServiceSnapshot;
@protocol WC2ServiceSubscriber;


extern NSString *const WC2DeviceAvailableNotification;
extern NSString *const WC2DeviceDidOpenConnectionNotification;
extern NSString *const WC2DeviceDidCloseConnectionNotification;
extern NSString *const WC2DeviceDidFailConnectionNotification;

extern NSString *const WC2DeviceNotificationKey;
extern NSString *const WC2DeviceConnectionErrorNotificationKey;


typedef NS_ENUM(NSUInteger, WC2DeviceModel) {
	WC2DeviceModelConcept1 =		1,
	WC2DeviceModelConcept2 =		2
};

typedef NS_ENUM(NSUInteger, WC2Service) {
	WC2ServiceWearingState =					0x1000,
	WC2ServiceProximity =						0x1001,
	WC2ServiceOrientation =						0x0000,
	WC2ServiceCompassHeading =                  0x0001,
	WC2ServiceStepCount =						0x0002,
	WC2ServiceFreeFall =						0x0003,
	WC2ServiceTaps =							0x0004,
	WC2ServiceAcceleration =					0x0013,
	WC2ServiceAngularVelocity =					0x0014,
	WC2ServiceMagneticField =					0x0015,
	WC2ServiceVoiceEvents =						0x0016
};

typedef NS_ENUM(NSInteger, WC2DeviceError) {
	WC2DeviceErrorUnknownError =				1,
	WC2DeviceErrorConnectionAlreadyOpen =		2,
	WC2DeviceErrorConnectionNotOpen =			3,
	WC2DeviceErrorInvalidArgument =				4,
	WC2DeviceErrorInvalidService =				5
};


NSString *NSStringFromWC2Service(WC2Service service);


@interface WC2Device : NSObject

// discovering devices

+ (NSArray *)availableDevices;

// connecting to and disconnecting from devices

- (void)openConnection:(NSError **)error;
- (void)closeConnection;

// setting and reading service configurations. setting a nil configuration will revert service to defaults

- (void)setConfiguration:(WC2ServiceConfiguration *)configuration forService:(WC2Service)service error:(NSError **)error;
- (WC2ServiceConfiguration *)configurationForService:(WC2Service)service error:(NSError **)error;

// subscribing to and unsubscribing from service snapshot updates

- (void)subscribe:(id <WC2ServiceSubscriber>)subscriber toService:(WC2Service)service minPeriod:(NSUInteger)minPeriod error:(NSError **)error;
- (void)unsubscribe:(id <WC2ServiceSubscriber>)subscriber fromService:(WC2Service)service;
- (void)unsubscribeFromAll:(id <WC2ServiceSubscriber>)subscriber;

// querying service snapshots

- (void)queryUpdate:(id <WC2ServiceSubscriber>)subscriber forService:(WC2Service)service error:(NSError **)error;

// getting cached service snapshots

- (WC2ServiceSnapshot *)cachedInfoForService:(WC2Service)service error:(NSError **)error;

// reading device info and state

@property(nonatomic,readonly)	BOOL					isConnectionOpen;
@property(nonatomic,readonly)	NSString				*address;
@property(nonatomic,readonly)	WC2DeviceModel			model;
@property(nonatomic,readonly)	NSString				*name;
@property(nonatomic,readonly)	NSString				*serialNumber;
@property(nonatomic,readonly)	NSString				*hardwareVersion;
@property(nonatomic,readonly)	NSString				*firmwareVersion;
@property(nonatomic,readonly)	NSArray					*supportedServices;

@end


@interface WC2ServiceSubscription : NSObject

@property(nonatomic,readonly)	WC2Service				service;
@property(nonatomic,readonly)	uint16_t				minPeriod;

@end


@protocol WC2ServiceSubscriber <NSObject>

- (void)device:(WC2Device *)device didReceiveSnapshot:(WC2ServiceSnapshot *)snapshot;
- (void)device:(WC2Device *)device didChangeSubscription:(WC2ServiceSubscription *)oldSubscription toSubscription:(WC2ServiceSubscription *)newSubscription;

@end
