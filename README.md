CoreLib
=======

CoreLib is a collection of reusable Objective-C source code to make various aspects of developing Mac apps easier, faster & safer.

CoreLib is designed so you can just use the parts you want/need and are not forced to adopt all of it. 

Just `#import CoreLib.h` in your .pch (or in files that use it). Additional Classes in the Mac/ folder can be included as needed.

CoreLib has these components:

* categories on base Cocoa like `NSArray`, `NSData`, `NSObject`, `NSString`, etc for new functionality or syntactic sugar (AppKit+CoreCode, Foundation+CoreCode)

* for Mac) convenience classes for e-mail sending, getting host information, managing login items, showing styled font lists, etc  (Mac/JM*)

* for Mac) subclasses for `WebView`, `NSButton`, `NSTextView` as well as custom view controllers to do many common tasks easier e.g. just configure properties in IB without any code (Mac/JM*)

* CoreLib provided much important stuff earlier than Apple, which is still useful on older Xcode versions where this is not supported (API availability warnings, statically typed collections, properties for getters/setters, object subscripting)

### Requirements

CoreLib up to version 1.8 requires Xcode 6 and deploys back to Mac OS X 10.6 / iOS 6  
CoreLib version 1.9 requires Xcode 7 and deploys back to Mac OS X 10.6 / iOS 7  
CoreLib version 1.10 and above requires Xcode 8 and deploys back to Mac OS X 10.6 / iOS 8  
CoreLib version 1.14 and above requires Xcode 9 and deploys back to Mac OS X 10.10 / iOS 8
CoreLib version 1.21 and above requires Xcode 10 and deploys back to Mac OS X 10.10 / iOS 8
CoreLib version 1.25 and above requires Xcode 10 and deploys back to Mac OS X 10.13 / iOS 11

### Initialization

in your PCH file if you have one, or at top of your source or header files you have to include the CoreLib master header:
 
```objc
#import <Cocoa/Cocoa.h> // you had that before
#import "CoreLib.h"
```

in your `applicationDidFinishLaunching`  method:

```objc
cc = [CoreLib new]; // dont forget this
```

### Usage

some examples how CoreLib makes developing apps more fun.

example user defaults convenience:

```objc
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
```


example string convenience:

```objc
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
```


example downloading files:

```objc
// old way
NSURL *url = [NSURL URLWithString:@"http://myhost/myfile"];
NSURLRequest *request = [NSURLRequest requestWithURL:url];
NSData *file = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
// new way
NSData *file = @"http://myhost/myfile".download;
```

there are about 2000 lines of convenience categories including some functional extensions for NSArray.

### Defines & Configuration

some features of CoreLib require linking additional frameworks and are therefore only available if you include these framework and set some preprocessor value:


```objc
#define USE_SECURITY 1 // if you (want to) link Security.framework
#define USE_SYSTEMCONFIGURATION 1 // if you (want to) link SystemConfiguration.framework
#define USE_IOKIT 1 // if yo (want to) link IOKit.framework
#define USE_DISKARBITRATION 1 // if you (want to) link DiskArbitration.framework

#define USE_APPLEMAIL 1 // if you want to send mail through Mail.app with the ScriptingBridge (needs temporary exception if sandboxed)

#define USE_MAILCORE 1 // if you link MailCore.framework
#define USE_SNAPPY 1 // if you link Snappy.framework
```

additionally some parts of CoreLib require setting the `SANDBOX` `#define` to indicate whether your app is sandboxed

you can also use this if you want to include `JMApplicationDelegate` but not `JMRatingWindow`
```objc
#define SKIP_RATINGWINDOW 1 
```
	

also you can define `VENDOR_HOMEPAGE` and `FEEDBACK_EMAIL` for the built-in feedback mechanism (`openURL`)	

some parts of CoreLib do more checking if `DEBUG` is defined

CoreLib saves the last 10 messages logged with `cc_log()` to the user defaults unless you define  `DONTLOGTOUSERDEFAULTS`

CoreLib has changed its return values of the `alert*()` functions away from deprecated `NSAlertDefaultReturn`/`NSOKButton` values and undefines those to make sure you update. define `IMADESURENOTTOCOMPAREALERTRETURNVALUESAGAINSTOLDRETURNVALUES` to make sure you can still use the old return values for old appkit functions

defining `FORCE_LOG` forces output to the system log even for release builds

