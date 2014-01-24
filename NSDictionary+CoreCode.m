//
//  NSDictionary+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 04.12.12.
/*	Copyright (c) 2012 - 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */



#import "NSDictionary+CoreCode.h"


@implementation NSDictionary (CoreCode)

@dynamic mutableObject;

- (NSMutableDictionary *)mutableObject
{
	return [NSMutableDictionary dictionaryWithDictionary:self];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [super methodSignatureForSelector:@selector(valueForKey:)];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *propertyName = NSStringFromSelector(invocation.selector);
    [invocation setSelector:@selector(valueForKey:)];
    [invocation setArgument:&propertyName atIndex:2];
    [invocation invokeWithTarget:self];
}

- (NSDictionary *)dictionaryByAddingValue:(id)value forKey:(NSString *)key
{
	NSMutableDictionary *mutable = self.mutableObject;

	mutable[key] = value;

	return mutable.immutableObject;
}

@end


@implementation  NSMutableDictionary (CoreCode)

@dynamic immutableObject;

- (NSDictionary *)immutableObject
{
	return [NSDictionary dictionaryWithDictionary:self];
}
@end
