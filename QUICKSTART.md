# Wearable Concept 2 SDK, iOS Quick Start
**PLT Labs**  
API version: .8  
Document version .8  
August 5, 2015  
[morgan.davis@plantronics.com](mailto:morgan.davis@plantronics.com)  

## Introduction
This document serves as a quick-start to using the Wearable Concept 2 iOS SDK for building mobile applications. The iOS version of the SDK is an Objective-C implementation of the generic API described in the “WC2 Generalized API” document.

	Mac OS 10.8 or later
	Xcode 6 or later
	iPhone 5 or later, or iPad 4 or later, iPad mini 2 or later
	iOS 7 or later
The iOS SDL uses several patterns to achieve the functionality outlined in the generlized API.

###	Static methods
	
The SDK uses several NSNotifications available through the default notification center to relay information about device availability and connectivity changes.  

 **WC2DeviceAvailableNotification**  
Sent when a new device becomes available. Contains the *WC2DeviceNotificationKey* userInfo key containing a pointer to the newly available device.
 **WC2DeviceDidOpenConnectionNotification**  
 **WC2DeviceDidCloseConnectionNotification**  
+ **WC2DeviceDidFailConnectionNotification**  

###	*WC2ServiceSubscriber* protocol

1. Deliver service snapshots when queried with *queryUpdate:forService:* or when new snapshots become available to a observer previously subscribed with *subscribe:toService:minPeriod:error:* and,  
2. Notify listeners when a change to a service subscription is made.
```
This section will guide you through obtaining the SDK, connecting your Concept a to your iOS device, setting up your Xcode project, and discovering, connecting to, and retrieving data from the device.

### Obtaining the SDK

 Create a new Xcode project for your application using any template desired. Ensure that the Language is set to Objective-C and that Objective-C Automatic Reference Counting (ARC) is enabled for the project (the SDK is fully compatible with Swift 1.2 and 2.0 but setup and usage is not covered by this document).
	Add a *UISupportedExternalAccessoryProtocols* array to the app’s *Info.plist*, and add the item *com.plantronics.headsetdataservice* to the array. This will allow your app to communicate with the Concept 2 device.

```
```

	If your app needs to interact with the device while running in the background, add a *UIBackgroundModes* array with *external-accessory* key to the app’s *Info.plist* file.

```
```

	Locate the *wc2_sdk_ios.framework* file as described above and copy it to a suitable location (we recommend copying it inside your Xcode project directory).
	Add *wc2_sdk_ios.framework* to your project by either selecting **Add Files to [[your project name]]…** from the **File** menu and choosing the framework file, or by dragging the framework file into your project’s **Project Navigator** view. Ensure that your app’s executable target is checked under the Add to targets area when prompted.
+ Embedd the framework binary within your app by selecting the root item at the top left of the **Project Navigator** view, then selecting your project's target in the left-hand **Taregets** colum, then selecting the **General** tab and finally dragging the framework from the **Project Navigator** into the **Embedded Binaries** section.
	Add  *ExternalAccessory.framework* to your project under the **Link Binaries with Libraries** build phase. You should now be able to build your project.

```
				(WC2Device *)([note userInfo][WC2DeviceNotificationKey]));
   	
   	// connection failed


- (void)queryUpdate


```
```
WC2OrientationConfiguration *config = [WC2OrientationConfiguration 	configurationWithReferenceQuaternion:WC2_QUATERNION_ZERO 	type:WC2OrientationReferenceTypeBody];
[self.device setConfiguration:config forService:WC2ServiceOrientation error:&err];
if (err) { ... }
```
WC2OrientationConfiguration *config = [WC2OrientationConfiguration 	configurationWithReferenceSnapshot:somePreviousSnapshot	type:WC2OrientationReferenceTypeBody];
[self.device setConfiguration:config forService:WC2ServiceOrientation error:&err];
if (err) { ... }
```

Calling *setConfiguration:forService:error:* with a nil configuration clears any existing configuration.
WC2StepCountConfiguration *config = [WC2StepCountConfiguration 	configurationWithOffsetSteps:0];
[self.device config forService:WC2ServiceStepCount error:&err];
if (err) { ... }

```
