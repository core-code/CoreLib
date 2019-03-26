//
//  LaunchAppDelegate.m
//  LaunchHelper
//
//  Created by CoreCode on 12.04.12.
//  Copyright © 2019 CoreCode Limited. All rights reserved.
//

#import "LaunchAppDelegate.h"

#ifdef DONTAPPEND
#error DOESNTWORK
#endif

#if ! __has_feature(objc_arc)
	#error manual reference counting is no longer supported
#endif

static NSString *restartWithPID;

@implementation LaunchAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{	
	NSString *appPath = [[[[[NSBundle.mainBundle bundlePath] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
	
	if (restartWithPID)
	{
		while ([NSRunningApplication runningApplicationWithProcessIdentifier:[restartWithPID intValue]])
		{		
			[NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
		}
	}
		
	[NSWorkspace.sharedWorkspace launchApplication:appPath];


	[NSApp terminate:nil];
}

@end

int main(int argc, const char *argv[])
{
	if (argc >= 2)
    {
        restartWithPID = [NSString stringWithUTF8String:argv[1]];
    }
	
	return NSApplicationMain(argc, (const char **)argv);
}
