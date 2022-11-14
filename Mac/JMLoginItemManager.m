//
//  JMLoginItemManager.m
//  CoreLib
//
//  Created by CoreCode on Fri Jun 18 2004.
/*	Copyright © 2022 CoreCode Limited
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#ifdef USE_SERVICEMANAGEMENT

#import "JMLoginItemManager.h"
#import "CoreLib.h"
#if __has_feature(modules)
@import ServiceManagement;
#else
#import <ServiceManagement/ServiceManagement.h>
#endif



#ifdef DONTAPPEND
#error DOESNTWORK
#endif

@implementation LoginItemManager

+ (NSString *)appIDCleaned
{
	NSString *appID = cc.appBundleIdentifier;

	if ([appID hasSuffix:@"-DEMO"]) appID = [appID removed:@"-DEMO"];
	if ([appID hasSuffix:@"-TRYOUT"]) appID = [appID removed:@"-TRYOUT"];

	return appID;
}

+ (NSString *)appNameCleaned
{
	NSString *appName = cc.appName;

	if ([appName hasSuffix:@"-DEMO"]) appName = [appName removed:@"-DEMO"];
	if ([appName hasSuffix:@"-TRYOUT"]) appName = [appName removed:@"-TRYOUT"];

    appName = [appName removed:@" "];
    
	return appName;
}


+ (void)restartApp
{
#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 110000
    let config = [NSWorkspaceOpenConfiguration new];
    config.createsNewApplicationInstance = YES;
    [workspace openApplicationAtURL:bundle.bundleURL configuration:config completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error)
    {
        if (app)
            [NSApp terminate:nil];
    }];
#else
     NSString *appPath = [bundle.bundlePath stringByAppendingPathComponent:makeString(@"Contents/Library/LoginItems/%@LaunchHelper.app", [LoginItemManager appNameCleaned])];
     int pid = NSProcessInfo.processInfo.processIdentifier;

     [workspace launchApplicationAtURL:appPath.fileURL
                               options:NSWorkspaceLaunchDefault
                         configuration:@{@"NSWorkspaceLaunchConfigurationArguments" : @[@(pid).stringValue]}
                                 error:NULL];
    [NSApp terminate:nil];
#endif
}

- (BOOL)launchesAtLogin
{
	LOGFUNC

#if defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
    if (@available(macOS 13.0, *))
    {
        switch (SMAppService.mainAppService.status)
        {
            case SMAppServiceStatusEnabled:
                return YES;
            case SMAppServiceStatusNotRegistered:		// This is the regular 'launch at login not enabled' case
            case SMAppServiceStatusRequiresApproval:	// not sure about this one
            case SMAppServiceStatusNotFound:			// This happens when there's no BTM record yet, i.e. on first launch etc. It's not an error
                return NO;
            default:
            {
                let info = makeString(@"SMAppService.mainAppService.status: %ld  %@  %li", (long)SMAppService.mainAppService.status, NSProcessInfo.processInfo.operatingSystemVersionString, (long)@"corelib_usages".defaultInt);
                assert_custom_info(0, info);
                return NO;
            }
        }
    }
    else
#endif
    {
        return [self legacyHelperLaunchesAtLogin];
    }
}

- (void)setLaunchesAtLogin:(BOOL)launchesAtLogin
{
	LOGFUNC

#if defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
    if (@available(macOS 13.0, *))
    {
        NSError *error;
        if (launchesAtLogin)
        {
            [SMAppService.mainAppService registerAndReturnError:&error];
            if (error)
            {
                switch (error.code)
                {
                    case kSMErrorAlreadyRegistered:
                        break;
                    case kSMErrorLaunchDeniedByUser:
                    default:
                    {
                        NSString *info = [NSString stringWithFormat:@"Error %li registering mainAppService: %@\n%@", (long)error.code, error.userInfo, NSProcessInfo.processInfo.operatingSystemVersionString];
                        assert_custom_info(0, info);
                    }
                }
            }
        }
        else
        {
            [SMAppService.mainAppService unregisterAndReturnError:&error];
            if (error)
            {
                switch (error.code)
                {
                    case kSMErrorJobNotFound: // Already unregistered
                        break;
                    default:
                    {
                        NSString *info = [NSString stringWithFormat:@"Error %li unregistering mainAppService: %@", (long)error.code, error.userInfo];
                        assert_custom_info(0, info);
                    }
                }
            }
        }
        
        [self setLegacyHelperLaunchesAtLogin:NO]; // prevent issue where the would be started both in the old and the new way
    }
    else
#endif
    {
        [self setLegacyHelperLaunchesAtLogin:launchesAtLogin];
    }
}

// MARK: - Legacy helper launcher

- (BOOL)legacyHelperLaunchesAtLogin
{
    NSString *helperBundleIdentifier = [[LoginItemManager appIDCleaned] stringByAppendingString:@"LaunchHelper"];

#if defined(DEBUG) && !defined(SKIP_LAUNCHHELPERCHECK)
    NSString *infoPath = [[bundle bundlePath] stringByAppendingPathComponent:
                          makeString(@"Contents/Library/LoginItems/%@LaunchHelper.app/Contents/Info.plist", [LoginItemManager appNameCleaned])];
    NSDictionary *infoDictionary = [NSDictionary dictionaryWithContentsOfFile:infoPath];
    NSString *bundleIdentifierInHelperOnDisk = infoDictionary[@"CFBundleIdentifier"];
    assert([bundleIdentifierInHelperOnDisk isEqualToString:helperBundleIdentifier]);
#endif


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSArray *jobDicts = (__bridge NSArray *)SMCopyAllJobDictionaries(kSMDomainUserLaunchd); // this is deprecated but probably should not be: rdar://20510672
#pragma clang diagnostic pop

    if (jobDicts != nil)
    {
        BOOL onDemand = NO;

        for (NSDictionary * job in jobDicts)
        {
            NSString *label = [job objectForKey:@"Label"];

            if ([helperBundleIdentifier isEqualToString:label])
            {
                NSNumber *od = [job objectForKey:@"OnDemand"];

                onDemand = od.boolValue;
                break;
            }
        }

        CFRelease((__bridge CFArrayRef)jobDicts);
        jobDicts = nil;
        return onDemand;

    }
    return NO;
}

- (void)setLegacyHelperLaunchesAtLogin:(BOOL)launchesAtLogin
{
    NSString *helperBundleIdentifier = [[LoginItemManager appIDCleaned] stringByAppendingString:@"LaunchHelper"];
#if defined(DEBUG) && !defined(SKIP_LAUNCHHELPERCHECK)
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:[[bundle bundlePath] stringByAppendingPathComponent:makeString(@"Contents/Library/LoginItems/%@LaunchHelper.app/Contents/Info.plist", [LoginItemManager appNameCleaned])]];
    NSString *bid = d[@"CFBundleIdentifier"];
    assert([bid isEqualToString:helperBundleIdentifier]);
#endif


    if (launchesAtLogin && ![self launchesAtLogin]) // add it
    {
        if (!SMLoginItemSetEnabled((__bridge CFStringRef)helperBundleIdentifier, YES))
            cc_log(@"SMLoginItemSetEnabled failed.");
    }
    else if (!launchesAtLogin && [self launchesAtLogin]) // remove it
    {
        if (!SMLoginItemSetEnabled((__bridge CFStringRef)helperBundleIdentifier, NO))
            cc_log(@"SMLoginItemSetEnabled failed.");
    }
}

- (void)migrateToSMAppServiceIfNeeded
{
    if (@available(macOS 13.0, *))
    {
        NSString *key = @"migratedToSMAppService";
        if ([userDefaults boolForKey: key]) return;
        
        if ([self legacyHelperLaunchesAtLogin])
        {
            [self setLegacyHelperLaunchesAtLogin:NO];
            [self setLaunchesAtLogin:YES];
        }
        [userDefaults setBool:YES forKey:key];
    }
}

@end


#endif
