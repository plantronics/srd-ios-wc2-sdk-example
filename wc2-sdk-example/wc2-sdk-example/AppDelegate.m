//
//  AppDelegate.m
//  wc2-sdk-example
//
//  Created by Morgan Davis on 8/4/15.
//  Copyright © 2015 Plantronics. All rights reserved.
//

#import "AppDelegate.h"


@interface PLTDLogger : NSObject
+ (PLTDLogger *)sharedLogger;
@property(nonatomic,assign)	NSInteger level;
@end


@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // turn on debug logging by uncommenting this line
    //[PLTDLogger sharedLogger].level = 0;
    
    return YES;
}


@end
