//
//  CoreLib.h
//  CoreLib
//
//  Created by CoreCode on 12.04.12.
/*	Copyright (c) 2015 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#ifdef __OBJC__

#ifndef CORELIB
#define CORELIB 1


#ifdef __cplusplus
extern "C"
{
#endif


// include system headers and make sure requrements are met
#if __has_feature(modules)
@import Darwin.TargetConditionals;
#else
#import <TargetConditionals.h>
#endif
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
#if __has_feature(modules)
@import Cocoa;
#else
#import <Cocoa/Cocoa.h>
#endif
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_6
#error CoreLib requires 10.6
#endif
#endif



// !!!: BASIC TYPES
typedef CGPoint CCFloatPoint;
typedef struct
{
    NSInteger x;
    NSInteger y;
} CCIntPoint;
typedef struct
{
    CGFloat min;
    CGFloat max;
    CGFloat length;
} CCFloatRange1D;
typedef struct
{
    CCFloatPoint min;
    CCFloatPoint max;
    CCFloatPoint length;
} CCFloatRange2D;
typedef struct
{
    NSInteger min;
    NSInteger max;
    NSInteger length;
} CCIntRange1D;
typedef struct
{
    CCIntPoint min;
    CCIntPoint max;
    CCIntPoint length;
} CCIntRange2D;
#ifdef __BLOCKS__
typedef void (^BasicBlock)(void);
typedef void (^DoubleInBlock)(double input);
typedef void (^StringInBlock)(NSString *input);
typedef void (^ObjectInBlock)(id input);
typedef id (^ObjectInOutBlock)(id input);
typedef int (^ObjectInIntOutBlock)(id input);
typedef float (^ObjectInFloatOutBlock)(id input);
typedef CCIntPoint (^ObjectInPointOutBlock)(id input);
typedef int (^IntInOutBlock)(int input);
typedef void (^IntInBlock)(int input);
typedef int (^IntOutBlock)(void);
#endif
#ifdef __cplusplus
#define CC_ENUM(type, name) enum class name : type
#else
#define CC_ENUM(type, name) typedef NS_ENUM(type, name)
#endif
CC_ENUM(uint8_t, openChoice)
{
	openSupportRequestMail = 1,	// VendorProductPage info.plist key
	openBetaSignupMail,			// FeedbackEmail info.plist key
	openHomepageWebsite,		// VendorProductPage info.plist key
	openAppStoreWebsite,		// StoreProductPage info.plist key
	openAppStoreApp,			// StoreProductPage info.plist key
	openMacupdateWebsite		// MacupdateProductPage info.plist key
};



// !!!: CUSTOM TEMPLATE COLLECTIONS
// lets you define custom types for collection classes that so that the compiler knows what type they return
#define CUSTOM_ARRAY(classname) \
@interface classname ## Array : NSArray \
_Pragma("GCC diagnostic push") \
_Pragma("GCC diagnostic ignored \"-Woverriding-method-mismatch\"") \
_Pragma("GCC diagnostic ignored \"-Wunused-function\"") \
+ (instancetype)arrayWithObject:(id)anObject; \
- (NSArray *)arrayByAddingObject:(classname *)anObject; \
- (BOOL)containsObject:(classname *)anObject; \
- (NSUInteger)indexOfObject:(classname *)anObject; \
- (NSUInteger)indexOfObject:(classname *)anObject inRange:(NSRange)range; \
- (NSUInteger)indexOfObjectIdenticalTo:(classname *)anObject; \
- (NSUInteger)indexOfObjectIdenticalTo:(classname *)anObject inRange:(NSRange)range; \
- (classname *)objectAtIndexedSubscript:(NSUInteger)index; \
- (classname *)firstObject; \
- (classname *)lastObject; \
@end \
static inline classname ## Array * make ## classname ## Array (void)    { return (classname ## Array *)[NSArray new];} \
_Pragma("GCC diagnostic pop")
#define CUSTOM_MUTABLE_ARRAY(classname) \
_Pragma("GCC diagnostic push") \
_Pragma("GCC diagnostic ignored \"-Woverriding-method-mismatch\"") \
_Pragma("GCC diagnostic ignored \"-Wsuper-class-method-mismatch\"") \
_Pragma("GCC diagnostic ignored \"-Wunused-function\"") \
@interface Mutable ## classname ## Array : NSMutableArray \
- (classname *)objectAtIndexedSubscript:(NSUInteger)index;\
- (void)setObject:(classname *)anObject atIndexedSubscript:(NSUInteger)index; \
- (void)addObject:(classname *)anObject; \
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index; \
- (void)removeObject:(classname *)anObject; \
- (void)removeObject:(classname *)anObject inRange:(NSRange)aRange; \
- (void)removeObjectIdenticalTo:(classname *)anObject; \
- (void)removeObjectIdenticalTo:(classname *)anObject inRange:(NSRange)aRange; \
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(classname *)anObject; \
- (classname *)firstObject; \
- (classname *)lastObject; \
@end \
static inline Mutable ## classname ## Array * make ## Mutable ## classname ## Array (void)    { return (Mutable ## classname ## Array *)[NSMutableArray new];} \
_Pragma("GCC diagnostic pop")
#define CUSTOM_DICTIONARY(classname) \
@interface classname ## Dictionary : NSDictionary \
_Pragma("GCC diagnostic push") \
_Pragma("GCC diagnostic ignored \"-Woverriding-method-mismatch\"") \
_Pragma("GCC diagnostic ignored \"-Wunused-function\"") \
- (classname *)objectForKeyedSubscript:(id)key;\
+ (instancetype)dictionaryWithObject:(classname *)anObject forKey:(id<NSCopying>)aKey; \
- (NSArray *)allKeysForObject:(classname *)anObject; \
- (classname *)objectForKey:(id)aKey; \
- (void)getObjects:(classname * __unsafe_unretained [])objects andKeys:(id __unsafe_unretained [])keys; \
@end \
static inline classname ## Dictionary * make ## classname ## Dictionary (void)    { return (classname ## Dictionary *)[NSDictionary new];} \
_Pragma("GCC diagnostic pop")
#define CUSTOM_MUTABLE_DICTIONARY(classname) \
@interface Mutable ## classname ## Dictionary : NSMutableDictionary \
_Pragma("GCC diagnostic push") \
_Pragma("GCC diagnostic ignored \"-Woverriding-method-mismatch\"") \
_Pragma("GCC diagnostic ignored \"-Wsuper-class-method-mismatch\"") \
_Pragma("GCC diagnostic ignored \"-Wunused-function\"") \
- (classname *)objectForKeyedSubscript:(id)key;\
- (void)setObject:(classname *)object forKeyedSubscript:(id < NSCopying >)aKey; \
- (void)setObject:(classname *)anObject forKey:(id < NSCopying >)aKey; \
@end \
static inline Mutable ## classname ## Dictionary * make ## Mutable ## classname ## Dictionary (void)    { return (Mutable ## classname ## Dictionary *)[NSMutableDictionary new];} \
_Pragma("GCC diagnostic pop")
CUSTOM_ARRAY(NSString)
CUSTOM_ARRAY(NSNumber)
CUSTOM_ARRAY(NSArray)
CUSTOM_ARRAY(NSURL)
CUSTOM_ARRAY(NSDictionary)
CUSTOM_ARRAY(NSMutableArray)
CUSTOM_ARRAY(NSMutableDictionary)
CUSTOM_MUTABLE_ARRAY(NSString)
CUSTOM_MUTABLE_ARRAY(NSNumber)
CUSTOM_MUTABLE_ARRAY(NSArray)
CUSTOM_MUTABLE_ARRAY(NSDictionary)
CUSTOM_MUTABLE_ARRAY(NSMutableArray)
CUSTOM_MUTABLE_ARRAY(NSMutableDictionary)
CUSTOM_DICTIONARY(NSString)
CUSTOM_DICTIONARY(NSNumber)
CUSTOM_MUTABLE_DICTIONARY(NSString)
CUSTOM_MUTABLE_DICTIONARY(NSNumber)
#define MAKE_MAKER(classname) \
static inline NS ## classname * make ## classname (void) { return (NS ## classname *)[NS ## classname new];}
MAKE_MAKER(MutableArray)
MAKE_MAKER(MutableDictionary)
MAKE_MAKER(MutableString)



// !!!: CORELIB OBJ INTERFACE
@interface CoreLib : NSObject
// info bundle key convenience
@property (readonly, nonatomic) NSString *appID;
@property (readonly, nonatomic) int appBuild;
@property (readonly, nonatomic) NSString *appVersionString;
@property (readonly, nonatomic) NSString *appName;
// path convenience
@property (readonly, nonatomic) NSString *prefsPath;
@property (readonly, nonatomic) NSString *resDir;
@property (readonly, nonatomic) NSString *docDir;
@property (readonly, nonatomic) NSString *deskDir;
@property (readonly, nonatomic) NSString *suppDir;
@property (readonly, nonatomic) NSURL *prefsURL;
@property (readonly, nonatomic) NSURL *resURL;
@property (readonly, nonatomic) NSURL *docURL;
@property (readonly, nonatomic) NSURL *deskURL;
@property (readonly, nonatomic) NSURL *suppURL;
@property (readonly, nonatomic) NSURL *homeURL;
// misc
@property (readonly, nonatomic) NSArray *appCrashLogs;
@property (readonly, nonatomic) NSString *appSHA;
- (void)openURL:(openChoice)choice;
@end



// !!!: GLOBALS
extern CoreLib *cc; // init CoreLib with: cc = [CoreLib new];
extern NSUserDefaults *userDefaults;
extern NSFileManager *fileManager;
extern NSNotificationCenter *notificationCenter;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
extern NSFontManager *fontManager;
extern NSDistributedNotificationCenter *distributedNotificationCenter;
extern NSWorkspace *workspace;
extern NSApplication *application;
extern NSProcessInfo *processInfo;
#endif



// !!!: ALERT FUNCTIONS
NSInteger alert_selection(NSString *prompt, NSArray *buttons, NSStringArray *choices, NSInteger *result); // alert with popup button for selection of choice
NSInteger alert_input(NSString *prompt, NSArray *buttons, NSString **result); // alert with text field prompting users
NSInteger alert_inputtext(NSString *prompt, NSArray *buttons, NSString **result);
NSInteger alert_inputsecure(NSString *prompt, NSArray *buttons, NSString **result);
NSInteger alert(NSString *title, NSString *message, NSString *defaultButton, NSString *alternateButton, NSString *otherButton);
NSInteger alert_apptitled(NSString *message, NSString *defaultButton, NSString *alternateButton, NSString *otherButton);
void alert_dontwarnagain_version(NSString *identifier, NSString *title, NSString *message, NSString *defaultButton, NSString *dontwarnButton)  __attribute__((nonnull (4, 5)));
void alert_dontwarnagain_ever(NSString *identifier, NSString *title, NSString *message, NSString *defaultButton, NSString *dontwarnButton) __attribute__((nonnull (4, 5)));
void alert_feedback_fatal(NSString *usermsg, NSString *details) __attribute__((noreturn));
void alert_feedback_nonfatal(NSString *usermsg, NSString *details);



// !!!: OBJECT CREATION FUNCTIONS
NSString *makeString(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
NSValue *makeRectValue(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
NSString *makeTempFolder();
NSPredicate *makePredicate(NSString *format, ...);
NSString *makeDescription(id sender, NSArray *args);
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
NSColor *makeColor(float r, float g, float b, float a);		// params from 0..1
NSColor *makeColor255(float r, float g, float b, float a);	// params from 0..255
#else
UIColor *makeColor(float r, float g, float b, float a);
UIColor *makeColor255(float r, float g, float b, float a);
#endif


// !!!: GRAND CENTRAL DISPATCH FUNCTIONS
void dispatch_after_main(float seconds, dispatch_block_t block);
void dispatch_after_back(float seconds, dispatch_block_t block);
void dispatch_async_main(dispatch_block_t block);
void dispatch_async_back(dispatch_block_t block);
void dispatch_sync_main(dispatch_block_t block);
void dispatch_sync_back(dispatch_block_t block);



// !!!: CONSTANT KEYS
#define CONST_KEY(name) \
static NSString *const k ## name ## Key = @ #name;
#define CONST_KEY_IMPLEMENTATION(name) \
NSString *const k ## name ## Key = @ #name;
#define CONST_KEY_DECLARATION(name) \
extern NSString *const k ## name ## Key;
#define CONST_KEY_ENUM(name, enumname) \
@interface enumname ## Key : NSString @property (assign, nonatomic) enumname defaultInt; @end \
enumname ## Key *const k ## name ## Key = ( enumname ## Key *) @ #name;
#define CONST_KEY_ENUM_IMPLEMENTATION(name, enumname) \
enumname ## Key *const k ## name ## Key = ( enumname ## Key *) @ #name;
#define CONST_KEY_ENUM_DECLARATION(name, enumname) \
@interface name ## Key : NSString @property (assign, nonatomic) enumname defaultInt; @end \
extern enumname ## Key *const k ## name ## Key;



// !!!: LOGGING
#include <asl.h>
void asl_NSLog(int level, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
#ifdef FORCE_LOG
    #define asl_NSLog_debug(...) asl_NSLog(ASL_LEVEL_NOTICE, __VA_ARGS__ )
#elif defined(DEBUG)
    #define asl_NSLog_debug(...) asl_NSLog(ASL_LEVEL_DEBUG, __VA_ARGS__ )
#else
	#define asl_NSLog_debug(...)
#endif
#define LOGFUNC				asl_NSLog_debug(@"%@ (%p)", @(__PRETTY_FUNCTION__), self)
#define LOGFUNCPARAM(x)		asl_NSLog_debug(@"%@ (%p) [%@]", @(__PRETTY_FUNCTION__), self, [(x) description])
#define LOGSUCC				asl_NSLog_debug(@"success %@ %d", @(__FILE__), __LINE__)
#define LOGFAIL				asl_NSLog_debug(@"failure %@ %d", @(__FILE__), __LINE__)
#define LOG(x)				asl_NSLog_debug(@"%@", [(x) description]);



// !!!: CONVENIENCE MACROS
#define PROPERTY_STR(p)		NSStringFromSelector(@selector(p))
#define OBJECT_OR(x,y)		((x) ? (x) : (y))
#define STRING_OR(x, y)		(((x) && ([x length])) ? (x) : (y))
#define VALID_STR(x)		(((x) && ([x isKindOfClass:[NSString class]])) ? (x) : @"")
#define NON_NIL_STR(x)		((x) ? (x) : @"")
#define NON_NIL_OBJ(x)		((x) ? (x) : [NSNull null])
#define IS_FLOAT_EQUAL(x,y) (fabsf((x)-(y)) < 0.0001f)
#define IS_DOUBLE_EQUAL(x,y) (fabs((x)-(y)) < 0.000001f)
#define IS_IN_RANGE(v,l,h)  (((v) >= (l)) && ((v) <= (h)))
#define CLAMP(x, low, high) (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))
#define ONCE(block)			{ static dispatch_once_t onceToken; dispatch_once(&onceToken, block); }
#define ONCE_EVERY_MINUTES(block, minutes)	{ 	static NSDate *time = nil;	if (!time || [[NSDate date] timeIntervalSinceDate:time] > (minutes * 60))	{	block();	time = [NSDate date]; } }
#define OS_IS_POST_10_6		(NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_7)
#define OS_IS_POST_10_7		(NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_8)
#define OS_IS_POST_10_8		(NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_9)
#define OS_IS_POST_10_9		(NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_10)
#define MAX3(x,y,z)			(MAX(MAX((x),(y)),(z)))
#define MIN3(x,y,z)			(MIN(MIN((x),(y)),(z)))

// log macros


// !!!: MISC MACROS
#ifndef NSAppKitVersionNumber10_6
#define NSAppKitVersionNumber10_6 1038
#endif
#ifndef NSAppKitVersionNumber10_7
#define NSAppKitVersionNumber10_7 1138
#endif
#ifndef NSAppKitVersionNumber10_8
#define NSAppKitVersionNumber10_8 1187
#endif
#ifndef NSAppKitVersionNumber10_9
#define NSAppKitVersionNumber10_9 1265
#endif
#ifndef NSAppKitVersionNumber10_10
#define NSAppKitVersionNumber10_10 1343.14
#endif
#if ! __has_feature(objc_arc)
#define BRIDGE
#else
#define BRIDGE __bridge
#endif
#ifndef __IPHONE_OS_VERSION_MIN_REQUIRED
#define __IPHONE_OS_VERSION_MIN_REQUIRED 0
#endif


// !!!: CONFIGURATION
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



// !!!: INCLUDES
#import "AppKit+CoreCode.h"
#import "Foundation+CoreCode.h"

#if ((defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED < 101000) || (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED < 90000)))
#import "AppKit+Properties.h"
#import "Foundation+Properties.h"
#endif



// !!!: UNDEFS
// this makes sure youo not compare the return values of our alert*() functions against old values and use NSLog when you should use ASL. remove as appropriate
#ifndef IMADESURENOTTOCOMPAREALERTRETURNVALUESAGAINSTOLDRETURNVALUES
    // alert() and related corelib functions previously returned old deprecated return values from NSRunAlertPanel() and friends. now they return new NSAlertFirst/..ButtonReturn values. we undefine the old return values to make sure you don't use them. if you use NSRunAlertPanel() and friends directly in your code you can set the define to prevent the errors after making sure to update return value checks of alert*()
    #define NSAlertDefaultReturn
    #define NSAlertAlternateReturn
    #define NSAlertOtherReturn
    #define NSAlertErrorReturn
    #define NSOKButton
    #define NSCancelButton
#endif
#define asl_log
#define NSLog
    
#ifdef __cplusplus
}
#endif

#endif
#endif
