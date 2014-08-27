//
//  CDVAudioStreamer.m
//  KME
//
//  Created by Mitchell Wagner on 11/15/12.
//
//

#import "CDVAudioStreamer.h"

@implementation CDVAudioStreamer
@synthesize streamer;

//- (void)setStreamURL:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
//    NSLog(@"CDVAudioStreamer.setStreamURL was called");
//    NSLog(@"Arguments  : %@", [arguments description]);
//    NSLog(@"Options  : %@", [options description]);
//
//    
//    NSString* callbackID = [arguments pop];
//    NSString* jsString;
//    CDVPluginResult* result;    
//    
//    NSString *escapedValue =
//    [(NSString *)CFURLCreateStringByAddingPercentEscapes(nil,
//                                                         (CFStringRef)[options objectForKey:@"url"],
//                                                         NULL,
//                                                         NULL,
//                                                         kCFStringEncodingUTF8) autorelease];
//    
//	NSURL *url = [NSURL URLWithString:escapedValue];
//
//    @try{
//        // If running, kill it.
//        if (streamer){
//            [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                            name:ASStatusChangedNotification
//                                                          object:streamer];
//            
//            [streamer stop];
//            [streamer release];
//            streamer = nil;
//        }
//
//        streamer = [[AudioStreamer alloc] initWithURL:url];
//
//        // explicitly set type, since AudioStreamer currently doesn't check streams mime-type automatically. 
//        if([[options objectForKey:@"type"] isEqualToString:@"mp3"]){
//            [streamer setFileExtension:@"mp3"];
//        }else if([[options objectForKey:@"type"] isEqualToString:@"shoutcast"] || [[options objectForKey:@"type"] isEqualToString:@""]){
//            // Streamer Handles Shoutcast easily by default. No need to set file extension.
//        }
//
//        if([[options objectForKey:@"autoplay"] intValue]){
//            [streamer start];
//        }
//
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//        jsString = [result toSuccessCallbackString:callbackID];
//        [self writeJavascript:jsString];
//    }@catch (NSException* e) {
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:[e reason]];
//        jsString = [result toErrorCallbackString:callbackID];
//        [self writeJavascript:jsString];
//    }
//}

- (void)playStream:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSLog(@"Play Args: %@", [arguments description]);
    NSLog(@"Play Opts: %@", [options description]);

    

    
    
    NSString* callbackID = [arguments pop];
    NSString* jsString;
    CDVPluginResult* result;
    
    NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(nil,
                                                         (CFStringRef)[options objectForKey:@"url"],
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8) autorelease];
    
	NSURL *url = [NSURL URLWithString:escapedValue];
    
    @try{
        // If running, kill it.
        if (streamer){
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:ASStatusChangedNotification
                                                          object:streamer];
            
            [streamer stop];
            [streamer release];
            streamer = nil;
        }
        
        streamer = [[AudioStreamer alloc] initWithURL:url];
        
        // explicitly set type, since AudioStreamer currently doesn't check streams mime-type automatically.
        if([[options objectForKey:@"type"] isEqualToString:@"mp3"]){
            [streamer setFileExtension:@"mp3"];
        }else if([[options objectForKey:@"type"] isEqualToString:@"shoutcast"] || [[options objectForKey:@"type"] isEqualToString:@""]){
            // Streamer Handles Shoutcast easily by default. No need to set file extension.
        }
        
        if([[options objectForKey:@"autoplay"] intValue]){
            [streamer start];
        }
        
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        jsString = [result toSuccessCallbackString:callbackID];
        [self writeJavascript:jsString];
    }@catch (NSException* e) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:[e reason]];
        jsString = [result toErrorCallbackString:callbackID];
        [self writeJavascript:jsString];
    }
    
    
//    NSLog(@"CDVAudioStreamer.playStream was called");
//    NSString* callbackID = [arguments pop];
//    NSString* jsString;
//    CDVPluginResult* result;
    
//    if([streamer isPaused] || [streamer isIdle]){
//        [streamer start];
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//        jsString = [result toSuccessCallbackString:callbackID];
//        [self writeJavascript:jsString];
//    }else{
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:@"Was Unable to Play"];
//        jsString = [result toErrorCallbackString:callbackID];
//        [self writeJavascript:jsString];
//    }
}

- (void)pauseStream:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSLog(@"CDVAudioStreamer.pauseStream was called");
    NSString* callbackID = [arguments pop];
    NSString* jsString;
    CDVPluginResult* result;
    @try{
        if([streamer isPlaying]){
            [streamer pause];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            jsString = [result toSuccessCallbackString:callbackID];
        }else{
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:@"Unable to Pause"];
            jsString = [result toSuccessCallbackString:callbackID];
        }
    }@catch(NSException* e){
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:[e reason]];
        jsString = [result toErrorCallbackString:callbackID];
    }@finally{
        [self writeJavascript:jsString];
    }

}

//- (void)toggleStream:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
//    NSLog(@"CDVAudioStreamer.pauseStream was called");
//    NSString* callbackID = [arguments pop];
//    NSString* jsString;
//    CDVPluginResult* result;
//    @try{
//        if([streamer isPlaying]){
//            [streamer pause];
//            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"paused"];
//            jsString = [result toSuccessCallbackString:callbackID];
//        }else if([streamer isPaused]){
//            [streamer start];
//            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"playing"];
//            jsString = [result toSuccessCallbackString:callbackID];
//        }
//    }@catch(NSException* e){
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:[e reason]];
//        jsString = [result toErrorCallbackString:callbackID];
//    }@finally{
//        [self writeJavascript:jsString];
//    }
//}


- (void)stopStream:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSLog(@"CDVAudioStreamer.stopStream was called");
    NSString* callbackID = [arguments pop];
    NSString* jsString;
    CDVPluginResult* result;
    @try{
        [streamer stop];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        jsString = [result toSuccessCallbackString:callbackID];
    }@catch(NSException* e){
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:@"Unable to Stop"];
        jsString = [result toErrorCallbackString:callbackID];
    }@finally{
        [self writeJavascript:jsString];
    }
    
}

@end
