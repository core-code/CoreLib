CoreLib
=======

CoreLib is a collection of reusable Objective-C source code to make various aspects of developing Mac and iOS applications easier, faster & safer.

CoreLib is designed so you can just use the parts you want/need and are not forced to adopt all of it. 

Just include CoreLib.h in your .pch and the files performing the tasks you are interested in.

CoreLib has these components:

* categories on base Cocoa like NSArray, NSData, NSObject, NSString, etc for new functionality or syntactic sugar (AppKit+CoreCode, Foundation+CoreCode)

* for iOS) subclasses for UIActionSheet, UIAlertView, etc to provide a more convenient block based interface or new view controllers (iOS/JM*)

* for Mac) convenience classes for e-mail sending, getting host information, managing login items, showing styled font lists, etc  (Mac/JM*)

* categories on all Foundation&AppKit classes to provide properties instead of getters/setters. this is provided in the 10.10 SDK too, but we have it for pre Xcode 6 (AppKit+Properties, Foundation+Properties)

* support for object subscripting with old SDKs where Apple doesn't support it (Foundation+Indexing)

* support for generating warnings on invocation of methods/classes that are not available on your deployment target (CoreLib_Availability)

* support for pseudo static typing in collection classes (for invoking properties on objects from collections without casting) and much more convenience stuff (CoreLib)


### Initialization

in your PCH file:
 
	#import "CoreLib_Availability.h" // optional, for warnings on calls to unavailable methods
	#import <Cocoa/Cocoa.h> // you had that before
	#import "CoreLib.h"

in your applicationDidFinishLaunching:  method:

	cc = [CoreLib new]; // dont forget this

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

### Defines

some features of CoreLib require linking additional frameworks and are therefore only available if you include these framework and set some preprocessor value:
	#define USE_SECURITY 1 // if you link Security.framework
	#define USE_SYSTEMCONFIGURATION 1 // if you link SystemConfiguration.framework
	#define USE_IOKIT 1 // if you link IOKit.framework
	#define USE_DISKARBITRATION 1 // if you link DiskArbitration.framework
	#define USE_SNAPPY 1 // if you link Snappy.framework
	#define USE_MAILCORE 1 // if you link MailCore.framework
	#define USE_APPLEMAIL 1 // if you have the ScriptingDefinition for Mail.app 

additionally some parts of CoreLib require setting the SANDBOX #define to indicate whether your app is sandbox
	