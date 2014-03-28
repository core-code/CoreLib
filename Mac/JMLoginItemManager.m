//
//  JMLoginItemManager.m
//  CoreLib
//
//  Created by CoreCode on Fri Jun 18 2004.
/*	Copyright (c) 2014 CoreCode
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMLoginItemManager.h"
#import <ServiceManagement/ServiceManagement.h>

#ifndef SANDBOX
#define SANDBOX 0
#endif

#if ! __has_feature(objc_arc)
#define BRIDGE
#else
#define BRIDGE __bridge
#endif

#define USING_SANDBOX		(OS_IS_POST_SNOW) && (SANDBOX)

#pragma GCC diagnostic ignored "-Wunreachable-code"

@implementation LoginItemManager

@dynamic launchesAtLogin;

+ (void)restartApp
{
	NSString *appPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Library/LoginItems/LaunchHelper.app"];
	int pid = [[NSProcessInfo processInfo] processIdentifier];

	[[NSWorkspace sharedWorkspace] launchApplicationAtURL:[NSURL fileURLWithPath:appPath]
												  options:NSWorkspaceLaunchDefault
											configuration:@{@"NSWorkspaceLaunchConfigurationArguments" : @[makeString(@"%i", pid)]}
													error:NULL];

	[NSApp terminate:nil];
}

- (BOOL)launchesAtLogin
{
	return IsLoginItem();
}

- (void)setLaunchesAtLogin:(BOOL)launchesAtLogin
{
	//[self willChangeValueForKey:@"launchesAtLogin"];

	if (launchesAtLogin && !IsLoginItem())
		AddLoginItem();
	else if (!launchesAtLogin && IsLoginItem())
		RemoveLoginItem();

	//[self didChangeValueForKey:@"launchesAtLogin"];
}
@end



BOOL IsLoginItem_SM(void)
{
#if SANDBOX
#ifdef DONTAPPEND
	NSString *helperBundleIdentifier = @"com.corecode.LaunchHelper";
#else
	NSString *helperBundleIdentifier = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] stringByAppendingString:@"LaunchHelper"];
#endif
    NSArray * jobDicts = nil;
    jobDicts = (BRIDGE NSArray *)SMCopyAllJobDictionaries( kSMDomainUserLaunchd );
    // Note: Sandbox issue when using SMJobCopyDictionary()
	
    if (jobDicts != nil)
	{
        BOOL bOnDemand = NO;
		
        for (NSDictionary * job in jobDicts)
		{
            if ( [helperBundleIdentifier isEqualToString:[job objectForKey:@"Label"]] )
			{
                bOnDemand = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }
		
        CFRelease((BRIDGE CFDictionaryRef)jobDicts); jobDicts = nil;
        return bOnDemand;
		
    }
    return NO;
#else
	return NO;
#endif
}

BOOL IsLoginItem_LS(void)
{
	UInt32 outSnapshotSeed;
	LSSharedFileListRef list = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	
	if (list)
	{
		NSArray *array = (BRIDGE NSArray *) LSSharedFileListCopySnapshot(list, &outSnapshotSeed);
		
		if (array)
		{
			NSString *bp = [[NSBundle mainBundle] bundlePath];
			
			for (id item in array)
			{
				CFURLRef url = NULL;
				OSStatus status = LSSharedFileListItemResolve((BRIDGE LSSharedFileListItemRef)item, kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes, &url, NULL);
				
				if (status == noErr)
				{
					//asl_NSLog_debug(@"isLoginItem: current login item: %@", [url path]);
					
					if (NSOrderedSame == [[(BRIDGE NSURL *)url path] compare:bp]) // the path is the same as ours => return true
					{
						//asl_NSLog_debug(@"isLoginItem: FOUND US");
						CFRelease((url));
						CFRelease((BRIDGE CFTypeRef)(array));
						CFRelease(list);
						return TRUE;
					}
					else if (NSOrderedSame == [[[(BRIDGE NSURL *)url path] lastPathComponent] compare:[[[NSBundle mainBundle] bundlePath] lastPathComponent]]) // another entry of us, must be valid since on 10.5 invalid entries are erased automatically
					{
						//asl_NSLog_debug(@"isLoginItem: found similar");
					}
				}
				
				
				if (url != NULL)
					CFRelease(url);
			}
			CFRelease((BRIDGE CFTypeRef)(array));
		}
		else
			asl_NSLog(ASL_LEVEL_WARNING, @"Warning: _IsLoginItem : LSSharedFileListCopySnapshot delivered NULL list!");
		
		CFRelease(list);
	}
	else
		asl_NSLog(ASL_LEVEL_WARNING, @"Warning: _IsLoginItem : LSSharedFileListCreate delivered NULL list!");
	
	return FALSE;
}

BOOL IsLoginItem(void)
{
	if (USING_SANDBOX)
		return IsLoginItem_SM();
	else 
		return IsLoginItem_LS();
}

void AddLoginItem_SM(void)
{
#if SANDBOX
#ifdef DONTAPPEND
	NSString *helperBundleIdentifier = @"com.corecode.LaunchHelper";
#else
	NSString *helperBundleIdentifier = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] stringByAppendingString:@"LaunchHelper"];
#endif
	
	if (!SMLoginItemSetEnabled((BRIDGE CFStringRef)helperBundleIdentifier, true)) 
		NSLog(@"SMLoginItemSetEnabled failed.");
#endif
}

void AddLoginItem_LS(void)
{
	//asl_NSLog_debug(@"addLoginItem: bundle path: %@", [[NSBundle mainBundle] bundlePath]);
	LSSharedFileListRef list = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	
	if (list)
	{
		LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(list, kLSSharedFileListItemLast, (BRIDGE CFStringRef)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"], NULL, (BRIDGE CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]], NULL, NULL);
		
		CFRelease(list);
		
		if (item)
			CFRelease(item);
		else
			asl_NSLog(ASL_LEVEL_WARNING, @"Warning: _AddLoginItem : LSSharedFileListInsertItemURL delivered NULL item!");
	}
	else
		asl_NSLog(ASL_LEVEL_WARNING, @"Warning: _AddLoginItem : LSSharedFileListCreate delivered NULL list!");
}

void AddLoginItem(void)
{
	if (USING_SANDBOX)
		AddLoginItem_SM();
	else 
		AddLoginItem_LS();
}

void RemoveLoginItem_SM(void)
{
#if SANDBOX
#ifdef DONTAPPEND
	NSString *helperBundleIdentifier = @"com.corecode.LaunchHelper";
#else
	NSString *helperBundleIdentifier = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] stringByAppendingString:@"LaunchHelper"];
#endif

	if (!SMLoginItemSetEnabled((BRIDGE CFStringRef)helperBundleIdentifier, false))
		NSLog(@"SMLoginItemSetEnabled failed.");
#endif
}

void RemoveLoginItem_LS(void)
{
	UInt32 outSnapshotSeed;
	LSSharedFileListRef list = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	
	if (list)
	{
		NSArray *array = (BRIDGE NSArray *) LSSharedFileListCopySnapshot(list, &outSnapshotSeed);
		
		if (array)
		{
			NSString *bp = [[NSBundle mainBundle] bundlePath];
			
			for (id item in array)
			{
				CFURLRef url;
				OSStatus status = LSSharedFileListItemResolve((BRIDGE LSSharedFileListItemRef)item, kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes, &url, NULL);
				
				if (status == noErr)
				{
					if (NSOrderedSame == [[(BRIDGE NSURL *)url path] compare:bp]) // the path is the same as ours => return true
					{
						asl_NSLog_debug(@"removeLoginItem: removing: %@", [(BRIDGE NSURL *)url path]);
						
						LSSharedFileListItemRemove(list, (BRIDGE LSSharedFileListItemRef) item);
					}
					CFRelease(url);
				}
				else if (status != fnfErr)
					asl_NSLog(ASL_LEVEL_WARNING, @"Warning: removeLoginItem: LSSharedFileListItemResolve error %i", (int)status);
			}
			CFRelease((BRIDGE CFTypeRef)(array));
		}
		else
			asl_NSLog(ASL_LEVEL_WARNING, @"Warning: _RemoveLoginItem : LSSharedFileListCopySnapshot delivered NULL list!");
		
		CFRelease(list);
	}
	else
		asl_NSLog(ASL_LEVEL_WARNING, @"Warning: _RemoveLoginItem : LSSharedFileListCreate delivered NULL list!");
}

void RemoveLoginItem(void)
{
	if (USING_SANDBOX)
		RemoveLoginItem_SM();
	else 
		RemoveLoginItem_LS();
}
