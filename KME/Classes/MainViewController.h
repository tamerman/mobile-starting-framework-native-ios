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

#import <Cordova/CDVViewController.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <AVFoundation/AVFoundation.h>
#import <Social/Social.h>


@interface MainViewController : CDVViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate, AVAudioPlayerDelegate, UIPrintInteractionControllerDelegate>{

    IBOutlet UIImageView* bezel;
    IBOutlet UIActivityIndicatorView* spinner;
    
    IBOutlet UINavigationItem* navTitle;
    IBOutlet UINavigationBar*  navBar;
    
    NSString *backURL;
    NSString *homeURL;

    IBOutlet UIImageView*	forwardImage;
    IBOutlet UIImageView*	backImage;
    IBOutlet UIImageView*	homeImage;
    IBOutlet UIImageView*	safariImage;
    
    IBOutlet UIButton* forwardButton;
    IBOutlet UIButton* backButton;
    IBOutlet UIButton* safariButton;
    IBOutlet UIButton* homeButton;
    
    
	BOOL showingActionSheet;
	UIActionSheet* safariActionSheet;
	UIActionSheet* homeActionSheet;

   	BOOL	 hasPush;
   	NSDictionary* incomingPush;
}

@property (nonatomic, retain) IBOutlet UIImageView	*bezel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, retain) IBOutlet UINavigationItem* navTitle;
@property (nonatomic, retain) IBOutlet UINavigationBar* navBar;
@property (nonatomic, retain) NSString * backURL;
@property (nonatomic, retain) NSString * homeURL;

@property (nonatomic) BOOL showingActionSheet;
@property (nonatomic, retain) UIActionSheet * safariActionSheet;
@property (nonatomic, retain) UIActionSheet * homeActionSheet;

@property (nonatomic, retain) IBOutlet UIImageView	*backImage;
@property (nonatomic, retain) IBOutlet UIImageView	*forwardImage;
@property (nonatomic, retain) IBOutlet UIImageView	*homeImage;
@property (nonatomic, retain) IBOutlet UIImageView	*safariImage;

@property (nonatomic, retain) IBOutlet UIButton	*backButton;
@property (nonatomic, retain) IBOutlet UIButton	*forwardButton;
@property (nonatomic, retain) IBOutlet UIButton	*safariButton;
@property (nonatomic, retain) IBOutlet UIButton	*homeButton;

@property BOOL hasPush;
@property (nonatomic, retain) NSDictionary * incomingPush;


- (BOOL) sendTwitterPost:(NSString*)textToPost url:(NSString*)url image:(UIImage*)image;
- (BOOL) sendFacebookPost:(NSString*)textToPost url:(NSString*)url image:(UIImage*)image;
- (BOOL) sendSocialPost:(NSString*)textToPost url:(NSString*)url image:(UIImage*)image type:(NSString*)serviceType;

- (void) showErrorPage:(NSString*)page;

- (IBAction) showActionSheet:(id)sender;

- (IBAction) goHome:(id)sender;

- (IBAction)willTouchBackButton:(id)sender;
- (IBAction)willTouchForwardButton:(id)sender;
- (IBAction)willTouchSafariButton:(id)sender;
- (IBAction)willTouchHomeButton:(id)sender;

- (IBAction) didTouchBackButton:(id)sender;
- (IBAction) didTouchForwardButton:(id)sender;

- (IBAction) didTouchSafariButton:(id)sender;
- (IBAction) didTouchHomeButton:(id)sender;
- (IBAction) didTouchSettingsButton:(id)sender;
- (IBAction) didTouchAboutButton:(id)sender;

@end
