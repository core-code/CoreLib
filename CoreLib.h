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


#import "NSArray+CoreCode.h"
#import "NSData+CoreCode.h"
#import "NSDictionary+CoreCode.h"
#import "NSFileHandle+CoreCode.h"
#import "NSObject+CoreCode.h"
#import "NSString+CoreCode.h"
#import "NSLocale+CoreCode.h"
#import "NSDate+CoreCode.h"

// basic block types
#ifdef __BLOCKS__
typedef void (^BasicBlock)(void);
typedef void (^DoubleInBlock)(double input);
typedef void (^StringInBlock)(NSString *input);
typedef BOOL (^BoolOutBlock)(void);
typedef int (^IntInOutBlock)(int input);
typedef void (^IntInBlock)(int input);
#endif


// platform dependent convenience stuff
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
	static inline NSInteger alert(NSString *title, NSString *msgFormat, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...)
	{ [NSApp activateIgnoringOtherApps:YES]; return NSRunAlertPanel(title, msgFormat, defaultButton, alternateButton, otherButton); }
	#define _alert(format...)	(alert(format))
#else
	#define _appfile(x,y)		([[NSFileManager defaultManager] fileExistsAtPath:[_stringf(@"~/Documents/%@.%@", (x), (y)) stringByExpandingTildeInPath]] ? [_stringf(@"~/Documents/%@.%@", (x), (y)) stringByExpandingTildeInPath] : [[NSBundle mainBundle] pathForResource:(x) ofType:(y)])
#endif

// platform independent color convenience
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
	#define _color(r,g,b,a)		([NSColor colorWithCalibratedRed:(r) green:(g) blue:(b) alpha:(a)])
	#define _color255(r,g,b,a)	([NSColor colorWithCalibratedRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0])
#else
	#define _color(r,g,b,a)		([UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)])
	#define _color255(r,g,b,a)	([UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0])
#endif

// info bundle key convenience
#define _appbundleid			([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"])
#define _appbundleversion		([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"])
#define _appname				([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"])
#define _appversion				([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])

// path convenience
#define _docdir					([@"~/Documents/" stringByExpandingTildeInPath])
#define _appsuppdir				([[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:_appname])
#define _dir_contents(x)		([[NSFileManager defaultManager] contentsOfDirectoryAtPath:(x) error:NULL])
#define _dir_contents_rec(x)	([[NSFileManager defaultManager] subpathsOfDirectoryAtPath:(x) error:NULL])
#define _unique_file(file)		(unique(file))

// obj creation convenience
#define _predf(format...)		([NSPredicate predicateWithFormat:format])
#define _stringcu8(x)			((NSString *)[NSString stringWithUTF8String:x])
#define _stringf(format...)		((NSString *)[NSString stringWithFormat:format])
#define _mstringf(format...)	((NSMutableString *)[NSMutableString stringWithFormat:format])

// nsuserdefaults convenience
#define _default(key)			([[NSUserDefaults standardUserDefaults] objectForKey:key])
#define _defaults(key)			([[NSUserDefaults standardUserDefaults] stringForKey:key])
#define _defaultu(key)			([[NSUserDefaults standardUserDefaults] URLForKey:key])
#define _defaulti(key)			([[NSUserDefaults standardUserDefaults] integerForKey:key])
#define _defaultf(key)			([[NSUserDefaults standardUserDefaults] floatForKey:key])
#define _remdefault(key)		([[NSUserDefaults standardUserDefaults] removeObjectForKey:key])
#define _setdefault(o, key)		([[NSUserDefaults standardUserDefaults] setObject:o forKey:key])
#define _setdefaultu(o, key)	([[NSUserDefaults standardUserDefaults] setURL:o forKey:key])
#define _setdefaulti(i, key)	([[NSUserDefaults standardUserDefaults] setInteger:i forKey:key])
#define _setdefaultf(f, key)	([[NSUserDefaults standardUserDefaults] setFloat:f forKey:key])
#define _defaultsync			([[NSUserDefaults standardUserDefaults] synchronize])



static inline NSString * unique(NSString *filename)
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:filename])	return filename;
	else
	{
		NSString *ext = [filename pathExtension];
		NSString *namewithoutext = [filename stringByDeletingPathExtension];
		int i = 0;
		while ([[NSFileManager defaultManager] fileExistsAtPath:_stringf(@"%@-%i.%@", namewithoutext, i,ext)]) i++;
		return _stringf(@"%@-%i.%@", namewithoutext, i,ext);
	}
}

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
