//
//  NSURL+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 17.12.12.
/*	Copyright (c) 2012 - 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "NSURL+CoreCode.h"
#import "NSString+CoreCode.h"

@implementation NSURL (CoreCode)

@dynamic dirContents, dirContentsRecursive, fileExists, uniqueFile, path, request, fileSize, isWriteablePath, download, contents;

- (NSURLRequest *)request
{
	return [NSURLRequest requestWithURL:self];
}

- (NSURL *)add:(NSString *)component
{
	return [self URLByAppendingPathComponent:component];
}

- (NSStringArray *)dirContents
{
	if (![self isFileURL]) return nil;
	return (NSStringArray *)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self path] error:NULL];
}

- (NSStringArray *)dirContentsRecursive
{
	if (![self isFileURL]) return nil;
	return (NSStringArray *)[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:[self path] error:NULL];
}

- (NSURL *)uniqueFile
{
	if (![self isFileURL]) return nil;
	return [self path].uniqueFile.fileURL;
}

- (BOOL)fileExists
{
	return [self isFileURL] && [[NSFileManager defaultManager] fileExistsAtPath:[self path]];
}

- (unsigned long long)fileSize
{
	NSNumber *size;

	if ([self getResourceValue:&size forKey:NSURLFileSizeKey error:nil])
        return [size unsignedLongLongValue];
	else
		return 0;
}

- (void)open
{
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
	[[NSWorkspace sharedWorkspace] openURL:self];
#else
	[[UIApplication sharedApplication] openURL:self];
#endif
}

- (BOOL)isWriteablePath
{
	if (self.fileExists)
		return NO;

	if (![@"TEST" writeToURL:self atomically:YES encoding:NSUTF8StringEncoding error:NULL])
		return NO;

	[fileManager removeItemAtURL:self error:NULL];

	return YES;
}


- (NSData *)download
{
	NSData *d = [[NSData alloc] initWithContentsOfURL:self];
#if ! __has_feature(objc_arc)
	[d autorelease];
#endif
	return d;
}

- (NSData *)contents
{
	return self.download;
}
@end
