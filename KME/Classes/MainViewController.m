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
//  MainViewController.h
//  KME
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Constants.h"
#import "Macros.h"
#import "JSONKit.h"




@implementation MainViewController

@synthesize navTitle, navBar;
@synthesize backURL, homeURL;
@synthesize bezel, spinner;
@synthesize showingActionSheet, safariActionSheet, homeActionSheet;
@synthesize backImage, forwardImage, homeImage, safariImage;
@synthesize backButton, forwardButton, homeButton, safariButton;
@synthesize hasPush, incomingPush;



- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    
    
//    NSString* usernamePref      = [[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"];
//    NSString* passphrasePref    = [[NSUserDefaults standardUserDefaults] stringForKey:@"passphrase_preference"];
//    BOOL remainLoggedInPref     = [[NSUserDefaults standardUserDefaults] boolForKey:@"remain_logged_in_preference"];
//    NSLog(@"Username: \"%@\" with passphrase: \"%@\", Will %@Remain Logged in.", usernamePref, passphrasePref, remainLoggedInPref?@"":@"NOT ");
//    
//    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"menu_type"] == kNativeHeader) {
//        kHeaderType = kNativeHeader;
//        NSLog(@"Menu Type is: Native");
//    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"menu_type"] == kNonNativeHeader) {
//        NSLog(@"Menu Type is: NonNative");
//        kHeaderType = kNonNativeHeader;
//    }
    
    if(kHeaderType == kNativeHeader){
        self = [super initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
    }else if(kHeaderType == kNonNativeHeader){
        self = [super initWithNibName:@"NonNativeMainViewController" bundle:[NSBundle mainBundle]];
    }else{
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // Set the main view to utilize the entire application frame space of the device.
    // Change this to suit your view's UI footprint needs in your application.

    UIView* rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    CGRect webViewFrame = [[[rootView subviews] objectAtIndex:0] frame];  // first subview is the UIWebView

    if (CGRectEqualToRect(webViewFrame, CGRectZero)) { // UIWebView is sized according to its parent, here it hasn't been sized yet
        self.view.frame = [[UIScreen mainScreen] applicationFrame]; // size UIWebView's parent according to application frame, which will in turn resize the UIWebView
    }

    if(kHeaderType == kNativeHeader){
        [self.navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,
                                                                                        [UIColor darkGrayColor], UITextAttributeTextShadowColor,
                                                                                        [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,nil]];
    }
    
    //Custom Linen BAckground.
    //[self.webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"texture.png"]]];

    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navTitle.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-home"] style:UIBarButtonItemStyleBordered target:self action:@selector(didTouchSettingsButton:)];
//    self.navTitle.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-back"] style:UIBarButtonItemStyleBordered target:self action:@selector(didTouchAboutButton:)];
    showingActionSheet = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.webView setDelegate:nil];
    [self.webView stopLoading];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    // If we're using a custom NavBar background, rescale it whenever orientation changes.
    if(![kNavBarBackgroundImageName isEqualToString:@""]){
        UIImage *img = [UIImage imageNamed:kNavBarBackgroundImageName];
        CGSize imgSize = self.navBar.frame.size;
        UIGraphicsBeginImageContext( imgSize );
        [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //        [self.navBar setBackgroundImage:[UIImage imageNamed:navBarBackgroundImageName] forBarMetrics:UIBarMetricsDefault];
        [self.navBar setBackgroundImage:newImage forBarMetrics:UIBarMetricsDefault];
    }
    
    
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/* Comment out the block below to over-ride */

/*
- (CDVCordovaView*) newCordovaViewWithFrame:(CGRect)bounds
{
    return[super newCordovaViewWithFrame:bounds];
}
*/

/* Comment out the block below to over-ride */

/*
#pragma CDVCommandDelegate implementation

- (id) getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (BOOL) execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

- (NSString*) pathForResource:(NSString*)resourcepath;
{
    return [super pathForResource:resourcepath];
}

- (void) registerPlugin:(CDVPlugin*)plugin withClassName:(NSString*)className
{
    return [super registerPlugin:plugin withClassName:className];
}
*/

#pragma mark - UIWebDelegate implementation

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    // only valid if ___PROJECTNAME__-Info.plist specifies a protocol to handle

    // Enable Pinch for webView. WebView Content will control whether it can be zoomed or not.
    //[theWebView setScalesPageToFit:YES];
    
    // jQm Header just in case.
    if(kHeaderType == kNativeHeader){
        if(![[theWebView stringByEvaluatingJavaScriptFromString: @"$('div[data-role=\"header\"]').length"] isEqualToString:@""]){
            [theWebView stringByEvaluatingJavaScriptFromString: @"$('div[data-role=\"header\"]').css('display', 'none')"];
        }
    }
    
    // Set NavBar title to equal the Page's title.
    NSString *title		= [theWebView stringByEvaluatingJavaScriptFromString: @"document.title"];
    NSString *location	= [theWebView stringByEvaluatingJavaScriptFromString: @"window.location.href"];
//    self.navTitle.title = title;

    if(![kNavBarLogoImageName isEqualToString:@""]){
        self.navTitle.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kNavBarLogoImageName]];
    }else{
        self.navTitle.title = title;
    }
    
    if(![kNavBarBackgroundImageName isEqualToString:@""]){
        UIImage *img = [UIImage imageNamed:kNavBarBackgroundImageName];
        CGSize imgSize = self.navBar.frame.size;
        UIGraphicsBeginImageContext( imgSize );
        [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //        [self.navBar setBackgroundImage:[UIImage imageNamed:navBarBackgroundImageName] forBarMetrics:UIBarMetricsDefault];
        [self.navBar setBackgroundImage:newImage forBarMetrics:UIBarMetricsDefault];
    }
    
    
    // Set and Show the Back and Home Button in NavBar if they have values.
    NSString *back		= [theWebView stringByEvaluatingJavaScriptFromString: @"$('a[data-icon=\"back\"]').attr('href')"];
    NSString *home		= [theWebView stringByEvaluatingJavaScriptFromString: @"$('a[data-icon=\"home\"]').attr('href')"];
    NSString *gear		= [theWebView stringByEvaluatingJavaScriptFromString: @"$('div[data-role=\"header\"] a[data-icon=\"gear\"]').attr('href')"];
    NSLog(@"Gear: %@", [kBaseURL stringByAppendingFormat:@"/%@", gear]);
    
    NSLog(@"theWebView: %@", [[[theWebView request] URL] absoluteString]);
    NSLog(@"kLuanchURL: %@", [[NSURL URLWithString:kLaunchURL] absoluteString]);
    
    
    NSLog(@"theWebView is: %@", [[[theWebView request] URL] absoluteString]);
    NSLog(@"NSURL is:      %@", [[NSURL URLWithString:kLaunchURL] absoluteString]);
    NSLog(@"kBaseURL is:   %@", [[NSURL URLWithString:[kBaseURL stringByAppendingFormat:@"/home"]] absoluteString]);
    if([[[[theWebView request] URL] absoluteString] isEqualToString:[[NSURL URLWithString:kLaunchURL] absoluteString]] ||
            [[[[theWebView request] URL] absoluteString] isEqualToString:[[NSURL URLWithString:[kBaseURL stringByAppendingFormat:@"/home"]] absoluteString]]){
        [self.navTitle setLeftBarButtonItem:nil animated:YES];
        if(![kSettingsURL isEqualToString:@""] && kSettingsEnabled){
            self.navTitle.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-settings"] style:UIBarButtonItemStyleBordered target:self action:@selector(didTouchSettingsButton:)];
        }
    }else{
        self.navTitle.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-back"] style:UIBarButtonItemStyleBordered target:self action:@selector(didTouchBackButton:)];
        self.navTitle.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-home"] style:UIBarButtonItemStyleBordered target:self action:@selector(didTouchHomeButton:)];
    }
    
    
//    if(![back isEqualToString:@""]){
//        NSLog(@"Back A:%@",back);
//        backURL = back;
//        self.navTitle.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-back"] style:UIBarButtonItemStyleBordered target:self action:@selector(didTouchBackButton:)];
//    }else{
//        NSLog(@"Back B:%@",back);
//        if([[[[theWebView request] URL] absoluteString] isEqualToString:[[NSURL URLWithString:kLaunchURL] absoluteString]]){
//            NSLog(@"theWebView domain isEqualTo kLaunchURL domain: %@", [[[theWebView request] URL] absoluteString]);
//            self.navTitle.leftBarButtonItem = nil;        
//        }else{
//            NSLog(@"theWebView is NOT equal kLaunchURL");
//            self.navTitle.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-back"] style:UIBarButtonItemStyleBordered target:self action:@selector(didTouchBackButton:)];
//        }
//        [self.backImage setImage:[UIImage imageNamed:@"back-disabled"]];
//    }
//    
//    if(![home isEqualToString:@""]){
//        NSLog(@"Home A:%@",home);
//        homeURL = home;
//        self.navTitle.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-home"] style:UIBarButtonItemStyleBordered target:self action:@selector(didTouchSafariButton:)];
//    }else{
//        NSLog(@"Home B:%@",home);
//        self.navTitle.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-home"] style:UIBarButtonItemStyleBordered target:self action:@selector(didTouchSafariButton:)];
//    }
//
//    if(![gear isEqualToString:@""]){
//        NSLog(@"Gear A:%@",gear);
//    }else{
//        NSLog(@"Gear B:%@",gear);
//    }
    
//    if([home isEqualToString:@""] && [back isEqualToString:@""]){
//        NSLog(@"RESET:%@",@"Do Nothing Currently");
//        self.navTitle.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-home"] style:UIBarButtonItemStyleBordered target:self action:@selector(didTouchSafariButton:)];
//    }
    
    if([location hasPrefix:@"file:"]){
//        NSLog(@"Loading an Internal File: %@", location);
        self.navTitle.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-home"] style:UIBarButtonItemStyleBordered target:self action:@selector(didTouchHomeButton:)];
    }
    
    // Black base color for background matches the native apps
    //theWebView.backgroundColor = [UIColor blackColor];

    
    self.webView.userInteractionEnabled = YES;
    
    // Animate Fade out of thinking spinner
    [UIView beginAnimations:@"SomeAnimation" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    self.bezel.alpha = 0;
    self.spinner.alpha = 0;
	[UIView commitAnimations];
	[self.spinner stopAnimating];

    if([self.webView canGoForward]){
        [self.forwardImage setImage:[UIImage imageNamed:@"forward-enabled.png"]];
    }else{
        [self.forwardImage setImage:[UIImage imageNamed:@"forward-disabled.png"]];
    }

    if([[[[theWebView request] URL] absoluteString] isEqualToString:[[NSURL URLWithString:kLaunchURL] absoluteString]] ||
       [[[[theWebView request] URL] absoluteString] isEqualToString:[[NSURL URLWithString:[kBaseURL stringByAppendingFormat:@"/home"]] absoluteString]]){
        [self.backImage setImage:[UIImage imageNamed:@"back-disabled.png"]];
    }else{
        [self.backImage setImage:[UIImage imageNamed:@"back-enabled.png"]];
    }

    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"hasPush"] isEqualToString:@"YES"]){
		NSLog(@"NSUserDefault.hasPush == YES");
		NSString* json = [NSString stringWithFormat:@"%@",[self.incomingPush JSONString]];
		NSLog(@"%@", json);
		NSString* js = [NSString stringWithFormat:@" var pushMessageJSON = \'%@\';", json];
		[theWebView stringByEvaluatingJavaScriptFromString:js];
	}else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"hasPush"] isEqualToString:@"NO"]){
//		NSLog(@"NSUserDefault.hasPush == NO");
		NSString* js = [NSString stringWithFormat:@" var pushMessageJSON = \'{empty}\';"];
		[theWebView stringByEvaluatingJavaScriptFromString:js];
	}
    
	NSLog(@"js.pushMessageJSON is :%@", [theWebView stringByEvaluatingJavaScriptFromString:@"pushMessageJSON"]);
	NSLog(@"incomingPush is :%@", [theWebView stringByEvaluatingJavaScriptFromString:[self.incomingPush JSONString]]);
    
    NSString* username = [theWebView stringByEvaluatingJavaScriptFromString:@"$.cookie('currentNetworkId');"];
	NSString* prefusername = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    
	// if we get a non-null currentNetworkId cookie
	// Then we should register our username with our puch device.
	if([username length] != 0 && ![prefusername isEqualToString:username]){
		NSLog(@"currentNetworkId is : %@", username);
		[[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate willRegisterUsernameForPush:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]];
	}
    
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *cookies = [cookieJar cookies];
//    NSLog(@"Cookies: %@", cookies);
    

    // If we arrive at a specific url defined in Constants.h (typically some sort of logout page, like CAS) go back to home after 3 seconds.
    // NSArray *urlsArray = urlsToReturnHome;
    NSEnumerator *enumerator = [urlsToReturnHome objectEnumerator];
    NSString *thisLocation;
    while(thisLocation = [enumerator nextObject]){
        if([location isEqualToString:thisLocation]){
            [self performSelector:@selector(goHome:) withObject:nil afterDelay:3.0];
            break;
        }
    }
    
    NSString *klu = [NSString stringWithFormat:@"kLaunchURL = \'%@\';", kLaunchURL];
    [theWebView stringByEvaluatingJavaScriptFromString:klu];
    
    
    return [super webViewDidFinishLoad:theWebView];
}

