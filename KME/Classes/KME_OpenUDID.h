//
//  KME_OpenUDID.h
//  KME
//  iOS code from https://github.com/ylechelle/OpenUDID
//
//  used by Feng, Xin on 4/2/14.
//
//

#import <Foundation/Foundation.h>

#define kOpenUDIDErrorNone          0
#define kOpenUDIDErrorOptedOut      1
#define kOpenUDIDErrorCompromised   2

@interface KME_OpenUDID : NSObject {
    
}

+ (NSString*) value;
+ (NSString*) valueWithError:(NSError**)error;
+ (void) setOptOut:(BOOL)optOutValue;

@end