//
//  CoreLib.m
//  CoreLib
//
//  Created by CoreCode on 17.12.12.
/*	Copyright (c) 2011 - 2012 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

CoreLib *cc;

@implementation CoreLib

@dynamic appCrashLogs, appID, appVersion, appVersionString, appName, resDir, docDir, suppDir, resURL, docURL, suppURL;

- (id)init
{
	if ((self = [super init]))
		if (!cc.suppURL.fileExists)
			[[NSFileManager defaultManager] createDirectoryAtURL:cc.suppURL withIntermediateDirectories:YES attributes:nil error:NULL];
	
	return self;
}

- (NSArray *)appCrashLogs
{
	return [@"~/Library/Logs/DiagnosticReports/".expanded.dirContents filteredArrayUsingPredicate:_predf(@"self BEGINSWITH[cd] %@", self.appName)];
}

- (NSString *)appID
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)appVersionString
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appName
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (int)appVersion
{
	return [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] intValue];
}

- (NSString *)resDir
{
	return [[NSBundle mainBundle] resourcePath];
}

- (NSURL *)resURL
{
	return [[NSBundle mainBundle] resourceURL];
}

- (NSString *)docDir
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSURL *)docURL
{
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
}

- (NSString *)suppDir
{
	return [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:self.appName];
}

- (NSURL *)suppURL
{
	NSURL *dir = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
	return [dir add:self.appName];
}

@end