/* Comment out the block below to over-ride */

- (void) webViewDidStartLoad:(UIWebView*)theWebView
{
    NSLog(@"webViewDidStartLoad.domain: %@", [[[theWebView request] URL] host]);
    
    
    
    self.webView.userInteractionEnabled = NO;
    self.bezel.hidden                   = NO;
    self.spinner.hidden                 = NO;
    
    // Fade in the think spinner
    [UIView beginAnimations:@"SomeAnimation" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
        self.bezel.alpha = 0.8;
        self.spinner.alpha = 1.0;
    [UIView commitAnimations];
    
    // Animate the spinner.
	[self.spinner startAnimating];
    
    
    if(kHeaderType == kNonNativeHeader){
        
    }

//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *cookies = [cookieJar cookies];
//    NSLog(@"Cookies: %@", cookies);
    
    
    return [super webViewDidStartLoad:theWebView];
}

- (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{

/*
    // NSURLErrorDomain -999 causes an endless loop. This check prevents that.
    if([error code] != -999){
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mdotHome]]];
//        return [super webView:theWebView didFailLoadWithError:error];
        NSLog(@"ERROR: %d %@", [error code],[error localizedDescription]);
        [self showConnectionError:self];
    }else{
        NSLog(@"ERROR: %@", [error localizedDescription]);
    }
*/
    NSLog(@"ERROR: %d %@", [error code],[error localizedDescription]);
    switch([error code]){
        case -999:
            NSLog(@"ERROR: %d %@", [error code],[error localizedDescription]);
            break;
        case -1001:
            [self showErrorPage:@"timeout.html"];
            break;
        case -1009:
            [self showErrorPage:@"connection.html"];
            break;
        default:
            [self showErrorPage:@"general.html"];
            return [super webView:theWebView didFailLoadWithError:error];
    }
    
    
}


- (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest");
    NSLog(@"Request Host %@", [[request URL] host]);
    
    
    if ([[[request URL] scheme] isEqual:@"mailto"]) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }

    if ([[[request URL] scheme] isEqual:@"tel"]) {
        NSString *phone = [[request URL] absoluteString];
        NSLog(@"phone: %@", phone);
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"phone: %@", phone);
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phone]]){
            NSLog(@"Can Open URL");
        }else{
            NSLog(@"Can NOT Open URL");            
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        return NO;
    }

    /* Open the URL externally in Mobile Safari if query string contains "iOSSafari=true" */
    NSString *const openInSafari = @"iOSSafari=true";
    NSString *queryStr = [[request URL] query];
    NSLog(@"query String %@", queryStr);
    if (queryStr != nil && [queryStr rangeOfString:openInSafari].location != NSNotFound) {
        // TODO stripe out "iOSSafari=true" from queryString if needed
        
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    /*
     *  Make the page so that it can pinch to zoom. Pages will need to disable this, so that it is
     *  only works on pdfs or image files. 
     */
    [theWebView setScalesPageToFit:YES];

    /*
     *  Here we write cookies to the UIWebView for the domain of the next url to be loaded.
     *  The effect is the cookie will be available to the webpage being loaded. Here we are
     *  setting ccokies for platform, native and phonegap version.
     */
    if(kPreInsertCookies && [[request URL] host] != NULL){
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:@"native" forKey:NSHTTPCookieName];
        [cookieProperties setObject:@"yes" forKey:NSHTTPCookieValue];
        [cookieProperties setObject:[[request URL] host] forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[[request URL] host] forKey:NSHTTPCookieOriginURL];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:(365*24*60*60)] forKey:NSHTTPCookieExpires]; //Expires in 1 year.  
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

        [cookieProperties setObject:@"phonegap" forKey:NSHTTPCookieName];
        [cookieProperties setObject:kPhonegapVersion forKey:NSHTTPCookieValue];
        cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
        [cookieProperties setObject:@"platform" forKey:NSHTTPCookieName];
        [cookieProperties setObject:@"iOS" forKey:NSHTTPCookieValue];
        cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

        [cookieProperties setObject:@"jqmHeader" forKey:NSHTTPCookieName];
        if(kHeaderType == kNativeHeader){
            [cookieProperties setObject:@"hide" forKey:NSHTTPCookieValue];
        }else if(kHeaderType == kNonNativeHeader){
            [cookieProperties setObject:@"show" forKey:NSHTTPCookieValue];
        }
        cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    }
        
    return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
}


