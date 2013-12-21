//
//  NSNumber+CoreCode.h
//  CoreLib
//
//  Created by CoreCode on 03.07.13.
/*	Copyright (c) 2012 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "CoreLib.h"


@interface NSNumber (CoreCode)


@property (readonly, nonatomic) BOOL  boolValue;
@property (readonly, nonatomic) char  charValue;
@property (readonly, nonatomic) NSDecimal  decimalValue;
@property (readonly, nonatomic) double  doubleValue;
@property (readonly, nonatomic) float  floatValue;
@property (readonly, nonatomic) int  intValue;
@property (readonly, nonatomic) NSInteger  integerValue;
@property (readonly, nonatomic) long long longLongValue;
@property (readonly, nonatomic) long longValue;
@property (readonly, nonatomic) short shortValue;
@property (readonly, nonatomic) unsigned char unsignedCharValue;
@property (readonly, nonatomic) NSUInteger unsignedIntegerValue;
@property (readonly, nonatomic) unsigned int unsignedIntValue;
@property (readonly, nonatomic) unsigned long long unsignedLongLongValue;
@property (readonly, nonatomic) unsigned long unsignedLongValue;
@property (readonly, nonatomic) unsigned short unsignedShortValue;
@property (readonly, nonatomic) NSString *stringValue;


@end

