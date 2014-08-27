//
//  Constants.m
//  KME
//
//  Created by Mitchell Wagner on 11/5/12.
//
//

#import "Constants.h"




/**** ----- Configurable Options ----- ****/

//  Native style UINavigationBar type header, or non-native footer bar?
int             kHeaderType             = kNativeHeader;                // kNativeHeader or kNonNativeHeader

//  ActionButton (to left of Home button in non-native bar can open directly in Safari or present an ActionSheet.
int const       kActionButton           = kOpenUsingSafari;        // kOpenUsingActionSheet or kOpenUsingSafari

//  Which items do you want to show up in the Pop-up action sheet.
BOOL const      kSettingsEnabled        = YES;                      // Also controls visibility of the settings button.
BOOL const      kOpenInSafariEnabled    = YES;
BOOL const      kEmailtoEnabled         = YES;
BOOL const      kFacebookEnabled        = YES;
BOOL const      kTweetEnabled           = YES;
BOOL const      kPrintingEnabled        = YES;

//  Should Shaking device open the action sheet?
BOOL const      kShakeToOpenActionSheet = NO;                          // YES or NO

//  Should cookies be Pre inserted for every page about to be opened? For 'native', 'phonegap' and 'platform'.
//  This will make these cookies available to all domains. 
BOOL const      kPreInsertCookies       = YES;

//  What version of Phonegap/Cordova is being used. 
NSString *const kPhonegapVersion        = @"2.2.0";



/**** ----- URL STRINGS ----- ****/
NSString *const kKMEHomeName            = @"KME Mobile";
NSString *const kBaseURL                = @"http://<SERVER>:9999/mdot";                                               // URL for Home Button and Device Registration.
NSString *const kSettingsURL            = @"http://<SERVER>:9999/mdot/campus?toolName=home";                          // URL for Settings Page.
NSString *const kLaunchURL              = @"http://<SERVER>:9999/mdot/home?native=yes&phonegap=2.2.0&header=show";    // Launch URL
NSString *const kRegistrationURL        = @"http://<SERVER>:9999/mdot/services/device/register?";                              // URL for registering device for Push



/**** ----- UI STRINGS ----- ****/

// App twitter Hashtag and @tag.
NSString *const kTwitterHash            = @"#KME";
NSString *const kTwitterTag             = @"@KME";
// NOTE: If you want to customize/localize/internationalize other strings used in the UI, look at /Resources/en.lproj/Localizable.strings



/**** ----- UI & Graphics ----- ****/
NSString *const kNavBarBackgroundImageName  = @"";
NSString *const kNavBarLogoImageName        = @"";
BOOL const kWebViewBounceEnabled            = YES;