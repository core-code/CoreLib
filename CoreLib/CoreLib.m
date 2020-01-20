//
//  CoreLib.m
//  CoreLib
//
//  Created by CoreCode on 17.12.12.
/*    Copyright © 2020 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "CoreLib.h"
#ifndef CORELIB
#error you need to include CoreLib.h in your PCH file
#endif
#ifdef USE_SECURITY
#if __has_feature(modules)
@import CommonCrypto.CommonDigest;
#else
#include <CommonCrypto/CommonDigest.h>
#endif
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
NSString *_machineType(void);
BOOL _isUserAdmin(void);
__attribute__((noreturn)) void exceptionHandler(NSException *exception)
{
    alert_feedback_fatal(exception.name, makeString(@" %@ %@ %@ %@", exception.description, exception.reason, exception.userInfo.description, exception.callStackSymbols));
}
#endif

@implementation CoreLib

@dynamic appCrashLogs, appCrashLogFilenames, appBundleIdentifier, appBuildNumber, appVersionString, appName, resDir, docDir, suppDir, resURL, docURL, suppURL, deskDir, deskURL, prefsPath, prefsURL, homeURLInsideSandbox, homeURLOutsideSandbox
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

        userDefaults = NSUserDefaults.standardUserDefaults;
        fileManager = NSFileManager.defaultManager;
        notificationCenter = NSNotificationCenter.defaultCenter;
        bundle = NSBundle.mainBundle;
    #if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
        fontManager = NSFontManager.sharedFontManager;
        distributedNotificationCenter = NSDistributedNotificationCenter.defaultCenter;
        workspace = NSWorkspace.sharedWorkspace;
        application = NSApplication.sharedApplication;
        processInfo = NSProcessInfo.processInfo;
    #endif

#ifndef SKIP_CREATE_APPSUPPORT_DIRECTORY
        if (self.appName)
        {
            BOOL exists = self.suppURL.fileExists;
            
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
            if ((!exists && self.suppURL.fileIsSymlink) ||  // broken symlink
                (exists && !self.suppURL.fileIsDirectory))  // not a folder
            {
                alert_apptitled(makeString(@"This application can not be launched because its 'Application Support' folder is not a folder but a file. Please remove the file '%@' and re-launch this app.", self.suppURL.path), @"OK", nil, nil);
            }
            else
#endif
                if (!exists) // non-existant
            {
                NSError *error;
                BOOL succ = [fileManager createDirectoryAtURL:self.suppURL withIntermediateDirectories:YES attributes:nil error:&error];
                if (!succ)
                {
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
                    alert_apptitled(makeString(@"This application can not be launched because the 'Application Support' can not be created at the path '%@'.\nError: %@", self.suppURL.path, error.localizedDescription), @"OK", nil, nil);
#else
                    cc_log(@"This application can not be launched because the 'Application Support' can not be created at the path '%@'.\nError: %@", self.suppURL.path, error.localizedDescription);

#endif
                    exit(1);
                }
            }
        }
#endif

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
            if (![[self appBundleIdentifier] isEqualToString:bundleID] && self.appName)
            {
                cc_log_error(@"Error: bundle identifier doesn't match");

                exit(666);
            }
        #endif

        if ([(NSNumber *)[bundle objectForInfoDictionaryKey:@"LSUIElement"] boolValue] &&
            ![(NSString *)[bundle objectForInfoDictionaryKey:@"NSPrincipalClass"] isEqualToString:@"JMDocklessApplication"])
            cc_log_debug(@"Warning: app can hide dock symbol but has no fixed principal class");

#ifndef CLI
        if (![[(NSString *)[bundle objectForInfoDictionaryKey:@"MacupdateProductPage"] lowercaseString] contains:self.appName.lowercaseString])
            cc_log_debug(@"Warning: info.plist key MacupdateProductPage not properly set");

        if ([[(NSString *)[bundle objectForInfoDictionaryKey:@"MacupdateProductPage"] lowercaseString] contains:@"/find/"])
            cc_log_debug(@"Warning: info.plist key MacupdateProductPage should be updated to proper product page");

        if (![[(NSString *)[bundle objectForInfoDictionaryKey:@"StoreProductPage"] lowercaseString] contains:self.appName.lowercaseString])
            cc_log_debug(@"Warning: info.plist key StoreProductPage not properly set (%@ NOT CONTAINS %@", [(NSString *)[bundle objectForInfoDictionaryKey:@"StoreProductPage"] lowercaseString], self.appName.lowercaseString);

        if (!((NSString *)[bundle objectForInfoDictionaryKey:@"LSApplicationCategoryType"]).length)
            LOG(@"Warning: LSApplicationCategoryType not properly set")
#endif
        
        
        
        if (NSClassFromString(@"JMRatingWindowController") &&
            NSProcessInfo.processInfo.environment[@"XCInjectBundleInto"] != nil)
        {
            assert(@"icon-appstore".namedImage);
            assert(@"icon-macupdate".namedImage);
            assert(@"JMRatingWindow.nib".resourceURL);
        }
        #ifdef USE_SPARKLE
            assert(@"dsa_pub.pem".resourceURL);
        #endif
    #else
        #if !defined(NDEBUG) && !defined(CLI)
            cc_log_error(@"Warning: you are not running in DEBUG mode but have not disabled assertions (NDEBUG)");
        #endif
    #endif

        
    #if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
    #ifndef DONT_CRASH_ON_EXCEPTIONS
        NSSetUncaughtExceptionHandler(&exceptionHandler);
    #endif


        #if !defined(XCTEST) || !XCTEST

        NSString *frameworkPath = bundle.privateFrameworksPath;
        for (NSString *framework in frameworkPath.directoryContents)
        {
            NSString *smylinkToBinaryPath = makeString(@"%@/%@/%@", frameworkPath, framework, framework.stringByDeletingPathExtension);

            if (!smylinkToBinaryPath.fileIsAlias)
            {
#ifdef DEBUG
                if ([framework hasPrefix:@"libclang"]) continue;
#endif
                alert_apptitled(makeString(@"This application is damaged. Either your download was damaged or you used a faulty program to extract the ZIP archive. Please re-download and make sure to use the ZIP decompression built into Mac OS X.\n\nOffending Path: %@", smylinkToBinaryPath), @"OK", nil, nil);
                exit(1);
            }
#ifdef DEBUG
            NSString *versionsPath = makeString(@"%@/%@/Versions", frameworkPath, framework);
            for (NSString *versionsEntry in versionsPath.directoryContents)
            {
                if ((![versionsEntry isEqualToString:@"A"]) && (![versionsEntry isEqualToString:@"Current"]))
                {
                    cc_log_error(@"The frameworks are damaged probably by lowercasing. Either your download was damaged or you used a faulty program to extract the ZIP archive. Please re-download and make sure to use the ZIP decompression built into Mac OS X.");
                    exit(1);
                }
            }
            NSString *versionAPath = makeString(@"%@/%@/Versions/A", frameworkPath, framework);
            for (NSString *entry in versionAPath.directoryContents)
            {
                if (([entry isEqualToString:@"headers"]) && (![entry isEqualToString:@"resources"]))
                {
                    cc_log_error(@"The frameworks are damaged probably by lowercasing. Either your download was damaged or you used a faulty program to extract the ZIP archive. Please re-download and make sure to use the ZIP decompression built into Mac OS X.");
                    exit(1);
                }
            }
#endif
        }
    #endif
#endif
        
        RANDOM_INIT
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

- (NSArray *)appCrashLogFilenames // doesn't do anything in sandbox!
{
    NSArray <NSString *> *logs1 = @"~/Library/Logs/DiagnosticReports/".expanded.directoryContents;
    logs1 = [logs1 filteredUsingPredicateString:@"self BEGINSWITH[cd] %@", self.appName];
    logs1 = [logs1 mapped:^id(NSString *input) { return [@"~/Library/Logs/DiagnosticReports/".stringByExpandingTildeInPath stringByAppendingPathComponent:input]; }];
    NSArray <NSString *> *logs2 = @"/Library/Logs/DiagnosticReports/".expanded.directoryContents;
    logs2 = [logs2 filteredUsingPredicateString:@"self BEGINSWITH[cd] %@", self.appName];
    logs2 = [logs2 mapped:^id(NSString *input) { return [@"/Library/Logs/DiagnosticReports/" stringByAppendingPathComponent:input]; }];

    
    NSArray <NSString *> *logs = [logs1 arrayByAddingObjectsFromArray:logs2];
    return logs;
}

- (NSArray *)appCrashLogs // doesn't do anything in sandbox!
{
    NSArray <NSString *> *logFilenames = self.appCrashLogFilenames;
    NSArray <NSString *> *logs = [logFilenames mapped:^id(NSString *input) { return [input.contents.string split:@"/System/Library/"][0]; }];

    return logs;
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
    NSString *bundleVersion = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    return bundleVersion.intValue;
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

    return self.appName ? [dir add:self.appName] : nil;
}

- (NSString *)appChecksumSHA
{
    NSURL *u = NSBundle.mainBundle.executableURL;
    
    return u.fileChecksumSHA;
}

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (void)sendSupportRequestMail:(NSString *)text
{
    NSString *urlString = @"";

    NSString *encodedPrefs = @"";
    NSString *crashReports = @"";

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
    BOOL optionDown = ([NSEvent modifierFlags] & NSEventModifierFlagOption) != 0;
    if (optionDown)
    {
        encodedPrefs = makeString(@"Preferences (BASE64): %@", [self.prefsURL.contents base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0]);
    }
#ifndef SANDBOX
    if ((cc.appCrashLogFilenames).count)
    {
        NSArray <NSString *> *logFilenames = cc.appCrashLogFilenames;
        NSString *crashes = @"";
        for (NSString *path in logFilenames)
        {
            if (![path hasSuffix:@"crash"]) continue;
            
            NSString *token = makeString(@"DSC_%@", path);
            if (!token.defaultInt)
            {
                NSString *additionalCrash = [path.contents.string split:@"/System/Library/"][0];
                if (crashes.length + additionalCrash.length < 100000)
                {
                    crashes = [crashes stringByAppendingString:additionalCrash];
                    token.defaultInt = 1; // we don't wanna send crashes twice, but erasing them is probably not OK
                }
            }
        }
        crashReports = makeString(@"Crash Reports: \n\n%@", crashes);
    }
#endif
#endif

    NSString *appName = cc.appName;
    NSString *licenseCode = cc.appChecksumSHA;
    NSString *recipient = OBJECT_OR([bundle objectForInfoDictionaryKey:@"FeedbackEmail"], kFeedbackEmail);
    NSString *udid = @"N/A";
    
#if defined(USE_SECURITY) && defined(USE_IOKIT)
    Class hostInfoClass = NSClassFromString(@"JMHostInformation");
    if (hostInfoClass)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        NSString *macAddress = [hostInfoClass performSelector:@selector(macAddress)];
#pragma clang diagnostic pop
        udid = macAddress.SHA1;
    }
#endif
    
    if ([NSApp.delegate respondsToSelector:@selector(customSupportRequestAppName)])
        appName = [NSApp.delegate performSelector:@selector(customSupportRequestAppName)];
    if ([NSApp.delegate respondsToSelector:@selector(customSupportRequestLicense)])
        licenseCode = [NSApp.delegate performSelector:@selector(customSupportRequestLicense)];
    
    NSString *subject = makeString(@"%@ v%@ (%i) Support Request (License code: %@)",
                                   appName,
                                   cc.appVersionString,
                                   cc.appBuildNumber,
                                   licenseCode);
    
    NSString *content =  makeString(@"%@\n\n\n\nP.S: Hardware: %@ Software: %@ UDID: %@\n%@\n%@",
                                    text,
                                    _machineType(),
                                    NSProcessInfo.processInfo.operatingSystemVersionString,
                                    udid,
                                    encodedPrefs,
                                    crashReports);
    
    
    urlString = makeString(@"mailto:%@?subject=%@&body=%@", recipient, subject, content);
    
    [urlString.escaped.URL open];
}
#endif

- (void)openURL:(openChoice)choice
{
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
    if (choice == openSupportRequestMail)
    {
        [self sendSupportRequestMail:@"<Insert Support Request Here>"];
        return;
    }
#endif
    
    NSString *urlString = @"";

    if (choice == openBetaSignupMail)
        urlString = makeString(@"s%@?subject=%@ Beta Versions&body=Hello\nI would like to test upcoming beta versions of %@.\nBye\n",
                               [bundle objectForInfoDictionaryKey:@"FeedbackEmail"], cc.appName, cc.appName);
    else if (choice == openHomepageWebsite)
        urlString = OBJECT_OR([bundle objectForInfoDictionaryKey:@"VendorProductPage"],
                              makeString(@"%@%@/", kVendorHomepage, [cc.appName.lowercaseString.words[0] split:@"-"][0]));
    else if (choice == openAppStoreWebsite)
        urlString = [bundle objectForInfoDictionaryKey:@"StoreProductPage"];
    else if (choice == openAppStoreApp)
    {
        NSString *spp = [bundle objectForInfoDictionaryKey:@"StoreProductPage"];
        urlString = [spp replaced:@"https" with:@"macappstore"];
        urlString = [urlString stringByAppendingString:@"&at=1000lwks"];
        
        if (!urlString)
            urlString = [bundle objectForInfoDictionaryKey:@"AlternativetoProductPage"];
    }
    else if (choice == openMacupdateWebsite)
    {
        urlString = [bundle objectForInfoDictionaryKey:@"MacupdateProductPage"];
        
        if (!urlString)
            urlString = [bundle objectForInfoDictionaryKey:@"FilehorseProductPage"];
    }

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

NSDictionary<NSString *, id> * _makeDictionaryOfVariables(NSString *commaSeparatedKeysString, id firstValue, ...)
{
    NSUInteger i = 0;
    NSArray <NSString *> *argumentNames = [commaSeparatedKeysString split:@","];
    
    if (!argumentNames.count) return nil;
    
    NSMutableDictionary *dict = makeMutableDictionary();
    va_list args;
    va_start(args, firstValue);
    
    NSString *firstArgumentName = argumentNames.firstObject.trimmedOfWhitespaceAndNewlines;
    dict[firstArgumentName] = OBJECT_OR(firstValue, @"(null)");

    for (NSString *name in argumentNames)
    {
        if (i!=0)
        {
            id arg = va_arg(args, id);
            dict[name.trimmedOfWhitespaceAndNewlines] = OBJECT_OR(arg, @"(null)");
        }
        i++;
    }
    va_end(args);
    return dict;
}

NSString *makeDescription(NSObject *sender, NSArray *args)
{
    NSMutableString *tmp = [NSMutableString new];

    for (NSString *arg in args)
    {
        NSObject *value = [sender valueForKey:arg];
        NSString *d = [value description];

        [tmp appendFormat:@"\n%@: %@", arg, d];
    }

    return tmp.immutableObject;
}

NSString *makeLocalizedString(NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format.localized arguments:args];
    va_end(args);
    
    return str;
}

NSString *makeString(NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    return str;
}

NSString *makeTempDirectory()
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

NSString *makeTempFilepath(NSString *extension)
{
    NSString *tempDir = makeTempDirectory();
    if (!tempDir)
        return nil;
    NSString *fileName = [@"1." stringByAppendingString:extension];
    NSString *filePath = @[tempDir, fileName].path;
    NSString *finalPath = filePath.uniqueFile;

    return finalPath;
}

NSValue *makeRectValue(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
    return [NSValue valueWithRect:CGRectMake(x, y, width, height)];
#else
    return [NSValue valueWithCGRect:CGRectMake(x, y, width, height)];
#endif
}

#ifdef USE_LAM
#import "NSData+LAMCompression.h"
#endif

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
void alert_feedback(NSString *usermsg, NSString *details, BOOL fatal)
{
    cc_log_error(@"alert_feedback %@ %@", usermsg, details);

    dispatch_block_t block = ^
    {
        static const int maxLen = 400;

        NSString *encodedPrefs = @"";
        
        [NSUserDefaults.standardUserDefaults synchronize];
        
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
        NSData *prefsData = cc.prefsURL.contents;
        
#ifdef USE_LAM
        prefsData = [prefsData lam_compressedDataUsingCompression:LAMCompressionZLIB];
#endif
        
        encodedPrefs = [prefsData base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];

#ifndef SANDBOX
        if ((cc.appCrashLogFilenames).count)
        {
            NSString *crashes = [cc.appCrashLogs joined:@"\n"];
            encodedPrefs = [encodedPrefs stringByAppendingString:@"\n\n"];
            encodedPrefs = [encodedPrefs stringByAppendingString:crashes];
        }
#endif
#endif
        
        NSString *visibleDetails = details;
        if (visibleDetails.length > maxLen)
            visibleDetails = makeString(@"%@  …\n(Remaining message omitted)", [visibleDetails clamp:maxLen]);
        NSString *message = makeString(@"%@\n\n You can contact our support with detailed information so that we can fix this problem.\n\nInformation: %@", usermsg, visibleDetails);
        NSString *mailtoLink = @"";
        @try
        {
            NSString *appName = cc.appName;
            NSString *licenseCode = cc.appChecksumSHA;

            if ([NSApp.delegate respondsToSelector:@selector(customSupportRequestAppName)])
                appName = [NSApp.delegate performSelector:@selector(customSupportRequestAppName)];
            if ([NSApp.delegate respondsToSelector:@selector(customSupportRequestLicense)])
                licenseCode = [NSApp.delegate performSelector:@selector(customSupportRequestLicense)];
            
            mailtoLink = makeString(@"mailto:%@?subject=%@ v%@ (%i) Problem Report (License code: %@)&body=Hello\nA %@ error in %@ occurred (%@).\n\nBye\n\nP.S. Details: %@\n\n\nP.P.S: Hardware: %@ Software: %@ Admin: %i\n\nPreferences: %@\n",
                                                kFeedbackEmail,
                                                appName,
                                                cc.appVersionString,
                                                cc.appBuildNumber,
                                                licenseCode,
                                                fatal ? @"fatal" : @"",
                                                cc.appName,
                                                usermsg,
                                                details,
                                                _machineType(),
                                                NSProcessInfo.processInfo.operatingSystemVersionString,
                                                _isUserAdmin(),
                                                encodedPrefs);

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
                while (taskApp.isRunning)
                {
                    [NSThread sleepForTimeInterval:0.05];
                }
            }
            @catch (NSException *exception)
            {
                cc_log_error(@"could not spawn crash helper %@", exception.userInfo);

                if (alert(fatal ? @"Fatal Error".localized : @"Error".localized,
                          message,
                          @"Send to support".localized, fatal ? @"Quit".localized : @"Continue".localized, nil) == NSAlertFirstButtonReturn)
                {
                    [mailtoLink.escaped.URL open];
                }
            }
        }
        else
#endif
        {
            if (alert(fatal ? @"Fatal Error".localized : @"Error".localized,
                      message,
                      @"Send to support".localized, fatal ? @"Quit".localized : @"Continue".localized, nil) == NSAlertFirstButtonReturn)
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
    ASSERT_MAINTHREAD;

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

    alert.accessoryView = input;
    NSInteger selectedButton = [alert runModal];

    [input validateEditing];
    *result = input.stringValue;
    
    return selectedButton;
}

NSInteger alert_checkbox(NSString *title, NSString *prompt, NSArray <NSString *>*buttons, NSString *checkboxTitle, NSUInteger *checkboxStatus)
{
    assert(buttons);
    assert(checkboxStatus);
    ASSERT_MAINTHREAD;

    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = title;
    alert.informativeText = prompt;

    if (buttons.count > 0)
        [alert addButtonWithTitle:buttons[0]];
    if (buttons.count > 1)
        [alert addButtonWithTitle:buttons[1]];
    if (buttons.count > 2)
        [alert addButtonWithTitle:buttons[2]];

    NSButton *input = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 310, 24)];
    [input setButtonType:NSButtonTypeSwitch];
    input.state = (NSInteger )*checkboxStatus;
    input.title = checkboxTitle;

    alert.accessoryView = input;
    NSInteger selectedButton = [alert runModal];

    *checkboxStatus = (NSUInteger)input.state;


    return selectedButton;
}

NSInteger alert_colorwell(NSString *prompt, NSArray <NSString *>*buttons, NSColor **selectedColor)
{
    assert(buttons);
    assert(selectedColor);
    ASSERT_MAINTHREAD;

    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = prompt;

    if (buttons.count > 0)
        [alert addButtonWithTitle:buttons[0]];
    if (buttons.count > 1)
        [alert addButtonWithTitle:buttons[1]];
    if (buttons.count > 2)
        [alert addButtonWithTitle:buttons[2]];

    NSColorWell *input = [[NSColorWell alloc] initWithFrame:NSMakeRect(0, 0, 310, 24)];
    input.color = *selectedColor;

    alert.accessoryView = input;
    NSInteger selectedButton = [alert runModal];

    *selectedColor = input.color;
    
    return selectedButton;
}

NSInteger alert_inputtext(NSString *prompt, NSArray *buttons, NSString **result)
{
    assert(buttons);
    assert(result);
    ASSERT_MAINTHREAD;

    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = prompt;

    if (buttons.count > 0)
        [alert addButtonWithTitle:buttons[0]];
    if (buttons.count > 1)
        [alert addButtonWithTitle:buttons[1]];
    if (buttons.count > 2)
        [alert addButtonWithTitle:buttons[2]];

    NSScrollView *scrollview = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, 310, 200)];
    NSSize contentSize = [scrollview contentSize];
    
    [scrollview setBorderType:NSNoBorder];
    [scrollview setHasVerticalScroller:YES];
    [scrollview setHasHorizontalScroller:NO];
    [scrollview setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    NSTextView *theTextView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height)];
    [theTextView setMinSize:NSMakeSize(0.0, contentSize.height)];
    [theTextView setMaxSize:NSMakeSize((CGFloat)FLT_MAX, (CGFloat)FLT_MAX)];
    [theTextView setVerticallyResizable:YES];
    [theTextView setHorizontallyResizable:NO];
    [theTextView setAutoresizingMask:NSViewWidthSizable];

    
    [[theTextView textContainer] setContainerSize:NSMakeSize(contentSize.width, (CGFloat)FLT_MAX)];
    [[theTextView textContainer] setWidthTracksTextView:YES];
    
    [scrollview setDocumentView:theTextView];

    
    NSString *inputString = *result;
    if (inputString.length)
        theTextView.string = inputString;
    
    alert.accessoryView = scrollview;
    NSInteger selectedButton = [alert runModal];
    *result = theTextView.string;

    return selectedButton;
}

NSInteger alert_outputtext(NSString *message, NSArray *buttons, NSString *text)
{
    assert(buttons);
    ASSERT_MAINTHREAD;
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = message;
    
    if (buttons.count > 0)
        [alert addButtonWithTitle:buttons[0]];
    if (buttons.count > 1)
        [alert addButtonWithTitle:buttons[1]];
    if (buttons.count > 2)
        [alert addButtonWithTitle:buttons[2]];
    
    NSScrollView *scrollview = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, 310, 200)];
    NSSize contentSize = [scrollview contentSize];
    
    [scrollview setBorderType:NSNoBorder];
    [scrollview setHasVerticalScroller:YES];
    [scrollview setHasHorizontalScroller:NO];
    [scrollview setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    NSTextView *theTextView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height)];
    [theTextView setMinSize:NSMakeSize(0.0, contentSize.height)];
    [theTextView setMaxSize:NSMakeSize((CGFloat)FLT_MAX, (CGFloat)FLT_MAX)];
    [theTextView setVerticallyResizable:YES];
    [theTextView setHorizontallyResizable:NO];
    [theTextView setAutoresizingMask:NSViewWidthSizable];

    
    [[theTextView textContainer] setContainerSize:NSMakeSize(contentSize.width, (CGFloat)FLT_MAX)];
    [[theTextView textContainer] setWidthTracksTextView:YES];
    
    [scrollview setDocumentView:theTextView];

    
    theTextView.editable = NO;
    theTextView.string = text;
    
    alert.accessoryView = scrollview;
    NSInteger selectedButton = [alert runModal];
    
    
    return selectedButton;
}

NSInteger alert_selection_popup(NSString *prompt, NSArray<NSString *> *choices, NSArray<NSString *> *buttons, NSUInteger *result)
{
    assert(buttons);
    assert(choices);
    assert(result);
    ASSERT_MAINTHREAD;

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

    alert.accessoryView = input;
    NSInteger selectedButton = [alert runModal];

    [input validateEditing];
    *result = (NSUInteger)input.indexOfSelectedItem;

    return selectedButton;
}

NSInteger alert_selection_matrix(NSString *prompt, NSArray<NSString *> *choices, NSArray<NSString *> *buttons, NSUInteger *result)
{
    assert(buttons);
    assert(result);
    ASSERT_MAINTHREAD;

    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = prompt;

    if (buttons.count > 0)
        [alert addButtonWithTitle:buttons[0]];
    if (buttons.count > 1)
        [alert addButtonWithTitle:buttons[1]];
    if (buttons.count > 2)
        [alert addButtonWithTitle:buttons[2]];

    NSButtonCell *thepushbutton = [[NSButtonCell alloc] init];
    [thepushbutton setButtonType:NSButtonTypeRadio];

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

        [thepushbuttons.selectedCell setTitle:title];
    }
    [thepushbuttons selectCellAtRow:0 column:0];

    [thepushbuttons sizeToFit];

    alert.accessoryView = thepushbuttons;
    //[[alert window] makeFirstResponder:thepushbuttons];

    NSInteger selectedButton = [alert runModal];
//U    [[alert window] setInitialFirstResponder: thepushbuttons];

    *result = (NSUInteger)thepushbuttons.selectedRow;


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

__attribute__((annotate("returns_localized_nsstring"))) static inline NSString *LocalizationNotNeeded(NSString *s) { return s; }
NSInteger alert(NSString *title, NSString *message, NSString *defaultButton, NSString *alternateButton, NSString *otherButton)
{
    return alert_customicon(title, message, defaultButton, alternateButton, otherButton, nil);
}

NSInteger alert_customicon(NSString *title, NSString *message, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSImage *customIcon)
{
    ASSERT_MAINTHREAD;
    
    [NSApp activateIgnoringOtherApps:YES];
    
    cc_log_error(@"Alert: %@ - %@", title, message),
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = title;
    alert.informativeText = LocalizationNotNeeded(message);
    alert.icon = customIcon;
    
    if (defaultButton)
    {
        NSButton *b = [alert addButtonWithTitle:LocalizationNotNeeded(defaultButton)];
        if (defaultButton.associatedValue)
            [b setKeyEquivalent:defaultButton.associatedValue];
    }
    if (alternateButton)
    {
        NSButton *b = [alert addButtonWithTitle:alternateButton];
        if (alternateButton.associatedValue)
            [b setKeyEquivalent:alternateButton.associatedValue];
    }
    if (otherButton)
        [alert addButtonWithTitle:otherButton];
    
    NSInteger result = [alert runModal];
    
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
        }
    };

    if ([NSThread currentThread] == [NSThread mainThread])
        block();
    else
        dispatch_async_main(block);
}
#pragma clang diagnostic pop


CGFloat _attributedStringHeightForWidth(NSAttributedString *string, CGFloat width)
{
    NSSize answer = NSZeroSize ;
    if ([string length] > 0) {
        // Checking for empty string is necessary since Layout Manager will give the nominal
        // height of one line if length is 0.  Our API specifies 0.0 for an empty string.
        NSSize size = NSMakeSize(width, (CGFloat)FLT_MAX) ;
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:size] ;
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:string] ;
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init] ;
        [layoutManager addTextContainer:textContainer] ;
        [textStorage addLayoutManager:layoutManager] ;
        [layoutManager setHyphenationFactor:0.0] ;
        
        // NSLayoutManager is lazy, so we need the following kludge to force layout:
        [layoutManager glyphRangeForTextContainer:textContainer] ;
        
        answer = [layoutManager usedRectForTextContainer:textContainer].size ;
        
        // Adjust if there is extra height for the cursor
        NSSize extraLineSize = [layoutManager extraLineFragmentRect].size ;
        if (extraLineSize.height > 0) {
            answer.height -= extraLineSize.height ;
        }
    }
    
    return answer.height;
}


void alert_nonmodal(NSString *title, NSString *message, NSString *button)
{
    alert_nonmodal_customicon(title, message, button, nil);
}

void alert_nonmodal_customicon_block(NSString *title, NSString *message, NSString *button, NSImage *customIcon, BasicBlock block)
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName : [NSFont systemFontOfSize:11]}];
    CGFloat messageHeight = (CGFloat)MAX(30.0, _attributedStringHeightForWidth(attributedString, 300));
    CGFloat height = 100 + messageHeight;
    NSWindow *fakeAlertWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0.0, 0.0, 420.0, height)
                                                            styleMask:NSWindowStyleMaskTitled
                                                              backing:NSBackingStoreBuffered
                                                                defer:NO];
    
    
    NSTextField *alertTitle = [[NSTextField alloc] initWithFrame:NSMakeRect(100.0, height-30, 300.0, 17.0)];
    NSTextView *alertMessage = [[NSTextView alloc] initWithFrame:NSMakeRect(100.0-3, 50, 300.0, height-50-40)];
    NSImageView *alertImage = [[NSImageView alloc] initWithFrame:NSMakeRect(20.0, height-80, 64, 64)];
    NSButton *firstButton = [[NSButton alloc] initWithFrame:NSMakeRect(315.0, 12, 90, 30)];
    
    
    alertTitle.stringValue = title;
    alertMessage.string = message;
    
    
    alertTitle.font = [NSFont boldSystemFontOfSize:14];
    alertTitle.alignment = NSTextAlignmentLeft;
    alertTitle.bezeled = NO;
    [alertTitle setDrawsBackground:NO];
    [alertTitle setLineBreakMode:NSLineBreakByWordWrapping];
    [alertTitle setEditable:NO];
    [alertTitle setSelectable:NO];
    [fakeAlertWindow.contentView addSubview:alertTitle];
    
    alertMessage.font = [NSFont systemFontOfSize:11];
    alertMessage.alignment = NSTextAlignmentLeft;
    [alertMessage setDrawsBackground:NO];
    [alertMessage setEditable:NO];
    [alertMessage setSelectable:NO];
    [fakeAlertWindow.contentView addSubview:alertMessage];
    
    
    alertImage.image = OBJECT_OR(customIcon, @"AppIcon".namedImage);
    [fakeAlertWindow.contentView addSubview:alertImage];
    
    firstButton.bezelStyle = NSBezelStyleRounded;
    firstButton.title = button;
    firstButton.keyEquivalent = @"\r";
    [fakeAlertWindow.contentView addSubview:firstButton];
    
    __weak  NSWindow *weakWindow = fakeAlertWindow;
    firstButton.actionBlock = ^(id sender)
    {
        [weakWindow close];
        if (block)
            block();
    };
    
    fakeAlertWindow.releasedWhenClosed = NO;
    [fakeAlertWindow center];
    
    [NSApp activateIgnoringOtherApps:YES];
    [fakeAlertWindow makeKeyAndOrderFront:@""];
}

void alert_nonmodal_customicon(NSString *title, NSString *message, NSString *button, NSImage *customIcon)
{
    alert_nonmodal_customicon_block(title, message, button, customIcon, nil);
}

void alert_nonmodal_checkbox(NSString *title, NSString *message, NSString *button, NSString *checkboxTitle, NSInteger checkboxStatusIn, IntInBlock resultBlock)
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName : [NSFont systemFontOfSize:11]}];
    CGFloat messageHeight = (CGFloat)MAX(50.0, _attributedStringHeightForWidth(attributedString, 300));
    CGFloat height = 120 + messageHeight;
    NSWindow *fakeAlertWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(0.0, 0.0, 420.0, height)
                                                            styleMask:NSWindowStyleMaskTitled
                                                              backing:NSBackingStoreBuffered
                                                                defer:NO];
    
    
    NSTextField *alertTitle = [[NSTextField alloc] initWithFrame:NSMakeRect(100.0, height-30, 300.0, 17.0)];
    NSTextView *alertMessage = [[NSTextView alloc] initWithFrame:NSMakeRect(100.0-3, 70, 300.0, height-70-40)];
    NSImageView *alertImage = [[NSImageView alloc] initWithFrame:NSMakeRect(20.0, height-80, 64, 64)];
    NSButton *firstButton = [[NSButton alloc] initWithFrame:NSMakeRect(315.0, 12, 90, 30)];
    
    
    alertTitle.stringValue = title;
    alertMessage.string = message;
    
    
    alertTitle.font = [NSFont boldSystemFontOfSize:14];
    alertTitle.alignment = NSTextAlignmentLeft;
    alertTitle.bezeled = NO;
    [alertTitle setDrawsBackground:NO];
    [alertTitle setLineBreakMode:NSLineBreakByWordWrapping];
    [alertTitle setEditable:NO];
    [alertTitle setSelectable:NO];
    [fakeAlertWindow.contentView addSubview:alertTitle];
    
    alertMessage.font = [NSFont systemFontOfSize:11];
    alertMessage.alignment = NSTextAlignmentLeft;
    [alertMessage setDrawsBackground:NO];
    [alertMessage setEditable:NO];
    [alertMessage setSelectable:NO];
    [fakeAlertWindow.contentView addSubview:alertMessage];
    
    
    alertImage.image = @"AppIcon".namedImage;
    [fakeAlertWindow.contentView addSubview:alertImage];
    
    firstButton.bezelStyle = NSBezelStyleRounded;
    firstButton.title = button;
    firstButton.keyEquivalent = @"\r";
    [fakeAlertWindow.contentView addSubview:firstButton];
    
    
    NSButton *input = [[NSButton alloc] initWithFrame:NSMakeRect(105, 55, 310, 24)];
    [input setButtonType:NSButtonTypeSwitch];
    input.state = checkboxStatusIn;
    input.title = checkboxTitle;
    [fakeAlertWindow.contentView addSubview:input];


    
    __weak  NSWindow *weakWindow = fakeAlertWindow;
    __weak  NSButton *weakCheckbox = input;
    firstButton.actionBlock = ^(id sender)
    {
        resultBlock((int)weakCheckbox.state);
        [weakWindow close];
    };
    
    fakeAlertWindow.releasedWhenClosed = NO;
    [fakeAlertWindow center];
    
    [NSApp activateIgnoringOtherApps:YES];
    [fakeAlertWindow makeKeyAndOrderFront:@""];
}


// colors

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

// randoms

__inline__ CGFloat generateRandomFloatBetween(CGFloat a, CGFloat b)
{
    return a + (b - a) * (random() / (CGFloat) RAND_MAX);
}

__inline__ int generateRandomIntBetween(int a, int b)
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
static cc_log_type minimumLogType;

void cc_log_enablecapturetofile(NSURL *fileURL, unsigned long long filesizeLimit, cc_log_type _minimumLogType) // ASL broken on 10.12+ and especially logging to file not working anymore
{
    assert(!logfileHandle);

    if (!fileURL.fileExists)
        [NSData.data writeToURL:fileURL atomically:YES]; // create file with weird API
    else if (filesizeLimit) // truncate first
    {
        NSString *path = fileURL.path;

        NSDictionary *attr = [fileManager attributesOfItemAtPath:path error:NULL];
        NSNumber *fs = attr[NSFileSize];
        unsigned long long filesize = fs.unsignedLongLongValue;

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
    
    minimumLogType = _minimumLogType;
}

void _cc_log_tologfile(int level, NSString *string)
{
    if (logfileHandle && (level <= minimumLogType))
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
#ifndef CLI
#ifndef DONTLOGTOUSERDEFAULTS
    static int lastPosition[8] = {0,0,0,0,0,0,0,0};
    assert(level < 8);
    NSString *key = makeString(@"corelib_asl_lev%i_pos%i", level, lastPosition[level]);
    key.defaultString = makeString(@"date: %@ message: %@", NSDate.date.description, string);
    lastPosition[level]++;
    if (lastPosition[level] > 9)
        lastPosition[level] = 0;
#endif
#endif
}

void cc_log_level(cc_log_type level, NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    _cc_log_tologfile(level, str);
    _cc_log_toprefs(level, str);

#ifdef CLI
    if (level <= CC_LOG_LEVEL_ERROR)
        fprintf(stderr, "\033[91m%s\033[0m\n", str.UTF8String);
    else if ([str.lowercaseString hasPrefix:@"warning"])
        fprintf(stderr, "\033[93m%s\033[0m\n", str.UTF8String);
    else
        fprintf(stderr, "%s\n", str.UTF8String);
#else
    const char *utf = str.UTF8String;

    if (level == ASL_LEVEL_DEBUG || level == ASL_LEVEL_INFO)
        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG, "%{public}s", utf);
    else if (level == ASL_LEVEL_NOTICE || level == ASL_LEVEL_WARNING)
        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEFAULT, "%{public}s", utf);
    else if (level == ASL_LEVEL_ERR)
        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_ERROR, "%{public}s", utf);
    else if (level == ASL_LEVEL_CRIT || level == ASL_LEVEL_ALERT || level == ASL_LEVEL_EMERG)
        os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_FAULT, "%{public}s", utf);
#endif
    
#ifdef DEBUG
    if (level <= CC_LOG_LEVEL_ERROR)
    {
        // just for breakpoints
    }
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
        block();    // using with dispatch_sync would deadlock when on the main thread
    else
        dispatch_sync(dispatch_get_main_queue(), block);
}

void dispatch_sync_back(dispatch_block_t block)
{
    dispatch_sync(dispatch_get_global_queue(0, 0), block);
}

BOOL dispatch_sync_back_timeout(dispatch_block_t block, float timeoutSeconds) // returns 0 on succ
{
    dispatch_block_t newblock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block);
    dispatch_async(dispatch_get_global_queue(0, 0), newblock);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeoutSeconds * NSEC_PER_SEC));
    return dispatch_block_wait(newblock, popTime) != 0;
}

static dispatch_semaphore_t ccAsyncToSyncSema;
static id ccAsyncToSyncResult;

void dispatch_async_to_sync_resulthandler(id res)
{
    assert(ccAsyncToSyncSema);
    assert(!ccAsyncToSyncResult);
    ccAsyncToSyncResult = res;
    dispatch_semaphore_signal(ccAsyncToSyncSema);
}

id dispatch_async_to_sync(BasicBlock block)
{
    assert(!ccAsyncToSyncResult);
    assert(!ccAsyncToSyncSema);
    ccAsyncToSyncSema = dispatch_semaphore_create(0);
    block();
    dispatch_semaphore_wait(ccAsyncToSyncSema, DISPATCH_TIME_FOREVER);
    assert(ccAsyncToSyncResult);
    ccAsyncToSyncSema = NULL;
    id copy = ccAsyncToSyncResult;
    ccAsyncToSyncResult = nil;
    return copy;
}

// private
NSString *_machineType()
{
    Class hostInfoClass = NSClassFromString(@"JMHostInformation");
    
    if (hostInfoClass)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        NSString *machineType = [hostInfoClass performSelector:@selector(machineType)];
#pragma clang diagnostic pop
        return machineType;
    }
    return @"";
}
BOOL _isUserAdmin()
{
    Class hostInfoClass = NSClassFromString(@"JMHostInformation");
    
    if (hostInfoClass)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        NSMethodSignature *sig = [hostInfoClass methodSignatureForSelector:@selector(isUserAdmin)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setSelector:@selector(isUserAdmin)];
#pragma clang diagnostic pop
        [invocation setTarget:hostInfoClass];
        [invocation invoke];
        BOOL returnValue;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    }
    return YES;
}
