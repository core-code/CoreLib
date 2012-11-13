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

#ifdef __BLOCKS__
typedef void (^BasicBlock)(void);
typedef void (^DoubleInBlock)(double input);
typedef void (^StringInBlock)(NSString *input);
typedef BOOL (^BoolOutBlock)(void);
typedef int (^IntInOutBlock)(int input);
typedef void (^IntInBlock)(int input);

#import "NSString+CoreCode.h"
#endif




#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
	static inline NSInteger alert(NSString *title, NSString *msgFormat, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...)
{[NSApp activateIgnoringOtherApps:YES]; return NSRunAlertPanel(title, msgFormat, defaultButton, alternateButton, otherButton);}
	#define _alert(format...)		(alert(format))
	#define _color(r,g,b,a)			([NSColor colorWithCalibratedRed:(r) green:(g) blue:(b) alpha:(a)])
	#define _color255(r,g,b,a)		([NSColor colorWithCalibratedRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0])
#else
	#define _color(r,g,b,a)			([UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)])
	#define _color255(r,g,b,a)		([UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0])
	#define _appfile(x,y)			([[NSFileManager defaultManager] fileExistsAtPath:[_stringf(@"~/Documents/%@.%@", (x), (y)) stringByExpandingTildeInPath]] ? [_stringf(@"~/Documents/%@.%@", (x), (y)) stringByExpandingTildeInPath] : [[NSBundle mainBundle] pathForResource:(x) ofType:(y)])
#endif

#define _appbundleid			([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"])
#define _appname				([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"])

#define _docdir					([@"~/Documents/" stringByExpandingTildeInPath])
#define _appsuppdir				([[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:_appname])

#define _dir_contents(x)		([[NSFileManager defaultManager] contentsOfDirectoryAtPath:(x) error:NULL])
#define _dir_contents_rec(x)	([[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dstPath error:NULL])
#define _unique_file(file)	(unique(file))

#define _url(x)					((NSURL *)[NSURL URLWithString:(x)])
#define _stringcu8(x)			((NSString *)[NSString stringWithUTF8String:x])
#define _stringf(format...)		((NSString *)[NSString stringWithFormat:format])
#define _mstringf(format...)	((NSMutableString *)[NSMutableString stringWithFormat:format])
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
#define _predf(format...)		([NSPredicate predicateWithFormat:format])

#define _md(dict)				((NSMutableDictionary *)[NSMutableDictionary dictionaryWithDictionary:dict])
#define _ma(array)				((NSMutableArray *)[NSMutableArray arrayWithArray:array])
#define _ms(str)				((NSMutableString *)[NSMutableString stringWithString:str])
#define _d(dict)				((NSDictionary *)[NSDictionary dictionaryWithDictionary:dict])
#define _a(array)				((NSArray *)[NSArray arrayWithArray:array])
#define _s(str)					((NSString *)[NSString stringWithString:str])

#define _object_or(x,y)			((x) ? (x) : (y))
#define _non_nil_str(x)			((x) ? (x) : @"")
#define _logsuc					NSLog(@"success")
#define _logfail				NSLog(@"failure")
#define _log(x)					NSLog(@"%@", [(x) description]);



static inline NSString * unique(NSString *filename)
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
		return filename;
	else
	{
		int i = 0;
		
		while ([[NSFileManager defaultManager] fileExistsAtPath:_stringf(@"%@-%i", filename, i)]) i++;
		
		return _stringf(@"%@-%i", filename, i);
	}
}
#endif

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



#include <asl.h>

extern aslclient client;

#define asl_NSLog(level, format, ...) asl_log(client, NULL, level, "%s", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])

#ifdef DEBUG
	#define asl_NSLog_debug(format, ...) asl_log(client, NULL, ASL_LEVEL_DEBUG, "%s", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
	#define asl_NSLog_debug(format, ...) 
#endif



#ifndef NSAppKitVersionNumber10_6
    #define NSAppKitVersionNumber10_6 1038
#endif
#ifndef NSAppKitVersionNumber10_7
    #define NSAppKitVersionNumber10_7 1138
#endif
#ifndef NSAppKitVersionNumber10_8
    #define NSAppKitVersionNumber10_8 1187
#endif

#define IS_FLOAT_EQUAL(x,y) (fabsf((x)-(y)) < 0.0001f)
#define CLAMP(x, low, high) (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

#define OS_IS_POST_SNOW		(NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_7) 
#define OS_IS_POST_LION		(NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_8) 
#define USING_SANDBOX		(OS_IS_POST_SNOW) && (SANDBOX)


