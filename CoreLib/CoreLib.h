//
//  CoreLib.h
//  CoreLib
//
//  Created by CoreCode on 12.04.12.
/*	Copyright © 2020 CoreCode Limited
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
@import Darwin.Availability;
#else
#import <TargetConditionals.h>
#import <Availability.h>
#endif

#if ! __has_feature(objc_arc) // this is hit even when including corelib in the PCH and any file in the project - maybe not even using corelib - still uses manual retain count, so its a warning and not an error
    #warning CoreLib > 1.13 does not support manual reference counting anymore
#endif
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
#if __has_feature(modules)
    @import Cocoa;
#else
    #import <Cocoa/Cocoa.h>
#endif
#if defined(MAC_OS_X_VERSION_MIN_REQUIRED) && MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_13
    #error CoreLib only deploys back to Mac OS X 10.13
#endif
#endif

#if defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE
#if __has_feature(modules)
    @import UIKit;
#else
    #import <UIKit/UIKit.h>
#endif
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
    #error CoreLib only deploys back to iOS 8
#endif
#endif



// !!!: BASIC TYPES
typedef CGPoint CCFloatPoint;
typedef struct { NSInteger x; NSInteger y; } CCIntPoint;
typedef struct { CGFloat min; CGFloat max; CGFloat length; } CCFloatRange1D;
typedef struct { CCFloatPoint min; CCFloatPoint max; CCFloatPoint length; } CCFloatRange2D;
typedef struct { NSInteger min; NSInteger max; NSInteger length; } CCIntRange1D;
typedef struct { CCIntPoint min; CCIntPoint max; CCIntPoint length; } CCIntRange2D;
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

@protocol CoreLibAppDelegate
@optional
- (NSString *)customSupportRequestAppName;
- (NSString *)customSupportRequestLicense;
@end

#define MAKE_MAKER(classname) \
static inline NS ## classname * make ## classname (void) { return (NS ## classname *)[NS ## classname new];}
MAKE_MAKER(MutableArray)
MAKE_MAKER(MutableDictionary)
MAKE_MAKER(MutableIndexSet)
MAKE_MAKER(MutableString)
MAKE_MAKER(MutableSet)


// !!!: CORELIB OBJ INTERFACE
@interface CoreLib : NSObject
// info bundle key convenience
@property (readonly, nonatomic) NSString *appBundleIdentifier;
@property (readonly, nonatomic) int appBuildNumber;
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
@property (readonly, nonatomic) NSURL *homeURLInsideSandbox;
@property (readonly, nonatomic) NSURL *homeURLOutsideSandbox;
// misc
@property (readonly, nonatomic) NSArray <NSString *>*appCrashLogFilenames;
@property (readonly, nonatomic) NSArray <NSString *>*appCrashLogs;
@property (readonly, nonatomic) NSString *appChecksumSHA;
@property (readonly, nonatomic) NSString *appChecksumIncludingFrameworksSHA;

- (void)openURL:(openChoice)choice;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (void)sendSupportRequestMail:(NSString *)text;
#endif
@end

@interface FakeAlertWindow : NSWindow
@end



// !!!: GLOBALS
extern CoreLib *cc; // init CoreLib with: cc = [CoreLib new];
extern NSUserDefaults *userDefaults;
extern NSFileManager *fileManager;
extern NSNotificationCenter *notificationCenter;
extern NSBundle *bundle;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
extern NSFontManager *fontManager;
extern NSDistributedNotificationCenter *distributedNotificationCenter;
extern NSWorkspace *workspace;
extern NSApplication *application;
extern NSProcessInfo *processInfo;
#endif



// !!!: ALERT FUNCTIONS
NSInteger alert_selection_popup(NSString *prompt, NSArray<NSString *> *choices, NSArray<NSString *> *buttons, NSUInteger *result);	// alert with popup button for selection of choice
NSInteger alert_selection_matrix(NSString *prompt, NSArray<NSString *> *choices, NSArray<NSString *> *buttons, NSUInteger *result);  // alert with radiobutton matrix for selection of choice
NSInteger alert_input(NSString *title, NSArray *buttons, NSString **result); // alert with text field prompting users
NSInteger alert_inputtext(NSString *title, NSArray *buttons, NSString **result); // alert with large text view prompting users
NSInteger alert_checkbox(NSString *title, NSString *message, NSArray <NSString *>*buttons, NSString *checkboxTitle, NSUInteger *checkboxStatus); // alert with a single checkbox
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
NSInteger alert_colorwell(NSString *prompt, NSArray <NSString *>*buttons, NSColor **selectedColor); // alert with a colorwell for choosing colors
NSInteger alert_customicon(NSString *title, NSString *message, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSImage *customIcon);
#endif
NSInteger alert_inputsecure(NSString *prompt, NSArray *buttons, NSString **result);
NSInteger alert_outputtext(NSString *message, NSArray *buttons, NSString *text);
NSInteger alert_apptitled(NSString *message, NSString *defaultButton, NSString *alternateButton, NSString *otherButton);
NSInteger alert(NSString *title, NSString *message, NSString *defaultButton, NSString *alternateButton, NSString *otherButton);
void alert_dontwarnagain_version(NSString *identifier, NSString *title, NSString *message, NSString *defaultButton, NSString *dontwarnButton)  __attribute__((nonnull (4, 5)));
void alert_dontwarnagain_ever(NSString *identifier, NSString *title, NSString *message, NSString *defaultButton, NSString *dontwarnButton) __attribute__((nonnull (4, 5)));
NSInteger _alert_dontwarnagain_prefs(NSString *identifier, NSString *title, NSString *message, NSString *defaultButton, NSString *alternateButton, NSString *dontwarnButton);
void alert_feedback_fatal(NSString *usermsg, NSString *details) __attribute__((noreturn));
void alert_feedback_nonfatal(NSString *usermsg, NSString *details);
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
void alert_nonmodal(NSString *title, NSString *message, NSString *button);
void alert_nonmodal_customicon(NSString *title, NSString *message, NSString *button, NSImage *customIcon);
void alert_nonmodal_customicon_block(NSString *title, NSString *message, NSString *button, NSImage *customIcon, BasicBlock block);
void alert_nonmodal_checkbox(NSString *title, NSString *message, NSString *button, NSString *checkboxTitle, NSInteger checkboxStatusIn, IntInBlock resultBlock);
#endif

    
// !!!: OBJECT CREATION FUNCTIONS
NSString *makeString(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
NSString *makeLocalizedString(NSString *format, ...)  NS_FORMAT_FUNCTION(1,2);
    
NSValue *makeRectValue(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
NSString *makeTempDirectory(void);
NSString *makeTempFilepath(NSString *extension);
NSPredicate *makePredicate(NSString *format, ...);
NSString *makeDescription(NSObject *sender, NSArray *args);
#define makeDictionaryOfVariables(...) _makeDictionaryOfVariables(@"" # __VA_ARGS__, __VA_ARGS__, nil) // like NSDictionaryOfVariableBindings() but safe in case of nil values
NSDictionary<NSString *, id> * _makeDictionaryOfVariables(NSString * commaSeparatedKeysString, id firstValue, ...); // not for direct use
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
NSColor *makeColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a);		// params from 0..1
NSColor *makeColor255(CGFloat r, CGFloat g, CGFloat b, CGFloat a);	// params from 0..255
#else
UIColor *makeColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a);
UIColor *makeColor255(CGFloat r, CGFloat g, CGFloat b, CGFloat a);
#endif
CGFloat generateRandomFloatBetween(CGFloat a, CGFloat b);
int generateRandomIntBetween(int a, int b);



// !!!: GRAND CENTRAL DISPATCH FUNCTIONS
void dispatch_after_main(float seconds, dispatch_block_t block);
void dispatch_after_back(float seconds, dispatch_block_t block);
void dispatch_async_main(dispatch_block_t block);
void dispatch_async_back(dispatch_block_t block);
void dispatch_sync_main(dispatch_block_t block);
void dispatch_sync_back(dispatch_block_t block);
BOOL dispatch_sync_back_timeout(dispatch_block_t block, float timeoutSeconds); // returns 0 on succ
id dispatch_async_to_sync(BasicBlock block);



// !!!: CONSTANT KEYS
#define CONST_KEY(name) \
static NSString *const k ## name ## Key = @ #name;
#define CONST_KEY_IMPLEMENTATION(name) \
NSString *const k ## name ## Key = @ #name;
#define CONST_KEY_DECLARATION(name) \
extern NSString *const k ## name ## Key;
#define CONST_KEY_ENUM(name, enumname) \
@interface name ## Key : NSString @property (assign, nonatomic) enumname defaultInt; @end \
static name ## Key *const k ## name ## Key = ( name ## Key *) @ #name;
#define CONST_KEY_ENUM_IMPLEMENTATION(name, enumname) \
name ## Key *const k ## name ## Key = ( name ## Key *) @ #name;
#define CONST_KEY_ENUM_DECLARATION(name, enumname) \
@interface name ## Key : NSString @property (assign, nonatomic) enumname defaultInt; @end \
extern name ## Key *const k ## name ## Key;

    
// !!!: LOGGING
typedef NS_ENUM(uint8_t, cc_log_type)
{
    CC_LOG_LEVEL_DEBUG   = 7,
    CC_LOG_LEVEL_DEFAULT = 5,
    CC_LOG_LEVEL_ERROR   = 3,
    CC_LOG_LEVEL_FAULT   = 0,
};

void log_to_prefs(NSString *string);
void cc_log_enablecapturetofile(NSURL *fileURL, unsigned long long sizeLimit, cc_log_type minimumLogType);
void cc_defaults_addtoarray(NSString *key, NSObject *entry, NSUInteger maximumEntries);



void cc_log_level(cc_log_type level, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
#ifdef FORCE_LOG
#define cc_log_debug(...)     cc_log_level(CC_LOG_LEVEL_DEFAULT, __VA_ARGS__)
#elif defined(DEBUG) && !defined(FORCE_NOLOG)
#define cc_log_debug(...)     cc_log_level(CC_LOG_LEVEL_DEBUG, __VA_ARGS__)
#else
#define cc_log_debug(...)
#endif
#define cc_log(...)           cc_log_level(CC_LOG_LEVEL_DEFAULT, __VA_ARGS__)
#define cc_log_error(...)     cc_log_level(CC_LOG_LEVEL_ERROR, __VA_ARGS__)
#define cc_log_emerg(...)     cc_log_level(CC_LOG_LEVEL_FAULT, __VA_ARGS__)

#define LOGFUNCA				cc_log_debug(@"%@ %@ (%p)", self.undoManager.isUndoing ? @"UNDOACTION" : (self.undoManager.isRedoing ? @"REDOACTION" : @"ACTION"), @(__PRETTY_FUNCTION__), (__bridge void *)self);
#define LOGFUNC					cc_log_debug(@"%@ (%p)", @(__PRETTY_FUNCTION__), (__bridge void *)self);
#define LOGFUNCPARAMA(x)		cc_log_debug(@"%@ %@ (%p) [%@]", self.undoManager.isUndoing ? @"UNDOACTION" : (self.undoManager.isRedoing ? @"REDOACTION" : @"ACTION"), @(__PRETTY_FUNCTION__), (__bridge void *)self, [(x) description]);
#define LOGFUNCPARAM(x)			cc_log_debug(@"%@ (%p) [%@]", @(__PRETTY_FUNCTION__), (__bridge void *)self, [(NSObject *)(x) description]);
#define LOGSUCC					cc_log_debug(@"success %@ %d", @(__FILE__), __LINE__);
#define LOGFAIL					cc_log_debug(@"failure %@ %d", @(__FILE__), __LINE__);
#define LOG(x)					cc_log_debug(@"%@", [(x) description]);

    
// !!!: ASSERTION MACROS
#ifdef CUSTOM_ASSERT_FUNCTION   // allows clients to get more info about failures, just def CUSTOM_ASSERT_FUNCTION to a function that sends the string home
    void CUSTOM_ASSERT_FUNCTION(NSString * text);
#define assert_custom(e) (__builtin_expect(!(e), 0) ? CUSTOM_ASSERT_FUNCTION(makeString(@"%@ %@ %i %@", @(__func__), @(__FILE__), __LINE__, @(#e))) : (void)0)
#define assert_custom_info(e, i) (__builtin_expect(!(e), 0) ? CUSTOM_ASSERT_FUNCTION(makeString(@"%@ %@ %i %@  info: %@", @(__func__), @(__FILE__), __LINE__, @(#e), i)) : (void)0)
#else
#define assert_custom(e) assert(e)
#define assert_custom_info(e, i) assert(((e) || ((e) && (i))))
#endif
#define ASSERT_MAINTHREAD       assert_custom_info([NSThread currentThread] == [NSThread mainThread], makeString(@"main thread violation: %@", [NSThread.callStackSymbols joined:@"|"]))
#define ASSERT_BACKTHREAD       assert_custom_info([NSThread currentThread] != [NSThread mainThread], makeString(@"back thread violation: %@", [NSThread.callStackSymbols joined:@"|"]))


// !!!: CONVENIENCE MACROS
#define PROPERTY_STR(p)			NSStringFromSelector(@selector(p))
#define OBJECT_OR(x,y)			((x) ? (x) : (y))
#define STRING_OR(x, y)			(((x) && ([x isKindOfClass:[NSString class]]) && ([((NSString *)x) length])) ? (x) : (y))
#define VALID_STR(x)			(((x) && ([x isKindOfClass:[NSString class]])) ? (x) : @"")
#define NON_NIL_STR(x)			((x) ? (x) : @"")
#define NON_NIL_ARR(x)			((x) ? (x) : @[])
#define NON_NIL_NUM(x)          ((x) ? (x) : @(0))
#define NON_NIL_OBJ(x)			((x) ? (x) : [NSNull null])
#define NON_NSNULL_OBJ(x)       (([[NSNull null] isEqual:(x)]) ? nil : (x))
#define IS_FLOAT_EQUAL(x,y)		(fabsf((x)-(y)) < 0.0001f)
#define IS_DOUBLE_EQUAL(x,y)	(fabs((x)-(y)) < 0.000001)
#define IS_IN_RANGE(v,l,h)		(((v) >= (l)) && ((v) <= (h)))
#define CLAMP(x, low, high)		(((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))
#define ONCE_PER_FUNCTION(b)	{ static dispatch_once_t onceToken; dispatch_once(&onceToken, b); }
#define ONCE_PER_OBJECT(o,b)	@synchronized(o){ static dispatch_once_t onceToken; NSNumber *tokenNumber = [o associatedValueForKey:o.id]; onceToken = tokenNumber.longValue; dispatch_once(&onceToken, b); [o setAssociatedValue:@(onceToken) forKey:o.id]; }
#define ONCE_EVERY_MINUTES(b,m)	{ static NSDate *time = nil; if (!time || [[NSDate date] timeIntervalSinceDate:time] > (m * 60)) { b(); time = [NSDate date]; }}
#define RANDOM_INIT             {srandom((unsigned)time(0));}
#define RANDOM_FLOAT(a,b)       ((a) + ((b) - (a)) * (random() / (CGFloat) RAND_MAX))
#define RANDOM_INT(a,b)         ((int)((a) + ((b) - (a) + 1) * (random() / (CGFloat) RAND_MAX)))        // this is INCLUSIVE; a and b will be part of the results
#define OBJECT_OR3(x,y,z)       OBJECT_OR((x),OBJECT_OR((y),(z)))
#define STRING_OR3(x,y,z)       STRING_OR((x),STRING_OR((y),(z)))
#define MAX3(x,y,z)				(MAX(MAX((x),(y)),(z)))
#define MIN3(x,y,z)				(MIN(MIN((x),(y)),(z)))
#define BYTES_TO_KB(x)			((double)(x) / (1024.0))
#define BYTES_TO_MB(x)			((double)(x) / (1024.0 * 1024.0))
#define BYTES_TO_GB(x)			((double)(x) / (1024.0 * 1024.0 * 1024.0))
#define KB_TO_BYTES(x)			((x) * (1024))
#define MB_TO_BYTES(x)			((x) * (1024 * 1024))
#define GB_TO_BYTES(x)			((x) * (1024 * 1024 * 1024))
#define BYTES_TO_KB_NEW(x)      ((double)(x) / (1000.0))
#define BYTES_TO_MB_NEW(x)      ((double)(x) / (1000.0 * 1000.0))
#define BYTES_TO_GB_NEW(x)      ((double)(x) / (1000.0 * 1000.0 * 1000.0))
#define KB_TO_BYTES_NEW(x)      ((x) * (1000))
#define MB_TO_BYTES_NEW(x)      ((x) * (1000 * 1000))
#define GB_TO_BYTES_NEW(x)      ((x) * (1000 * 1000 * 1000))
#define SECONDS_PER_MINUTES(x)  ((x) * 60)
#define SECONDS_PER_HOURS(x)    (SECONDS_PER_MINUTES((x)) * 60)
#define SECONDS_PER_DAYS(x)     (SECONDS_PER_HOURS((x)) * 24)
#define SECONDS_PER_WEEKS(x)    (SECONDS_PER_DAYS((x)) * 7)

    
// !!!: SWIFTY VAR & LET SUPPORT
#define var __auto_type
#define let const __auto_type


// !!!: CONFIGURATION
#ifdef VENDOR_HOMEPAGE
#define kVendorHomepage VENDOR_HOMEPAGE
#else
#define kVendorHomepage @"https://www.corecode.io/"
#endif
#ifdef FEEDBACK_EMAIL
#define kFeedbackEmail FEEDBACK_EMAIL
#else
#define kFeedbackEmail @"feedback@corecode.io"
#endif
#define kExceptionInformationKey @"corelib_exception_info"


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
#ifndef DISABLELOGGINGIMPLEMENTATION
    #define asl_log
    #define asl_NSLog_debug
    #define NSLog
    #define os_log
    #define os_log_info
    #define os_log_debug
    #define os_log_error
    #define os_log_fault
#endif

#ifdef __cplusplus
}
#endif

#endif
#endif


// !!!: INCLUDES
#import "AppKit+CoreCode.h"
#import "Foundation+CoreCode.h"
