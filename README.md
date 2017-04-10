CoreLib
=======

CoreLib is a collection of reusable Objective-C source code to make various aspects of developing Mac and iOS applications easier, faster & safer.

CoreLib is designed so you can just use the parts you want/need and are not forced to adopt all of it. 

Just #import CoreLib.h in your .pch (or in files that use it). Additional Classes in the Mac/ and iOS/ folders can be included as needed.

CoreLib has these components:

* categories on base Cocoa like NSArray, NSData, NSObject, NSString, etc for new functionality or syntactic sugar (AppKit+CoreCode, Foundation+CoreCode)

* for iOS) subclasses for UIActionSheet, UIAlertView, etc to provide a more convenient block based interface or new view controllers (iOS/JM*)

* for Mac) convenience classes for e-mail sending, getting host information, managing login items, showing styled font lists, etc  (Mac/JM*)

* categories on all Foundation&AppKit classes to provide properties instead of getters/setters. this is provided in the 10.10 SDK too, but we have it for pre Xcode 6 (AppKit+Properties, Foundation+Properties)

* support for object subscripting with old SDKs where Apple doesn't support it (Foundation+Indexing)

* support for generating warnings on invocation of methods/classes that are not available on your deployment target (CoreLib_Availability)

* support for pseudo static typing in collection classes (for invoking properties on objects from collections without casting) and much more convenience stuff (CoreLib)

### Requirements

CoreLib up to version 1.8 requires Xcode 6 and deploys back to Mac OS X 10.6 / iOS 6
CoreLib version 1.9 and above requires Xcode 7 and deploys back to Mac OS X 10.6 / iOS 7
CoreLib version 1.10 and above requires Xcode 8 and deploys back to Mac OS X 10.6 / iOS 8

### Initialization

in your PCH file:
 
	#import "CoreLib_Availability.h" // optional, this provides warnings on calls to methods unavailable in your deployment target - only works when not compiling with 'modules'
	#import <Cocoa/Cocoa.h> // you had that before
	#import "CoreLib.h"

in your applicationDidFinishLaunching:  method:

	cc = [CoreLib new]; // dont forget this

### Usage

some examples how CoreLib makes developing apps more fun.

example user defaults convenience:

	// setting defaults
	// old way 
	[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MyPref"];
	// new way 
	@"MyPref".defaultInt = 1;

	// using defaults
	// old way 
	[[NSUserDefaults standardUserDefaults] objectForKey:@"MyPref"]
	// new way 
	@"MyPref".defaultObj


example string convenience:

	// splitting string into lines
	// old way
	[@"abc\ndef\nbla" componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]
	// new way
	@"abc\ndef\nbla".lines

	// trimming whitespace
	// old way
	[someString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
	// new way
	string.trimmedOfWhitespace;


example downloading files:

	// old way
	NSURL *url = [NSURL URLWithString:@"http://myhost/myfile"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSData *file = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
	// new way
	NSData *file = @"http://myhost/myfile".download;

there are about 2000 lines of convenience categories including some functional extensions for NSArray.

### Defines & Configuration

some features of CoreLib require linking additional frameworks and are therefore only available if you include these framework and set some preprocessor value:


	#define USE_SECURITY 1 // if you (want to) link Security.framework
	#define USE_SYSTEMCONFIGURATION 1 // if you (want to) link SystemConfiguration.framework
	#define USE_IOKIT 1 // if yo (want to) link IOKit.framework
	#define USE_DISKARBITRATION 1 // if you (want to) link DiskArbitration.framework

	#define USE_APPLEMAIL 1 // if you want to send mail through Mail.app with the ScriptingBridge (needs temporary exception if sandboxed)

	#define USE_MAILCORE 1 // if you link MailCore.framework
	#define USE_SNAPPY 1 // if you link Snappy.framework

additionally some parts of CoreLib require setting the SANDBOX #define to indicate whether your app is sandbox

also you can define VENDOR_HOMEPAGE and FEEDBACK_EMAIL for the built-in feedback mechanism (openURL)	

some parts of CoreLib do more checking if DEBUG is defined

CoreLib saves the last 10 messages logged with asl_NSLog() to the user defaults unless you define  DONTLOGASLTOUSERDEFAULTS

CoreLib has changed its return values of the alert*() functions away from deprecated NSAlertDefaultReturn/NSOKButton values and undefines those to make sure you update. define IMADESURENOTTOCOMPAREALERTRETURNVALUESAGAINSTOLDRETURNVALUES to make sure you can still use the old return values for old appkit functions

defining FORCE_LOG forces output to the system log even for release builds