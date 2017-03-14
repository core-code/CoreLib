//
//  CoreLib.m
//  CoreLib
//
//  Created by CoreCode on 17.12.12.
/*	Copyright © 2017 CoreCode Limited
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

#if __has_feature(modules)
@import Darwin.POSIX.unistd;
@import Darwin.POSIX.sys.types;
@import Darwin.POSIX.pwd;
#include <assert.h>
#else
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>
#include <assert.h>
#endif



NSString *_machineType(void);
BOOL _isUserAdmin(void);

CoreLib *cc;
NSUserDefaults *userDefaults;
NSFileManager *fileManager;
NSNotificationCenter *notificationCenter;
NSBundle *bundle;
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

@dynamic appCrashLogs, appBundleIdentifier, appBuildNumber, appVersionString, appName, resDir, docDir, suppDir, resURL, docURL, suppURL, deskDir, deskURL, prefsPath, prefsURL, homeURLInsideSandbox, homeURLOutsideSandbox, appSystemLogEntries
#ifdef USE_SECURITY
, appChecksumSHA;
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
    {
        cc = self;


        userDefaults = [NSUserDefaults standardUserDefaults];
        fileManager = [NSFileManager defaultManager];
        notificationCenter = [NSNotificationCenter defaultCenter];
        bundle = [NSBundle mainBundle];
    #if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
        fontManager = [NSFontManager sharedFontManager];
        distributedNotificationCenter = [NSDistributedNotificationCenter defaultCenter];
        workspace = [NSWorkspace sharedWorkspace];
        application = [NSApplication sharedApplication];
        processInfo = [NSProcessInfo processInfo];
    #endif

        if (!self.suppURL.fileExists)
		{
			if ([fileManager respondsToSelector:@selector(createDirectoryAtURL:withIntermediateDirectories:attributes:error:)])
				[fileManager createDirectoryAtURL:self.suppURL
					  withIntermediateDirectories:YES attributes:nil error:NULL];
			else
			{
				NSString *p = self.suppURL.path;
				[fileManager createDirectoryAtPath:p
					   withIntermediateDirectories:YES attributes:nil error:NULL];
			}
		}

    #ifdef DEBUG
		#ifndef XCTEST
            BOOL isSandbox = [@"~/Library/".expanded contains:@"/Library/Containers/"];

            #ifdef SANDBOX
                assert(isSandbox);
            #else
                assert(!isSandbox);
            #endif
		#endif

        #ifdef NDEBUG
            LOG(@"Warning: you are running in DEBUG mode but have disabled assertions (NDEBUG)");
        #endif

        #if !defined(XCTEST) || !XCTEST
            NSString *bundleID = [bundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
            if (![[self appBundleIdentifier] isEqualToString:bundleID])
                exit(666);
        #endif

        if ([[bundle objectForInfoDictionaryKey:@"LSUIElement"] boolValue] &&
            ![[bundle objectForInfoDictionaryKey:@"NSPrincipalClass"] isEqualToString:@"JMDocklessApplication"])
            cc_log_debug(@"Warning: app can hide dock symbol but has no fixed principal class");


        if (![[[bundle objectForInfoDictionaryKey:@"MacupdateProductPage"] lowercaseString] contains:self.appName.lowercaseString])
            cc_log_debug(@"Warning: info.plist key MacupdateProductPage not properly set");

        if ([[[bundle objectForInfoDictionaryKey:@"MacupdateProductPage"] lowercaseString] contains:@"/find/"])
            cc_log_debug(@"Warning: info.plist key MacupdateProductPage should be updated to proper product page");

        if (![[[bundle objectForInfoDictionaryKey:@"StoreProductPage"] lowercaseString] contains:self.appName.lowercaseString])
            cc_log_debug(@"Warning: info.plist key StoreProductPage not properly set (%@ NOT CONTAINS %@", [[bundle objectForInfoDictionaryKey:@"StoreProductPage"] lowercaseString], self.appName.lowercaseString);

        if (![(NSString *)[bundle objectForInfoDictionaryKey:@"LSApplicationCategoryType"] length])
            LOG(@"Warning: LSApplicationCategoryType not properly set");
    #else
        #ifndef NDEBUG
            cc_log_error(@"Warning: you are not running in DEBUG mode but have not disabled assertions (NDEBUG)");
        #endif
    #endif

        
    #if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
    #ifndef DONT_CRASH_ON_EXCEPTIONS
        NSSetUncaughtExceptionHandler(&exceptionHandler);
    #endif

        
        NSString *frameworkPath = bundle.privateFrameworksPath;
        for (NSString *framework in frameworkPath.dirContents)
        {
            NSString *smylinkToBinaryPath = makeString(@"%@/%@/%@", frameworkPath, framework, framework.stringByDeletingPathExtension);

            if (!smylinkToBinaryPath.fileIsAlias)
            {
#ifdef DEBUG
                if ([framework hasPrefix:@"libclang"]) continue;
#endif
                alert_apptitled(@"This application is damaged. Either your download was damaged or you used a faulty program to extract the ZIP archive. Please re-download and make sure to use the ZIP decompression built into Mac OS X.", @"OK", nil, nil);
                exit(0);
            }
#ifdef DEBUG
            NSString *versionsPath = makeString(@"%@/%@/Versions", frameworkPath, framework);
            for (NSString *versionsEntry in versionsPath.dirContents)
            {
                if ((![versionsEntry isEqualToString:@"A"]) && (![versionsEntry isEqualToString:@"Current"]))
                {
                    cc_log_error(@"The frameworks are damaged probably by lowercasing. Either your download was damaged or you used a faulty program to extract the ZIP archive. Please re-download and make sure to use the ZIP decompression built into Mac OS X.");
                    exit(0);
                }
            }
            NSString *versionAPath = makeString(@"%@/%@/Versions/A", frameworkPath, framework);
            for (NSString *entry in versionAPath.dirContents)
            {
                if (([entry isEqualToString:@"headers"]) && (![entry isEqualToString:@"resources"]))
                {
                    cc_log_error(@"The frameworks are damaged probably by lowercasing. Either your download was damaged or you used a faulty program to extract the ZIP archive. Please re-download and make sure to use the ZIP decompression built into Mac OS X.");
                    exit(0);
                }
            }
#endif
        }
    #endif
    }

    assert(cc);


	return self;
}

- (NSString *)prefsPath
{
	return makeString(@"~/Library/Preferences/%@.plist", self.appBundleIdentifier).expanded;
}

- (NSURL *)prefsURL
{
	return self.prefsPath.fileURL;
}

- (NSArray *)appCrashLogs // doesn't do anything in sandbox!
{
	NSArray <NSString *> *logs1 = @"~/Library/Logs/DiagnosticReports/".expanded.dirContents;
	NSArray <NSString *> *logs2 = @"/Library/Logs/DiagnosticReports/".expanded.dirContents;
	NSArray <NSString *> *logs = [logs1 arrayByAddingObjectsFromArray:logs2];
	
	return [logs filteredUsingPredicateString:@"self BEGINSWITH[cd] %@", self.appName];
}

- (NSString *)appBundleIdentifier
{
	return NSBundle.mainBundle.bundleIdentifier;
}

- (NSString *)appVersionString
{
	return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appName
{
#if defined(XCTEST) && XCTEST
	return @"TEST";
#else
	return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
#endif
}

- (int)appBuildNumber
{
	return [[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"] intValue];
}

- (NSString *)resDir
{
	return NSBundle.mainBundle.resourcePath;
}

- (NSURL *)resURL
{
	return NSBundle.mainBundle.resourceURL;
}

- (NSString *)docDir
{
	return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)deskDir
{
	return NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0];
}

- (NSURL *)homeURLInsideSandbox
{
	return NSHomeDirectory().fileURL;
}

- (NSURL *)homeURLOutsideSandbox
{
    struct passwd *pw = getpwuid(getuid());
    assert(pw);
    NSString *realHomePath = @(pw->pw_dir);
    NSURL *realHomeURL = [NSURL fileURLWithPath:realHomePath];

    return realHomeURL;
}


- (NSURL *)docURL
{
	return [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
}

- (NSURL *)deskURL
{
	return [NSFileManager.defaultManager URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask][0];
}

- (NSString *)suppDir
{
	return [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:self.appName];
}

- ( NSURL * __nonnull)suppURL
{
	NSURL *dir = [NSFileManager.defaultManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask][0];

	assert(dir && self.appName);

	return [dir add:self.appName];
}

- (NSString *)appChecksumSHA
{
#ifdef USE_SECURITY
    NSURL *u = [[NSBundle mainBundle] executableURL];
	NSData *d = [NSData dataWithContentsOfURL:u];
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
#pragma clang diagnostic ignored "-Wpartial-availability"
#endif
		if (optionDown && [NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
			encodedPrefs = [self.prefsURL.contents base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
#if (__MAC_OS_X_VERSION_MIN_REQUIRED < 1090)
#pragma clang diagnostic pop
#endif
#endif


		NSString *recipient = OBJECT_OR([bundle objectForInfoDictionaryKey:@"FeedbackEmail"], kFeedbackEmail);

		NSString *subject = makeString(@"%@ v%@ (%i) Support Request (License code: %@)",
							   cc.appName,
							   cc.appVersionString,
							   cc.appBuildNumber,
							   cc.appChecksumSHA);

		NSString *content =  makeString(@"<Insert Support Request Here>\n\n\n\nP.S: Hardware: %@ Software: %@%@\n%@",
								_machineType(),
								[[NSProcessInfo processInfo] operatingSystemVersionString],
								([cc.appCrashLogs count] ? makeString(@" Problems: %li", (unsigned long)[cc.appCrashLogs count]) : @""),
								encodedPrefs);


		urlString = makeString(@"mailto:%@?subject=%@&body=%@", recipient, subject, content);
	}
	else if (choice == openBetaSignupMail)
		urlString = makeString(@"s%@?subject=%@ Beta Versions&body=Hello\nI would like to test upcoming beta versions of %@.\nBye\n",
							   [bundle objectForInfoDictionaryKey:@"FeedbackEmail"], cc.appName, cc.appName);
	else if (choice == openHomepageWebsite)
		urlString = OBJECT_OR([bundle objectForInfoDictionaryKey:@"VendorProductPage"],
							  makeString(@"%@%@/", kVendorHomepage, [cc.appName.lowercaseString.words[0] split:@"-"][0]));
	else if (choice == openAppStoreWebsite)
		urlString = [bundle objectForInfoDictionaryKey:@"StoreProductPage"];
	else if (choice == openAppStoreApp)
		urlString = [[bundle objectForInfoDictionaryKey:@"StoreProductPage"] replaced:@"https" with:@"macappstore"];
	else if (choice == openMacupdateWebsite)
		urlString = [bundle objectForInfoDictionaryKey:@"MacupdateProductPage"];

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
    NSString *bundleID = [bundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
	NSString *tempDirectoryTemplate = [[NSTemporaryDirectory() stringByAppendingPathComponent:bundleID] stringByAppendingString:@".XXXXXX"];
	const char *tempDirectoryTemplateCString = tempDirectoryTemplate.fileSystemRepresentation;
	if (!tempDirectoryTemplateCString) return nil;

	char *tempDirectoryNameCString = (char *)malloc(strlen(tempDirectoryTemplateCString) + 1);
	strcpy(tempDirectoryNameCString, tempDirectoryTemplateCString);

	char *result = mkdtemp(tempDirectoryNameCString);
	if (!result)
	{
		free(tempDirectoryNameCString);
		return nil;
	}

	NSString *tempDirectoryPath = [fileManager stringWithFileSystemRepresentation:result length:strlen(result)];
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
    cc_log_error(@"alert_feedback %@ %@", usermsg, details);

	dispatch_block_t block = ^
	{
        static const int maxLen = 400;

        NSString *encodedPrefs = @"";
        
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
#if (__MAC_OS_X_VERSION_MIN_REQUIRED < 1090)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wpartial-availability"
#endif
		if ([NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
			encodedPrefs = [cc.prefsURL.contents base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
#if (__MAC_OS_X_VERSION_MIN_REQUIRED < 1090)
#pragma clang diagnostic pop
#endif
#endif

		NSString *visibleDetails = details;
		if (visibleDetails.length > maxLen)
			visibleDetails = makeString(@"%@  …\n(Remaining message omitted)", [visibleDetails clamp:maxLen]);
		NSString *message = makeString(@"%@\n\n You can contact our support with detailed information so that we can fix this problem.\n\nInformation: %@", usermsg, visibleDetails);
		NSString *mailtoLink = @"";
		@try
		{
			mailtoLink = makeString(@"mailto:%@?subject=%@ v%@ (%i) Problem Report (License code: %@)&body=Hello\nA %@ error in %@ occured (%@).\n\nBye\n\nP.S. Details: %@\n\n\nP.P.S: Hardware: %@ Software: %@ Admin: %i%@\n\nPreferences: %@\n Messages: %@\n",
												kFeedbackEmail,
												cc.appName,
												cc.appVersionString,
												cc.appBuildNumber,
												cc.appChecksumSHA,
												fatal ? @"fatal" : @"",
												cc.appName,
												usermsg,
												details,
												_machineType(),
												[[NSProcessInfo processInfo] operatingSystemVersionString],
												_isUserAdmin(),
												([cc.appCrashLogs count] ? makeString(@" Problems: %li", [cc.appCrashLogs count]) : @""),
												encodedPrefs,
												cc.appSystemLogEntries);

		}
		@catch (NSException *)
		{
		}


#if defined(USE_CRASHHELPER) && USE_CRASHHELPER
		if (fatal)
		{
			NSString *title = makeString(@"%@ Fatal Error", cc.appName);
			mailtoLink  = [mailtoLink clamp:100000]; // will expand to twice the size and kern.argmax: 262144 causes NSTask with too long arguments to 'silently' fail with a posix spawn error 7
			NSDictionary *dict = @{@"title" : title, @"message" : message, @"mailto" : mailtoLink};
			NSData *dictjsondata = dict.JSONData;
			NSString *dictjsondatahexstring = dictjsondata.hexString;
			NSString *crashhelperpath = @[cc.resDir, @"CrashHelper.app/Contents/MacOS/CrashHelper"].path;
			NSTask *taskApp = [[NSTask alloc] init];


			
			@try
			{
				taskApp.launchPath = crashhelperpath;
				taskApp.arguments = @[dictjsondatahexstring];

				[taskApp launch];
				[taskApp waitUntilExit];
			}
			@catch (NSException *exception)
			{
				cc_log_error(@"could not spawn crash helper %@", exception.userInfo);

				if (alert(fatal ? @"Fatal Error" : @"Error",
						  message,
						  @"Send to support", fatal ? @"Quit" : @"Continue", nil) == NSAlertFirstButtonReturn)
				{
					[mailtoLink.escaped.URL open];
				}
			}
		}
		else
#endif
		{
			if (alert(fatal ? @"Fatal Error" : @"Error",
					  message,
					  @"Send to support", fatal ? @"Quit" : @"Continue", nil) == NSAlertFirstButtonReturn)
			{
				[mailtoLink.escaped.URL open];
			}
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

NSInteger alert_checkbox(NSString *prompt, NSArray <NSString *>*buttons, NSString *checkboxTitle, NSUInteger *checkboxStatus)
{
	assert(buttons);
	assert(checkboxStatus);
	assert([NSThread currentThread] == [NSThread mainThread]);

	NSAlert *alert = [[NSAlert alloc] init];
	alert.messageText = prompt;

	if (buttons.count > 0)
		[alert addButtonWithTitle:buttons[0]];
	if (buttons.count > 1)
		[alert addButtonWithTitle:buttons[1]];
	if (buttons.count > 2)
		[alert addButtonWithTitle:buttons[2]];

	NSButton *input = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 310, 24)];
	[input setButtonType:NSSwitchButton];
	[input setState:(NSInteger )*checkboxStatus];
	[input setTitle:checkboxTitle];

	[alert setAccessoryView:input];
	NSInteger selectedButton = [alert runModal];

	*checkboxStatus = (NSUInteger)[input state];

#if ! __has_feature(objc_arc)
	[input release];
	[alert release];
#endif

	return selectedButton;
}

NSInteger alert_colorwell(NSString *prompt, NSArray <NSString *>*buttons, NSColor **selectedColor)
{
    assert(buttons);
    assert(selectedColor);
    assert([NSThread currentThread] == [NSThread mainThread]);

    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = prompt;

    if (buttons.count > 0)
        [alert addButtonWithTitle:buttons[0]];
    if (buttons.count > 1)
        [alert addButtonWithTitle:buttons[1]];
    if (buttons.count > 2)
        [alert addButtonWithTitle:buttons[2]];

    NSColorWell *input = [[NSColorWell alloc] initWithFrame:NSMakeRect(0, 0, 310, 24)];
    [input setColor:*selectedColor];

    [alert setAccessoryView:input];
    NSInteger selectedButton = [alert runModal];

    *selectedColor = [input color];

#if ! __has_feature(objc_arc)
    [input release];
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

NSInteger alert_selection_popup(NSString *prompt, NSArray<NSString *> *choices, NSArray<NSString *> *buttons, NSUInteger *result)
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
	*result = (NSUInteger)[input indexOfSelectedItem];

#if ! __has_feature(objc_arc)
	[alert release];
#endif

	return selectedButton;
}

NSInteger alert_selection_matrix(NSString *prompt, NSArray<NSString *> *choices, NSArray<NSString *> *buttons, NSUInteger *result)
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

	NSButtonCell *thepushbutton = [[NSButtonCell alloc] init];
	[thepushbutton setButtonType:NSRadioButton];

	NSMatrix *thepushbuttons = [[NSMatrix alloc] initWithFrame:NSMakeRect(0,0,269,17 * choices.count)
                                                          mode:NSRadioModeMatrix
                                                     prototype:thepushbutton
                                                  numberOfRows:(int)choices.count
                                               numberOfColumns:1];

	for (NSUInteger i = 0; i < choices.count; i++)
	{
		[thepushbuttons selectCellAtRow:(int)i column:0];

        NSString *title = choices[i];
        if (title.length > 150)
            title = makeString(@"%@ […] %@", [title substringToIndex:70], [title substringFromIndex:title.length-70]);

		[[thepushbuttons selectedCell] setTitle:title];
	}
	[thepushbuttons selectCellAtRow:0 column:0];

	[thepushbuttons sizeToFit];

	[alert setAccessoryView:thepushbuttons];
	[[alert window] makeFirstResponder:thepushbuttons];

	NSInteger selectedButton = [alert runModal];
//U	[[alert window] setInitialFirstResponder: thepushbuttons];

	*result = (NSUInteger)[thepushbuttons selectedRow];

#if ! __has_feature(objc_arc)
	[thepushbuttons release];
	[thepushbutton release];
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


NSColor *makeColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
	return [NSColor colorWithCalibratedRed:(r) green:(g) blue:(b) alpha:(a)];
}
NSColor *makeColor255(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
	return [NSColor colorWithCalibratedRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 255.0];
}
#else
UIColor *makeColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
	return [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)];
}
UIColor *makeColor255(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
	return [UIColor colorWithRed:(r) / (CGFloat)255.0 green:(g) / (CGFloat)255.0 blue:(b) / (CGFloat)255.0 alpha:(a) / (CGFloat)255.0];
}
#endif

__inline__ CGFloat generateRandomFloatBetween(CGFloat a, CGFloat b)
{
	return a + (b - a) * (random() / (CGFloat) RAND_MAX);
}

__inline__ int generateRRandomIntBetween(int a, int b)
{
	int range = b - a < 0 ? b - a - 1 : b - a + 1;
	long rand = random();
	int value = (int)(range * ((CGFloat)rand  / (CGFloat) RAND_MAX));
	return value == range ? a : a + value;
}


// logging support


#undef asl_log
#undef os_log
#if __has_feature(modules) && ((defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 101200) || (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000)))
@import asl;
@import os.log;
#else
#include <asl.h>
#include <os/log.h>
#endif



static NSFileHandle *logfileHandle;
void cc_log_enablecapturetofile(NSURL *fileURL, unsigned long long filesizeLimit) // ASL broken on 10.12+ and especially logging to file not working anymore
{
    assert(!logfileHandle);

    if (!fileURL.fileExists)
        [NSData.data writeToURL:fileURL atomically:YES]; // create file with weird API
    else if (filesizeLimit) // truncate first
    {
        NSString *path = fileURL.path;

        unsigned long long filesize = [[[fileManager attributesOfItemAtPath:path error:NULL] objectForKey:@"NSFileSize"] unsignedLongLongValue];

        if (filesize > filesizeLimit)
        {
            NSFileHandle *fh = [NSFileHandle fileHandleForUpdatingURL:fileURL error:nil];

            [fh seekToFileOffset:(filesize - filesizeLimit)];

            NSData *data = [fh readDataToEndOfFile];

            [fh seekToFileOffset:0];
            [fh writeData:data];
            [fh truncateFileAtOffset:filesizeLimit];
            [fh synchronizeFile];
            [fh closeFile];
        }
    }

    // now open for appending
    logfileHandle = [NSFileHandle fileHandleForUpdatingURL:fileURL error:nil];

    if (!logfileHandle)
    {
        cc_log_error(@"could not open file %@ for log file usage", fileURL.path);
    }
#if  !__has_feature(objc_arc)
    [logfileHandle retain];
#endif
}

void _cc_log_tologfile(int level, NSString *string)
{
    if (logfileHandle)
    {
        static const char* levelNames[8] = {ASL_STRING_EMERG, ASL_STRING_ALERT, ASL_STRING_CRIT, ASL_STRING_ERR, ASL_STRING_WARNING, ASL_STRING_NOTICE, ASL_STRING_INFO, ASL_STRING_DEBUG};
        assert(level < 8);
        NSString *levelStr = @(levelNames[level]);
        NSString *dayString = [NSDate.date stringUsingFormat:@"MMM dd"];
        NSString *timeString = [NSDate.date stringUsingDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        NSString *finalString = makeString(@"%@ %@  %@[%i] <%@>: %@\n",
                                           dayString,
                                           timeString,
                                           cc.appName,
                                           NSProcessInfo.processInfo.processIdentifier,
                                           levelStr,
                                           string);

        [logfileHandle seekToEndOfFile];

        NSData *data = [finalString dataUsingEncoding:NSUTF8StringEncoding];

        if (data)
            [logfileHandle writeData:data];
        else
            cc_log_error(@"could not open create data from string %@ for log", finalString);
    }
}

void _cc_log_toprefs(int level, NSString *string)
{
#ifndef DONTLOGASLTOUSERDEFAULTS
    static int lastPosition[8] = {0,0,0,0,0,0,0,0};
    assert(level < 8);
    NSString *key = makeString(@"corelib_asl_lev%i_pos%i", level, lastPosition[level]);
    key.defaultString = makeString(@"date: %@ message: %@", NSDate.date.description, string);
    lastPosition[level]++;
    if (lastPosition[level] > 9)
        lastPosition[level] = 0;
#endif
}


void cc_log_level(int level, NSString *format, ...)
{
    assert(level >= 0);
    assert(level < 8);
	va_list args;
	va_start(args, format);
	NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
	va_end(args);

    _cc_log_tologfile(level, str);
    _cc_log_toprefs(level, str);


    if (OS_IS_POST_10_11)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wpartial-availability"
        const char *utf = str.UTF8String;

        if (level == ASL_LEVEL_DEBUG || level == ASL_LEVEL_INFO)
            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG, "%s", utf);
        else if (level == ASL_LEVEL_NOTICE || level == ASL_LEVEL_WARNING)
            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEFAULT, "%s", utf);
        else if (level == ASL_LEVEL_ERR)
            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_ERROR, "%s", utf);
        else if (level == ASL_LEVEL_CRIT || level == ASL_LEVEL_ALERT || level == ASL_LEVEL_EMERG)
            os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_FAULT, "%s", utf);
#pragma clang diagnostic pop
    }
    else
        asl_log(NULL, NULL, level, "%s", str.UTF8String);

#if ! __has_feature(objc_arc)
	[str release];
#endif
}

void log_to_prefs(NSString *str)
{
    static int lastPosition = 0;

    NSString *key = makeString(@"corelib_logtoprefs_pos%i", lastPosition);

    key.defaultString = makeString(@"date: %@ message: %@", NSDate.date.description, str);

    lastPosition++;

    if (lastPosition > 42)
        lastPosition = 0;
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
		block();	// using with dispatch_sync would deadlock when on the main thread
	else
		dispatch_sync(dispatch_get_main_queue(), block);
}

void dispatch_sync_back(dispatch_block_t block)
{
	dispatch_sync(dispatch_get_global_queue(0, 0), block);
}
#if ((defined(MAC_OS_X_VERSION_MIN_REQUIRED) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_10) || (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000))
BOOL dispatch_sync_back_timeout(dispatch_block_t block, float timeoutSeconds) // returns 0 on succ
{
    dispatch_block_t newblock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block);
    dispatch_async(dispatch_get_global_queue(0, 0), newblock);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeoutSeconds * NSEC_PER_SEC));
    return dispatch_block_wait(newblock, popTime) != 0;
}
#endif

// private
#if __has_feature(modules)
@import Darwin.POSIX.sys.types;
@import Darwin.sys.sysctl;
@import Darwin.POSIX.pwd;
@import Darwin.POSIX.grp;
#else
#include <sys/types.h>
#include <sys/sysctl.h>
#include <pwd.h>
#include <grp.h>
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
BOOL _isUserAdmin()
{
    uid_t current_user_id = getuid();
    struct passwd *pwentry = getpwuid(current_user_id);
    struct group *admin_group = getgrnam("admin");
    while(*admin_group->gr_mem != NULL)
    {
        if (strcmp(pwentry->pw_name, *admin_group->gr_mem) == 0)
        {
            return YES;
        }
        admin_group->gr_mem++;
    }
    
    return NO;
}

