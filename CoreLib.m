//
//  CoreLib.m
//  CoreLib
//
//  Created by CoreCode on 17.12.12.
/*	Copyright (c) 2011 - 2013 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#ifndef  CORELIB
#error you need to include CoreLib.h in your PCH file
#endif

CoreLib *cc;
aslclient client;
NSUserDefaults *userDefaults;
NSFileManager *fileManager;
NSNotificationCenter *notificationCenter;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
NSWorkspace *workspace;
#endif

@implementation CoreLib

@dynamic appCrashLogs, appID, appVersion, appVersionString, appName, resDir, docDir, suppDir, resURL, docURL, suppURL
#ifdef USE_SECURITY
, appSHA;
#else
;
#endif

- (id)init
{
	assert(!cc);
	if ((self = [super init]))
		if (!self.suppURL.fileExists)
			[[NSFileManager defaultManager] createDirectoryAtPath:self.suppURL.path withIntermediateDirectories:YES attributes:nil error:NULL];

	cc = self;
	client = asl_open(NULL, NULL, 0U);

#ifdef DEBUG
	asl_add_log_file(client, STDERR_FILENO);
#endif
	
	userDefaults = [NSUserDefaults standardUserDefaults];
	fileManager = [NSFileManager defaultManager];
	notificationCenter = [NSNotificationCenter defaultCenter];
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
	workspace = [NSWorkspace sharedWorkspace];
#endif
	return self;
}

- (NSArray *)appCrashLogs
{
	return [@"~/Library/Logs/DiagnosticReports/".expanded.dirContents filteredUsingPredicateString:@"self BEGINSWITH[cd] %@", self.appName];
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

#ifdef USE_SECURITY
#include <CommonCrypto/CommonDigest.h>
- (NSString *)appSHA
{
	NSData *d = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] executableURL]];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1([d bytes], (CC_LONG)[d length], result);
	NSMutableString *ms = [NSMutableString string];
	
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
	{
		[ms appendFormat: @"%02x", (int)(result [i])];
	}
	
#if ! __has_feature(objc_arc)
	return [[ms copy] autorelease];
#else
	return [ms copy];
#endif
}
#endif


NSString *_machineType();

- (void)openURL:(openChoice)choice
{
	NSString *urlString = @"";

	if (choice == openSupportRequestMail)
		urlString = makeString(@"mailto:%@?subject=%@ v%@ (%i) Support Request%@&body=Insert Support Request Here\n\n\n\nP.S: Hardware: %@ Software: %@%@",
							   OBJECT_OR([[NSBundle mainBundle] objectForInfoDictionaryKey:@"FeedbackEmail"], kFeedbackEmail),
							   cc.appName,
							   cc.appVersionString,
							   cc.appVersion,
#ifdef USE_SECURITY
							   makeString(@" (License code: %@)", cc.appSHA),
#else
							   @"",
#endif
							   _machineType(),
							   [[NSProcessInfo processInfo] operatingSystemVersionString],
							   ([cc.appCrashLogs count] ? makeString(@" Problems: %li", (unsigned long)[cc.appCrashLogs count]) : @""));
	else if (choice == openBetaSignupMail)
		urlString = makeString(@"mailto:%@?subject=%@ Beta Versions&body=Hello\nI would like to test upcoming beta versions of %@.\nBye\n",
							   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FeedbackEmail"],
							   cc.appName, cc.appName);
	else if (choice == openHomepageWebsite)
	{
		urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"VendorProductPage"];

		if (!urlString)
			urlString = makeString(@"%@%@/", kVendorHomepage, [cc.appName lowercaseString]);
	}
	else if (choice == openAppStoreWebsite)
		urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"StoreProductPage"];
	else if (choice == openAppStoreApp)
		urlString = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"StoreProductPage"] replaced:@"https" with:@"macappstore"];
	else if (choice == openMacupdateWebsite)
		urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MacupdateProductPage"];

	[urlString.escapedURL open];
}

@end

#pragma GCC diagnostic ignored "-Wformat-nonliteral"

// obj creation convenience
//NSPredicate *makePredicate(NSString *format, ...)
//{
//	va_list args;
//	va_start(args, format);
//	NSPredicate *pred = [NSPredicate predicateWithFormat:format arguments:args];
//	va_end(args);
//
//	return pred;
//}

NSString *makeString(NSString *format, ...)
{
	va_list args;
	va_start(args, format);
	NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
	va_end(args);
	
#if ! __has_feature(objc_arc)
	[str autorelease];
#endif
	
	return str;
}

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
NSColor *makeColor(float r, float g, float b, float a)
{
	return [NSColor colorWithCalibratedRed:(r) green:(g) blue:(b) alpha:(a)];
}
NSColor *makeColor255(float r, float g, float b, float a)
{
	return [NSColor colorWithCalibratedRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0];
}
#else
UIColor *makeColor(float r, float g, float b, float a)
{
	return [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)];
}
UIColor *makeColor255(float r, float g, float b, float a)
{
	return [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0];
}
#endif

// logging support
void asl_NSLog(int level, NSString *format, ...)
{
	va_list args;
	va_start(args, format);
	NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
	va_end(args);

	
	asl_log(client, NULL, level, "%s", [str UTF8String]);
	
#if ! __has_feature(objc_arc)
	[str release];
#endif
}

#if defined(DEBUG) || defined(FORCE_LOG)
void asl_NSLog_debug(NSString *format, ...)
{
	va_list args;
	va_start(args, format);
	NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
	va_end(args);
	
#ifdef FORCE_LOG
	asl_log(client, NULL, ASL_LEVEL_NOTICE, "%s", [str UTF8String]);
#else
	asl_log(client, NULL, ASL_LEVEL_DEBUG, "%s", [str UTF8String]);
#endif
	
#if ! __has_feature(objc_arc)
	[str release];
#endif
}
#else
void asl_NSLog_debug(NSString *format, ...)
{
}
#endif

// gcd convenience
void dispatch_after_main(float seconds, dispatch_block_t block)
{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), block);
}

void dispatch_after_back(float seconds, dispatch_block_t block)
{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_global_queue(0, 0), block);
}

void dispatch_async_main(dispatch_block_t block)
{
	dispatch_async(dispatch_get_main_queue(), block);
}

void dispatch_async_back(dispatch_block_t block)
{
	dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
	assert(dispatch_get_current_queue() != queue);
	dispatch_async(queue, block);
}

void dispatch_sync_main(dispatch_block_t block)
{
	assert([NSThread currentThread] != [NSThread mainThread]);
	dispatch_sync(dispatch_get_main_queue(), block);
}

void dispatch_sync_back(dispatch_block_t block)
{
	dispatch_sync(dispatch_get_global_queue(0, 0), block);
}


// private
#include <sys/types.h>
#include <sys/sysctl.h>
NSString *_machineType()
{
	char modelBuffer[256];
	size_t sz = sizeof(modelBuffer);
	if (0 == sysctlbyname("hw.model", modelBuffer, &sz, NULL, 0))
	{
		modelBuffer[sizeof(modelBuffer) - 1] = 0;
		return [NSString stringWithUTF8String:modelBuffer];
	}
	else
	{
		return @"";
	}
}