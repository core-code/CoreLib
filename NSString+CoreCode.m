//
//  NSString+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 15.03.12.
/*	Copyright (c) 2012 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "NSString+CoreCode.h"


@implementation NSString (CoreCode)

- (BOOL)contains:(NSString *)otherString
{
	return ([self rangeOfString:otherString].location != NSNotFound);
}

- (NSString *)trimmed
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByReplacingMultipleStrings:(NSDictionary *)replacements
{
	NSString *ret = self;
	for (NSString *key in replacements) 
		ret = [ret stringByReplacingOccurrencesOfString:key withString:[key stringByAppendingString:@"k9BBV15zFYi44YyB"]];
	
	for (NSString *key in replacements) 
		ret = [ret stringByReplacingOccurrencesOfString:[key stringByAppendingString:@"k9BBV15zFYi44YyB"] withString:[replacements objectForKey:key]];
	
	return ret;
}

- (NSString *)clamp:(NSUInteger)maximumLength
{
    return (([self length] <= maximumLength) ? self : [self substringToIndex:maximumLength]);
}
@end
