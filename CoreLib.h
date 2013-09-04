//
//  CoreLib.h
//  CoreLib
//
//  Created by CoreCode on 12.04.12.
/*	Copyright (c) 2011 - 2013 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#ifdef __OBJC__

#ifndef CORELIB
#define CORELIB 1


// basic block types
#ifdef __BLOCKS__
typedef void (^BasicBlock)(void);
typedef void (^DoubleInBlock)(double input);
typedef void (^StringInBlock)(NSString *input);
typedef void (^ObjectInBlock)(id input);
typedef id (^ObjectInOutBlock)(id input);
typedef int (^ObjectInIntOutBlock)(id input);
typedef BOOL (^BoolOutBlock)(void);
typedef int (^IntInOutBlock)(int input);
typedef void (^IntInBlock)(int input);
#endif

typedef enum
{
	openSupportRequestMail = 1,	// VendorProductPage info.plist key
	openBetaSignupMail,			// FeedbackEmail info.plist key
	openHomepageWebsite,		// VendorProductPage info.plist key
	openAppStoreWebsite,		// StoreProductPage info.plist key
	openAppStoreApp,			// StoreProductPage info.plist key
	openMacupdateWebsite		// MacupdateProductPage info.plist key
} openChoice;


// CUSTOM TEMPLATE COLLECTIONS
// lets you define custom types for collection classes that so that the compiler knows what type they return
#define CUSTOM_ARRAY(classname) \
@interface classname ## Array : NSArray \
- (classname *)objectAtIndexedSubscript:(NSUInteger)index;\
@end
#define CUSTOM_MUTABLE_ARRAY(classname) \
@interface Mutable ## classname ## Array : NSMutableArray \
- (classname *)objectAtIndexedSubscript:(NSUInteger)index;\
@end
#define CUSTOM_DICTIONARY(classname) \
@interface classname ## Dictionary : NSDictionary \
- (classname *)objectForKeyedSubscript:(id)key;\
@end
#define CUSTOM_MUTABLE_DICTIONARY(classname) \
@interface Mutable ## classname ## Dictionary : NSMutableDictionary \
- (classname *)objectForKeyedSubscript:(id)key;\
@end
CUSTOM_ARRAY(NSString)
CUSTOM_ARRAY(NSNumber)
CUSTOM_MUTABLE_ARRAY(NSString)
CUSTOM_MUTABLE_ARRAY(NSNumber)
CUSTOM_DICTIONARY(NSString)
CUSTOM_DICTIONARY(NSNumber)
CUSTOM_MUTABLE_DICTIONARY(NSString)
CUSTOM_MUTABLE_DICTIONARY(NSNumber)




#import "NSArray+CoreCode.h"
#import "NSURL+CoreCode.h"
#import "NSData+CoreCode.h"
#import "NSDictionary+CoreCode.h"
#import "NSFileHandle+CoreCode.h"
#import "NSObject+CoreCode.h"
#import "NSString+CoreCode.h"
#import "NSLocale+CoreCode.h"
#import "NSDate+CoreCode.h"


@interface CoreLib : NSObject

@property (readonly, nonatomic) NSArray *appCrashLogs;

// info bundle key convenience
@property (readonly, nonatomic) NSString *appID;
@property (readonly, nonatomic) int appVersion;
@property (readonly, nonatomic) NSString *appVersionString;
@property (readonly, nonatomic) NSString *appName;

// path convenience
@property (readonly, nonatomic) NSString *resDir;
@property (readonly, nonatomic) NSString *docDir;
@property (readonly, nonatomic) NSString *suppDir;
@property (readonly, nonatomic) NSURL *resURL;
@property (readonly, nonatomic) NSURL *docURL;
@property (readonly, nonatomic) NSURL *suppURL;

#ifdef USE_SECURITY
@property (readonly, nonatomic) NSString *appSHA;
#endif

- (void)openURL:(openChoice)choice;

@end

// convenience globals for CoreLib and common words singletons
extern CoreLib *cc; // init CoreLib with: cc = [CoreLib new]; 
extern NSUserDefaults *userDefaults;
extern NSFileManager *fileManager;
extern NSNotificationCenter *notificationCenter;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
extern NSWorkspace *workspace;
#endif


// alert convenience
NSInteger input(NSString *prompt, NSArray *buttons, NSString **result); // alert with text field prompting users
void alertfeedbackfatal(NSString *usermsg, NSString *details);


// obj creation convenience
NSString *makeString(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
//NSPredicate *makePredicate(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
NSColor *makeColor(float r, float g, float b, float a);		// params from 0..1
NSColor *makeColor255(float r, float g, float b, float a);	// params from 0..255
#else
UIColor *makeColor(float r, float g, float b, float a);
UIColor *makeColor255(float r, float g, float b, float a);
#endif


// gcd convenience
void dispatch_after_main(float seconds, dispatch_block_t block);
void dispatch_after_back(float seconds, dispatch_block_t block);
void dispatch_async_main(dispatch_block_t block);
void dispatch_async_back(dispatch_block_t block);
void dispatch_sync_main(dispatch_block_t block);
void dispatch_sync_back(dispatch_block_t block);



// for easy const key generation
#define CONST_KEY(name) \
NSString *const k ## name ## Key = @ #name;

#define CONST_KEY_EXTERN(name) \
extern NSString *const k ## name ## Key;

#define CONST_KEY_CUSTOM(key, value) \
NSString *const key = @ #value;

#define CONST_KEY_CUSTOM_EXTERN(name) \
extern NSString *const name;


// logging support
#include <asl.h>
extern aslclient client;
void asl_NSLog(int level, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
void asl_NSLog_debug(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);


// old sdk support
#ifndef NSAppKitVersionNumber10_6
    #define NSAppKitVersionNumber10_6 1038
#endif
#ifndef NSAppKitVersionNumber10_7
    #define NSAppKitVersionNumber10_7 1138
#endif
#ifndef NSAppKitVersionNumber10_8
    #define NSAppKitVersionNumber10_8 1187
#endif


// convenience macros
#define LOGSUCC				NSLog(@"success")
#define LOGFAIL				NSLog(@"failure")
#define LOG(x)				NSLog(@"%@", [(x) description]);
#define OBJECT_OR(x,y)		((x) ? (x) : (y))
#define NON_NIL_STR(x)		((x) ? (x) : @"")
#define NON_NIL_OBJ(x)		((x) ? (x) : [NSNull null])
#define IS_FLOAT_EQUAL(x,y) (fabsf((x)-(y)) < 0.0001f)
#define IS_IN_RANGE(v,l,h)  (((v) >= (l)) && ((v) <= (h)))
#define CLAMP(x, low, high) (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))
#define ONCE(block)			{ static BOOL once = FALSE; if (!once) {	block();	once = TRUE; } }
#define ONCE_EVERY_MINUTES(block, minutes)	{ 	static NSDate *time = nil;	if (!time || [[NSDate date] timeIntervalSinceDate:time] > (minutes * 60))	{	block();	time = [NSDate date]; } }
#define OS_IS_POST_SNOW		(NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_7)
#define OS_IS_POST_LION		(NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_8) 
#define kUsagesThisVersionKey makeString(@"%@_usages", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define kAskedThisVersionKey makeString(@"%@_asked", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wformat-nonliteral"
static inline NSInteger alert(NSString *title, NSString *msgFormat, NSString *defaultButton, NSString *alternateButton, NSString *otherButton)
{ [NSApp activateIgnoringOtherApps:YES]; return NSRunAlertPanel(title, msgFormat, defaultButton, alternateButton, otherButton); }
static inline NSInteger alertapp(NSString *msgFormat, NSString *defaultButton, NSString *alternateButton, NSString *otherButton)
{ [NSApp activateIgnoringOtherApps:YES]; return NSRunAlertPanel(cc.appName, msgFormat, defaultButton, alternateButton, otherButton); }
#pragma GCC diagnostic pop
#endif

// vendor information
#ifdef VENDOR_HOMEPAGE
#define kVendorHomepage VENDOR_HOMEPAGE
#else
#define kVendorHomepage @"http://www.corecode.at/"
#endif
#ifdef FEEDBACK_EMAIL
#define kFeedbackEmail FEEDBACK_EMAIL
#else
#define kFeedbackEmail @"feedback@corecode.at"
#endif

#endif
#endif