- (IBAction) goHome:(id)sender{
	NSLog(@"--- goHome");
    [self.webView stopLoading];
	if(self.webView.loading){
        [self.webView stopLoading];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kLaunchURL]]];
    }else if(!self.webView.loading){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kLaunchURL]]];
    }
}


#pragma mark - UI Methods


- (IBAction)willTouchBackButton:(id)sender {
	NSLog(@"willTouchBackButton");
	[self.backImage setImage:[UIImage imageNamed:@"back-active.png"]];
}
- (IBAction)willTouchForwardButton:(id)sender {
	NSLog(@"willTouchForwardButton");
	[self.forwardImage setImage:[UIImage imageNamed:@"forward-active.png"]];
}

- (IBAction)willTouchSafariButton:(id)sender {
	NSLog(@"willTouchSafariButton");
	[self.safariImage setImage:[UIImage imageNamed:@"safari-active.png"]];
}

- (IBAction)willTouchHomeButton:(id)sender {
	NSLog(@"willTouchHomeButton");
	[self.homeImage setImage:[UIImage imageNamed:@"home-active.png"]];
}


#pragma mark -

- (IBAction) didTouchBackButton:(id)sender{
    NSString *back		= [self.webView stringByEvaluatingJavaScriptFromString: @"$('a[data-icon=\"back\"]').attr('href')"];
    NSString *backFunction	= [self.webView stringByEvaluatingJavaScriptFromString: @"$('a[data-icon=\"back\"]').attr('data-back-function')"];
    
    
    NSLog(@"didTouchBackButton: %@", back);
    
    if(![backFunction isEqualToString:@""]){
        NSLog(@"calling headers BackFunction. %@", backFunction);
        [self.webView stringByEvaluatingJavaScriptFromString:backFunction];
    }else if([back isEqualToString:@"javascript: history.go(-1)"] || [back isEqualToString:@"javascript:history.go(-1)"]){
        if([self.webView canGoBack]){
            [self.webView goBack];
        }
        
    }else if(![back isEqualToString:@""]){
        NSString *url = [NSString stringWithFormat:@"window.location.href = \"%@\";", back];
        NSLog(url);
        if([self.webView isLoading]){
            [self.webView stopLoading];
        }
        [self.webView stringByEvaluatingJavaScriptFromString:url];
    }else if([back isEqualToString:@""]){
        // If a Burger King Model doesn't give a back button in the header bar, we go to the same URL as hitting the Home button.
        NSLog(@"No Back Button defined: Going home.");
        if([self.webView canGoBack]){
            [self.webView goBack];
        }else{
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kLaunchURL]]];
        }
    }else{
        
        NSURL *loc = [NSURL URLWithString:[self.webView stringByEvaluatingJavaScriptFromString: @"window.location.href"]];
        NSLog(@"LOC %@", loc);
        NSString *url;
        if([[NSURL URLWithString:back] scheme] == nil){
            if([loc port] != nil){
//                url = [NSString stringWithFormat:@"%@://%@:%@%@", [loc scheme], [loc host], [loc port], back];
                url = [NSString stringWithFormat:@"%@://%@:%@", [loc scheme], [loc host], [loc port]];
            }else{
//                url = [NSString stringWithFormat:@"%@://%@%@", [loc scheme], [loc host], back];
                url = [NSString stringWithFormat:@"%@://%@", [loc scheme], [loc host]];
            }
            if([back hasPrefix:@"/"]){
                url = [NSString stringWithFormat:@"%@%@", url, back];
            }else{
                url = [NSString stringWithFormat:@"%@/%@", url, back];
            }
            
        }else{
            url = back;
        }
        NSLog(@"Back to: %@", url);
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    [self.backImage setImage:[UIImage imageNamed:@"back-enabled.png"]];
}


