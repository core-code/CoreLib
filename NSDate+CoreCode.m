//
//  NSDate+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 07.12.12.
/*	Copyright (c) 2012 - 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */



#import "NSDate+CoreCode.h"

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

