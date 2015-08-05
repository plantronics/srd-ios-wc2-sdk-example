//
//  ViewController.m
//  WCDeviceExample
//
//  Created by Morgan Davis on 6/15/15.
//  Copyright (c) 2015 Plantronics. All rights reserved.
//

#import "ViewController.h"
#import <wc2_sdk_ios/wc2_sdk_ios.h>


@interface ViewController () <WC2ServiceSubscriber>

- (IBAction)zeroOrientationButton:(id)sender;
- (void)setUIConnected:(BOOL)flag;

@property(nonatomic,strong)	WC2Device					*device;
@property(nonatomic,assign)	IBOutlet UILabel			*conenctionStatusLabel;
@property(nonatomic,strong)	IBOutlet UIButton			*zeroOrientationButton;
@property(nonatomic,strong)	IBOutlet UIProgressView		*headingProgressView;
@property(nonatomic,strong)	IBOutlet UIProgressView		*pitchProgressView;
@property(nonatomic,strong)	IBOutlet UIProgressView		*rollProgressView;
@property(nonatomic,strong)	IBOutlet UILabel			*headingLabel;
@property(nonatomic,strong)	IBOutlet UILabel			*pitchLabel;
@property(nonatomic,strong)	IBOutlet UILabel			*rollLabel;

@end


@implementation ViewController

#pragma mark - IBActions

- (IBAction)zeroOrientationButton:(id)sender
{	
	// "zero" orientation to current position
	NSError *err = nil;
	WC2OrientationConfiguration *orientationConfig = [WC2OrientationConfiguration configurationWithReferenceSnapshot:nil type:WC2OrientationReferenceTypeBody];
	[self.device setConfiguration:orientationConfig forService:WC2ServiceOrientation error:&err];
	if (err) {
		NSLog(@"Error setting orientation configuration: %@", err);
	}
	
	// the above is similar to the following
	// however the above will always zero as close as it can get to the CURRENT physical orientation of the headset
	// the following takes an arbitrary orientation to zero to
	// WCOrientationSnapshot *somePreciousSnapshot = ... // could use device.cachedInfo[@(WCServiceOrientation)] so long as there is cached info to get!
	// WCOrientationConfiguration *orientationConfig = [WCOrientationConfiguration configurationWithReferenceSnapshot:somePreciousSnapshot type:WCOrientationReferenceTypeBody];
	// [self.device setConfiguration:orientationConfig forService:WCServiceOrientation error:&err];
}

- (IBAction)debugButton:(id)sender
{
	NSError *err = nil;
	[self.device setConfiguration:nil forService:WC2ServiceOrientation error:&err];
	if (err) {
		NSLog(@"Error setting orientation configuration: %@", err);
	}
}

#pragma mark - Private

- (void)addNotificationHandlers
{
	// register for device connectivity-related notifications: connection open, connection failed, connection closed, new device available
	
	// connection open
	[[NSNotificationCenter defaultCenter] addObserverForName:WC2DeviceDidOpenConnectionNotification object:nil queue:NULL usingBlock:^(NSNotification *note) {
		WC2Device *device = (WC2Device *)[note userInfo][WC2DeviceNotificationKey];
		NSLog(@"Device conncetion open: %@ [%@]", device.name, device.serialNumber);
		
		[self setUIConnected:YES];

		
		// QUERY SERVICES

		// now that a connection is established, subscribe to all services with mode "on-change" and minPeriod 0 (deliover updates as fast as possible)
		
		NSError *err = nil;		
		for (NSNumber *serviceNum in self.device.supportedServices) {
			WC2Service service = serviceNum.shortValue;
			NSLog(@"Subscribing to %@ service...", NSStringFromWC2Service(service));
			[self.device subscribe:self toService:service minPeriod:0 error:&err];
			if (err) NSLog(@"Error subscribing to %@ service: %@", NSStringFromWC2Service(service), err);
		}
	}];
	
	// connection failed
	[[NSNotificationCenter defaultCenter] addObserverForName:WC2DeviceDidFailOpenConnectionNotification object:nil queue:NULL usingBlock:^(NSNotification *note) {
		WC2Device *device = (WC2Device *)[note userInfo][WC2DeviceNotificationKey];
		NSInteger error = [(NSNumber *)[note userInfo][WC2DeviceConnectionErrorNotificationKey] intValue];
		
		NSLog(@"Device conncetion failed with error: %ld, device: %@ [%@]", (long)error, device.name, device.serialNumber);
		
		self.device = nil;
		[self setUIConnected:NO];
		self.conenctionStatusLabel.text = @"Connection failed.";
	}];
	
	// connection closed
	[[NSNotificationCenter defaultCenter] addObserverForName:WC2DeviceDidCloseConnectionNotification object:nil queue:NULL usingBlock:^(NSNotification *note) {
		WC2Device *device = (WC2Device *)[note userInfo][WC2DeviceNotificationKey];
		
		NSLog(@"Device conncetion closed: %@ [%@]", device.name, device.serialNumber);
		
		self.device = nil;
		[self setUIConnected:NO];
		self.conenctionStatusLabel.text = @"Device disconnected.";
	}];
	
	// new device available
	[[NSNotificationCenter defaultCenter] addObserverForName:WC2DeviceAvailableNotification object:nil queue:NULL usingBlock:^(NSNotification *note) {
		WC2Device *device = (WC2Device *)[note userInfo][WC2DeviceNotificationKey];
		
		NSLog(@"Device available: %@ [%@]", device.name, device.serialNumber);
		
		// if we're not already connected to a device, connect to this one
		
		if (!self.device || ![self.device isConnectionOpen]) {
			NSLog(@"Opening connection to %@ [%@]...", device.name, device.serialNumber);
			self.device = device;
			NSError *err = nil;
			[self.device openConnection:&err];
			if (err) {
				NSLog(@"Error opening connection: %@", err);
			}
		}
	}];
}