- (IBAction) didTouchForwardButton:(id)sender{
    NSLog(@"didTouchForwardButton: %@", @"");
    if([self.webView canGoForward]){
        [self.forwardImage setImage:[UIImage imageNamed:@"forward-enabled.png"]];
        [self.webView goForward];
    }else{
       	[self.forwardImage setImage:[UIImage imageNamed:@"forward-disabled.png"]];
    }
}

- (IBAction) didTouchSafariButton:(id)sender{
    NSLog(@"didTouchSafariButton: %@", @"");
    [self.safariImage setImage:[UIImage imageNamed:@"safari-enabled.png"]];

    switch(kActionButton){
        case kOpenUsingActionSheet:
            if(!showingActionSheet){
                [self showActionSheet:self];
            }else{
                [safariActionSheet dismissWithClickedButtonIndex:([safariActionSheet numberOfButtons] -1) animated:YES];
                showingActionSheet = NO;
            }
            break;
        case kOpenUsingSafari:
            [[ UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.webView stringByEvaluatingJavaScriptFromString: @"window.location.href"]]];
            break;
    }
}



- (IBAction) didTouchHomeButton:(id)sender{
    NSLog(@"didTouchHomeButton: %@", @"");
	[self.homeImage setImage:[UIImage imageNamed:@"home-enabled.png"]];
    
    if([self.webView isLoading]){
        [self.webView stopLoading];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kLaunchURL]]];
}


