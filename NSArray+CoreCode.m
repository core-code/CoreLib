//
//  NSArray+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 24.04.12.
/*	Copyright (c) 2012 - 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */



#import "NSArray+CoreCode.h"

@implementation NSArray (CoreCode)

@dynamic mutableObject, empty, count, set, reverseArray, firstObject, lastObject;

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

- (NSArray *)arrayOfValuesForKey:(NSString *)key
{
    NSMutableArray *resultArray = [NSMutableArray new];

    for (id object in self)
		[resultArray addObject:[object valueForKey:key]];

#if ! __has_feature(objc_arc)
	[resultArray autorelease];
#endif

    return [NSArray arrayWithArray:resultArray];
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
