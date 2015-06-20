//
//  JMLoginItemManager.m
//  CoreLib
//
//  Created by CoreCode on Fri Jun 18 2004.
/*	Copyright (c) 2015 CoreCode
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#ifdef USE_SERVICEMANAGEMENT

#import "JMLoginItemManager.h"
#if __has_feature(modules)
@import ServiceManagement;
#else
#import <ServiceManagement/ServiceManagement.h>
#endif



#ifdef DONTAPPEND
#error DOESNTWORK
#endif

@implementation LoginItemManager

@dynamic launchesAtLogin;

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

	return appName;
}


+ (void)restartApp
{
	NSString *appPath = [[bundle bundlePath] stringByAppendingPathComponent:makeString(@"Contents/Library/LoginItems/%@LaunchHelper.app", [LoginItemManager appNameCleaned])];
	int pid = [[NSProcessInfo processInfo] processIdentifier];

	[[NSWorkspace sharedWorkspace] launchApplicationAtURL:appPath.fileURL
												  options:NSWorkspaceLaunchDefault
											configuration:@{@"NSWorkspaceLaunchConfigurationArguments" : @[@(pid).stringValue]}
													error:NULL];

	[NSApp terminate:nil];
}

- (BOOL)launchesAtLogin
{
	LOGFUNC;

	NSString *helperBundleIdentifier = [[LoginItemManager appIDCleaned] stringByAppendingString:@"LaunchHelper"];
#ifdef DEBUG
	NSString *infoPath = [[bundle bundlePath] stringByAppendingPathComponent:
						  makeString(@"Contents/Library/LoginItems/%@LaunchHelper.app/Contents/Info.plist", [LoginItemManager appNameCleaned])];
	NSDictionary *infoDictionary = [NSDictionary dictionaryWithContentsOfFile:infoPath];
	NSString *bundleIdentifierInHelperOnDisk = infoDictionary[@"CFBundleIdentifier"];
	assert([bundleIdentifierInHelperOnDisk isEqualToString:helperBundleIdentifier]);
#endif
	

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSArray *jobDicts = (BRIDGE NSArray *)SMCopyAllJobDictionaries(kSMDomainUserLaunchd); // this is deprecated but probably should not be: rdar://20510672
#pragma clang diagnostic pop

	if (jobDicts != nil)
    {
        BOOL onDemand = NO;
        
        for (NSDictionary * job in jobDicts)
        {
			NSString *label = [job objectForKey:@"Label"];

            if ([helperBundleIdentifier isEqualToString:label])
            {
                onDemand = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }
        
        CFRelease((BRIDGE CFArrayRef)jobDicts);
        jobDicts = nil;
        return onDemand;
        
    }
    return NO;
}

- (void)setLaunchesAtLogin:(BOOL)launchesAtLogin
{
	LOGFUNC;

	//[self willChangeValueForKey:@"launchesAtLogin"];

    NSString *helperBundleIdentifier = [[LoginItemManager appIDCleaned] stringByAppendingString:@"LaunchHelper"];
	assert([[NSDictionary dictionaryWithContentsOfFile:[[bundle bundlePath] stringByAppendingPathComponent:makeString(@"Contents/Library/LoginItems/%@LaunchHelper.app/Contents/Info.plist", [LoginItemManager appNameCleaned])]][@"CFBundleIdentifier"] isEqualToString:helperBundleIdentifier]);


	if (launchesAtLogin && ![self launchesAtLogin]) // add it
    {
        if (!SMLoginItemSetEnabled((BRIDGE CFStringRef)helperBundleIdentifier, true))
            LOG(@"SMLoginItemSetEnabled failed.");
    }
	else if (!launchesAtLogin && [self launchesAtLogin]) // remove it
    {
        if (!SMLoginItemSetEnabled((BRIDGE CFStringRef)helperBundleIdentifier, false))
            LOG(@"SMLoginItemSetEnabled failed.");
    }
        

	//[self didChangeValueForKey:@"launchesAtLogin"];
}
@end


#endif