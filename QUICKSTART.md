# Wearable Concept 2 SDK, iOS Quick Start
**PLT Labs**  
API version: .9  
Document version .9  
December 29, 2015  
[morgan.davis@plantronics.com](mailto:morgan.davis@plantronics.com)  

## Introduction
This document serves as a quick-start to using the Wearable Concept 2 iOS SDK for building mobile applications. The iOS version of the SDK is an Objective-C implementation of the generic API described in the “WC2 Generalized API” document.## PrerequisitesTo use the WC2 SDK, your system must meet the following requirements:
### Development Environment+	Mac OS 10.10 or later+	Xcode 7 or later### Mobile Device+	iPhone 5 or later, or iPad 4 or later, iPad mini 2 or later+	iOS 8 or later## Conventions
The iOS SDL uses several patterns to achieve the functionality outlined in the generlized API.

###	Class methodsThe *WC2Device* class employs one static method, *availableDevices*, that can be used at any time to retrieve a list of paired WC2 devices, connected or not.
	###	Notifications
The SDK uses several NSNotifications available through the default notification center to relay information about device availability and connectivity changes.  
+ **WC2DeviceAvailableNotification**  
Sent when a new device becomes available. Contains the *WC2DeviceNotificationKey* userInfo key containing a pointer to the newly available device.+ **WC2DeviceDidOpenConnectionNotification**  Sent when a device finishes connecting after a previous call to *openConnection()*. Contains the *WC2DeviceNotificationKey* userInfo key containing a pointer to the newly connected device.+ **WC2DeviceDidCloseConnectionNotification**  Sent when a device disconnects after a previous call to *closeConnection()*, due to running out of battery, exceeding Bluetooth signal range, or any other reason. Contains the *WC2DeviceNotificationKey* userInfo key containing a pointer to the newly disconnected device.
+ **WC2DeviceDidFailConnectionNotification**  Sent when a device connection after a previous call to *openConnection()*. Contains the *WC2DeviceNotificationKey* userInfo key containing a pointer to the device that failed to open a connection, and *WC2DeviceConnectionErrorNotificationKey* containing a pointer to an *NSError* object containing information about the failure.

###	*WC2ServiceSubscriber* protocolThe SDK uses this single "callback" protocol to:

1. Deliver service snapshots when queried with *queryUpdate:forService:* or when new snapshots become available to a observer previously subscribed with *subscribe:toService:minPeriod:error:* and,  
2. Notify listeners when a change to a service subscription is made.```@protocol WC2ServiceSubscriber <NSObject>- (void)device:(WC2Device *)device didReceiveSnapshot:(WC2ServiceSnapshot *)snapshot;- (void)device:(WC2Device *)device didChangeSubscription:(WC2ServiceSubscription *)oldSubscription	toSubscription:(WC2ServiceSubscription *)newSubscription;@end
```If any SDK client makes a change to a service subscription (start a subscription, end a subscription, or change the *minPeriod*), all API clients will be notified with the *device:didChangeSubscription:toSubscription:* method.## Quick Start
This section will guide you through obtaining the SDK, connecting your Concept a to your iOS device, setting up your Xcode project, and discovering, connecting to, and retrieving data from the device.

### Obtaining the SDKThe *wc2-sdk-example* example project can be found accompanying this document or in the Git repository located at [https://github.com/plantronics-innovation/ios-wc2-sdk-example](). The actual WC2 SDK framework (*wc2_sdk_ios.framework*) is located inside the *Frameworks* subdirectory of the project's directory.
###	Pairing Concept 2 with your mobile deviceBefore using Concept 2 you will need to pair it over Bluetooth to your iOS device. To pair Concept 2, power it on using the power switch on the back panel of the device, then hold the *answer/end call button* located at the back end of the boom until the status indicator light begins to blink red/blue.Once in pairing mode, open the **Settings** app on your iOS device and navigate to the **Bluetooth** settings. Tap on the Bluetooth device at the bottom of the list labeled “PLT_WC2” with the caption “Not Paired” next to it. The “PLT_WC2” device should now be paired with your iOS device and display “Connected” next to its name.###	Setting up your Xcode project+ Create a new Xcode project for your application using any template desired. Ensure that the Language is set to Objective-C and that Objective-C Automatic Reference Counting (ARC) is enabled for the project (the SDK is fully compatible with Swift 1.2 and 2.0 but setup and usage is not covered by this document).+	Add a *UISupportedExternalAccessoryProtocols* array to the app’s *Info.plist*, and add the item *com.plantronics.headsetdataservice* to the array. This will allow your app to communicate with the Concept 2 device.

