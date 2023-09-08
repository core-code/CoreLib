//
//  JMHostInformation.h
//  CoreLib
//
//  Created by CoreCode on 16.01.05.
/*	Copyright © 2022 CoreCode Limited
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "CoreLib.h"

#define kDiskNameKey                        @"DiskName"
#define kDiskNumberKey                      @"DiskNumber"

CC_ENUM(uint8_t, smartStatusEnum)
{
	kSMARTStatusUnknown = 0,
	kSMARTStatusError = 1,
	kSMARTStatusOK = 2,
    kSMARTStatusNotSMARTCompatible = 3
};


@interface JMHostInformation : NSObject

+ (BOOL)isRunningTranslocatedOrReadonly;
+ (BOOL)isRunningFromDiskImage;
+ (BOOL)isRunningUnderRosetta2;
+ (BOOL)isUserAdmin;
+ (BOOL)hasFullDiskAccess;
+ (BOOL)haveAutomationPermissions:(BOOL)allowAskingNow; // for apple events to finder basically  -NOTE: if allowAskingNow == FALSE, then a return value of YES doesn't mean we have permissions. it could also mean we haven't asked the user yet. it just means the permissions haven't been denied
+ (NSURL *)growlInstallURL;
+ (NSString *)ipAddress:(bool)ipv6;
+ (NSString *)machineType;
+ (NSString *)appStoreCountryCode;
+ (NSArray <NSString *> *)otherLoggedInUsers;
+ (NSArray <NSString *> *)runningProcesses;
+ (double)uptime;

#ifdef USE_DISKARBITRATION // requires linking DiskArbitration.framework
+ (NSString *)volumeNamesForDevice:(NSInteger)deviceNumber;
+ (NSNumber *)bsdNumberForVolume:(NSString *)volume;
+ (NSDictionary *)descriptionForDevice:(NSInteger)bsdNum;
#endif

#ifdef USE_SYSTEMCONFIGURATION // requires linking SystemConfiguration.framework
+ (BOOL)isOnline;
+ (NSString *)ipName;
#endif
#ifdef USE_IOKIT // requires linking IOKit.framework
+ (NSString *)serialNumber;
+ (NSString *)UUID;
+ (NSString *)macAddress;
+ (BOOL)runsOnBattery;
+ (smartStatusEnum)getDiskSMARTStatus:(int)disk;
+ (NSDictionary *)getDiskSMARTAttributes:(int)disk;
#ifdef USE_DISKARBITRATION // requires linking DiskArbitration.framework
+ (NSArray *)mountedHarddisks:(BOOL)includeRAIDBackingDevices;
+ (NSArray *)allHarddisks;
#endif
#endif

@end
