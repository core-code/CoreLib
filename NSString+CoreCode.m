//
//  NSString+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 15.03.12.
/*	Copyright (c) 2012 - 2013 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "NSString+CoreCode.h"

#ifdef USE_SECURITY
#include <CommonCrypto/CommonDigest.h>
#endif

@implementation NSString (CoreCode)

@dynamic lines, trimmed, URL, fileURL, download, escapedURL, resourceURL, resourcePath, localized, defaultObj, defaultString, defaultInt, defaultFloat, defaultURL, dirContents, dirContentsRecursive, fileExists, uniqueFile, expanded, length, defaultArray, defaultDict, isWriteablePath, fileSize;
#ifdef USE_SECURITY
@dynamic SHA1;
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

- (NSArray *)dirContents
{
	return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self error:NULL];
}

- (NSArray *)dirContentsRecursive
{
	return [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self error:NULL];
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

- (NSURL *)escapedURL
{
#if  __has_feature(objc_arc)
	return [NSURL URLWithString:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, NULL, kCFStringEncodingUTF8))];
#else
	return [NSURL URLWithString:[(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, NULL, kCFStringEncodingUTF8) autorelease]];
#endif
}

- (NSURL *)fileURL
{
	return [NSURL fileURLWithPath:self];
}

- (NSString *)expanded
{
	return [self stringByExpandingTildeInPath];
}

- (NSArray *)lines
{
	return [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
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
		ret = [ret stringByReplacingOccurrencesOfString:key withString:[key stringByAppendingString:@"k9BBV15zFYi44YyB"]];
	}
	
	for (NSString *key in replacements)
	{
		if ([[NSNull null] isEqual:key] || [[NSNull null] isEqual:[replacements objectForKey:key]])
			continue;
		ret = [ret stringByReplacingOccurrencesOfString:[key stringByAppendingString:@"k9BBV15zFYi44YyB"] withString:[replacements objectForKey:key]];
	}
	
	return ret;
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

- (NSMutableString *)mutable
{
	return [NSMutableString stringWithString:self];
}

- (NSString *)replaced:(NSString *)str1 with:(NSString *)str2	// stringByReplacingOccurencesOfString:withString:
{
	return [self stringByReplacingOccurrencesOfString:str1 withString:str2];
}

- (NSArray *)split:(NSString *)sep								// componentsSeparatedByString:
{
	return [self componentsSeparatedByString:sep];
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
- (id)defaultObj
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:self];
}

- (void)setDefaultObj:(id)newDefault
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

@dynamic immutable;

- (NSString *)immutable
{
	return [NSString stringWithString:self];
}
@end
