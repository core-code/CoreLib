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

@dynamic appCrashLogs, appBundleIdentifier, appBuildNumber, appVersionString, appName, resDir, docDir, suppDir, resURL, docURL, suppURL, deskDir, deskURL, prefsPath, prefsURL, homeURL, appSystemLogEntries
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



        
    #ifdef DEBUG
        asl_add_log_file(NULL, STDERR_FILENO);
    #endif
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
            [fileManager createDirectoryAtURL:self.suppURL
                  withIntermediateDirectories:YES attributes:nil error:NULL];

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
            asl_NSLog_debug(@"Warning: app can hide dock symbol but has no fixed principal class");


        if (![[[bundle objectForInfoDictionaryKey:@"MacupdateProductPage"] lowercaseString] contains:self.appName.lowercaseString])
            asl_NSLog_debug(@"Warning: info.plist key MacupdateProductPage not properly set");

        if ([[[bundle objectForInfoDictionaryKey:@"MacupdateProductPage"] lowercaseString] contains:@"/find/"])
            asl_NSLog_debug(@"Warning: info.plist key MacupdateProductPage should be updated to proper product page");

        if (![[[bundle objectForInfoDictionaryKey:@"StoreProductPage"] lowercaseString] contains:self.appName.lowercaseString])
            asl_NSLog_debug(@"Warning: info.plist key StoreProductPage not properly set (%@ NOT CONTAINS %@", [[bundle objectForInfoDictionaryKey:@"StoreProductPage"] lowercaseString], self.appName.lowercaseString);

        if (![(NSString *)[bundle objectForInfoDictionaryKey:@"LSApplicationCategoryType"] length])
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

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSArray <NSString *> *)appSystemLogEntries
{
#ifndef SANDBOX
	NSMutableArray <NSString *>*messages = makeMutableArray();

#if ! __has_feature(objc_arc)
	[messages autorelease];
#endif
	aslmsg query = asl_new(ASL_TYPE_QUERY);

	if (asl_set_query(query, ASL_KEY_SENDER, cc.appName.UTF8String , (ASL_QUERY_OP_EQUAL | ASL_QUERY_OP_SUBSTRING | ASL_QUERY_OP_CASEFOLD))) return nil;

	aslresponse response = asl_search(NULL, query);

	asl_free(query);

	aslmsg msg;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    if (OS_IS_POST_10_9)
    {
        while ((msg = asl_next(response)))
        {
            const char *m = asl_get(msg, ASL_KEY_MSG);
			NSDate *time = [NSDate dateWithTimeIntervalSince1970:@(asl_get(msg, ASL_KEY_TIME)).doubleValue];
			NSString *line = makeString(@"%@: %@", time.description, @(m));

            [messages addObject:line];
        }
    }
    else
    {
        while ((msg = aslresponse_next(response)))
        {
            const char *m = asl_get(msg, ASL_KEY_MSG);
			NSDate *time = [NSDate dateWithTimeIntervalSince1970:@(asl_get(msg, ASL_KEY_TIME)).doubleValue];
			NSString *line = makeString(@"%@: %@", time.description, @(m));

            [messages addObject:line];
        }
    }

    if (OS_IS_POST_10_9)
        asl_release(response);
    else
        aslresponse_free(response);

#pragma clang diagnostic pop


	return messages.immutableObject;
#else
	return nil;
#endif
}
#endif

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

- (NSURL *)homeURL
{
	return NSHomeDirectory().fileURL;
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
    asl_NSLog(ASL_LEVEL_ERR, @"alert_feedback %@ %@", usermsg, details);

	dispatch_block_t block = ^
	{
        static const int maxLen = 400;

        NSString *encodedPrefs = @"";
        
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
#if (__MAC_OS_X_VERSION_MIN_REQUIRED < 1090)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
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

		if (alert(fatal ? @"Fatal Error" : @"Error",
                  makeString(@"%@\n\n You can contact our support with detailed information so that we can fix this problem.\n\nInformation: %@", usermsg, visibleDetails),
				  @"Send to support", fatal ? @"Quit" : @"Continue", nil) == NSAlertFirstButtonReturn)
		{
			NSString *mailtoLink = makeString(@"mailto:feedback@corecode.at?subject=%@ v%@ (%i) Problem Report (License code: %@)&body=Hello\nA %@ error in %@ occured (%@).\n\nBye\n\nP.S. Details: %@\n\n\nP.P.S: Hardware: %@ Software: %@ Admin: %i%@\n\nPreferences: %@\n Messages: %@\n",
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

	NSMatrix *thepushbuttons = [[NSMatrix alloc]initWithFrame:NSMakeRect(0,0,269,17 * choices.count)
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

