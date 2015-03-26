#ifdef MAC
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif

#define USE_SECURITY 1 // if you link Security.framework
#define USE_SYSTEMCONFIGURATION 1 // if you link SystemConfiguration.framework
#define USE_IOKIT 1 // if you link IOKit.framework
#define USE_DISKARBITRATION 1 // if you link DiskArbitration.framework

#import "CoreLib.h"