```<key>UISupportedExternalAccessoryProtocols</key><array>	<string>com.plantronics.headsetdataservice</string></array>
```
+	If your app needs to interact with the device while running in the background, add a *UIBackgroundModes* array with *external-accessory* key to the app’s *Info.plist* file.

```<key>UIBackgroundModes</key><array>	<string>external-accessory</string></array>
```
+	Locate the *wc2_sdk_ios.framework* file as described above and copy it to a suitable location (we recommend copying it inside your Xcode project directory).+	Add *wc2_sdk_ios.framework* to your project by either selecting **Add Files to [[your project name]]…** from the **File** menu and choosing the framework file, or by dragging the framework file into your project’s **Project Navigator** view. Ensure that your app’s executable target is checked under the Add to targets area when prompted.
+ Embedd the framework binary within your app by selecting the root item at the top left of the **Project Navigator** view, then selecting your project's target in the left-hand **Taregets** colum, then selecting the **General** tab and finally dragging the framework from the **Project Navigator** into the **Embedded Binaries** section.+	Add  *ExternalAccessory.framework* to your project under the **Link Binaries with Libraries** build phase. You should now be able to build your project.###	Iterating over and connecting to available devicesThe *WC2Device* class contains the class method *availableDevices* that can be used at any time to retrieve a list of available Concept 2 devices. Additionally, your app can use the default notification center to subscribe to the *WC2DeviceAvailableNotification* to be notified when a new device becomes available. The following code could be added to a class to search for and connect to a device at instantiation, to be notified of device connection events (connection open, closed, error) and observe and connect to new devices as they become available.

```@property(nonatomic, strong) WC2Device *device;- (id)init{	[self addNotificationHandlers];	if (self = [super init]) {		NSArray *devices = [WC2Device availableDevices];		if ([devices count]) {			self.device = devices[0];			[self.device openConnection];		}		else {			NSLog(@"No available devices.");		}	}	return nil;}- (void)addNotificationHandlers{   	// connection open   	[[NSNotificationCenter defaultCenter]	  addObserverForName:WC2DeviceDidOpenConnectionNotification	  object:nil	  queue:NULL	  usingBlock:^(NSNotification *note) {			NSLog(@"Device conncetion open: %@",
				(WC2Device *)([note userInfo][WC2DeviceNotificationKey]));	}];       	// connection closed   [[NSNotificationCenter defaultCenter]		addObserverForName:WC2DeviceDidCloseConnectionNotification		object:nil		queue:NULL		usingBlock:^(NSNotification *note) {	   		WC2Device *device = (WC2Device *)([note userInfo][WC2DeviceNotificationKey]);	 		NSLog(@"Device conncetion closed: %@", device);   	}];
   	
   	// connection failed	[[NSNotificationCenter defaultCenter]	  addObserverForName:WC2DeviceDidFailConnectionNotification	  object:nil	  queue:NULL	  usingBlock:^(NSNotification *note) {			NSDictionary *ui = [note userInfo];     		PLTDevice *device = (WC2Device *)(ui[WC2DeviceNotificationKey]);			NSInteger error = [(NSNumber *)(ui[WC2DeviceConnectionErrorNotificationKey]) intValue];			NSLog(@"Device conncetion failed with error: %ld, device: %@", (long)error, device);   	}];       	// new device available   	[[NSNotificationCenter defaultCenter		addObserverForName:WC2DeviceAvailableNotification		object:nil		queue:NULL		usingBlock:^(NSNotification *note) {	   		PLTDevice *device = (WC2Device *)([note userInfo][WC2DeviceNotificationKey]);	  	NSLog(@"Device available: %@", device);   	}];}```