- (void)setUIConnected:(BOOL)flag
{
	self.zeroOrientationButton.enabled = flag;
	
	if (!flag) {
		self.conenctionStatusLabel.text = @"Looking for devices...";
		self.headingProgressView.progress = 0;
		self.pitchProgressView.progress = 0;
		self.rollProgressView.progress = 0;
		self.headingLabel.text = @"0˚";
		self.pitchLabel.text = @"0˚";
		self.rollLabel.text = @"0˚";
		
		
		NSArray *ALL_SERVICES = @[@(WC2ServiceWearingState),
								  @(WC2ServiceProximity),
								  @(WC2ServiceOrientation),
								  @(WC2ServiceCompassHeading),
								  @(WC2ServiceStepCount),
								  @(WC2ServiceFreeFall),
								  @(WC2ServiceTaps),
								  @(WC2ServiceAcceleration),
								  @(WC2ServiceAngularVelocity),
								  @(WC2ServiceMagneticField),
								  @(WC2ServiceVoiceEvents)];
		
		// UILabels for service snapshots have their "tags" set to the service ID's...
		for (NSNumber *serviceNum in ALL_SERVICES) {
			WC2Service service = serviceNum.unsignedShortValue;
			if (service != WC2ServiceOrientation) {
				UILabel *label = (UILabel *)[self.view viewWithTag:service];
				label.text = @"-";
			}
		}
	}
	else {
		self.conenctionStatusLabel.text = [NSString stringWithFormat:@"%@ connected.", self.device.name];
	}
}

#pragma mark - WCServiceSubscriber

