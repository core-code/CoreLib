//
//  AppDelegate.m
//  CrashHelper
//
//  Created by CoreCode on 23/11/16.
//  Copyright © 2018 CoreCode Limited. All rights reserved.
//

#import "CrashAppDelegate.h"
#import "CoreLib.h"


static NSString *inputString;


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	cc = [CoreLib new];

	NSData *data = inputString.dataFromHexString;
	NSDictionary *dict = data.JSONDictionary;

	NSString *title = NON_NIL_STR(dict[@"title"]);
	NSString *message = NON_NIL_STR(dict[@"message"]);
	NSString *mailto = NON_NIL_STR(dict[@"mailto"]);


	if (alert(title, message, @"Send to support", @"Quit", nil) == NSAlertFirstButtonReturn)
	{
		[mailto.escaped.URL open];
	}

	exit(1);
}

@end



int main(int argc, const char * argv[])
{
	if (argc >= 2)
		inputString = [NSString stringWithUTF8String:argv[1]];
	else
		exit(1);


	return NSApplicationMain(argc, argv);
}