###	Querying servicesIndividual queries can be performed for service data using *WC2Device*'s *queryUpdate:forService:* instance method in combination with the *WC2ServiceSubscriber* protocol.
```
- (void)queryUpdate{	[self.device queryUpdate:self forService:WC2ServiceStepCount];}- (void)device:(WC2Device *)device didReceiveSnapshot:(WC2ServiceSnapshot *)snapshot{	NSLog(@"WC2Device: %@ didReceiveSnapshot: %@", device, snapshot);}```
###	Subscribing to servicesObserver can use *WC2Device*'s *subscribe:toService:error:* method to register to receive new service data as soon as it is available. The *minPeriod* parameter is used to specify the minumim time period in milliseconds that must pass before new updates as delivered, thus throttling the data rate. A minPeriod of 0 delivers new data as fast as possible.

```- (void)subscribe{	NSError *err = nil;	[self.device subscribe:self toService:WC2ServiceAcceleration minPeriod:0 error:&err];	if (err) { ... }}- (void)device:(WC2Device *)device didReceiveSnapshot:(WC2ServiceSnapshot *)snapshot{	NSLog(@"WC2Device: %@ didReceiveSnapshot: %@", device, snapshot);		if ([snapshot isKindOfClass:[WC2AccelerationSnapshot class]]) {	   WC2AccelerationSnapshot *accelSnap = (WC2AccelerationSnapshot *)snapshot;	   NSLog(@"Acceleration: %@", NSStringFromWC2Acceleration(accelSnap.acceleration));    }}
```###	Zeroing servicesThe *Orientation* and *Step Count* services may be configured for the purpose of "zeroing" the data. The process consists of creating a *WC2Configuration* for the appropriate class (e.g. *WC2OrientationConfiguration* or *WC2StepCountConfigurtion*), setting a reference orientation/step count, and then applying it using *WC2Device*'s *setConfiguration:forService:error:* method.####	Orientation"Zeroing" orientation allows sets a reference orientation at from which other orientations are based. For example, the device could be zeroed so that the service reports “dead-center” (Euler angles 0,0,0) when the is actually pointing straight up. There are two ways to perform an orientation zero. The first is to call *setCalibration:forService:error:* supplying *WC_QUATERNION_ZERO* as the reference. This will zero orientation to the current orientation.```NSError *err = nil;
WC2OrientationConfiguration *config = [WC2OrientationConfiguration 	configurationWithReferenceQuaternion:WC2_QUATERNION_ZERO 	type:WC2OrientationReferenceTypeBody];
[self.device setConfiguration:config forService:WC2ServiceOrientation error:&err];
if (err) { ... }
```The second method is to supply *setConfiguration:forService:error:* with a configuration object containing a specific orientation to zero to.```NSError *err = nil;
WC2OrientationConfiguration *config = [WC2OrientationConfiguration 	configurationWithReferenceSnapshot:somePreviousSnapshot	type:WC2OrientationReferenceTypeBody];
[self.device setConfiguration:config forService:WC2ServiceOrientation error:&err];
if (err) { ... }
```

Calling *setConfiguration:forService:error:* with a nil configuration clears any existing configuration.####	Step CountStep Count configuration is done in a similar manner to orientation, but an offset step count is used instead of reference orientation. Supplying an offset of 0 will use the current step count, thus "zeroing" the service.```NSError *err = nil;
WC2StepCountConfiguration *config = [WC2StepCountConfiguration 	configurationWithOffsetSteps:0];
[self.device config forService:WC2ServiceStepCount error:&err];
if (err) { ... }

```##		Known Issues
###	Unsubscribing from services before closing connectionThe SDK will not automatically unsubscribe from services when closing a connection. If your app explicitly closes a device connection or otherwise no longer needs service data, it should unsubscribe from the service using *WC2Device*'s *unsubscribe* method. This will help save power on the device.  