- (void)device:(WC2Device *)device didGetServiceSnapshot:(WC2ServiceSnapshot *)snapshot
{
	// this method is called when new device snapshots become available as a result of a service subscription of a query
	// check the snapshot's to see what type of snapshot it is
	
	//NSLog(@"WCDevice: %@ didGetServiceSnapshot: %@", device, snapshot);
	
	if ([snapshot isKindOfClass:[WC2WearingStateSnapshot class]]) {
		WC2WearingStateSnapshot *snap = (WC2WearingStateSnapshot *)snapshot;
		
		((UILabel *)[self.view viewWithTag:WC2ServiceWearingState]).text = (snap.isBeingWorn ? @"yes" : @"no");
	}
	else if ([snapshot isKindOfClass:[WC2ProximitySnapshot class]]) {
		WC2ProximitySnapshot *snap = (WC2ProximitySnapshot *)snapshot;
		
		((UILabel *)[self.view viewWithTag:WC2ServiceProximity]).text = NSStringFromWC2Proximity(snap.localProximity);
	}
	else if ([snapshot isKindOfClass:[WC2OrientationSnapshot class]]) {
		WC2EulerAngles eulerAngles = ((WC2OrientationSnapshot *)snapshot).eulerAngles;
		
		[self.headingProgressView	setProgress:(eulerAngles.x + 180.0)/360.0	animated:YES];
		[self.pitchProgressView		setProgress:(eulerAngles.y + 90.0)/180.0	animated:YES];
		[self.rollProgressView		setProgress:(eulerAngles.z + 180.0)/360.0	animated:YES];
		
		self.headingLabel.text =	[NSString stringWithFormat:@"%ld˚", lroundf(eulerAngles.x)];
		self.pitchLabel.text =		[NSString stringWithFormat:@"%ld˚", lroundf(eulerAngles.y)];
		self.rollLabel.text =		[NSString stringWithFormat:@"%ld˚", lroundf(eulerAngles.z)];
	}
	else if ([snapshot isKindOfClass:[WC2CompassHeadingSnapshot class]]) {
		WC2CompassHeadingSnapshot *snap = (WC2CompassHeadingSnapshot *)snapshot;
		
		((UILabel *)[self.view viewWithTag:WC2ServiceCompassHeading]).text = [NSString stringWithFormat:@"%.2f˚", snap.heading];
	}
	else if ([snapshot isKindOfClass:[WC2StepCountSnapshot class]]) {
		WC2StepCountSnapshot *snap = (WC2StepCountSnapshot *)snapshot;
		
		((UILabel *)[self.view viewWithTag:WC2ServiceStepCount]).text = [NSString stringWithFormat:@"%lu", (unsigned long)snap.stepCount];
	}
	else if ([snapshot isKindOfClass:[WC2FreeFallSnapshot class]]) {
		WC2FreeFallSnapshot *snap = (WC2FreeFallSnapshot *)snapshot;
		
		((UILabel *)[self.view viewWithTag:WC2ServiceFreeFall]).text = (snap.isInFreeFall ? @"yes" : @"no");
	}
	else if ([snapshot isKindOfClass:[WC2TapsSnapshot class]]) {
		WC2TapsSnapshot *snap = (WC2TapsSnapshot *)snapshot;
		
		UILabel *label = (UILabel *)[self.view viewWithTag:WC2ServiceTaps];
		if (snap.count) {
			label.text = [NSString stringWithFormat:@"%lu in %@", (unsigned long)snap.count, NSStringFromWC2TapDirection(snap.direction)];
		}
		else {
			label.text = @"-";
		}
	}
	else if ([snapshot isKindOfClass:[WC2AccelerationSnapshot class]]) {
		WC2AccelerationSnapshot *snap = (WC2AccelerationSnapshot *)snapshot;
		
		((UILabel *)[self.view viewWithTag:WC2ServiceAcceleration]).text = NSStringFromWC2Acceleration(snap.acceleration);
	}
	else if ([snapshot isKindOfClass:[WC2AngularVelocitySnapshot class]]) {
		WC2AngularVelocitySnapshot *snap = (WC2AngularVelocitySnapshot *)snapshot;
		
		NSLog(@"WCAngularVelocitySnapshot cal'd? %@", (snap.isInternallyCalibrated ? @"YES" : @"NO"));
		
		((UILabel *)[self.view viewWithTag:WC2ServiceAngularVelocity]).text = NSStringFromWC2AngularVelocity(snap.angularVelocity);
	}
	else if ([snapshot isKindOfClass:[WC2MagneticFieldSnapshot class]]) {
		WC2MagneticFieldSnapshot *snap = (WC2MagneticFieldSnapshot *)snapshot;
		
		((UILabel *)[self.view viewWithTag:WC2ServiceMagneticField]).text = NSStringFromWC2MagneticField(snap.magneticField);
	}
	else if ([snapshot isKindOfClass:[WC2VoiceEventSnapshot class]]) {
		WC2VoiceEventSnapshot *snap = (WC2VoiceEventSnapshot *)snapshot;
		WC2Phrase phrase = snap.phrase;
		NSString *phraseStr = NSStringFromWC2Phrase(phrase);
		
		((UILabel *)[self.view viewWithTag:WC2ServiceVoiceEvents]).text = phraseStr;
	}
}

- (void)device:(WC2Device *)device didChangeServiceSubscription:(WC2ServiceSubscription *)oldSubscription toSubscription:(WC2ServiceSubscription *)newSubscription
{
	NSLog(@"device: %@, didChangeServiceSubscription: %@, toSubscription: %@", self, oldSubscription, newSubscription);
}

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// disable the UI
	
	[self setUIConnected:NO];
	
	// register for WCDevice-related notifications
	
	[self addNotificationHandlers];
	
	// check to see if there are any devices currently avaialble. if so, connect to the first one.
	
	NSArray *devices = [WC2Device availableDevices];
	if ([devices count]) {
		self.device = devices[0];
		NSLog(@"Opening connection to %@ [%@]...", self.device.name, self.device.serialNumber);
		NSError *err = nil;
		[self.device openConnection:&err];
		if (err) {
			NSLog(@"Error opening connection: %@", err);
		}
	}
	else {
		NSLog(@"No available devices.");
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

@end
