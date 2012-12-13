//
//  NSArray+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 24.04.12.
/*	Copyright (c) 2012 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */



#import "NSArray+CoreCode.h"

@implementation NSArray (CoreCode)

@dynamic mutable, empty;

- (NSArray *)arrayByRemovingObjectIdenticalTo:(id)anObject
{
	NSMutableArray *array = [NSMutableArray arrayWithArray:self];

	[array removeObjectIdenticalTo:anObject];

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

- (NSMutableArray *)mutable
{
	return [NSMutableArray arrayWithArray:self];
}

- (BOOL)empty
{
	return [self count] == 0;
}
@end


@implementation  NSMutableArray (CoreCode)

@dynamic immutable;

- (NSArray *)immutable
{
	return [NSArray arrayWithArray:self];
}
@end
