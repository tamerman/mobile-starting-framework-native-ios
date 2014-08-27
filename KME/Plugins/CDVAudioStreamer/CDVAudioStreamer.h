//
//  CDVAudioStreamer.h
//  KME
//
//  Created by Mitchell Wagner on 11/15/12.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "AudioStreamer.h"

@interface CDVAudioStreamer : CDVPlugin{
}

@property (nonatomic, strong) AudioStreamer* streamer;

//- (void)setStreamURL:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)playStream:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)pauseStream:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)stopStream:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
//- (void)toggleStream:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@end
