//
//  CoreLib.m
//  CoreLib
//
//  Created by CoreCode on 17.12.12.
/*	Copyright (c) 2015 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "CoreLib.h"
#ifndef CORELIB
#error you need to include CoreLib.h in your PCH file
#endif
#ifdef USE_SECURITY
#include <CommonCrypto/CommonDigest.h>
#endif


NSString *_machineType(void);

CoreLib *cc;
NSUserDefaults *userDefaults;
NSFileManager *fileManager;
NSNotificationCenter *notificationCenter;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
NSFontManager *fontManager;
NSDistributedNotificationCenter *distributedNotificationCenter;
NSApplication *application;
NSWorkspace *workspace;
NSProcessInfo *processInfo;
#endif


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
__attribute__((noreturn)) void exceptionHandler(NSException *exception)
{
	alert_feedback_fatal(exception.name, makeString(@" %@ %@ %@ %@", exception.description, exception.reason, exception.userInfo.description, exception.callStackSymbols));
}
#endif

@implementation CoreLib

@dynamic appCrashLogs, appID, appBuild, appVersionString, appName, resDir, docDir, suppDir, resURL, docURL, suppURL, deskDir, deskURL, prefsPath, prefsURL, homeURL
#ifdef USE_SECURITY
, appSHA;
#else
;
#endif

+ (void)initialize
{
	
}

- (instancetype)init
{
	assert(!cc);
	if ((self = [super init]))
		if (!self.suppURL.fileExists)
			[[NSFileManager defaultManager] createDirectoryAtPath:self.suppURL.path withIntermediateDirectories:YES attributes:nil error:NULL];

	cc = self;
	
    
#ifdef DEBUG
	asl_add_log_file(NULL, STDERR_FILENO);
#endif
	userDefaults = [NSUserDefaults standardUserDefaults];
	fileManager = [NSFileManager defaultManager];
	notificationCenter = [NSNotificationCenter defaultCenter];
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
	fontManager = [NSFontManager sharedFontManager];
	distributedNotificationCenter = [NSDistributedNotificationCenter defaultCenter];
	workspace = [NSWorkspace sharedWorkspace];
	application = [NSApplication sharedApplication];
	processInfo = [NSProcessInfo processInfo];
#endif

#ifdef DEBUG
	BOOL isSandbox = [@"~/Library/".expanded contains:@"/Library/Containers/"];
#ifdef SANDBOX
	assert(isSandbox);
#else
	assert(!isSandbox);
#endif

#ifdef NDEBUG
    LOG(@"Warning: you are running in DEBUG mode but have disabled assertions (NDEBUG)");
#endif



    if (![[self appID] isEqualToString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]])
		exit(666);

	if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"LSUIElement"] boolValue] &&
		![[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPrincipalClass"] isEqualToString:@"JMDocklessApplication"])
		asl_NSLog_debug(@"Warning: app can hide dock symbol but has no fixed principal class");


	if (![[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"MacupdateProductPage"] lowercaseString] contains:self.appName.lowercaseString])
		asl_NSLog_debug(@"Warning: info.plist key MacupdateProductPage not properly set");

	if ([[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"MacupdateProductPage"] lowercaseString] contains:@"/find/"])
		asl_NSLog_debug(@"Warning: info.plist key MacupdateProductPage should be updated to proper product page");

	if (![[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"StoreProductPage"] lowercaseString] contains:self.appName.lowercaseString])
		asl_NSLog_debug(@"Warning: info.plist key StoreProductPage not properly set (%@ NOT CONTAINS %@", [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"StoreProductPage"] lowercaseString], self.appName.lowercaseString);

	if (![(NSString *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"LSApplicationCategoryType"] length])
        LOG(@"Warning: LSApplicationCategoryType not properly set");
#else
    #ifndef NDEBUG
        asl_NSLog(ASL_LEVEL_WARNING, @"Warning: you are not running in DEBUG mode but have not disabled assertions (NDEBUG)");
    #endif
#endif

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
#ifndef DONT_CRASH_ON_EXCEPTIONS
	NSSetUncaughtExceptionHandler(&exceptionHandler);
#endif

	
	NSString *frameworkPath = [[NSBundle mainBundle] privateFrameworksPath];
	for (NSString *framework in frameworkPath.dirContents)
	{
		NSString *smylinkToBinaryPath = makeString(@"%@/%@/%@", frameworkPath, framework, framework.stringByDeletingPathExtension);

		if (!smylinkToBinaryPath.fileIsAlias)
		{
			alert_apptitled(@"This application is damaged. Either your download was damaged or you used a faulty program to extract the ZIP archive. Please re-download and use the ZIP decrompression built into Mac OS X.", @"OK", nil, nil);
			exit(0);
		}
	}
#endif

	return self;
}

- (NSString *)prefsPath
{
	return makeString(@"~/Library/Preferences/%@.plist", self.appID).expanded;
}

- (NSURL *)prefsURL
{
	return self.prefsPath.fileURL;
}

- (NSArray *)appCrashLogs // doesn't do anything in sandbox!
{
	NSStringArray *logs = @"~/Library/Logs/DiagnosticReports/".expanded.dirContents;
	return [logs filteredUsingPredicateString:@"self BEGINSWITH[cd] %@", self.appName];
}

- (NSString *)appID
{
	return [NSBundle mainBundle].bundleIdentifier;
}

- (NSString *)appVersionString
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appName
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (int)appBuild
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
	return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)deskDir
{
	return NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0];
}

- (NSURL *)homeURL
{
	return NSHomeDirectory().URL;
}

- (NSURL *)docURL
{
	return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
}

- (NSURL *)deskURL
{
	return [[NSFileManager defaultManager] URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask][0];
}

- (NSString *)suppDir
{
	return [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:self.appName];
}

- (NSURL *)suppURL
{
	NSURL *dir = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask][0];

    if (dir && self.appName)
        return [dir add:self.appName];
    else
        return nil;
}

- (NSString *)appSHA
{
#ifdef USE_SECURITY

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
#else
	return @"Unvailable";
#endif
}

- (void)openURL:(openChoice)choice
{
	NSString *urlString = @"";


	if (choice == openSupportRequestMail)
	{
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
		BOOL optionDown = ([NSEvent modifierFlags] & NSAlternateKeyMask) != 0;
#endif

		NSString *encodedPrefs = @"";

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
#if (__MAC_OS_X_VERSION_MIN_REQUIRED < 1090)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Wselector"
#endif
		if (optionDown && (NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_9))
			encodedPrefs = [self.prefsURL performSelector:@selector(base64EncodedStringWithOptions:) withObject:@(0)];
#if (__MAC_OS_X_VERSION_MIN_REQUIRED < 1090)
#pragma clang diagnostic pop
#endif
#endif


		NSString *recipient = OBJECT_OR([[NSBundle mainBundle] objectForInfoDictionaryKey:@"FeedbackEmail"], kFeedbackEmail);

		NSString *subject = makeString(@"%@ v%@ (%i) Support Request (License code: %@)",
							   cc.appName,
							   cc.appVersionString,
							   cc.appBuild,
							   cc.appSHA);

		NSString *content =  makeString(@"<Insert Support Request Here>\n\n\n\nP.S: Hardware: %@ Software: %@%@\n%@",
								_machineType(),
								[[NSProcessInfo processInfo] operatingSystemVersionString],
								([cc.appCrashLogs count] ? makeString(@" Problems: %li", (unsigned long)[cc.appCrashLogs count]) : @""),
								encodedPrefs);


		urlString = makeString(@"mailto:%@?subject=%@&body=%@", recipient, subject, content);
	}
	else if (choice == openBetaSignupMail)
		urlString = makeString(@"s%@?subject=%@ Beta Versions&body=Hello\nI would like to test upcoming beta versions of %@.\nBye\n",
							   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FeedbackEmail"], cc.appName, cc.appName);
	else if (choice == openHomepageWebsite)
		urlString = OBJECT_OR([[NSBundle mainBundle] objectForInfoDictionaryKey:@"VendorProductPage"],
							  makeString(@"%@%@/", kVendorHomepage, [cc.appName.lowercaseString.words[0] split:@"-"][0]));
	else if (choice == openAppStoreWebsite)
		urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"StoreProductPage"];
	else if (choice == openAppStoreApp)
		urlString = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"StoreProductPage"] replaced:@"https" with:@"macappstore"];
	else if (choice == openMacupdateWebsite)
		urlString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MacupdateProductPage"];

	[urlString.escaped.URL open];
}

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-nonliteral"

// obj creation convenience
NSPredicate *makePredicate(NSString *format, ...)
{
	assert([format rangeOfString:@"'%@'"].location == NSNotFound);

    
	va_list args;
	va_start(args, format);
	NSPredicate *pred = [NSPredicate predicateWithFormat:format arguments:args];
	va_end(args);

	return pred;
}

NSString *makeDescription(id sender, NSArray *args)
{
	NSMutableString *tmp = [NSMutableString new];

	for (NSString *arg in args)
	{
		NSString *d = [[sender valueForKey:arg] description];

		[tmp appendFormat:@"\n%@: %@", arg, d];
	}

#if ! __has_feature(objc_arc)
	[tmp autorelease];
#endif

	return tmp.immutableObject;
}

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

NSString *makeTempFolder()
{
	NSString *tempDirectoryTemplate = [[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]] stringByAppendingString:@".XXXXXX"];
	const char *tempDirectoryTemplateCString = [tempDirectoryTemplate fileSystemRepresentation];
	char *tempDirectoryNameCString = (char *)malloc(strlen(tempDirectoryTemplateCString) + 1);
	strcpy(tempDirectoryNameCString, tempDirectoryTemplateCString);

	char *result = mkdtemp(tempDirectoryNameCString);
	if (!result)
	{
		free(tempDirectoryNameCString);
		return nil;
	}

	NSString *tempDirectoryPath = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:result length:strlen(result)];
	free(tempDirectoryNameCString);

	return tempDirectoryPath;
}

NSValue *makeRectValue(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
	return [NSValue valueWithRect:CGRectMake(x, y, width, height)];
#else
	return [NSValue valueWithCGRect:CGRectMake(x, y, width, height)];
#endif
}

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

void alert_feedback(NSString *usermsg, NSString *details, BOOL fatal)
{
    asl_NSLog(ASL_LEVEL_ERR, @"alert_feedback %@ %@", usermsg, details);

	dispatch_block_t block = ^
	{
        static const int maxLen = 400;

        NSString *encodedPrefs = @"";
        
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
#if (__MAC_OS_X_VERSION_MIN_REQUIRED < 1090)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Wselector"
#endif
        if (NSAppKitVersionNumber >= (int)NSAppKitVersionNumber10_9)
            encodedPrefs = [cc.prefsURL.contents performSelector:@selector(base64EncodedStringWithOptions:) withObject:@(0)];
#if (__MAC_OS_X_VERSION_MIN_REQUIRED < 1090)
#pragma clang diagnostic pop
#endif
#endif
        
        
        NSString *visibleDetails = details;
        if (visibleDetails.length > maxLen)
            visibleDetails = makeString(@"%@  …\n(Remaining message omitted)", [visibleDetails clamp:maxLen]);

		if (alert(@"Fatal Error",
                  makeString(@"%@\n\n You can contact our support with detailed information so that we can fix this problem.\n\nInformation: %@", usermsg, visibleDetails),
				  @"Send to support", fatal ? @"Quit" : @"Continue", nil) == NSAlertFirstButtonReturn)
		{
			NSString *mailtoLink = makeString(@"mailto:feedback@corecode.at?subject=%@ v%@ (%i) Problem Report&body=Hello\nA fatal error in %@ occured (%@).\n\nBye\n\nP.S. Details: %@\n\n\nP.P.S: Hardware: %@ Software: %@%@\n\nPreferences: %@\n",
											  cc.appName,
											  cc.appVersionString,
											  cc.appBuild,
											  cc.appName,
											  usermsg,
											  details,
											  _machineType(),
											  [[NSProcessInfo processInfo] operatingSystemVersionString],
											  ([cc.appCrashLogs count] ? makeString(@" Problems: %li", [cc.appCrashLogs count]) : @""),
                                              encodedPrefs);
			
			[mailtoLink.escaped.URL open];
		}

		if (fatal)
			exit(1);
    };
    

	dispatch_sync_main(block);
}

void alert_feedback_fatal(NSString *usermsg, NSString *details)
{
	alert_feedback(usermsg, details, YES);
	exit(1);
}

void alert_feedback_nonfatal(NSString *usermsg, NSString *details)
{
	alert_feedback(usermsg, details, NO);
}

NSInteger alert_selection(NSString *prompt, NSArray *buttons, NSStringArray *choices, NSInteger *result)
{
    assert(buttons);
    assert(choices);
    assert(result);
    assert([NSThread currentThread] == [NSThread mainThread]);

    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = prompt;
    
    if (buttons.count > 0)
        [alert addButtonWithTitle:buttons[0]];
    if (buttons.count > 1)
        [alert addButtonWithTitle:buttons[1]];
    if (buttons.count > 2)
        [alert addButtonWithTitle:buttons[2]];
    
	NSPopUpButton *input = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 310, 24)];
	for (NSString *str in choices)
		[input addItemWithTitle:str];
#if ! __has_feature(objc_arc)
	[input autorelease];
#endif
	[alert setAccessoryView:input];
	NSInteger selectedButton = [alert runModal];

	[input validateEditing];
	*result = [input indexOfSelectedItem];

#if ! __has_feature(objc_arc)
    [alert release];
#endif
    
	return selectedButton;
}

NSInteger _alert_input(NSString *prompt, NSArray *buttons, NSString **result, BOOL useSecurePrompt)
{
    assert(buttons);
    assert(result);
    assert([NSThread currentThread] == [NSThread mainThread]);

    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = prompt;
    
    if (buttons.count > 0)
        [alert addButtonWithTitle:buttons[0]];
    if (buttons.count > 1)
        [alert addButtonWithTitle:buttons[1]];
    if (buttons.count > 2)
        [alert addButtonWithTitle:buttons[2]];
    
	NSTextField *input;
	if (useSecurePrompt)
		input = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 310, 24)];
	else
		input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 310, 24)];

#if ! __has_feature(objc_arc)
	[input autorelease];
#endif
	[alert setAccessoryView:input];
	NSInteger selectedButton = [alert runModal];

	[input validateEditing];
	*result = [input stringValue];
    
#if ! __has_feature(objc_arc)
    [alert release];
#endif
    
	return selectedButton;
}

NSInteger alert_inputtext(NSString *prompt, NSArray *buttons, NSString **result)
{
	assert(buttons);
	assert(result);
	assert([NSThread currentThread] == [NSThread mainThread]);

	NSAlert *alert = [[NSAlert alloc] init];
	alert.messageText = prompt;

	if (buttons.count > 0)
		[alert addButtonWithTitle:buttons[0]];
	if (buttons.count > 1)
		[alert addButtonWithTitle:buttons[1]];
	if (buttons.count > 2)
		[alert addButtonWithTitle:buttons[2]];

	NSTextView *input = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 310, 200)];

#if ! __has_feature(objc_arc)
	[input autorelease];
#endif
	[alert setAccessoryView:input];
	NSInteger selectedButton = [alert runModal];

	*result = [input string];

#if ! __has_feature(objc_arc)
	[alert release];
#endif

	return selectedButton;
}

NSInteger alert_input(NSString *prompt, NSArray *buttons, NSString **result)
{
	return _alert_input(prompt, buttons, result, NO);
}

NSInteger alert_inputsecure(NSString *prompt, NSArray *buttons, NSString **result)
{
	return _alert_input(prompt, buttons, result, YES);
}


NSInteger alert(NSString *title, NSString *message, NSString *defaultButton, NSString *alternateButton, NSString *otherButton)
{
	assert([NSThread currentThread] == [NSThread mainThread]);
    
	[NSApp activateIgnoringOtherApps:YES];

    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = title;
    alert.informativeText = message;
    
    if (defaultButton)
        [alert addButtonWithTitle:defaultButton];
    if (alternateButton)
        [alert addButtonWithTitle:alternateButton];
    if (otherButton)
        [alert addButtonWithTitle:otherButton];
    
    NSInteger result = [alert runModal];
    
#if ! __has_feature(objc_arc)
    [alert release];
#endif
    
    return result;
}

NSInteger alert_apptitled(NSString *message, NSString *defaultButton, NSString *alternateButton, NSString *otherButton)
{
	return alert(cc.appName, message, defaultButton, alternateButton, otherButton);
}

void alert_dontwarnagain_version(NSString *identifier, NSString *title, NSString *message, NSString *defaultButton, NSString *dontwarnButton)
{
    assert(defaultButton && dontwarnButton);
    
   	dispatch_block_t block = ^
	{
		NSString *defaultKey = makeString(@"_%@_%@_asked", identifier, cc.appVersionString);
		if (!defaultKey.defaultInt)
		{
            NSAlert *alert = [[NSAlert alloc] init];
            
            alert.messageText = title;
            alert.informativeText = message;
            [alert addButtonWithTitle:defaultButton];
            alert.showsSuppressionButton = YES;
            alert.suppressionButton.title = dontwarnButton;
            
            
			[NSApp activateIgnoringOtherApps:YES];
            [alert runModal];
            
            defaultKey.defaultInt = alert.suppressionButton.state;
            
            
#if ! __has_feature(objc_arc)
            [alert release];
#endif
		}
	};

    if ([NSThread currentThread] == [NSThread mainThread])
        block();
    else
        dispatch_async_main(block);
}
void alert_dontwarnagain_ever(NSString *identifier, NSString *title, NSString *message, NSString *defaultButton, NSString *dontwarnButton)
{
    dispatch_block_t block = ^
	{
		NSString *defaultKey = makeString(@"_%@_asked", identifier);
        
        if (!defaultKey.defaultInt)
        {
            NSAlert *alert = [[NSAlert alloc] init];
            
            alert.messageText = title;
            alert.informativeText = message;
            [alert addButtonWithTitle:defaultButton];
            alert.showsSuppressionButton = YES;
            alert.suppressionButton.title = dontwarnButton;
            
            
            [NSApp activateIgnoringOtherApps:YES];
            [alert runModal];
            
            defaultKey.defaultInt = alert.suppressionButton.state;
            
            
#if ! __has_feature(objc_arc)
            [alert release];
#endif
        }
	};

	if ([NSThread currentThread] == [NSThread mainThread])
		block();
	else
		dispatch_async_main(block);
}
#pragma clang diagnostic pop


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
	return [UIColor colorWithRed:(r) / (CGFloat)255.0 green:(g) / (CGFloat)255.0 blue:(b) / (CGFloat)255.0 alpha:(a) / (CGFloat)255.0];
}
#endif

// logging support
#undef asl_log
void asl_NSLog(int level, NSString *format, ...)
{
	va_list args;
	va_start(args, format);
	NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
	va_end(args);

    asl_log(NULL, NULL, level, "%s", [str UTF8String]);

    
#ifndef DONTLOGASLTOUSERDEFAULTS
    static int lastPosition[8] = {0,0,0,0,0,0,0,0};
    assert(level < 8);
    NSString *key = makeString(@"corelib_asl_lev%i_pos%i", level, lastPosition[level]);
    key.defaultString = makeString(@"date: %@ message: %@", NSDate.date.description, str);
    lastPosition[level]++;
	if (lastPosition[level] > 9)
		lastPosition[level] = 0;
#endif
    
    
#if ! __has_feature(objc_arc)
	[str release];
#endif
}


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
	dispatch_async(queue, block);
}

void dispatch_sync_main(dispatch_block_t block)
{
	if ([NSThread currentThread] == [NSThread mainThread])
		block();	// this would deadlock when performed with dispatch_sync
	else
		dispatch_sync(dispatch_get_main_queue(), block);
}

void dispatch_sync_back(dispatch_block_t block)
{
	dispatch_sync(dispatch_get_global_queue(0, 0), block);
}

// private
#if __has_feature(modules)
@import Darwin.POSIX.sys.types;
@import Darwin.sys.sysctl;
#else
#include <sys/types.h>
#include <sys/sysctl.h>
#endif
NSString *_machineType()
{
	char modelBuffer[256];
	size_t sz = sizeof(modelBuffer);
	if (0 == sysctlbyname("hw.model", modelBuffer, &sz, NULL, 0))
	{
		modelBuffer[sizeof(modelBuffer) - 1] = 0;
		return @(modelBuffer);
	}
	else
	{
		return @"";
	}
}