//
//  Foundation+Indexing.h
//  CoreLib
//
//  Created by CoreCode on 15.03.12.
/*	Copyright (c) 2012 - 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "CoreLib.h"


// support for subscripting with the 10.6 / 10.7 / iOS 5 SDK and deployment target that actually supports it
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundef"
#if (((__MAC_OS_X_VERSION_MAX_ALLOWED >= 1060) && (__MAC_OS_X_VERSION_MAX_ALLOWED <= 1070) && (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)) || ((__IPHONE_OS_VERSION_MAX_ALLOWED == 50000) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= 50000)))
@interface NSArray (Subscript)
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
@end
@interface NSMutableArray (Subscript)
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
@end
#endif
#pragma GCC diagnostic pop
// support for subscripting with the 10.6 / 10.7 / iOS 5 SDK and deployment target that actually supports it
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundef"
#if (((__MAC_OS_X_VERSION_MAX_ALLOWED >= 1060) && (__MAC_OS_X_VERSION_MAX_ALLOWED <= 1070) && (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)) || ((__IPHONE_OS_VERSION_MAX_ALLOWED == 50000) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= 50000)))
@interface  NSDictionary (Indexing)
- (id)objectForKeyedSubscript:(id)key;
@end
@interface  NSMutableDictionary (Indexing)
- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;
@end
#endif
#pragma GCC diagnostic pop