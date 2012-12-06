//
//  NSString+CoreCode.h
//  CoreLib
//
//  Created by CoreCode on 15.03.12.
/*	Copyright (c) 2012 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#define STRING_SHA1 1

@interface NSString (CoreCode)

@property (readonly, nonatomic) NSURL *fileURL;
@property (readonly, nonatomic) NSURL *URL;
@property (readonly, nonatomic) NSURL *escapedURL;
@property (readonly, nonatomic) NSArray *lines;
@property (readonly, nonatomic) NSString *trimmed;
@property (readonly, nonatomic) NSData *download;
@property (readonly, nonatomic) NSMutableString *mutable;
#ifdef STRING_SHA1
@property (readonly, nonatomic) NSString *SHA1;
#endif

- (NSUInteger)countOccurencesOfString:(NSString *)str;
- (BOOL)contains:(NSString *)otherString insensitive:(BOOL)insensitive;
- (BOOL)contains:(NSString *)otherString;
- (NSString *)stringByReplacingMultipleStrings:(NSDictionary *)replacements;
- (NSString *)clamp:(NSUInteger)maximumLength;


@end
