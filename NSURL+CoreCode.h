//
//  NSURL+CoreCode.h
//  CoreLib
//
//  Created by CoreCode on 17.12.12.
/*	Copyright (c) 2012 - 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "CoreLib.h"


@interface NSURL (CoreCode)

- (NSURL *)add:(NSString *)component;
- (void)open;

@property (readonly, nonatomic) NSString *path;
@property (readonly, nonatomic) NSStringArray *dirContents;
@property (readonly, nonatomic) NSStringArray *dirContentsRecursive;
@property (readonly, nonatomic) NSURL *uniqueFile;
@property (readonly, nonatomic) BOOL fileExists;
@property (readonly, nonatomic) unsigned long long fileSize;
@property (readonly, nonatomic) NSURLRequest *request;
@property (readonly, nonatomic) BOOL isWriteablePath;
// url string download
@property (readonly, nonatomic) NSData *download;
// path string filedata
@property (readonly, nonatomic) NSData *contents;


@end




