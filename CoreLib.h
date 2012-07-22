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

#define $appbundleid		([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"])
#define $appname			([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"])
#define $stringcu8(x)       ([NSString stringWithUTF8String:x])
#define $stringf(format...) ([NSString stringWithFormat:format])
#define $mstringf(format...)([NSMutableString stringWithFormat:format])
#define $default(key)       ([[NSUserDefaults standardUserDefaults] objectForKey:key])
#define $defaults(key)		([[NSUserDefaults standardUserDefaults] stringForKey:key])
#define $defaultu(key)		([[NSUserDefaults standardUserDefaults] URLForKey:key])
#define $defaulti(key)      ([[NSUserDefaults standardUserDefaults] integerForKey:key])
#define $defaultf(key)      ([[NSUserDefaults standardUserDefaults] floatForKey:key])
#define $remdefault(key)    ([[NSUserDefaults standardUserDefaults] removeObjectForKey:key])
#define $setdefault(o, key) ([[NSUserDefaults standardUserDefaults] setObject:o forKey:key])
#define $setdefaultu(o, key)([[NSUserDefaults standardUserDefaults] setURL:o forKey:key])
#define $setdefaulti(i, key)([[NSUserDefaults standardUserDefaults] setInteger:i forKey:key])
#define $setdefaultf(f, key)([[NSUserDefaults standardUserDefaults] setFloat:f forKey:key])
#define $defaultsync        ([[NSUserDefaults standardUserDefaults] synchronize])
#define $color(r,g,b,a)     ([NSColor colorWithCalibratedRed:(r) green:(g) blue:(b) alpha:(a)])
#define $predf(format...)   ([NSPredicate predicateWithFormat:format])
#define $alert(format...)   ({[NSApp activateIgnoringOtherApps:YES]; NSRunAlertPanel(format);})

#define $md(dict)			([NSMutableDictionary dictionaryWithDictionary:dict])
#define $ma(array)			([NSMutableArray arrayWithArray:array])
#define $ms(str)      		([NSMutableString stringWithString:str])

// made obsolete by obj-c literals in xcode 4.4
#define $earray             ([NSArray array])
#define $emarray            ([NSMutableArray array])
#define $array(OBJS...)     ((NSArray *)([NSArray arrayWithObjects:OBJS, nil]))
#define $marray(OBJS...)    ([NSMutableArray arrayWithObjects:OBJS, nil])
#define $dict(PAIRS...)     ([NSDictionary dictionaryWithObjectsAndKeys:PAIRS, nil])
#define $mdict(PAIRS...)    ([NSMutableDictionary dictionaryWithObjectsAndKeys:PAIRS, nil])
#define $num(num)			([NSNumber numberWithFloat:num])
#define $numd(num)			([NSNumber numberWithDouble:num])
#define $numi(num)			([NSNumber numberWithInteger:num])
#define $numui(num)			([NSNumber numberWithUnsignedInt:num])

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

