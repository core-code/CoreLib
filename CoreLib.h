//
//  CoreLib.h
//  CoreLib
//
//  Created by CoreCode on 12.04.12.
/*	Copyright (c) 2011 - 2012 CoreCode
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
@end

// convenience globals for CoreLib and common words singletons
extern CoreLib *cc; // init CoreLib with: cc = [CoreLib new]; 
extern NSUserDefaults *userDefaults;
extern NSFileManager *fileManager;
extern NSNotificationCenter *notificationCenter;
extern NSDateFormatter *dateFormatter;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
extern NSWorkspace *workSpace;
#endif


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


// custom template collections: lets you define custom types for collection classes that so that the compiler knows what type they return
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
#define IS_FLOAT_EQUAL(x,y) (fabsf((x)-(y)) < 0.0001f)
#define CLAMP(x, low, high) (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))
#define OS_IS_POST_SNOW		(NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_7) 
#define OS_IS_POST_LION		(NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_8) 

#endif
#endif