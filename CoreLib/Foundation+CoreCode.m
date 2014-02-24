//
//  Foundation+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 15.03.12.
/*	Copyright (c) 2012 - 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "Foundation+CoreCode.h"
#import <objc/runtime.h>
#ifdef USE_SECURITY
	#include <CommonCrypto/CommonDigest.h>
#endif
#if ! __has_feature(objc_arc)
	#define BRIDGE
#else
	#define BRIDGE __bridge
#endif
static CONST_KEY(CoreCodeAssociatedValue)



@implementation NSArray (CoreCode)

@dynamic mutableObject, empty, set, reverseArray, string, path;

- (NSData *)JSONData
{
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:(NSJSONWritingOptions)0 error:&err];

    if (!data || err)
    {
        NSLog(@"Error: JSON write fails! input %@ data %@ err %@", self, data, err);
        return nil;
    }

    return data;
}

- (NSString *)string
{
	NSString *ret = @"";

	for (NSString *str in self)
		ret = [ret stringByAppendingString:str];

	return ret;
}

- (NSString *)path
{
	NSString *ret = @"";

	for (NSString *str in self)
		ret = [ret stringByAppendingPathComponent:str];

	return ret;
}

- (BOOL)contains:(id)object
{
	return [self indexOfObject:object] != NSNotFound;
}

- (NSArray *)reverseArray
{
	return [[self reverseObjectEnumerator] allObjects];
}

- (NSSet *)set
{
	return [NSSet setWithArray:self];
}

- (NSArray *)arrayByAddingNewObject:(id)anObject
{
	if ([self indexOfObject:anObject] == NSNotFound)
		return [self arrayByAddingObject:anObject];
	else
		return self;
}

- (NSArray *)arrayByRemovingObjectIdenticalTo:(id)anObject
{
	NSMutableArray *array = [NSMutableArray arrayWithArray:self];

	[array removeObjectIdenticalTo:anObject];

	return [NSArray arrayWithArray:array];
}

- (NSArray *)arrayByRemovingObjectsIdenticalTo:(NSArray *)objects
{
	NSMutableArray *array = [NSMutableArray arrayWithArray:self];

    for (id obj in objects)
        [array removeObjectIdenticalTo:obj];

	return [NSArray arrayWithArray:array];
}

- (NSArray *)arrayByRemovingObjectsAtIndexes:(NSIndexSet *)indexSet
{
	NSMutableArray *array = [NSMutableArray arrayWithArray:self];

	[array removeObjectsAtIndexes:indexSet];

	return [NSArray arrayWithArray:array];
}

- (NSArray *)arrayByRemovingObjectAtIndex:(NSUInteger)index
{
	NSMutableArray *array = [NSMutableArray arrayWithArray:self];

	[array removeObjectAtIndex:index];

	return [NSArray arrayWithArray:array];
}

- (NSArray *)arrayByReplacingObject:(id)anObject withObject:(id)newObject
{
	NSMutableArray *mut = self.mutableObject;

	[mut replaceObjectAtIndex:[mut indexOfObject:anObject] withObject:newObject];

	return mut.immutableObject;
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if ([self count] > index)
        return [self objectAtIndex:index];
    else
        return nil;
}

- (NSString *)safeStringAtIndex:(NSUInteger)index
{
    if ([self count] > index)
        return [self objectAtIndex:index];
    else
        return @"";
}

- (BOOL)containsDictionaryWithKey:(NSString *)key equalTo:(NSString *)value
{
	for (NSDictionary *dict in self)
		if ([[dict valueForKey:key] isEqual:value])
			return TRUE;

	return FALSE;
}

- (NSArray *)sortedArrayByKey:(NSString *)key
{
	return [self sortedArrayByKey:key ascending:YES];
}

- (NSArray *)sortedArrayByKey:(NSString *)key ascending:(BOOL)ascending
{
	NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
#if ! __has_feature(objc_arc)
	[sd autorelease];
#endif
	return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:sd]];
}

- (NSMutableArray *)mutableObject
{
	return [NSMutableArray arrayWithArray:self];
}

- (BOOL)empty
{
	return [self count] == 0;
}

- (NSArray *)mapped:(ObjectInOutBlock)block
{
    NSMutableArray *resultArray = [NSMutableArray new];

    for (id object in self)
	{
		id result = block(object);
		if (result)
			[resultArray addObject:result];
	}
#if ! __has_feature(objc_arc)
	[resultArray autorelease];
#endif

    return [NSArray arrayWithArray:resultArray];
}

- (NSInteger)collect:(ObjectInIntOutBlock)block
{
    NSInteger value = 0;

    for (id object in self)
        value += block(object);

    return value;
}

- (NSArray *)filtered:(ObjectInIntOutBlock)block
{
    NSMutableArray *resultArray = [NSMutableArray new];

    for (id object in self)
        if (block(object))
            [resultArray addObject:object];

#if ! __has_feature(objc_arc)
	[resultArray autorelease];
#endif

    return [NSArray arrayWithArray:resultArray];
}

- (void)apply:(ObjectInBlock)block								// enumerateObjectsUsingBlock:
{
    for (id object in self)
		block(object);
}

// forwards for less typing
- (NSString *)joined:(NSString *)sep							// componentsJoinedByString:
{
	return [self componentsJoinedByString:sep];
}

- (NSArray *)filteredUsingPredicateString:(NSString *)format, ...
{
	va_list args;
	va_start(args, format);
	NSPredicate *pred = [NSPredicate predicateWithFormat:format arguments:args];
	va_end(args);

	return [self filteredArrayUsingPredicate:pred];
}


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSString *)runAsTask
{
	return [self runAsTaskWithTerminationStatus:NULL];
}

- (NSString *)runAsTaskWithTerminationStatus:(NSInteger *)terminationStatus
{
	NSTask *task = [NSTask new];
	NSPipe *taskPipe = [NSPipe pipe];
	NSFileHandle *file = [taskPipe fileHandleForReading];

	[task setLaunchPath:[self objectAtIndex:0]];
	[task setStandardOutput:taskPipe];
	[task setStandardError:taskPipe];
	[task setArguments:[self subarrayWithRange:NSMakeRange(1, self.count-1)]];
	[task launch];

	NSData *data = [file readDataToEndOfFile];

	[task waitUntilExit];

	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];


	if (terminationStatus)
		(*terminationStatus) = [task terminationStatus];

#if ! __has_feature(objc_arc)
	[task release];
	[string autorelease];
#endif

	return string;
}
#endif
@end


@implementation  NSMutableArray (CoreCode)

@dynamic immutableObject;

- (NSArray *)immutableObject
{
	return [NSArray arrayWithArray:self];
}

- (void)addNewObject:(id)anObject
{
	if (anObject && [self indexOfObject:anObject] == NSNotFound)
		[self addObject:anObject];
}

- (void)addObjectSafely:(id)anObject
{
	if (anObject)
		[self addObject:anObject];
}

- (void)map:(ObjectInOutBlock)block
{
    for (NSUInteger i = 0; i < [self count]; i++)
	{
		id result = block(self[i]);

		[self replaceObjectAtIndex:i withObject:result];
	}
}

- (void)filter:(ObjectInIntOutBlock)block
{
    NSMutableIndexSet *indices = [NSMutableIndexSet new];

    for (NSUInteger i = 0; i < [self count]; i++)
	{
		int result = block(self[i]);
		if (!result)
			[indices addIndex:i];
	}


	[self removeObjectsAtIndexes:indices];

#if ! __has_feature(objc_arc)
	[indices release];
#endif
}

- (void)filterUsingPredicateString:(NSString *)format, ...
{
	va_list args;
	va_start(args, format);
	NSPredicate *pred = [NSPredicate predicateWithFormat:format arguments:args];
	va_end(args);

	[self filterUsingPredicate:pred];
}

- (void)removeFirstObject
{
	[self removeObjectAtIndex:0];
}
@end



@implementation NSData (CoreCode)

@dynamic string, hexString, mutableObject, JSONArray, JSONDictionary;

- (NSString *)string
{
	NSString *s = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
	[s autorelease];
#endif
    return s;
}

- (NSString *)hexString
{
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];

    if (!dataBuffer)
        return [NSString string];

    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];

    for (NSUInteger i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];

    return [NSString stringWithString:hexString];
}

- (NSMutableData *)mutableObject
{
	return [NSMutableData dataWithData:self];
}

- (id)JSONObject
{
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self options:(NSJSONReadingOptions)0 error:&err];

    if (!dict || err || ![dict isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: JSON read fails! input %@ dict %@ err %@", self, dict, err);
        return nil;
    }

    return dict;
}

- (NSArray *)JSONArray
{
    return [self JSONObject];
}

- (NSDictionary *)JSONDictionary
{
    return [self JSONObject];
}
@end



@implementation NSDate (CoreCode)

+ (NSDate *)dateWithString:(NSString *)dateString andFormat:(NSString *)dateFormat andLocaleIdentifier:(NSString *)localeIdentifier
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:dateFormat];
	NSLocale *l = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
	[df setLocale:l];
#if ! __has_feature(objc_arc)
	[l release];
	[df autorelease];
#endif
	return [df dateFromString:dateString];
}

+ (NSDate *)dateWithString:(NSString *)dateString andFormat:(NSString *)dateFormat
{
	return [self dateWithString:dateString andFormat:dateFormat andLocaleIdentifier:@"en_US"];
}

+ (NSDate *)dateWithPreprocessorDate:(const char *)preprocessorDateString
{
	return [self dateWithString:@(preprocessorDateString) andFormat:@"MMM d yyyy"];
}

- (NSString *)stringUsingFormat:(NSString *)dateFormat
{
    NSDateFormatter *df = [NSDateFormatter new];
	NSLocale *l = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[df setLocale:l];
    [df setDateFormat:dateFormat];
#if ! __has_feature(objc_arc)
	[l release];
	[df autorelease];
#endif
    return [df stringFromDate:self];
}

- (NSString *)stringUsingDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle
{
    NSDateFormatter *df = [NSDateFormatter new];

	[df setLocale:[NSLocale currentLocale]];
    [df setDateStyle:dateStyle];
    [df setTimeStyle:timeStyle];
#if ! __has_feature(objc_arc)
	[df autorelease];
#endif
    return [df stringFromDate:self];
}

@end


@implementation NSDateFormatter (CoreCode)

+ (NSString *)formattedTimeFromTimeInterval:(NSTimeInterval)timeInterval
{
	int minutes = (int)(timeInterval / 60);
	int seconds = (int)(timeInterval - (minutes * 60));


	if (minutes)
		return makeString(@"%im %is", minutes, seconds);
	else
		return makeString(@"%is", (int)timeInterval);
}

@end



@implementation NSDictionary (CoreCode)

@dynamic mutableObject, JSONData;

- (NSData *)JSONData
{
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:(NSJSONWritingOptions)0 error:&err];

    if (!data || err)
    {
        NSLog(@"Error: JSON write fails! input %@ data %@ err %@", self, data, err);
        return nil;
    }

    return data;
}

- (NSMutableDictionary *)mutableObject
{
	return [NSMutableDictionary dictionaryWithDictionary:self];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [super methodSignatureForSelector:@selector(valueForKey:)];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *propertyName = NSStringFromSelector(invocation.selector);
    [invocation setSelector:@selector(valueForKey:)];
    [invocation setArgument:&propertyName atIndex:2];
    [invocation invokeWithTarget:self];
}

- (NSDictionary *)dictionaryByAddingValue:(id)value forKey:(NSString *)key
{
	NSMutableDictionary *mutable = self.mutableObject;

	mutable[key] = value;

	return mutable.immutableObject;
}

@end


@implementation  NSMutableDictionary (CoreCode)

@dynamic immutableObject;

- (NSDictionary *)immutableObject
{
	return [NSDictionary dictionaryWithDictionary:self];
}
@end



@implementation NSFileHandle (CoreCode)

- (float)readFloat
{
    float ret;
    [[self readDataOfLength:sizeof(float)] getBytes:&ret length:sizeof(float)];
    return ret;
}

- (int)readInt
{
    int ret;
    [[self readDataOfLength:sizeof(int)] getBytes:&ret length:sizeof(int)];
    return ret;
}
@end



@implementation NSLocale (CoreCode)

+ (NSArray *)preferredLanguages3Letter
{
	NSDictionary *iso2LetterTo3Letter = @{@"aa" : @"aar", @"ab" : @"abk", @"ae" : @"ave", @"af" : @"afr", @"ak" : @"aka", @"am" : @"amh", @"an" : @"arg", @"ar" : @"ara", @"as" : @"asm", @"av" : @"ava", @"ay" : @"aym", @"az" : @"aze", @"ba" : @"bak", @"be" : @"bel", @"bg" : @"bul", @"bh" : @"bih", @"bi" : @"bis", @"bm" : @"bam", @"bn" : @"ben", @"bo" : @"tib", @"bo" : @"tib", @"br" : @"bre", @"bs" : @"bos", @"ca" : @"cat", @"ce" : @"che", @"ch" : @"cha", @"co" : @"cos", @"cr" : @"cre", @"cs" : @"cze", @"cs" : @"cze", @"cu" : @"chu", @"cv" : @"chv", @"cy" : @"wel", @"cy" : @"wel", @"da" : @"dan", @"de" : @"ger", @"de" : @"ger", @"dv" : @"div", @"dz" : @"dzo", @"ee" : @"ewe", @"el" : @"gre", @"el" : @"gre", @"en" : @"eng", @"eo" : @"epo", @"es" : @"spa", @"et" : @"est", @"eu" : @"baq", @"eu" : @"baq", @"fa" : @"per", @"fa" : @"per", @"ff" : @"ful", @"fi" : @"fin", @"fj" : @"fij", @"fo" : @"fao", @"fr" : @"fre", @"fr" : @"fre", @"fy" : @"fry", @"ga" : @"gle", @"gd" : @"gla", @"gl" : @"glg", @"gn" : @"grn", @"gu" : @"guj", @"gv" : @"glv", @"ha" : @"hau", @"he" : @"heb", @"hi" : @"hin", @"ho" : @"hmo", @"hr" : @"hrv", @"ht" : @"hat", @"hu" : @"hun", @"hy" : @"arm", @"hy" : @"arm", @"hz" : @"her", @"ia" : @"ina", @"id" : @"ind", @"ie" : @"ile", @"ig" : @"ibo", @"ii" : @"iii", @"ik" : @"ipk", @"io" : @"ido", @"is" : @"ice", @"is" : @"ice", @"it" : @"ita", @"iu" : @"iku", @"ja" : @"jpn", @"jv" : @"jav", @"ka" : @"geo", @"ka" : @"geo", @"kg" : @"kon", @"ki" : @"kik", @"kj" : @"kua", @"kk" : @"kaz", @"kl" : @"kal", @"km" : @"khm", @"kn" : @"kan", @"ko" : @"kor", @"kr" : @"kau", @"ks" : @"kas", @"ku" : @"kur", @"kv" : @"kom", @"kw" : @"cor", @"ky" : @"kir", @"la" : @"lat", @"lb" : @"ltz", @"lg" : @"lug", @"li" : @"lim", @"ln" : @"lin", @"lo" : @"lao", @"lt" : @"lit", @"lu" : @"lub", @"lv" : @"lav", @"mg" : @"mlg", @"mh" : @"mah", @"mi" : @"mao", @"mi" : @"mao", @"mk" : @"mac", @"mk" : @"mac", @"ml" : @"mal", @"mn" : @"mon", @"mr" : @"mar", @"ms" : @"may", @"ms" : @"may", @"mt" : @"mlt", @"my" : @"bur", @"my" : @"bur", @"na" : @"nau", @"nb" : @"nob", @"nd" : @"nde", @"ne" : @"nep", @"ng" : @"ndo", @"nl" : @"dut", @"nl" : @"dut", @"nn" : @"nno", @"no" : @"nor", @"nr" : @"nbl", @"nv" : @"nav", @"ny" : @"nya", @"oc" : @"oci", @"oj" : @"oji", @"om" : @"orm", @"or" : @"ori", @"os" : @"oss", @"pa" : @"pan", @"pi" : @"pli", @"pl" : @"pol", @"ps" : @"pus", @"pt" : @"por", @"qu" : @"que", @"rm" : @"roh", @"rn" : @"run", @"ro" : @"rum", @"ro" : @"rum", @"ru" : @"rus", @"rw" : @"kin", @"sa" : @"san", @"sc" : @"srd", @"sd" : @"snd", @"se" : @"sme", @"sg" : @"sag", @"si" : @"sin", @"sk" : @"slo", @"sk" : @"slo", @"sl" : @"slv", @"sm" : @"smo", @"sn" : @"sna", @"so" : @"som", @"sq" : @"alb", @"sq" : @"alb", @"sr" : @"srp", @"ss" : @"ssw", @"st" : @"sot", @"su" : @"sun", @"sv" : @"swe", @"sw" : @"swa", @"ta" : @"tam", @"te" : @"tel", @"tg" : @"tgk", @"th" : @"tha", @"ti" : @"tir", @"tk" : @"tuk", @"tl" : @"tgl", @"tn" : @"tsn", @"to" : @"ton", @"tr" : @"tur", @"ts" : @"tso", @"tt" : @"tat", @"tw" : @"twi", @"ty" : @"tah", @"ug" : @"uig", @"uk" : @"ukr", @"ur" : @"urd", @"uz" : @"uzb", @"ve" : @"ven", @"vi" : @"vie", @"vo" : @"vol", @"wa" : @"wln", @"wo" : @"wol", @"xh" : @"xho", @"yi" : @"yid", @"yo" : @"yor", @"za" : @"zha", @"zh" : @"chi", @"zh" : @"chi", @"zu" : @"zul"};

	NSMutableArray *tmp = [NSMutableArray new];
	for (NSString *l in [NSLocale  preferredLanguages])
		[tmp addObject:([iso2LetterTo3Letter objectForKey:l] ? [iso2LetterTo3Letter objectForKey:l] : l)];

#if ! __has_feature(objc_arc)
	[tmp autorelease];
#endif

	return [NSArray arrayWithArray:tmp];
}

@end



@implementation NSObject (CoreCode)

@dynamic associatedValue;

- (void)setAssociatedValue:(id)value forKey:(NSString *)key
{
    objc_setAssociatedObject(self, (BRIDGE const void *)(key), value, OBJC_ASSOCIATION_RETAIN);
}

- (id)associatedValueForKey:(NSString *)key
{
    return objc_getAssociatedObject(self, (BRIDGE const void *)(key));
}

- (void)setAssociatedValue:(id)value
{
    [self setAssociatedValue:value forKey:kCoreCodeAssociatedValueKey];
}

- (id)associatedValue
{
    return [self associatedValueForKey:kCoreCodeAssociatedValueKey];
}
@end



@implementation NSString (CoreCode)

@dynamic words, lines, trimmed, URL, fileURL, download, resourceURL, resourcePath, localized, defaultObject, defaultString, defaultInt, defaultFloat, defaultURL, dirContents, dirContentsRecursive, fileExists, uniqueFile, expanded, defaultArray, defaultDict, isWriteablePath, fileSize, contents, dataFromHexString, escaped, encoded, namedImage;

#ifdef USE_SECURITY
@dynamic SHA1;
#endif

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSImage *)namedImage
{
	NSImage *image = [NSImage imageNamed:self];
	return image;
}
#else
- (UIImage *)namedImage
{
	UIImage *image = [UIImage imageNamed:self];
	return image;
}
#endif

- (unsigned long long)fileSize
{
	NSDictionary *attr = [fileManager attributesOfItemAtPath:self error:NULL];
	if (!attr) return 0;
	return [[attr objectForKey:NSFileSize] unsignedLongLongValue];
}

- (BOOL)isWriteablePath
{
	if (self.fileExists)
		return NO;

	if (![@"TEST" writeToFile:self atomically:YES encoding:NSUTF8StringEncoding error:NULL])
		return NO;

	[fileManager removeItemAtPath:self error:NULL];

	return YES;
}

- (NSStringArray *)dirContents
{
	return (NSStringArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self error:NULL];
}

- (NSStringArray *)dirContentsRecursive
{
	return (NSStringArray *)[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self error:NULL];
}

- (NSString *)uniqueFile
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:self])	return self;
	else
	{
		NSString *ext = [self pathExtension];
		NSString *namewithoutext = [self stringByDeletingPathExtension];
		int i = 0;
		while ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@-%i.%@", namewithoutext, i,ext]]) i++;
		return [NSString stringWithFormat:@"%@-%i.%@", namewithoutext, i,ext];
	}
}

- (NSData *)contents
{
#if  __has_feature(objc_arc)
	return [[NSData alloc] initWithContentsOfFile:self];
#else
	return [[[NSData alloc] initWithContentsOfFile:self] autorelease];
#endif
}

- (BOOL)fileExists
{
	return [[NSFileManager defaultManager] fileExistsAtPath:self];
}

- (NSUInteger)countOccurencesOfString:(NSString *)str
{
    return [[self componentsSeparatedByString:str] count] - 1;
}

- (BOOL)contains:(NSString *)otherString
{
	return ([self rangeOfString:otherString].location != NSNotFound);
}

- (BOOL)contains:(NSString *)otherString insensitive:(BOOL)insensitive
{
	return ([self rangeOfString:otherString options:insensitive ? NSCaseInsensitiveSearch : 0].location != NSNotFound);
}

- (BOOL)containsAny:(NSArray *)otherStrings
{
	for (NSString *otherString in otherStrings)
		if ([self rangeOfString:otherString].location != NSNotFound)
			return YES;

	return NO;
}

- (NSString *)localized
{
	return NSLocalizedString(self, nil);
}

- (NSString *)resourcePath
{
	return [[NSBundle mainBundle] pathForResource:self ofType:nil];
}

- (NSURL *)resourceURL
{
	return [[NSBundle mainBundle] URLForResource:self withExtension:nil];
}

- (NSURL *)URL
{
	return [NSURL URLWithString:self];
}

- (NSURL *)fileURL
{
	return [NSURL fileURLWithPath:self];
}

- (NSString *)expanded
{
	return [self stringByExpandingTildeInPath];
}

- (NSStringArray *)words
{
	return (NSStringArray *)[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSStringArray *)lines
{
	return (NSStringArray *)[self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

- (NSString *)trimmed
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)clamp:(NSUInteger)maximumLength
{
    return (([self length] <= maximumLength) ? self : [self substringToIndex:maximumLength]);
}

- (NSString *)stringByReplacingMultipleStrings:(NSDictionary *)replacements
{
	NSString *ret = self;

	for (NSString *key in replacements)
	{
		if ([[NSNull null] isEqual:key] || [[NSNull null] isEqual:[replacements objectForKey:key]])
			continue;
		ret = [ret stringByReplacingOccurrencesOfString:key
                                             withString:[key stringByAppendingString:@"k9BBV15zFYi44YyB"]];
	}

    BOOL replaced;
    do
    {
        replaced = FALSE;
        for (NSString *key in replacements)
        {
            if ([[NSNull null] isEqual:key] || [[NSNull null] isEqual:[replacements objectForKey:key]])
                continue;
            NSString *tmp = [ret stringByReplacingOccurrencesOfString:[key stringByAppendingString:@"k9BBV15zFYi44YyB"]
														   withString:[replacements objectForKey:key]];

            if (![tmp isEqualToString:ret])
            {
                ret = tmp;
                replaced = YES;
            }
        }
    } while (replaced);

	return ret;
}

- (NSString *)titlecaseString
{
	NSString *cap = [self capitalizedString];
	NSString *res = [cap stringByReplacingMultipleStrings:@{@" A " : @" a ", @" An " : @" an ", @" And " : @" and ", @" As " : @" as ", @" At " : @" at ", @" But " : @" but ", @" By " : @" by ", @" En " : @" en ", @" For " : @" for ", @" If " : @" if ", @" In " : @" in ", @" Of " : @" of ", @" On " : @" on ", @" Or " : @" or ", @" Nor " : @" nor ", @" The " : @" the ", @" To " : @" to ", @" V " : @" v ", @" Via " : @" via ", @" Vs " : @" vs ", @" Up " : @" up ", @" It " : @" it "}];


	return res;
}

- (NSString *)propercaseString
{
	if ([self length] == 0)
		return @"";
	else if ([self length] == 1)
		return [self uppercaseString];

	return makeString(@"%@%@",
					  [[self substringToIndex:1] uppercaseString],
					  [[self substringFromIndex:1] lowercaseString]);
}

- (NSData *)download
{
	NSData *d = [[NSData alloc] initWithContentsOfURL:self.URL];
#if ! __has_feature(objc_arc)
	[d autorelease];
#endif
	return d;
}

#ifdef USE_SECURITY
- (NSString *)SHA1
{
	const char *cStr = [self UTF8String];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(cStr, (CC_LONG)strlen(cStr), result);
	NSString *s = [NSString  stringWithFormat:
				   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				   result[0], result[1], result[2], result[3], result[4],
				   result[5], result[6], result[7],
				   result[8], result[9], result[10], result[11], result[12],
				   result[13], result[14], result[15],
				   result[16], result[17], result[18], result[19]
				   ];

    return s;
}
#endif

- (NSMutableString *)mutableObject
{
	return [NSMutableString stringWithString:self];
}

- (NSString *)replaced:(NSString *)str1 with:(NSString *)str2	// stringByReplacingOccurencesOfString:withString:
{
	return [self stringByReplacingOccurrencesOfString:str1 withString:str2];
}

- (NSStringArray *)split:(NSString *)sep								// componentsSeparatedByString:
{
	return (NSStringArray *)[self componentsSeparatedByString:sep];
}

- (NSArray *)defaultArray
{
	return [[NSUserDefaults standardUserDefaults] arrayForKey:self];
}

- (void)setDefaultArray:(NSArray *)newDefault
{
	[[NSUserDefaults standardUserDefaults] setObject:newDefault forKey:self];
}

- (NSDictionary *)defaultDict
{
	return [[NSUserDefaults standardUserDefaults] dictionaryForKey:self];
}

- (void)setDefaultDict:(NSDictionary *)newDefault
{
	[[NSUserDefaults standardUserDefaults] setObject:newDefault forKey:self];
}

- (id)defaultObject
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:self];
}

- (void)setDefaultObject:(id)newDefault
{
	[[NSUserDefaults standardUserDefaults] setObject:newDefault forKey:self];
}

- (NSString *)defaultString
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:self];
}

- (void)setDefaultString:(NSString *)newDefault
{
	[[NSUserDefaults standardUserDefaults] setObject:newDefault forKey:self];
}

- (NSURL *)defaultURL
{
	return [[NSUserDefaults standardUserDefaults] URLForKey:self];
}

- (void)setDefaultURL:(NSURL *)newDefault
{
	[[NSUserDefaults standardUserDefaults] setURL:newDefault forKey:self];
}

- (NSInteger)defaultInt
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:self];
}

- (void)setDefaultInt:(NSInteger)newDefault
{
	[[NSUserDefaults standardUserDefaults] setInteger:newDefault forKey:self];
}

- (float)defaultFloat
{
	return [[NSUserDefaults standardUserDefaults] floatForKey:self];
}

- (void)setDefaultFloat:(float)newDefault
{
	[[NSUserDefaults standardUserDefaults] setFloat:newDefault forKey:self];
}

- (NSString *)stringValue
{
	return self;
}

- (NSNumber *)numberValue
{
	return @(self.doubleValue);
}

- (NSData *)dataFromHexString
{
	const char * bytes = [self cStringUsingEncoding: NSUTF8StringEncoding];
	NSUInteger length = strlen(bytes);
	unsigned char * r = (unsigned char *) malloc(length / 2 + 1);
	unsigned char * index = r;

	while ((*bytes) && (*(bytes +1)))
	{
		char encoder[3] = {'\0','\0','\0'};
		encoder[0] = *bytes;
		encoder[1] = *(bytes+1);
		*index = (char) strtol(encoder, NULL, 16);
		index++;
		bytes+=2;
	}
	*index = '\0';

	NSData *result = [NSData dataWithBytes: r length: length / 2];
	free(r);
    return result;
}

- (NSString *)escaped
{
#if  __has_feature(objc_arc)
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, NULL, kCFStringEncodingUTF8));
	return encodedString;
#else
    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, NULL, kCFStringEncodingUTF8);
	return [encodedString autorelease];
#endif
}

- (NSString *)encoded
{
#if  __has_feature(objc_arc)
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
	return encodedString;
#else
    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	return [encodedString autorelease];
#endif
}

//- (NSString *)arg:(id)arg, ...
//{
//	va_list args;
//	void *stackLocal = (__bridge void *)(arg);
//	struct __va_list_tag *stackLocal2 = stackLocal;
//    va_start(args, arg);
//
//    NSString *result = [[NSString alloc] initWithFormat:self arguments:stackLocal2];
//    va_end(args);
//
//#if ! __has_feature(objc_arc)
//	[d result];
//#endif
//	return result;
//}

@end


@implementation  NSMutableString (CoreCode)

@dynamic immutableObject;

- (NSString *)immutableObject
{
	return [NSString stringWithString:self];
}
@end



@implementation NSURL (CoreCode)

@dynamic dirContents, dirContentsRecursive, fileExists, uniqueFile, path, request, fileSize, isWriteablePath, download, contents;

- (NSURLRequest *)request
{
	return [NSURLRequest requestWithURL:self];
}

- (NSURL *)add:(NSString *)component
{
	return [self URLByAppendingPathComponent:component];
}

- (NSStringArray *)dirContents
{
	if (![self isFileURL]) return nil;
	return (NSStringArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self path] error:NULL];
}

- (NSStringArray *)dirContentsRecursive
{
	if (![self isFileURL]) return nil;
	return (NSStringArray *)[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:[self path] error:NULL];
}

- (NSURL *)uniqueFile
{
	if (![self isFileURL]) return nil;
	return [self path].uniqueFile.fileURL;
}

- (BOOL)fileExists
{
	return [self isFileURL] && [[NSFileManager defaultManager] fileExistsAtPath:[self path]];
}

- (unsigned long long)fileSize
{
	NSNumber *size;

	if ([self getResourceValue:&size forKey:NSURLFileSizeKey error:nil])
        return [size unsignedLongLongValue];
	else
		return 0;
}

- (void)open
{
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
	[[NSWorkspace sharedWorkspace] openURL:self];
#else
	[[UIApplication sharedApplication] openURL:self];
#endif
}

- (BOOL)isWriteablePath
{
	if (self.fileExists)
		return NO;

	if (![@"TEST" writeToURL:self atomically:YES encoding:NSUTF8StringEncoding error:NULL])
		return NO;

	[fileManager removeItemAtURL:self error:NULL];

	return YES;
}


- (NSData *)download
{
	NSData *d = [[NSData alloc] initWithContentsOfURL:self];
#if ! __has_feature(objc_arc)
	[d autorelease];
#endif
	return d;
}

- (NSData *)contents
{
	return self.download;
}
@end