- (IBAction) didTouchSettingsButton:(id)sender{
    NSLog(@"didTouchSettingsButton: %@", @"");
    if([self.webView isLoading]){
        [self.webView stopLoading];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kSettingsURL]]];
}

- (IBAction) didTouchAboutButton:(id)sender{
    NSLog(@"didTouchAboutButton: %@", [NSURL fileURLWithPath:@"index.html"]);
    
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSMutableArray* directoryParts = [NSMutableArray arrayWithArray:[@"index.html" componentsSeparatedByString:@"/"]];
    NSString* filename = [directoryParts lastObject];
    
    [directoryParts removeLastObject];
    
    NSString* directoryPartsJoined = [directoryParts componentsJoinedByString:@"/"];
    NSString* directoryStr = self.wwwFolderName;
    
    if ([directoryPartsJoined length] > 0) {
        directoryStr = [NSString stringWithFormat:@"%@/%@", self.wwwFolderName, [directoryParts componentsJoinedByString:@"/"]];
    }
    
    NSLog(@"INNER File:%@", [mainBundle pathForResource:filename ofType:@"" inDirectory:directoryStr]);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[mainBundle pathForResource:filename ofType:@"" inDirectory:directoryStr]]]];
    

}

- (IBAction) showConnectionError:(id)sender{
    [self showErrorPage:@"timeout.html"];
}

