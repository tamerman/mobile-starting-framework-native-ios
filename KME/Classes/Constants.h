//
//  Constants.h
//  KME
//
//  Created by Mitchell Wagner on 11/5/12.
//
//

#import <Foundation/Foundation.h>

typedef enum{
    kNativeHeader,
    kNonNativeHeader,
}kNibType;

typedef enum{
    OK=200,
    BADREQUEST=400
}kHTTPStatusCodes;

typedef enum{
    kOpenUsingSafari,
    kOpenUsingActionSheet
}kActionType;



FOUNDATION_EXPORT int kHeaderType;
FOUNDATION_EXPORT int const kActionButton;
FOUNDATION_EXPORT BOOL const kShakeToOpenActionSheet;
FOUNDATION_EXPORT BOOL const kPreInsertCookies;
FOUNDATION_EXPORT NSString *const kPhonegapVersion;

//
// Name and URLS
//
FOUNDATION_EXPORT NSString *const kKMEHomeName;
FOUNDATION_EXPORT NSString *const kBaseURL;
FOUNDATION_EXPORT NSString *const kSettingsURL;
FOUNDATION_EXPORT NSString *const kLaunchURL;
FOUNDATION_EXPORT NSString *const kRegistrationURL;

//
// App twitter Hashtag and @tag.
//
FOUNDATION_EXPORT NSString *const kTwitterHash;
FOUNDATION_EXPORT NSString *const kTwitterTag;


//
// Action Sheet Elements. 
//
FOUNDATION_EXPORT BOOL const kSettingsEnabled;
FOUNDATION_EXPORT BOOL const kOpenInSafariEnabled;
FOUNDATION_EXPORT BOOL const kEmailtoEnabled;
FOUNDATION_EXPORT BOOL const kFacebookEnabled;
FOUNDATION_EXPORT BOOL const kTweetEnabled;
FOUNDATION_EXPORT BOOL const kPrintingEnabled;


//
// UI & Graphics Related
//
FOUNDATION_EXPORT NSString *const kNavBarBackgroundImageName;
FOUNDATION_EXPORT NSString *const kNavBarLogoImageName;
FOUNDATION_EXPORT BOOL const kWebViewBounceEnabled;


//
// Array of URLs that will cause the Cordova/WebView to return home after 3 seconds.  
//
#define urlsToReturnHome [NSArray arrayWithObjects:@"https://cas.iu.edu/cas/logout", @"Blah2", @"Blah3", nil]