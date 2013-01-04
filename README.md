CoreLib
=======

CoreLib is a collection of reusable Objective-C source code to make various aspects of developing Mac and iOS applications easier & faster.

CoreLib is designed so you can just use the parts you want/need and are not forced to adopt all of it. 

Just include CoreLib.h in your .pch and the files performing the tasks you are interested in.

CoreLib has these components:

* categories on base Cocoa like NSArray, NSData, NSObject, NSString, etc

* for iOS) subclasses for UIActionSheet, UIAlertView, etc to provide a more convenient block based interface

* for Mac) convenience classes for e-mail sending, getting host information, managing login items, etc

### Initialization

in your PCH file:
 
	#import "CoreLib.h"

in your applicationDidFinishLaunching:  method:

	cc = [CoreLib new];

### Usage

some examples how CoreLib makes developing apps more fun.

instead of

	[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPref"]
write

	@"MyPref".defaultObj

instead of

	[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MyPref"];
write

	@"MyPref".defaultInt = 1;

instead of

	[@"abc\ndef\nbla" componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]
write

	@"abc\ndef\nbla".lines

instead of

	NSURL *url = [NSURL URLWithString:@"http://myhost/myfile"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSData *file = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];

write

	NSData *file = @"http://myhost/myfile".download;

there are many more convenience methods including some functional extensions for NSArray.