- (void) showErrorPage:(NSString*)page{
    NSLog(@"didTouchAboutButton: %@", [NSURL fileURLWithPath:@"connection.html"]);
    
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSMutableArray* directoryParts = [NSMutableArray arrayWithArray:[page componentsSeparatedByString:@"/"]];
    NSString* filename = [directoryParts lastObject];
    
    [directoryParts removeLastObject];
    
    NSString* directoryPartsJoined = [directoryParts componentsJoinedByString:@"/"];
    NSString* directoryStr = self.wwwFolderName;
    
    if ([directoryPartsJoined length] > 0) {
        directoryStr = [NSString stringWithFormat:@"%@/%@", self.wwwFolderName, [directoryParts componentsJoinedByString:@"/"]];
    }
    
    NSLog(@"INNER File:%@", [mainBundle pathForResource:filename ofType:@"" inDirectory:directoryStr]);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[mainBundle pathForResource:filename ofType:@"" inDirectory:directoryStr]]]];
    
    
}

#pragma mark - UIActionSheet Actions

-(IBAction)showActionSheet:(id)sender {
    NSLog(@"showActionSheet: %@", @"");
    
    NSString* homeName = [NSString stringWithFormat:NSLocalizedString(@"%@ Home", nil), kKMEHomeName];
    
    safariActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:homeName, nil];

    // If the server has a user settings page, give it as an option.
    if(![kSettingsURL isEqualToString:@""] && kSettingsEnabled){
        [safariActionSheet addButtonWithTitle:NSLocalizedString(@"Settings", nil)];
    }
    
    // Anyone can open in safari, give it as an option.
    if(kOpenInSafariEnabled){
        [safariActionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", nil)];
    }
    
    // If an account is setup and we can send an email, give it as an option.
    if([MFMailComposeViewController canSendMail] && kEmailtoEnabled){
        [safariActionSheet addButtonWithTitle:NSLocalizedString(@"Email To...", nil)];
    }

    // If system version is > 5.0 and <= 6.0 we can check for Twitter.
    if(SYSTEM_VERSION_GREATER_THAN(@"5.0") && SYSTEM_VERSION_LESS_THAN(@"6.0")){
        if([TWTweetComposeViewController canSendTweet] && kTweetEnabled){
            [safariActionSheet addButtonWithTitle:NSLocalizedString(@"Tweet", nil)];
        }
    }
    
    // If system version is >= 6.0 we can check for face book and Twitter.
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        BOOL hasFacebook =  [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
        if(hasFacebook && kFacebookEnabled){
            NSLog(@"Has Facebook: %@",  hasFacebook ? @"YES":@"NO");
            [safariActionSheet addButtonWithTitle:NSLocalizedString(@"Facebook", nil)];
        }
        
        BOOL hasTwitter =   [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
        if(hasTwitter && kTweetEnabled){
            NSLog(@"Has Twitter: %@",   hasTwitter  ? @"YES":@"NO");
            [safariActionSheet addButtonWithTitle:NSLocalizedString(@"Tweet", nil)];
        }
    }
    
    if ([UIPrintInteractionController isPrintingAvailable] && kPrintingEnabled){
        [safariActionSheet addButtonWithTitle:NSLocalizedString(@"Print", nil)];
    }
    

    // Anyone can cancel an action Sheet. 
    [safariActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];    
    [safariActionSheet setCancelButtonIndex:[safariActionSheet numberOfButtons] - 1];
    
    self.showingActionSheet = YES;    
    safariActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;

    
    NSLog(@"showActionSheet.numberOfButtons: %d", [safariActionSheet numberOfButtons]);
    if([safariActionSheet numberOfButtons] == 2){
        [self didTouchHomeButton:self];
        return;
    }

    
    if(kHeaderType == kNativeHeader){
//        if(showingActionSheet){
            [safariActionSheet showFromBarButtonItem:self.navTitle.rightBarButtonItem animated:YES];
//        }
    }else{
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            // Show ActionSheet originating at the safari button.
//                if(showingActionSheet){
                    [safariActionSheet showFromRect:self.safariImage.bounds inView:self.safariImage animated:YES];
//                }
            }else{
            // Show ActionSheet in Center.
//                if(showingActionSheet){
                    [safariActionSheet showInView:self.view];
//                }
        }
    }

//    showingActionSheet = YES;
    [safariActionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(actionSheet == safariActionSheet){
		NSLog(@"didDismissWithButtonIndex:");

		
		if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:[NSString stringWithFormat:NSLocalizedString(@"%@ Home", nil), kKMEHomeName]]){
			NSLog(@"Go Home");
			[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kLaunchURL]]];
            
		}else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Settings", nil)]){
			NSLog(@"Go to Settings Page");
            if(![kSettingsURL isEqualToString:@""]){
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kSettingsURL]]];
            }
            
        }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Open in Safari", nil)]){
			NSLog(@"Open in Safari");
			NSURL* currentURL = [self.webView.request URL];
			[[UIApplication sharedApplication] openURL:currentURL];
            
		}else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Email To...", nil)]){
            NSLog(@"Email Link");
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
			picker.mailComposeDelegate = self;
			[picker setSubject:[NSString stringWithFormat:NSLocalizedString(@"Link From %@", nil), kKMEHomeName]];
            
			//SET UP THE RECIPIENTS (or leave not set)
			//NSArray *toRecipients = [NSArray arrayWithObjects:@"first@example.com", nil];
			//[picker setToRecipients:toRecipients];
            
			//NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
			//[picker setCcRecipients:ccRecipients];
            
			//NSArray *bccRecipients = [NSArray arrayWithObjects:@"four@example.com", nil];
			//[picker setBccRecipients:bccRecipients];
            
			//CREATE EMAIL BODY TEXT
			NSString *emailBody = [NSString stringWithFormat:@"%@", [self.webView.request URL]];
			[picker setMessageBody:emailBody isHTML:YES];
            
			//PRESENT THE MAIL COMPOSITION INTERFACE
			[self presentModalViewController:picker animated:YES];
			[picker release];
			
        }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Tweet", nil)]){
            NSLog(@"Tweet Link");
            [self sendTwitterPost:[NSString stringWithFormat:@"%@", kTwitterHash]
                              url:[self.webView stringByEvaluatingJavaScriptFromString: @"window.location.href"]
                            image:nil];

		}else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Facebook", nil)]){
			NSLog(@"Post Link to Facebook");
            [self sendFacebookPost:[NSString stringWithFormat:@"%@", kTwitterHash]
                               url:[self.webView stringByEvaluatingJavaScriptFromString: @"window.location.href"]
                             image:nil];
        }else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Print", nil)]){
            NSLog(@"Print Current Page");
            [self printWebViewContents:self.webView];
        }
	}
    showingActionSheet = NO;
}


