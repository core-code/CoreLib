//
//  NSArray+CoreCode.h
//  CoreLib
//
//  Created by CoreCode on 24.04.12.
/*	Copyright (c) 2012 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include "CoreLib.h"

@interface NSArray (CoreCode)

@property (readonly, nonatomic) NSMutableArray *mutable;
@property (readonly, nonatomic) BOOL empty;

- (NSArray *)arrayByRemovingObjectIdenticalTo:(id)anObject;
- (NSArray *)arrayByRemovingObjectAtIndex:(NSUInteger)index;
- (NSArray *)arrayByRemovingObjectsAtIndexes:(NSIndexSet *)indexSet;
- (id)safeObjectAtIndex:(NSUInteger)index;
- (NSString *)safeStringAtIndex:(NSUInteger)index;
- (BOOL)containsDictionaryWithKey:(NSString *)key equalTo:(NSString *)value;
- (NSArray *)sortedArrayByKey:(NSString *)key;
- (NSArray *)sortedArrayByKey:(NSString *)key ascending:(BOOL)ascending;

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSString *)runAsTask;
- (NSString *)runAsTaskWithTerminationStatus:(NSInteger *)terminationStatus;
#endif

- (NSArray *)mapped:(ObjectInOutBlock)block;
- (NSArray *)filtered:(ObjectInIntOutBlock)block;
- (NSArray *)filteredUsingPredicateString:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

// versions similar to cocoa methods
- (void)apply:(ObjectInBlock)block;								// enumerateObjectsUsingBlock:

// forwards for less typing
- (NSString *)joined:(NSString *)sep;							// componentsJoinedByString:

@property (readonly, nonatomic) NSUInteger count;

@end


@interface NSMutableArray (CoreCode)

@property (readonly, nonatomic) NSArray *immutable;

@end
