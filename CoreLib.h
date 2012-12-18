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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wvariadic-macros"
#pragma clang diagnostic ignored "-Wformat-nonliteral"

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

@end


extern CoreLib *cc;

// platform independent color convenience
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
	#define _color(r,g,b,a)		([NSColor colorWithCalibratedRed:(r) green:(g) blue:(b) alpha:(a)])
	#define _color255(r,g,b,a)	([NSColor colorWithCalibratedRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0])
#else
	#define _color(r,g,b,a)		([UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)])
	#define _color255(r,g,b,a)	([UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0])
#endif


// obj creation convenience
#define _predf(format...)		([NSPredicate predicateWithFormat:format])
#define _stringf(format...)		((NSString *)[NSString stringWithFormat:format])
#define _mstringf(format...)	((NSMutableString *)[NSMutableString stringWithFormat:format])


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

#define CONST_KEY_CUSTOM(key, value) \
NSString *const key = @ #value;


// logging support
#include <asl.h>
extern aslclient client;
#define asl_NSLog(level, format, ...) asl_log(client, NULL, level, "%s", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#ifdef DEBUG
	#define asl_NSLog_debug(format, ...) asl_log(client, NULL, ASL_LEVEL_DEBUG, "%s", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
	#define asl_NSLog_debug(format, ...) 
#endif


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


#pragma clang diagnostic pop

#endif