- (BOOL) sendSocialPost:(NSString*)textToPost url:(NSString*)url image:(UIImage*)image type:(NSString*)serviceType{
    BOOL result = YES;
    SLComposeViewController *mySLComposerSheet;
    mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller

    mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType]; //Tell him with what social plattform to use it, e.g. facebook or twitter
    
    [mySLComposerSheet setInitialText:textToPost]; //the message you want to post
    if(url != nil){
        [mySLComposerSheet addURL:[NSURL URLWithString:url]];
    }
    if(image != nil){
        [mySLComposerSheet addImage:image];
    }
    
    [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                NSLog(@"Post Cancelled");
                result = NO;
                break;
            case SLComposeViewControllerResultDone:
                NSLog(@"Post Successfull");
                result = YES;
                break;
            default:
                break;
        }
    }];
    return result;
}


- (BOOL) sendTwitterPost:(NSString*)textToPost url:(NSString*)url image:(UIImage*)image{
    if(SYSTEM_VERSION_GREATER_THAN(@"5.0") && SYSTEM_VERSION_LESS_THAN(@"6.0")){
        //
        // This block of code is untested as the ability to log into twitter via the simulator is busted.
        // Needs to be tested on a 5.0+ device. Though it should work. 
        //
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        [tweetViewController setInitialText:[NSString stringWithFormat:@"%@ %@", kTwitterHash, [self.webView.request URL]]];
        [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    NSLog(@"Post Cancelled");
                    result = NO;
                    break;
                case TWTweetComposeViewControllerResultDone:
                    NSLog(@"Post Successfull");
                    result = YES;
                    break;
                default:
                    break;
            }
            NSLog(@"%@", output);
            [self dismissModalViewControllerAnimated:YES];
        }];
        
    }else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        return [self sendSocialPost:textToPost
                                url:url
                              image:image
                               type:SLServiceTypeTwitter];
    }
    return NO;
}

