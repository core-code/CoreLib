//
//  NSData+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 06.12.12.
/*	Copyright (c) 2012 - 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "NSData+CoreCode.h"


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
