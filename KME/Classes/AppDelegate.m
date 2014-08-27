/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  KME
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Constants.h"
#import "Macros.h"
#import "KME_OpenUDID.h"

#import <Cordova/CDVPlugin.h>

@implementation AppDelegate

@synthesize window, viewController;
@synthesize lastAcceleration;

- (id)init
{
    
    
    // Assertions to Remind institution to customize all the URLs in Constants.mb
    if(NO){
        NSAssert(![kKMEHomeName     isEqualToString:@"KME Mobile"], @"The variable kKMEHomeName in Constants.m should be Customized for your institution.");
        NSAssert(![kBaseURL         hasPrefix:@"http://<SERVER>:9999/mdot"], @"The variable kBaseURL in Constants.m should be Customized for your institution.");
        NSAssert(![kSettingsURL     hasPrefix:@"http://<SERVER>:9999/mdot"], @"The variable kSettingsURL in Constants.m should be Customized for your institution. Can be an empty String");
        NSAssert(![kLaunchURL       hasPrefix:@"http://<SERVER>:9999/mdot"], @"The variable kLaunchURL in Constants.m should be Customized for your institution.");
        NSAssert(![kRegistrationURL hasPrefix:@"http://<SERVER>:9999/mdot"], @"The variable kRegistrationURL in Constants.m should be Customized for your institution. Can be an empty String");
    }

    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
		NSLog(@"Version Less than 5.0");
	}else{
		NSLog(@"Version is greater than 5.0");
	}

    //	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
	[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"hasPush"];
	NSLog(@"Username: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"username"]);
	NSLog(@"hasPush:  %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"hasPush"]);
    
    // Construct JSON query Param that will be used to register the device.
	NSString *jsonTemplate = @"{name:'<NAME>',regId:'<REGID>',deviceId:'<DEVID>',type:'iOS',username:'<USERNAME>'}";
    
    NSString *deviceUuid = [self getDeviceUuid];
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    if(username != nil){
        jsonTemplate = [jsonTemplate stringByReplacingOccurrencesOfString:@"<USERNAME>" withString:username];
    }else{
        jsonTemplate = [jsonTemplate stringByReplacingOccurrencesOfString:@"<USERNAME>" withString:@""];
    }
	jsonTemplate = [jsonTemplate stringByReplacingOccurrencesOfString:@"<NAME>" withString:deviceName];
	jsonTemplate = [jsonTemplate stringByReplacingOccurrencesOfString:@"<DEVID>" withString:deviceUuid];
    
	[[NSUserDefaults standardUserDefaults] setObject:jsonTemplate forKey:@"regTemplate"];
    
    self = [super init];
    return self;
}

#pragma UIApplicationDelegate implementation

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    
  	NSDictionary *notif= [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    for (id key in notif) {
        NSLog(@"key: %@, value: %@ \n", key, [notif objectForKey:key]);
    }
    
    NSURL* url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    NSString* invokeString = nil;

    if (url && [url isKindOfClass:[NSURL class]]) {
        invokeString = [url absoluteString];
        NSLog(@"KME launchOptions = %@, %@", url, invokeString);
    }

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
    self.window.autoresizesSubviews = YES;

    self.viewController = [[[MainViewController alloc] init] autorelease];
    self.viewController.useSplashScreen = YES;
    self.viewController.wwwFolderName = @"www";
    self.viewController.startPage = kLaunchURL;
//    self.viewController.startPage = @"https://www.iu.edu/~iumobile/BK/php/template.php?native=yes&platform=iOS&phonegap=2.2.0&header=&digitalSign=no";
    self.viewController.view.frame = screenBounds;
	self.viewController.webView.delegate = self.viewController;
    
    // NOTE: To control the view's frame size, override [self.viewController viewWillAppear:] in your view controller.

    // check whether the current orientation is supported: if it is, keep it, rather than forcing a rotation
    BOOL forceStartupRotation = YES;
    UIDeviceOrientation curDevOrientation = [[UIDevice currentDevice] orientation];

    if (UIDeviceOrientationUnknown == curDevOrientation) {
        // UIDevice isn't firing orientation notifications yet… go look at the status bar
        curDevOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    }

    if (UIDeviceOrientationIsValidInterfaceOrientation(curDevOrientation)) {
        if ([self.viewController supportsOrientation:curDevOrientation]) {
            forceStartupRotation = NO;
        }
    }

    if (forceStartupRotation) {
        UIInterfaceOrientation newOrient;
        if ([self.viewController supportsOrientation:UIInterfaceOrientationPortrait]) {
            newOrient = UIInterfaceOrientationPortrait;
        } else if ([self.viewController supportsOrientation:UIInterfaceOrientationLandscapeLeft]) {
            newOrient = UIInterfaceOrientationLandscapeLeft;
        } else if ([self.viewController supportsOrientation:UIInterfaceOrientationLandscapeRight]) {
            newOrient = UIInterfaceOrientationLandscapeRight;
        } else {
            newOrient = UIInterfaceOrientationPortraitUpsideDown;
        }

        NSLog(@"AppDelegate forcing status bar to: %d from: %d", newOrient, curDevOrientation);
        [[UIApplication sharedApplication] setStatusBarOrientation:newOrient];
    }
    
   	[UIAccelerometer sharedAccelerometer].delegate = self;

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
	if(notif != nil){
		[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hasPush"];
		self.viewController.incomingPush = notif;
	}
    
    return YES;
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if KME-Info.plist specifies a protocol to handle
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
    if (!url) {
        return NO;
    }

    // calls into javascript global function 'handleOpenURL'
    NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];
    [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];

    // all plugins will get the notification, and their handlers will be called
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];

    return YES;
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
    NSUInteger supportedInterfaceOrientations = (1 << UIInterfaceOrientationPortrait) | (1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight) | (1 << UIInterfaceOrientationPortraitUpsideDown);

    return supportedInterfaceOrientations;
}
#pragma mark - Push Related

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devToken
{
    
	NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    
	// Register this device with our service for APNs here.
    NSString *deviceUuid = [self getDeviceUuid];
    NSString *deviceName = [[UIDevice currentDevice] name];
    //    UIDevice *dev = [UIDevice currentDevice];
    //    NSString *deviceModel = dev.model;
    //    NSString *deviceSystemVersion = dev.systemVersion;
	NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    
	// Get rid of unnecessary chars in string.
	NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<" withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	[[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"currentDeviceToken"];
	NSLog(@"pref.CurrentDeviceToken: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"currentDeviceToken"]);
	
	NSString *registerString = kRegistrationURL;
	
	// Construct JSON query Param that will be used to register the device.
	NSString *jsonTemplate = @"{name:\"<NAME>\",regId:'<REGID>',deviceId:'<DEVID>',type:'iOS',username:'<USERNAME>'}";
    
    //Fixes JSON Exception Server Side. 
    deviceName = [NSString escapeString:deviceName];
	jsonTemplate = [jsonTemplate stringByReplacingOccurrencesOfString:@"<NAME>" withString:deviceName];
	jsonTemplate = [jsonTemplate stringByReplacingOccurrencesOfString:@"<REGID>" withString:deviceToken];
	jsonTemplate = [jsonTemplate stringByReplacingOccurrencesOfString:@"<DEVID>" withString:deviceUuid];
    
	[[NSUserDefaults standardUserDefaults] setObject:jsonTemplate forKey:@"regTemplate"];
	NSLog(@"pref.regTemplate: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"regTemplate"]);
    
    if(username != nil){
        jsonTemplate = [jsonTemplate stringByReplacingOccurrencesOfString:@"<USERNAME>" withString:username];
    }else{
        jsonTemplate = [jsonTemplate stringByReplacingOccurrencesOfString:@"<USERNAME>" withString:@""];
    }
    
	// Append to query URL/
	registerString = [registerString stringByAppendingString:@"data="];
	registerString = [registerString stringByAppendingString:jsonTemplate];
    
	// Append to HOST
//	NSString *devhost = [kHomeServerURL stringByAppendingString:registerString];
//	NSString *devhost = [kBaseURL stringByAppendingString:registerString];
	NSLog(@"registerString is: %@", registerString);
    
	// Create URL, execute POST/GET Request, deal with return values.
	NSURL *url = [[NSURL alloc] initWithString:[registerString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:10];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [request dealloc];
	// Display for debugging purposes.
    NSLog(@"Register URL: %@", url);
    NSLog(@"Return Data: %@ ~~~ %@", [returnData debugDescription], [returnData description]);
    NSLog(@"Response from Push Registration: %@", [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]]);
    NSLog(@"Error: %d %@", [error code], [error localizedDescription]);
    if([error code] == -1001){
        [self.viewController showErrorPage:@"timeout.html"];
    }
    
    
    
    NSLog(@"My token is: %@", deviceToken);
}


- (BOOL) willRegisterUsernameForPush:(NSString *)username
{
	NSLog(@"willRegisterUsernameForPush:%@", username);
	NSString* jsonTemplate = [[NSUserDefaults standardUserDefaults] stringForKey:@"regTemplate"];
	jsonTemplate = [jsonTemplate stringByReplacingOccurrencesOfString:@"<USERNAME>" withString:username];
    
	NSString *registerString = kRegistrationURL;
	// Append to query URL/
	registerString = [registerString stringByAppendingString:@"data="];
	registerString = [registerString stringByAppendingString:jsonTemplate];
    
	
	// Append to HOST
//	NSString *devhost = [kHomeServerURL stringByAppendingString:registerString];
//	NSString *devhost = [kBaseURL stringByAppendingString:registerString];

    NSLog(@"host:%@", registerString);
    
	
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Would have Registered in on a device.");
#else
    // Create URL, execute POST/GET Request, deal with return values.
	NSURL *url = [[NSURL alloc] initWithString:[registerString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	// Display for debugging purposes.
    NSLog(@"Register URL: %@", url);
    NSLog(@"Return Data: %@ ~~~ %@", [returnData debugDescription], [returnData description]);
#endif
    
    return YES;
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
	// Deal with Remote APNs for a "running" app here.
	// Update Badge.
	// Perhaps change the loading point of our app. Especially for Campus/Police Alerts.
    
	NSLog(@"didReceiveRemoteNotification");
	NSDictionary *dictionary = [userInfo objectForKey:@"aps"];
	self.viewController.incomingPush = dictionary;
	
    
	NSString *messageID	= [userInfo objectForKey:@"i"];
    //	NSString *url		= [userInfo objectForKey:@"u"];
	NSString *emergency	= [userInfo objectForKey:@"e"];
	
	NSString *alert		= [dictionary objectForKey:@"alert"];
	NSString *badge		= [dictionary objectForKey:@"badge"];
	
	NSString *js = [NSString stringWithFormat:@"handleIncomingPush('%@', '%@', '%@', '%@');", alert, messageID, emergency, badge];
    NSLog(@"%@", js);

    
	NSString *jsResult = [self.viewController.webView stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"handleIncomingPush result: %@", jsResult);
//	jsResult = [self.viewController.webView stringByEvaluatingJavaScriptFromString:@"test();"];
    
    
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:[badge integerValue]];
}

// Get uuid based on different iOS version
- (NSString *) getDeviceUuid{
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceUuid = nil;
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0f)) {
        deviceUuid= [KME_OpenUDID value];
        
    }
    else {
        deviceUuid = [[dev identifierForVendor] UUIDString];
    }
    
    NSLog(@"System version: %@ , deviceUuid is %@", [[UIDevice currentDevice] systemVersion], deviceUuid);
    return deviceUuid;
}

#pragma mark - Shake implementation
static BOOL L0AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold) {
    double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
    
    return
    (deltaX > threshold && deltaY > threshold) ||
    (deltaX > threshold && deltaZ > threshold) ||
    (deltaY > threshold && deltaZ > threshold);
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	if (self.lastAcceleration) {
		if (!histeresisExcited && L0AccelerationIsShaking(self.lastAcceleration, acceleration, 1.0)) {
			histeresisExcited = YES;

			// Do Shake related things...   
            if(kShakeToOpenActionSheet){
                NSLog(@"Shook!");
                if(!self.viewController.showingActionSheet){
                    [self.viewController showActionSheet:self];
                }  
            }

		} else if (histeresisExcited && !L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.2)) {
			histeresisExcited = NO;
		}
	}
	self.lastAcceleration = acceleration;
}


@end



// Category for escaping special characters in a string.
@implementation NSString (Filename)

+ (NSString *)escapeString:(NSString *)string{
    NSMutableString* ms = [NSMutableString stringWithString:string];
	[ms replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];
	[ms replaceOccurrencesOfString:@"'"  withString:@"\'" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];

    // Agressively strip out non english standard quoting marks
    [ms replaceOccurrencesOfString:@"`"  withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];
	[ms replaceOccurrencesOfString:@"‘"  withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];
	[ms replaceOccurrencesOfString:@"’"  withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];
	[ms replaceOccurrencesOfString:@"„"  withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];
	[ms replaceOccurrencesOfString:@"”"  withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];
	[ms replaceOccurrencesOfString:@"“"  withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];

    // These characters also cause JSONExceptions. Might be library used on server. 
    [ms replaceOccurrencesOfString:@"&"  withString:@""  options:NSLiteralSearch range:NSMakeRange(0, [ms length])];
	
    
	return ms;

}

@end