- (BOOL) sendFacebookPost:(NSString*)textToPost url:(NSString*)url image:(UIImage*)image{
    return [self sendSocialPost:textToPost
                            url:url
                          image:image
                           type:SLServiceTypeFacebook];
}


- (BOOL) printWebViewContents:(UIWebView *)theWebView{
    NSLog(@"Print WebView Contents");
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;

    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = [theWebView stringByEvaluatingJavaScriptFromString: @"document.title"];
    pic.printInfo = printInfo;
    pic.printFormatter = [theWebView viewPrintFormatter];
    pic.showsPageRange = YES;

    UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(completed && error){
            NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
        }
    };
    if(kHeaderType == kNativeHeader){
        // if Native header, show Dialog origination from the action button at top.
        [pic presentFromBarButtonItem:self.navTitle.rightBarButtonItem animated:YES completionHandler:completionHandler];
    }else{
//        [pic presentAnimated:YES completionHandler:completionHandler];
        // if Not native header, show dialog origination from the action button at bottom.
        [pic presentFromRect:[self.safariImage bounds] inView:self.safariImage animated:YES completionHandler:completionHandler];
    }
    return YES;
}

#pragma mark - Mail Related Functions

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    
    [self dismissModalViewControllerAnimated:YES];      //Clear the compose email view controller
}

- (IBAction)doButton:(id)sender{
	self.webView.delegate = nil;
}

@end
