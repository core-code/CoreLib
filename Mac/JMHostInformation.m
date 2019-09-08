//
//  JMHostInformation.m
//  CoreLib
//
//  Created by CoreCode on 16.01.05.
/*    Copyright © 2019 CoreCode Limited
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
// Some code here is derived from Apple Sample Code, but changes have been made

#import "JMHostInformation.h"


#if __has_feature(modules)
@import Darwin.sys.sysctl;
#import <libproc.h>
@import Darwin.POSIX.pwd;
@import Darwin.POSIX.grp;
@import Darwin.POSIX.sys.socket;
@import Darwin.POSIX.netinet.in;
@import Darwin.POSIX.arpa.inet;
#if defined(MAC_OS_X_VERSION_10_13) && \
    defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && \
    __MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_13
@import Darwin.POSIX.ifaddrs;
#else
#include <ifaddrs.h>
#endif
@import Darwin.POSIX.net;
@import Darwin.C.stdio;
@import Darwin.POSIX.unistd;
@import Darwin.POSIX.sys.types;
@import Darwin.POSIX.strings;
@import Darwin.sys.param;
@import Darwin.sys.mount;
#ifdef USE_IOKIT
@import IOKit.ps;
@import IOKit.network;
@import IOKit.storage;
@import IOKit.storage.ata;
#endif
#ifdef USE_SYSTEMCONFIGURATION
@import SystemConfiguration;
#endif
#else
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <strings.h>
#include <sys/param.h>
#include <sys/mount.h>
#include <pwd.h>
#include <grp.h>
#import <libproc.h>
#ifdef USE_IOKIT
#include <IOKit/ps/IOPSKeys.h>
#include <IOKit/ps/IOPowerSources.h>
#include <IOKit/network/IOEthernetInterface.h>
#include <IOKit/network/IONetworkInterface.h>
#include <IOKit/network/IOEthernetController.h>
#include <IOKit/storage/IOMedia.h>
#include <IOKit/storage/ata/IOATAStorageDefines.h>
#include <IOKit/storage/ata/ATASMARTLib.h>
#include <IOKit/storage/IOBlockStorageDevice.h>
#include <IOKit/storage/IOStorageDeviceCharacteristics.h>
#endif
#ifdef USE_SYSTEMCONFIGURATION
#include <SystemConfiguration/SystemConfiguration.h>
#endif
#endif


#ifdef USE_DISKARBITRATION
#ifdef FORCE_LOG
#define LOGMOUNTEDHARDDISK cc_log_debug
#else
#define LOGMOUNTEDHARDDISK(x, ...) 
#endif
#endif

#ifdef USE_IOKIT
static kern_return_t FindEthernetInterfaces(io_iterator_t *matchingServices);
static kern_return_t GetMACAddress(io_iterator_t intfIterator, UInt8 *MACAddress);
static IOReturn getSMARTStatusForDisk(const int bsdDeviceNumber, smartStatusEnum *smart);
static IOReturn getSMARTAttributesForDisk(const int bsdDeviceNumber, NSMutableDictionary *attributes);
#endif





@implementation JMHostInformation


+ (NSArray <NSString *> *)otherLoggedInUsers
{
    NSString *currentUser = [@[@"/usr/bin/whoami"] runAsTask].trimmedOfWhitespaceAndNewlines;
    NSString *loggedUsersString = [@[@"/usr/bin/who"] runAsTask];
    NSArray *loggedUsersArray = loggedUsersString.lines;
    NSArray *loggedUsersGuiArray = [loggedUsersArray filtered:^BOOL(NSString *input) { return [input contains:@"console"];}];
    NSArray *loggedUsersGuiExceptUsArray = [loggedUsersGuiArray filtered:^BOOL(NSString *input) { return ![input contains:currentUser];}];
    NSArray *loggedUsersGuiExceptUsCleanArray = [loggedUsersGuiExceptUsArray mapped:^NSString *(NSString *input) { return [input split:@" "].firstObject;}];

    
    return loggedUsersGuiExceptUsCleanArray;
}


+ (NSArray <NSString *> *)runningProcesses
{
    NSMutableArray *procs = makeMutableArray();
    int pidCount = proc_listpids(PROC_ALL_PIDS, 0, NULL, 0);
    unsigned long pidsBufSize = sizeof(pid_t) * (unsigned long)pidCount;
    pid_t * pids = malloc(pidsBufSize);
    bzero(pids, pidsBufSize);
    proc_listpids(PROC_ALL_PIDS, 0, pids, (int)pidsBufSize);
    char pathBuffer[PROC_PIDPATHINFO_MAXSIZE];
    for (int i=0; i < pidCount; i++) {
        
        pid_t currentPid = pids[i];
        if (currentPid)
        {
            bzero(pathBuffer, PROC_PIDPATHINFO_MAXSIZE);
            proc_pidpath(currentPid, pathBuffer, sizeof(pathBuffer));
            NSString *pathObject = @(pathBuffer);
            [procs addObject:pathObject];
        }
    }
    return procs;
}

+ (NSString *)appStoreCountryCode
{
    NSURL *updateJournalURL = @"~/Library/Application Support/App Store/updatejournal.plist".expanded.fileURL;
    NSDictionary *updateJournal = [NSDictionary dictionaryWithContentsOfURL:updateJournalURL];
    NSArray *updates = updateJournal[@"autoInstalledUpdates"];
    NSDictionary *lastUpdate = updates.lastObject;
    NSString *url = lastUpdate[@"url"];
    NSString *countyCode;
    
    if ([url contains:@"itunes.apple.com/"])
    {
        NSString *laterPart = [url split:@"itunes.apple.com/"][1];
        
        countyCode = [laterPart split:@"/"][0];
    }
    
    return countyCode;
}

+ (BOOL)isRunningTranslocated
{ // could also use kCFURLQuarantinePropertiesKey?
    struct statfs statfs_info;
    statfs(bundle.bundlePath.fileSystemRepresentation, &statfs_info);
    BOOL isTranslocated1 = (statfs_info.f_flags & MNT_RDONLY) != 0;
    BOOL isTranslocated2 = [bundle.bundlePath contains:@"AppTranslocation"];
    
    assert_custom(isTranslocated1 == isTranslocated2);
    
    return isTranslocated1 || isTranslocated2;
}

#ifdef USE_DISKARBITRATION
+ (NSNumber *)bsdNumberForVolume:(NSString *)volume
{
    DASessionRef session = DASessionCreate(kCFAllocatorDefault);
    assert(session);
    if (!session)
    {
        cc_log_error(@"Error:    DASessionCreate returned NULL");
        return nil;
    }

    NSArray *urls = [NSFileManager.defaultManager mountedVolumeURLsIncludingResourceValuesForKeys:@[NSURLVolumeNameKey] options:(NSVolumeEnumerationOptions)0];

    for (NSURL *mountURL in urls)
    {
        NSError *error;
        NSString *volumeName;
        [mountURL getResourceValue:&volumeName forKey:NSURLVolumeNameKey error:&error];

        if ([volumeName isEqualToString:volume])
        {
            DADiskRef disk = DADiskCreateFromVolumePath(kCFAllocatorDefault, session, (__bridge CFURLRef)mountURL);
            assert(disk);

            const char *utfBSDName = DADiskGetBSDName(disk);

            if (utfBSDName)
            {
                NSString *bsdName = @(utfBSDName);

                assert(bsdName);
                assert([bsdName hasPrefix:@"disk"]);

                bsdName = [bsdName replaced:@"disk" with:@""];

                if ([bsdName contains:@"s"])
                    bsdName = [bsdName split:@"s"][0];

                assert(bsdName.isIntegerNumberOnly);

                if (disk)
                    CFRelease(disk);
                CFRelease(session);

                return @(bsdName.integerValue);
            }
            
            if (disk)
                CFRelease(disk);
        }
    }

    CFRelease(session);
    return nil;
}

+ (NSString *)volumeNamesForDevice:(NSInteger)bsdNum
{
    NSMutableString *name = [NSMutableString stringWithCapacity:12];
    DASessionRef session = DASessionCreate(kCFAllocatorDefault);
    assert(session);
    if (!session)
    {
        cc_log_error(@"Error:    DASessionCreate returned NULL");
        return nil;
    }

    NSArray *urls = [NSFileManager.defaultManager mountedVolumeURLsIncludingResourceValuesForKeys:@[NSURLVolumeNameKey] options:(NSVolumeEnumerationOptions)0];

    for (NSURL *mountURL in urls)
    {
        if ([mountURL.path isEqualToString:@"/private/var/vm"]) // ignore HighSierra 'VM' partition
            continue;

        
        DADiskRef disk = DADiskCreateFromVolumePath(kCFAllocatorDefault, session, (__bridge CFURLRef)mountURL);

        if (disk)
        {
            const char *utfBSDName = DADiskGetBSDName(disk);

            if (utfBSDName)
            {
                NSString *bsdName = @(utfBSDName);
                
                
                assert([bsdName hasPrefix:@"disk"]);

                bsdName = [bsdName replaced:@"disk" with:@""];

                if ([bsdName contains:@"s"])
                    bsdName = [bsdName split:@"s"][0];

                assert(bsdName.isIntegerNumberOnly);

                if (bsdName.integerValue == bsdNum)
                {
                    NSError *error;
                    NSString *volumeName;
                    [mountURL getResourceValue:&volumeName forKey:NSURLVolumeNameKey error:&error];


                    if (![name isEqualToString:@""])
                        [name appendString:@", "];

                    [name appendString:volumeName];
                }
            }

            CFRelease(disk);
        }
    }

    CFRelease(session);

    return name.length ? name : nil;
}

+ (NSDictionary *)descriptionForDevice:(NSInteger)bsdNum
{
    DASessionRef session = DASessionCreate(kCFAllocatorDefault);
    NSDictionary *resultDict = nil;

    assert(session);
    if (!session)
    {
        cc_log_error(@"Error:    DASessionCreate returned NULL");
        return nil;
    }


    const char *bsdName = makeString(@"/dev/disk%li", (long)bsdNum).UTF8String;
    DADiskRef disk = DADiskCreateFromBSDName(kCFAllocatorDefault, session, bsdName);

    if (disk)
    {
        CFDictionaryRef dict = DADiskCopyDescription(disk);
        if (dict)
        {
            resultDict = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)dict];
            CFRelease(dict);

#ifdef USE_IOKIT
            NSString *path = resultDict[@"DADevicePath"];
            io_registry_entry_t entry = IORegistryEntryFromPath(kIOMasterPortDefault, path.UTF8String);

            if (entry != MACH_PORT_NULL)
            {
                CFTypeRef property = IORegistryEntryCreateCFProperty(entry, CFSTR(kIOPropertyDeviceCharacteristicsKey), kCFAllocatorDefault, 0);

                if (property)
                {
                    NSString *mediumTypeKey = @(kIOPropertyMediumTypeKey);
                    NSString *mediumTypeSSDKey = @(kIOPropertyMediumTypeSolidStateKey);

                    NSDictionary *propertyDict = (__bridge NSDictionary *)property;
                    NSString *mediumType = propertyDict[mediumTypeKey];

                    if ([mediumType isEqualToString:mediumTypeSSDKey])
                        resultDict = [resultDict dictionaryBySettingValue:@(YES) forKey:@"isSSD"];

                    CFRelease(property);
                }
                else
                    cc_log_error(@"Error:    could not IORegistryEntryCreateCFProperty() for IORegistryEntryFromPath()");

                IOObjectRelease(entry);
            }
            else
                cc_log_error(@"Error:    could not IORegistryEntryFromPath(%@) for DADevicePath - dict %@", path, resultDict.description);
#endif
        }
        else
        {
            cc_log_error(@"Error:    DADiskCopyDescription returned NULL");
        }

        CFRelease(disk);
    }
    else
    {
        cc_log_error(@"Error:    DADiskCreateFromBSDName returned NULL");
    }

    CFRelease(session);
    
    if ([resultDict[@"DABusName"] contains:@"NVMe"] || [resultDict[@"DABusPath"] contains:@"NVMe"] || [resultDict[@"DADevicePath"] contains:@"NVMe"] || [resultDict[@"DAMediaPath"] contains:@"NVMe"])
        resultDict = [resultDict dictionaryBySettingValue:@(YES) forKey:@"isNVME"];

    return resultDict;
}
#endif


+ (BOOL)isUserAdmin
{
    uid_t current_user_id = getuid();
    struct passwd *pwentry = getpwuid(current_user_id);
    struct group *admin_group = getgrnam("admin");
    while(*admin_group->gr_mem != NULL)
    {
        if (strcmp(pwentry->pw_name, *admin_group->gr_mem) == 0)
        {
            return YES;
        }
        admin_group->gr_mem++;
    }
    
    return NO;
}

+ (NSURL *)growlInstallURL
{
    NSString *appPath = @"/Applications/Growl.app";
    NSString *userPath = (@"~/Library/PreferencePanes/Growl.prefPane/Contents/Resources/GrowlHelperApp.app").stringByExpandingTildeInPath;
    NSString *systemPath = @"/Library/PreferencePanes/Growl.prefPane/Contents/Resources/GrowlHelperApp.app";
    NSURL *url = nil;
    
    if ([NSFileManager.defaultManager fileExistsAtPath:appPath])
        url    = [NSURL fileURLWithPath:appPath];
    else if ([NSFileManager.defaultManager fileExistsAtPath:userPath])
        url    = [NSURL fileURLWithPath:userPath];
    else if ([NSFileManager.defaultManager fileExistsAtPath:systemPath])
        url    = [NSURL fileURLWithPath:systemPath];
    
    return url;
}

#ifdef USE_IOKIT
+ (NSString *)macAddress
{
    NSString *result = @"";
    kern_return_t kernResult = KERN_SUCCESS;

    io_iterator_t intfIterator = 0;
    UInt8 MACAddress[kIOEthernetAddressSize];

    kernResult = FindEthernetInterfaces(&intfIterator);

    if (KERN_SUCCESS != kernResult)
        cc_log_error(@"Error:    FindEthernetInterfaces returned 0x%08x", kernResult);
    else
    {
        kernResult = GetMACAddress(intfIterator, MACAddress);

        if (KERN_SUCCESS != kernResult)
            cc_log_error(@"Error:    GetMACAddress returned 0x%08x", kernResult);
        else
        {
            uint8_t i;

            for (i = 0; i < kIOEthernetAddressSize; i++)
            {
                if (![result isEqualToString:@""])
                    result = [result stringByAppendingString:@":"];

                if (MACAddress[i] <= 15)
                    result = [result stringByAppendingString:@"0"];

                result = [result stringByAppendingFormat:@"%x", MACAddress[i]];
            }
        }
    }

    if (intfIterator)
        IOObjectRelease(intfIterator);

    return result;
}
#endif


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcast-align"

+ (NSString *)ipAddress:(bool)ipv6
{
//    NSArray *a = [[NSHost currentHost] addresses]; // [NSHost currentHost]  broken
//    NSMutableArray *b = [NSMutableArray arrayWithCapacity:[a count]];
//    unsigned char i;
//    unsigned char longestitem = 0, longest = 0;
//
//    for (i = 0; i < [a count]; i++)
//    {
//        if ([[a objectAtIndex:i] rangeOfString:ipv6 ? @":" : @"."].location != NSNotFound)
//            [b addObject:[a objectAtIndex:i]];
//    }
//
//
//    if ([b count] <= 1)
//        return [b objectAtIndex:0];
//
//    [b removeObjectIdenticalTo:ipv6 ? @"::1" : @"127.0.0.1"];
//
//    if ([b count] <= 1)
//        return [b objectAtIndex:0];
//
//
//    for (i = 0; i < [b count]; i++)
//    {
//        if ([(NSString *)[b objectAtIndex:i] length] > longest)
//        {
//            longest = [(NSString *)[b objectAtIndex:i] length];
//            longestitem = i;
//        }
//    }
//
//
//    return [b objectAtIndex:longestitem];
    struct ifaddrs *myaddrs, *ifa;
    struct sockaddr_in *s4;
    struct sockaddr_in6 *s6;
    int status;
    /* buf must be big enough for an IPv6 address (e.g. 3ffe:2fa0:1010:ca22:020a:95ff:fe8a:1cf8) */
    char buf[64];

    status = getifaddrs(&myaddrs);
    if (status != 0)
    {
        perror("getifaddrs");
        exit(1);
    }

    for (ifa = myaddrs; ifa != NULL; ifa = ifa->ifa_next)
    {
        if (ifa->ifa_addr == NULL) continue;
        if ((ifa->ifa_flags & IFF_UP) == 0) continue;

        if ((ifa->ifa_addr->sa_family == AF_INET) && !ipv6)
        {
            s4 = (struct sockaddr_in *)(ifa->ifa_addr);
            if (inet_ntop(ifa->ifa_addr->sa_family, (void *)&(s4->sin_addr), buf, sizeof(buf)) == NULL)
            {
                //printf("%s: inet_ntop failed!\n", ifa->ifa_name);
            }
            else
            {
                //printf("%s: %s\n", ifa->ifa_name, buf);

                if (![@(ifa->ifa_name) hasPrefix:@"lo"])
                {
                    freeifaddrs(myaddrs);
                    NSString *ip = @(buf);
                    if (ip)
                        return ip;
                }
            }
        }
        else if ((ifa->ifa_addr->sa_family == AF_INET6) && ipv6)
        {
            s6 = (struct sockaddr_in6 *)(ifa->ifa_addr);
            if (inet_ntop(ifa->ifa_addr->sa_family, (void *)&(s6->sin6_addr), buf, sizeof(buf)) == NULL)
            {
                //printf("%s: inet_ntop failed!\n", ifa->ifa_name);
            }
            else
            {
                //printf("%s: %s\n", ifa->ifa_name, buf);

                if (![@(ifa->ifa_name) hasPrefix:@"lo"])
                {
                    freeifaddrs(myaddrs);
                    NSString *ip = @(buf);
                    if (ip)
                        return ip;
                }
            }
        }
    }

    freeifaddrs(myaddrs);

    return ipv6 ? @"::1" : @"127.0.0.1";
}
#pragma clang diagnostic pop

#ifdef USE_SYSTEMCONFIGURATION
+ (BOOL)isOnline
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    Boolean connected = SCNetworkReachabilityGetFlags(reachability, &flags);
    BOOL isConnected = connected && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);
    return isConnected;
}

+ (NSString *)ipName
{
    //return [[NSHost currentHost] name]; // [NSHost currentHost]  broken

    SCDynamicStoreRef dynRef = SCDynamicStoreCreate(kCFAllocatorSystemDefault,
                                                    (__bridge CFStringRef)cc.appName,
                                                    NULL, NULL);

    if (dynRef)
    {
        CFStringRef hostnameCF = SCDynamicStoreCopyLocalHostName(dynRef);
        CFRelease(dynRef);

        if (!hostnameCF)
        {
            cc_log_error(@"Error: SCDynamicStoreCopyLocalHostName == NULL, %i", __LINE__);
            return @"";
        }
        NSString *hostname = [NSString stringWithFormat:@"%@.local", (__bridge NSString *)hostnameCF];
        CFRelease(hostnameCF);

        return hostname;
    }
    else
    {
        cc_log_error(@"Error: SCDynamicStoreCreate == NULL, %i", __LINE__);
        return @"";
    }
}
#endif

+ (NSString *)machineType
{
    char modelBuffer[256];
    size_t sz = sizeof(modelBuffer);
    if (0 == sysctlbyname("hw.model", modelBuffer, &sz, NULL, 0))
    {
        modelBuffer[sizeof(modelBuffer) - 1] = 0;
        return @(modelBuffer);
    }
    else
    {
        return @"";
    }
}

+ (NSInteger)bootDiskBSDNum
{
    static NSInteger num = -100;
    
    if (num == -100)
    {
        struct statfs buffer;
        statfs("/", &buffer);
        NSString *bootDiskString = @(buffer.f_mntfromname);
        if (![bootDiskString hasPrefix:@"/dev/disk"])
            return -1;
        NSString *bsdNumStr = [[bootDiskString substringFromIndex:9] componentsSeparatedByString:@"s"][0];
        num = bsdNumStr.integerValue;
    }
    
    return num;
}

+ (void)_addDiskToList:(NSMutableArray *)array number:(NSNumber *)num name:(NSString *)name detail:(NSString *)detail
{
    BOOL found = FALSE;
    
    for (NSMutableDictionary *disk in array)  
    {
        NSNumber *diskNum = disk[kDiskNumberKey];
        if ([diskNum isEqualToNumber:num])
        {
            NSString *currentName = disk[kDiskNameKey];
            disk[kDiskNameKey] = [name stringByAppendingFormat:@", %@", currentName];
            
            //cc_log_debug(@"_addDiskToList replace name unique %@\n", [disk description]);

            found = TRUE;
        }
    }

    if (!found)
    {
        NSMutableDictionary *diskDict = [NSMutableDictionary dictionary];

        diskDict[kDiskNumberKey] = num;
        diskDict[kDiskNameKey] = ((detail) ? makeString(@"%@ (%@)", name, detail) : name);
        
        //cc_log_debug(@"_addDiskToList add unique %@\n", [diskDict description]);
        
        [array addObject:diskDict];
    }
}

#ifdef USE_IOKIT
#ifdef USE_DISKARBITRATION

+ (NSString *)_serialNumberForIOKitObject:(io_object_t)ggparent
{
    NSString *serial = nil;
    
    CFTypeRef s = IORegistryEntrySearchCFProperty(ggparent, kIOServicePlane, CFSTR("Serial Number"), kCFAllocatorDefault, kIORegistryIterateRecursively | kIORegistryIterateParents);
    if (s)
    {
        cc_log_debug(@"Serial Number: %@", (__bridge NSString *) s);
        serial = [(__bridge NSString *)s copy];
        CFRelease(s);
    }
    else
    {
        s = IORegistryEntrySearchCFProperty(ggparent, kIOServicePlane, CFSTR("device serial"), kCFAllocatorDefault, kIORegistryIterateRecursively | kIORegistryIterateParents);
        if (s)
        {
            cc_log_debug(@"Serial Number: %@", (__bridge NSString *) s);
            serial = [(__bridge NSString *)s copy];
            CFRelease(s);
        }
        else
        {    
            s = IORegistryEntrySearchCFProperty(ggparent, kIOServicePlane, CFSTR("USB Serial Number"), kCFAllocatorDefault, kIORegistryIterateRecursively | kIORegistryIterateParents);
            if (s)
            {
                cc_log_debug(@"USB Serial Number: %@", (__bridge NSString *) s);
                serial = [(__bridge NSString *)s copy];
                
                CFRelease(s);
            }
            //                                                                                            else
            //                                                                                                cc_log_error(@"Error: couldn't get serial number");
        }
    }
    
    NSString *info = serial ? [serial stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"NOSERIAL";

    
    return info;
}


+ (void)_findZFSBacking:(BOOL *)foundBacking_p volumeName:(NSString *)volumeName nonRemovableVolumes:(NSMutableArray *)nonRemovableVolumes bsdNum:(NSInteger)bsdNum
{
    kern_return_t                kernResult;
    CFMutableDictionaryRef        matchingDict;
    io_iterator_t                iter;
    
    LOGMOUNTEDHARDDISK(@"mountedHarddisks ZFS");

    matchingDict = IOServiceMatching(kIOMediaClass);
    if (matchingDict != NULL)
    {
        kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &iter);
        
        if ((KERN_SUCCESS == kernResult) && (iter != 0))
        {
            io_object_t object;
            
            while ((object = IOIteratorNext(iter)))
            {
                
                CFTypeRef    bsdVolume = NULL;
                
                bsdVolume = IORegistryEntryCreateCFProperty(object, CFSTR("BSD Name"), kCFAllocatorDefault, 0);
                if (bsdVolume)
                {
                                        
                    if ([(__bridge NSString *)bsdVolume isEqualToString:[NSString stringWithFormat:@"disk%li", bsdNum]])
                    {
                        LOGMOUNTEDHARDDISK(@"mountedHarddisks ZFS found match");

                        io_iterator_t           parents = MACH_PORT_NULL;
                        kern_return_t res = IORegistryEntryGetParentIterator (object, kIOServicePlane, &parents);
                        
                        if ((KERN_SUCCESS == res) && (parents != 0))
                        {
                            io_object_t parent;
                            
                            while ((parent = IOIteratorNext(parents)))
                            {
                                io_iterator_t gparents = MACH_PORT_NULL;
                                
                                kern_return_t res2 = IORegistryEntryGetParentIterator (parent, kIOServicePlane, &gparents);
                                
                                if ((KERN_SUCCESS == res2) && (gparents != 0))
                                {
                                    io_object_t gparent;
                                    
                                    while ((gparent = IOIteratorNext(gparents)))
                                    {
                                        
                                        CFTypeRef data = IORegistryEntrySearchCFProperty(gparent, kIOServicePlane, CFSTR("BSD Name"), kCFAllocatorDefault, kIORegistryIterateRecursively | kIORegistryIterateParents);
                                        if (data)
                                        {
                                            LOGMOUNTEDHARDDISK(@"mountedHarddisks ZFS found match %@", (__bridge NSString *)data);


                                            NSMutableDictionary *diskDict2 = [NSMutableDictionary dictionary];
                                            
                                            
                                            if ([(__bridge NSString *)data hasPrefix:@"disk"] && (((__bridge NSString *)data).length >= 5))
                                            {
                                                NSInteger num = [(__bridge NSString *)data substringFromIndex:4].integerValue;
                                                diskDict2[kDiskNumberKey] = @(num);
                                            }
                                            else
                                                cc_log_error(@"Error: bsd name doesn't look good %@", (__bridge NSString *) data);
                                            
                                            CFRelease(data);
                                            
                                            
                                            
                                            if (diskDict2[kDiskNumberKey])
                                            {
                                                NSString *serial = [self _serialNumberForIOKitObject:gparent];
                                                
                                                [self _addDiskToList:nonRemovableVolumes
                                                              number:diskDict2[kDiskNumberKey]
                                                                name:volumeName
                                                              detail:serial];
                                                
                                                LOGMOUNTEDHARDDISK(@"mountedHarddisks found zfs backing %@", [diskDict2 description]);
                                                
                                                *foundBacking_p = true;
                                                //    NSLog(@"disk Dict %@", diskDict2);
                                                
                                            }
                                        }
                                        else
                                            cc_log_error(@"Error: couldn't get bsd name");
                                        
                                        IOObjectRelease(gparent);
                                    }
                                    
                                    IOObjectRelease(gparents);
                                }
                                
                                IOObjectRelease(parent);
                            }
                            
                            IOObjectRelease(parents);
                        }
                        
                    }
                    CFRelease(bsdVolume);
                }
                IOObjectRelease(object);
                
            }
            IOObjectRelease(iter);
        }
    }
}

+ (BOOL)_findRAIDBacking:(NSString *)bsdName props:(NSDictionary *)props volumeName:(NSString *)volumeName nonRemovableVolumes:(NSMutableArray *)nonRemovableVolumes
{
    BOOL foundBacking = false;
    LOGMOUNTEDHARDDISK(@"mountedHarddisks found props %@", bsdName);
    
    CFUUIDRef DAMediaUUID = (__bridge CFUUIDRef)props[@"DAMediaUUID"];
    if (DAMediaUUID)
    {
        CFStringRef uuidCF = CFUUIDCreateString(kCFAllocatorDefault, DAMediaUUID);
        NSString *uuid = (__bridge NSString *)uuidCF;


        
        LOGMOUNTEDHARDDISK(@"mountedHarddisks found UUID %@ %@", bsdName, uuid);
        
        
        kern_return_t                kernResult;
        CFMutableDictionaryRef        matchingDict;
        io_iterator_t                iter;
        
        
        matchingDict = IOServiceMatching(kIOMediaClass);
        if (matchingDict != NULL)
        {
            kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &iter);
            
            if ((KERN_SUCCESS == kernResult) && (iter != 0))
            {
                io_object_t object;
                
                while ((object = IOIteratorNext(iter)))
                {
                    CFTypeRef    ourUUID = IORegistryEntryCreateCFProperty(object, CFSTR(kIOMediaUUIDKey), kCFAllocatorDefault, 0);
                    if (ourUUID)
                    {
                        if ([(__bridge NSString *)ourUUID isEqualToString:uuid])
                        {
                            LOGMOUNTEDHARDDISK(@"mountedHarddisks found matching UUID %@", bsdName);
                            
                            
                            CFTypeRef    d = NULL;
                            d = IORegistryEntryCreateCFProperty(object, CFSTR("SoftRAID Provider Array"), kCFAllocatorDefault, 0);
                            if (d)
                            {
                                LOGMOUNTEDHARDDISK(@"mountedHarddisks SOFTRAID");
                                
                                for (NSString *name in (__bridge NSArray *)d)
                                {    
                                    if ([name hasPrefix:@"disk"] && (name.length >= 5))
                                    {
                                        NSString *numStr = [(NSString *)name substringFromIndex:4];
                                        NSInteger num;
                                        if ([numStr contains:@"s"])
                                            num = [numStr componentsSeparatedByString:@"s"][0].integerValue;
                                        else
                                            num = numStr.integerValue;
                                        
                                        [self _addDiskToList:nonRemovableVolumes
                                                      number:@(num)
                                                        name:volumeName
                                                      detail:name];
                                        
                                        LOGMOUNTEDHARDDISK(@"mountedHarddisks found1\n");
                                        
                                        foundBacking = true;
                                    }
                                    else
                                        cc_log_error(@"Error: 1bsd name doesn't look good %@", (NSString *) name);
                                    
                                }
                                CFRelease(d);
                            }
                            else
                            {
                                io_iterator_t           parents = MACH_PORT_NULL;
                                kern_return_t res = IORegistryEntryGetParentIterator (object, kIOServicePlane, &parents);
                                
                                if ((KERN_SUCCESS == res) && (parents != 0))
                                {
                                    io_object_t parent;
                                    
                                    while ((parent = IOIteratorNext(parents)))
                                    {
                                        io_iterator_t gparents = MACH_PORT_NULL;
                                        
                                        kern_return_t res2 = IORegistryEntryGetParentIterator (parent, kIOServicePlane, &gparents);
                                        
                                        if ((KERN_SUCCESS == res2) && (gparents != 0))
                                        {
                                            io_object_t gparent;
                                            
                                            while ((gparent = IOIteratorNext(gparents)))
                                            {
                                                io_iterator_t ggparents = MACH_PORT_NULL;
                                                
                                                kern_return_t res3 = IORegistryEntryGetParentIterator (gparent, kIOServicePlane, &ggparents);
                                                
                                                if ((KERN_SUCCESS == res3) && (ggparents != 0))
                                                {
                                                    io_object_t ggparent;
                                                    
                                                    while ((ggparent = IOIteratorNext(ggparents)))
                                                    {
                                                        
                                                        CFTypeRef    data = NULL;
                                                        NSMutableDictionary *diskDict2 = [NSMutableDictionary dictionary];
                                                        
                                                        
                                                        data = IORegistryEntrySearchCFProperty(ggparent, kIOServicePlane, CFSTR("BSD Name"), kCFAllocatorDefault, kIORegistryIterateRecursively | kIORegistryIterateParents);
                                                        if (data)
                                                        {                                                                            
                                                            if ([(__bridge NSString *)data hasPrefix:@"disk"] && (((__bridge NSString *)data).length >= 5))
                                                            {
                                                                NSInteger num = [(__bridge NSString *)data substringFromIndex:4].integerValue;
                                                                diskDict2[kDiskNumberKey] = @(num);
                                                            }
                                                            else
                                                                cc_log_error(@"Error: bsd name doesn't look good %@", (__bridge NSString *) data);
                                                            
                                                            CFRelease(data);
                                                            
                                                            
                                                            
                                                            if (diskDict2[kDiskNumberKey])
                                                            {
                                                                NSString *serial = [self _serialNumberForIOKitObject:ggparent];
                                                                
                                                                [self _addDiskToList:nonRemovableVolumes
                                                                              number:diskDict2[kDiskNumberKey]
                                                                                name:volumeName
                                                                              detail:serial];
                                                                
                                                                LOGMOUNTEDHARDDISK(@"mountedHarddisks found %@", [diskDict2 description]);
                                                                
                                                                foundBacking = true;
                                                                //    NSLog(@"disk Dict %@", diskDict2);
                                                            }
                                                            
                                                        }
                                                        else
                                                        {
                                                            LOGMOUNTEDHARDDISK(@"Error: couldn't get bsd name");
                                                        }

                                                        
                                                        
                                                        IOObjectRelease(ggparent);
                                                    }
                                                }
                                                IOObjectRelease(gparent);
                                            }
                                            IOObjectRelease(gparents);
                                        }
                                        IOObjectRelease(parent);
                                    }
                                }
                                IOObjectRelease(parents);
                            }
                        }
                        CFRelease(ourUUID);
                    }
                    IOObjectRelease(object);
                }
                IOObjectRelease(iter);
            }
        }

        CFRelease(uuidCF);
    }
    return foundBacking;
}

+ (NSMutableArray *)mountedHarddisks:(BOOL)includeRAIDBackingDevices
{
    NSMutableArray  *nonRemovableVolumes = [NSMutableArray array];


    DASessionRef session = DASessionCreate(kCFAllocatorDefault);
    assert(session);
    if (!session)
    {
        cc_log_error(@"Error:    DASessionCreate returned NULL");
        return nil;
    }



    NSArray *urls = [NSFileManager.defaultManager mountedVolumeURLsIncludingResourceValuesForKeys:@[NSURLVolumeNameKey] options:(NSVolumeEnumerationOptions)0];
    for (NSURL *mountURL in urls)
    {
        if ([mountURL.path isEqualToString:@"/private/var/vm"]) // ignore HighSierra 'VM' partition
            continue;
        
        NSError *error;
        NSNumber *isRemovable;
        [mountURL getResourceValue:&isRemovable forKey:NSURLVolumeIsRemovableKey error:&error];
        NSNumber *isEjectable;
        [mountURL getResourceValue:&isEjectable forKey:NSURLVolumeIsEjectableKey error:&error];

        if (isRemovable.intValue)
        {
            LOGMOUNTEDHARDDISK(@"ignoring because of removable: %@", mountURL);
            continue;
        }
        if (isEjectable.intValue)
        {
            LOGMOUNTEDHARDDISK(@"ignoring because of ejectable: %@", mountURL);
            continue;
        }

        NSString *volumeName;
        [mountURL getResourceValue:&volumeName forKey:NSURLVolumeNameKey error:&error];


        if (volumeName)
        {
            DADiskRef disk = DADiskCreateFromVolumePath(kCFAllocatorDefault, session, (__bridge CFURLRef)mountURL);

            if (disk)
            {
                const char *utfBSDName = DADiskGetBSDName(disk);
                if (utfBSDName)
                {

                    NSString *bsdName = @(utfBSDName);

                    cc_log_debug(@"Volume mounted at: %@  %@ %@", [mountURL path], volumeName, bsdName);

                    LOGMOUNTEDHARDDISK(@"mountedHarddisks found IOKit name %@", volumeName);

                    {

                        LOGMOUNTEDHARDDISK(@"mountedHarddisks has BSD name %@", bsdName);

                        if (![bsdName hasPrefix:@"disk"])
                        {
                            CFRelease(disk);
                            continue;
                        }
                        NSString *bsdNumStr = [[bsdName substringFromIndex:4] componentsSeparatedByString:@"s"][0];
                        NSInteger bsdNum = bsdNumStr.integerValue;
                        BOOL found = FALSE;

                        for (NSMutableDictionary *foundDisk in nonRemovableVolumes)  // check if we already added the disk because of another partition
                        {
                            NSNumber *diskNum = foundDisk[kDiskNumberKey];
                            
                            if (diskNum.integerValue == bsdNum)
                            {
                                NSString *currentName = foundDisk[kDiskNameKey];
                                foundDisk[kDiskNameKey] = [currentName stringByAppendingFormat:@", %@", volumeName];
                                found = TRUE;
                            }
                        }

                        if (!found) // new disk
                        {
                            BOOL foundBacking = false;


                            if (includeRAIDBackingDevices)
                            {
                                CFDictionaryRef propsCF = DADiskCopyDescription(disk);
                                if (propsCF)
                                {
                                    NSDictionary *props = (__bridge NSDictionary *)propsCF;


                                    LOGMOUNTEDHARDDISK(@"mountedHarddisks checking for raid backing %@", bsdName);

                                    if ([props[@"DAVolumeKind"] isEqualToString:@"zfs"])
                                    {
                                        [self _findZFSBacking:&foundBacking volumeName:volumeName nonRemovableVolumes:nonRemovableVolumes bsdNum:bsdNum];
                                    }
                                    else if ((props[@"DAMediaLeaf"] && [props[@"DAMediaLeaf"] intValue]) ||
                                             ([props[@"DAMediaName"] isEqualToString:@"AppleAPFSMedia"]))
                                    {
                                        foundBacking = [self _findRAIDBacking:bsdName props:props volumeName:volumeName nonRemovableVolumes:nonRemovableVolumes];
                                    }

                                    CFRelease(propsCF);
                                }
                                else
                                    cc_log_error(@"Error: DADiskCopyDescription == NULL, %i", __LINE__);
                            }

                            if (!foundBacking)
                            {
                                [self _addDiskToList:nonRemovableVolumes
                                              number:@(bsdNum)
                                                name:volumeName
                                              detail:nil];


                                LOGMOUNTEDHARDDISK(@"mountedHarddisks is new disk without backing %@", bsdName);
                            }
                            else
                                LOGMOUNTEDHARDDISK(@"mountedHarddisks ignoring volume with raid/zfs backing %@", bsdName);
                        }
                    }
                }

                CFRelease(disk);
            }
        }
        else
            cc_log_error(@"Error: getResourceValue == NULL, %i", __LINE__);
    }

    CFRelease(session);


    if (nonRemovableVolumes.count >= 2) // move boot volume to first spot
    {
        NSInteger bootDisk = [self bootDiskBSDNum];

        for (NSUInteger i = 1; i < nonRemovableVolumes.count; i++)
        {
            NSDictionary *disk = nonRemovableVolumes[i];

            if ([disk[kDiskNumberKey] integerValue] == bootDisk)
            {
                [nonRemovableVolumes exchangeObjectAtIndex:0 withObjectAtIndex:i];

                break;
            }
        }
    }

    return nonRemovableVolumes;
}

+ (NSArray *)allHarddisks
{
    DASessionRef session = DASessionCreate(kCFAllocatorDefault);
    
    int subsequentNil = 0;
    NSMutableArray *disks = [NSMutableArray array];
    for (int i = 0; i < 64 && subsequentNil < 5; i++)
    {
        NSString *bsdname = [NSString stringWithFormat:@"/dev/disk%i", i];
        const char *bsdnameC = bsdname.UTF8String;

        DADiskRef disk = DADiskCreateFromBSDName(kCFAllocatorDefault, session, bsdnameC);
        CFDictionaryRef propsCF = DADiskCopyDescription(disk);
        NSDictionary *props = (__bridge NSDictionary *)propsCF;

        if (!props)
            subsequentNil ++;
        else
        {
            subsequentNil = 0;
            NSString *name = props[@"DAVolumeName"];
            [disks addObject:@{kDiskNameKey :name ? name :  bsdname, kDiskNumberKey : @(i)}];
            
            CFRelease(propsCF);
        }
        
        
        CFRelease(disk);
        disk = NULL;
        
    }
    CFRelease(session);
    return disks.immutableObject;
}
#endif



#ifdef USE_IOKIT
+ (BOOL)runsOnBattery
{
    CFTypeRef        blob = IOPSCopyPowerSourcesInfo();
    if (!blob)        return FALSE;
    CFArrayRef        array = IOPSCopyPowerSourcesList(blob);
    BOOL            ret = FALSE;
    
    if (array)
    {
        for (int i = 0 ; i < CFArrayGetCount(array); i++)
        {
            CFDictionaryRef    dict = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(array, i));
            CFStringRef        str = (CFStringRef)CFDictionaryGetValue(dict, CFSTR(kIOPSPowerSourceStateKey));

            if (CFEqual(str, CFSTR(kIOPSBatteryPowerValue)))
                ret = TRUE;
        }
        CFRelease(array);
    }
    CFRelease(blob);

    return ret;
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshift-sign-overflow"
+ (smartStatusEnum)getDiskSMARTStatus:(int)disk
{
    smartStatusEnum status = kSMARTStatusUnknown;
    IOReturn err;
    uint16_t i = 0;


    err = getSMARTStatusForDisk(disk, &status);
    while ((err == kIOReturnNotResponding) && (i < 50))            // wait until disk is spun up
    {
        usleep(100000); // 0.1 sec
        err = getSMARTStatusForDisk(disk, &status);
        i++;
    }
    if ((status == kSMARTStatusOK) && (err != 0)) // downgrade status
    {
        status = kSMARTStatusUnknown;
        cc_log_error(@"Error: S.M.A.R.T. check downgraded result for disk%i from VERIFIED to UNKNOWN because some error(%i) occurred.", disk, err);
    }
    else if (err == kIOReturnNoResources)
        status = kSMARTStatusNotSMARTCompatible;


    return status;
}
+ (NSDictionary *)getDiskSMARTAttributes:(int)disk
{
    NSMutableDictionary *attrs = @{}.mutableObject;
    IOReturn err = getSMARTAttributesForDisk(disk, attrs);

    if (err != kIOReturnSuccess)
    {
        cc_log_debug(@"Info: S.M.A.R.T. attribute check failed for disk %i with status %i", disk, err);
        return nil;
    }
    else
        return attrs.immutableObject;

}
#pragma clang diagnostic pop
#endif
#endif
@end

#ifdef USE_IOKIT
// Returns an iterator containing the primary (built-in) Ethernet interface. The caller is responsible for
// releasing the iterator after the caller is done with it.
static kern_return_t FindEthernetInterfaces(io_iterator_t *matchingServices)
{
    kern_return_t kernResult;
    mach_port_t masterPort;
    CFMutableDictionaryRef matchingDict;
    CFMutableDictionaryRef propertyMatchDict;

    // Retrieve the Mach port used to initiate communication with I/O Kit
    kernResult = IOMasterPort(MACH_PORT_NULL, &masterPort);
    if (KERN_SUCCESS != kernResult)
    {
        cc_log_error(@"Error:    IOMasterPort returned %d", kernResult);
        return kernResult;
    }

    // Ethernet interfaces are instances of class kIOEthernetInterfaceClass.
    // IOServiceMatching is a convenience function to create a dictionary with the key kIOProviderClassKey and
    // the specified value.
    matchingDict = IOServiceMatching(kIOEthernetInterfaceClass);

    // Note that another option here would be:
    // matchingDict = IOBSDMatching("en0");

    if (NULL == matchingDict)
        cc_log_error(@"Error:    IOServiceMatching returned a NULL dictionary.");
    else
    {
        // Each IONetworkInterface object has a Boolean property with the key kIOPrimaryInterface. Only the
        // primary (built-in) interface has this property set to TRUE.

        // IOServiceGetMatchingServices uses the default matching criteria defined by IOService. This considers
        // only the following properties plus any family-specific matching in this order of precedence
        // (see IOService::passiveMatch):
        //
        // kIOProviderClassKey (IOServiceMatching)
        // kIONameMatchKey (IOServiceNameMatching)
        // kIOPropertyMatchKey
        // kIOPathMatchKey
        // kIOMatchedServiceCountKey
        // family-specific matching
        // kIOBSDNameKey (IOBSDNameMatching)
        // kIOLocationMatchKey

        // The IONetworkingFamily does not define any family-specific matching. This means that in
        // order to have IOServiceGetMatchingServices consider the kIOPrimaryInterface property, we must
        // add that property to a separate dictionary and then add that to our matching dictionary
        // specifying kIOPropertyMatchKey.

        propertyMatchDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0,
                                                      &kCFTypeDictionaryKeyCallBacks,
                                                      &kCFTypeDictionaryValueCallBacks);

        if (NULL == propertyMatchDict)
            cc_log_error(@"Error:    CFDictionaryCreateMutable returned a NULL dictionary.");
        else
        {
            // Set the value in the dictionary of the property with the given key, or add the key
            // to the dictionary if it doesn't exist. This call retains the value object passed in.
            CFDictionarySetValue(propertyMatchDict, CFSTR(kIOPrimaryInterface), kCFBooleanTrue);

            // Now add the dictionary containing the matching value for kIOPrimaryInterface to our main
            // matching dictionary. This call will retain propertyMatchDict, so we can release our reference
            // on propertyMatchDict after adding it to matchingDict.
            CFDictionarySetValue(matchingDict, CFSTR(kIOPropertyMatchKey), propertyMatchDict);
            CFRelease(propertyMatchDict);
        }
    }

    // IOServiceGetMatchingServices retains the returned iterator, so release the iterator when we're done with it.
    // IOServiceGetMatchingServices also consumes a reference on the matching dictionary so we don't need to release
    // the dictionary explicitly.
    kernResult = IOServiceGetMatchingServices(masterPort, matchingDict, matchingServices);

    if (KERN_SUCCESS != kernResult)
        cc_log_error(@"Error:    IOServiceGetMatchingServices returned %d", kernResult);

    return kernResult;
}

// Given an iterator across a set of Ethernet interfaces, return the MAC address of the last one.
// If no interfaces are found the MAC address is set to an empty string.
// In this sample the iterator should contain just the primary interface.

static kern_return_t GetMACAddress(io_iterator_t intfIterator, UInt8 *MACAddress)
{
    io_object_t intfService;
    io_object_t controllerService;
    kern_return_t kernResult = KERN_FAILURE;

    // Initialize the returned address
    bzero(MACAddress, kIOEthernetAddressSize);

    // IOIteratorNext retains the returned object, so release it when we're done with it.
    while ((intfService = IOIteratorNext(intfIterator)))
    {
        CFTypeRef MACAddressAsCFData;

        // IONetworkControllers can't be found directly by the IOServiceGetMatchingServices call,
        // since they are hardware nubs and do not participate in driver matching. In other words,
        // registerService() is never called on them. So we've found the IONetworkInterface and will
        // get its parent controller by asking for it specifically.

        // IORegistryEntryGetParentEntry retains the returned object, so release it when we're done with it.
        kernResult = IORegistryEntryGetParentEntry(intfService,
                                                   kIOServicePlane,
                                                   &controllerService);

        if (KERN_SUCCESS != kernResult)
            cc_log_error(@"Error:    IORegistryEntryGetParentEntry returned 0x%08x", kernResult);
        else
        {
            // Retrieve the MAC address property from the I/O Registry in the form of a CFData
            MACAddressAsCFData = IORegistryEntryCreateCFProperty(controllerService,
                                                                 CFSTR(kIOMACAddress),
                                                                 kCFAllocatorDefault,
                                                                 0);
            if (MACAddressAsCFData)
            {
                // CFShow(MACAddressAsCFData); for display purposes only; output goes to stderr

                // Get the raw bytes of the MAC address from the CFData
                CFDataGetBytes(MACAddressAsCFData, CFRangeMake(0, kIOEthernetAddressSize), MACAddress);
                CFRelease(MACAddressAsCFData);
            }

            // Done with the parent Ethernet controller object so we release it.
            (void) IOObjectRelease(controllerService);
        }

        // Done with the Ethernet interface object so we release it.
        (void) IOObjectRelease(intfService);
    }

    return kernResult;
}

#pragma pack(1)
typedef struct SMARTAttribute
{
    UInt8                attributeID;
    UInt16                flag;
    UInt8                currentValue;
    UInt8                worstValue;
    UInt8                rawValue[6];
    UInt8                reserved;
}  SMARTAttribute;
typedef struct VendorSpecificData
{
    UInt16                revisonNumber;
    SMARTAttribute        vendorAttributes[30];
}  VendorSpecificData;
typedef struct ThresholdAttribute
{
    UInt8                attributeId;
    UInt8                thresholdValue;
    UInt8                reserved[10];
} ThresholdAttribute;
typedef struct VendorSpecificDataThresholds
{
    UInt16                revisonNumber;
    ThresholdAttribute  thresholdEntries[30];
} VendorSpecificDataThresholds;
#pragma options align=reset

struct NVMESMARTData
{
    UInt8 criticalWarning;
    UInt8 temperature[2];
    UInt8 availableSpare;
    UInt8 availableSpareThreshold;
    UInt8 percentageUsed;
    UInt8 reserved1[26];
    UInt8 dataUnitsRead[16];
    UInt8 dataUnitsWritten[16];
    UInt8 hostReadCommands[16];
    UInt8 hostWriteCommands[16];
    UInt8 controllerBusyTime[16];
    UInt32 powerCycles[4];
    UInt32 powerOnHours[4];
    UInt32 unsafeShutdowns[4];
    UInt32 mediaAndDataIntegrityErrors[4];
    UInt32 numberOfErrorLogEntries[4];
    UInt32 warningCompositeTemperatureTime;
    UInt32 criticalCompositeTemperatureTime;
    UInt16 temperatureSensors[8];
    UInt32 thermalManagementTemperature1TransitionCount;
    UInt32 thermalManagementTemperature2TransitionCount;
    UInt32 totalTimeForThermalManagementTemperature1;
    UInt32 totalTimeForThermalManagementTemperature2;
    UInt8 reserved2[280];
};
typedef struct IONVMeSMARTInterface // reverse engineering thanks to https://smallhacks.wordpress.com/2017/09/20/how-to-monitor-nvme-drives-in-the-osx/
{
    IUNKNOWN_C_GUTS;
    UInt16 version;
    UInt16 revision;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wpadded"
    IOReturn ( *SMARTReadData )( void *  interface, struct NVMESMARTData * NVMeSMARTData );
    #pragma clang diagnostic pop
    IOReturn ( *GetIdentifyData )( void *  interface,  void * NVMeIdentifyControllerStruct, unsigned int ns );
    IOReturn ( *GetFieldCounters )( void *   interface, char * FieldCounters );
    IOReturn ( *ScheduleBGRefresh )( void *   interface);
    IOReturn ( *GetLogPage )( void *  interface, void * data, unsigned int, unsigned int);
    IOReturn ( *GetSystemCounters )( void *  interface, char *, unsigned int *);
    IOReturn ( *GetAlgorithmCounters )( void *  interface, char *, unsigned int *);
} IONVMeSMARTInterface;



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshift-sign-overflow"
static IOReturn getSMARTStatusForDisk(const int bsdDeviceNumber, smartStatusEnum *smart)
{
    io_object_t object = MACH_PORT_NULL;
    io_object_t parent = MACH_PORT_NULL;
    BOOL found = FALSE;
    IOReturn err = kIOReturnError;
    *smart = kSMARTStatusUnknown;


    object = IOServiceGetMatchingService(kIOMasterPortDefault, IOBSDNameMatching(kIOMasterPortDefault, 0, makeString(@"disk%i", bsdDeviceNumber).UTF8String));
    if (object == MACH_PORT_NULL)
        return kIOReturnNoResources;


    parent = object;
    while ((IOObjectConformsTo(object, kIOBlockStorageDeviceClass) == false))
    {
        err = IORegistryEntryGetParentEntry(object, kIOServicePlane, &parent);

        if (err != kIOReturnSuccess || parent == MACH_PORT_NULL)
        {
            IOObjectRelease(object);
            return kIOReturnNoResources;
        }

        object = parent;
    }

    if (IOObjectConformsTo(object, kIOBlockStorageDeviceClass))
    {
        Boolean hasSMART1 = FALSE;
        BOOL hasSMART2 = FALSE;
        Boolean hasSMART3 = FALSE;
        CFTypeRef data;

        data = IORegistryEntryCreateCFProperty(object, CFSTR(kIOPropertySMARTCapableKey), kCFAllocatorDefault, 0);
        if (data)
        {
            hasSMART1 = CFBooleanGetValue((CFBooleanRef) data);
            CFRelease(data);
        }

        data = IORegistryEntryCreateCFProperty(object, CFSTR(kIOUserClientClassKey), kCFAllocatorDefault, 0);
        if (data)
        {
            hasSMART2 = [(__bridge NSString *)data isEqualToString:@"ATASMARTUserClient"];
            CFRelease(data);
        }
        
        data = IORegistryEntryCreateCFProperty(object, CFSTR("NVMe SMART Capable"), kCFAllocatorDefault, 0);
        if (data)
        {
            hasSMART3 = CFBooleanGetValue((CFBooleanRef) data);
            CFRelease(data);
        }
        
        if (hasSMART1 || hasSMART2)
        {
            IOCFPlugInInterface **cfPlugInInterface = NULL;
            IOATASMARTInterface **smartInterface = NULL;
            HRESULT herr = S_OK;
            SInt32 score = 0;
            Boolean conditionExceeded = false;

            err = IOCreatePlugInInterfaceForService(object, kIOATASMARTUserClientTypeID, kIOCFPlugInInterfaceID, &cfPlugInInterface, &score);

            if (err == kIOReturnSuccess)
            {
                herr = (*cfPlugInInterface)->QueryInterface(cfPlugInInterface, CFUUIDGetUUIDBytes(kIOATASMARTInterfaceID), (LPVOID) &smartInterface);

                if ((herr == S_OK) && (smartInterface != NULL))
                {
                    err = (*smartInterface)->SMARTEnableDisableOperations(smartInterface, true);
                    if (err == kIOReturnSuccess)
                    {
                        err = (*smartInterface)->SMARTEnableDisableAutosave(smartInterface, true);
                        if (err == kIOReturnSuccess)
                        {
                            err = (*smartInterface)->SMARTReturnStatus(smartInterface, &conditionExceeded);
                            if (err == kIOReturnSuccess)
                            {
                                if (conditionExceeded)
                                    *smart = kSMARTStatusError;
                                else
                                    *smart = kSMARTStatusOK;

                                (*smartInterface)->SMARTEnableDisableAutosave(smartInterface, false);
                                (*smartInterface)->SMARTEnableDisableOperations(smartInterface, false);
                            }
                            else
                            {
                                cc_log_debug(@"S.M.A.R.T. check disk: %i  SMARTReturnStatus() failed with %x",  bsdDeviceNumber, err);
                            }
                        }
                        else
                        {
                            cc_log_debug(@"S.M.A.R.T. check disk: %i  SMARTEnableDisableAutosave() failed with %x",  bsdDeviceNumber, err);
                        }
                    }
                    else
                    {
                        cc_log_debug(@"S.M.A.R.T. check disk: %i  SMARTEnableDisableOperations() failed with %x",  bsdDeviceNumber, err);
                    }

                    (*smartInterface)->Release(smartInterface);
                    smartInterface = NULL;
                }
                else
                {
                    err = herr;
                    cc_log_debug(@"S.M.A.R.T. check disk: %i QueryInterface() failed with %x", bsdDeviceNumber, err);
                }

                IODestroyPlugInInterface(cfPlugInInterface);
            }
            else
            {
                cc_log_debug(@"S.M.A.R.T. check disk: %i  IOCreatePlugInInterfaceForService() failed with %x",  bsdDeviceNumber, err);
            }

            found = true;
        }
        else if (hasSMART3) // reverse engineering thanks to https://smallhacks.wordpress.com/2017/09/20/how-to-monitor-nvme-drives-in-the-osx/
        {
            // this either needs to run outside the sandbox or have this entitlement: <key>com.apple.security.temporary-exception.iokit-user-client-class</key> <array> <string>AppleNVMeSMARTUserClient</string> </array>
            #define kIONVMeSMARTUserClientTypeID CFUUIDGetConstantUUIDWithBytes(NULL, 0xAA, 0x0F, 0xA6, 0xF9, 0xC2, 0xD6, 0x45, 0x7F, 0xB1, 0x0B, 0x59, 0xA1, 0x32, 0x53, 0x29, 0x2F)
            #define kIONVMeSMARTInterfaceID CFUUIDGetConstantUUIDWithBytes(NULL, 0xcc, 0xd1, 0xdb, 0x19, 0xfd, 0x9a, 0x4d, 0xaf, 0xbf, 0x95, 0x12, 0x45, 0x4b, 0x23, 0xa, 0xb6)
            IOCFPlugInInterface **cfPlugInInterface = NULL;
            IONVMeSMARTInterface **smartInterface = NULL;
            HRESULT herr = S_OK;
            SInt32 score = 0;
            
            err = IOCreatePlugInInterfaceForService(object, kIONVMeSMARTUserClientTypeID, kIOCFPlugInInterfaceID, &cfPlugInInterface, &score);
            
            if (err == kIOReturnSuccess)
            {
                herr = (*cfPlugInInterface)->QueryInterface(cfPlugInInterface, CFUUIDGetUUIDBytes(kIONVMeSMARTInterfaceID), (LPVOID) &smartInterface);
                
                if ((herr == S_OK) && (smartInterface != NULL))
                {
                    struct NVMESMARTData smartdata;
                    
                    bzero(&smartdata, sizeof(smartdata));
                    
                    err =  (*smartInterface)->SMARTReadData(smartInterface, &smartdata);
                    if (err == kIOReturnSuccess)
                    {
                        UInt8 crit = smartdata.criticalWarning;
                        
                        if (crit != 0)
                            *smart = kSMARTStatusError;
                        else
                            *smart = kSMARTStatusOK;
                    }
                    else
                    {
                        cc_log_debug(@"S.M.A.R.T. check disk: %i  SMARTReadData() failed with %x",  bsdDeviceNumber, err);
                    }
                    (*smartInterface)->Release(smartInterface);
                    smartInterface = NULL;
                }
                else
                {
                    err = herr;
                    cc_log_debug(@"S.M.A.R.T. check disk: %i QueryInterface() failed with %x", bsdDeviceNumber, err);
                }
                
                IODestroyPlugInInterface(cfPlugInInterface);
            }
            else
                cc_log_debug(@"S.M.A.R.T. check disk: %i is NVME but could not open interface - probably blocked by sandbox", bsdDeviceNumber);
            
            found = true;
        }
        else
            cc_log_debug(@"S.M.A.R.T. check disk: %i not SMART capable", bsdDeviceNumber);
    }
    else
        cc_log_debug(@"S.M.A.R.T. check disk: %i not of kIOBlockStorageDeviceClass", bsdDeviceNumber);


    if (object != MACH_PORT_NULL)
        IOObjectRelease(object);

    return (found == false) ? kIOReturnNoResources : err;
}

static IOReturn getSMARTAttributesForDisk(const int bsdDeviceNumber, NSMutableDictionary *attributes)
{
    assert(attributes);
    assert(sizeof(SMARTAttribute) == 12);
    io_object_t object = MACH_PORT_NULL;
    io_object_t parent = MACH_PORT_NULL;
    BOOL found = FALSE;
    IOReturn err = kIOReturnError;


    object = IOServiceGetMatchingService(kIOMasterPortDefault, IOBSDNameMatching(kIOMasterPortDefault, 0, makeString(@"disk%i", bsdDeviceNumber).UTF8String));
    if (object == MACH_PORT_NULL)
        return kIOReturnNoResources;


    parent = object;
    while ((IOObjectConformsTo(object, kIOBlockStorageDeviceClass) == false))
    {
        err = IORegistryEntryGetParentEntry(object, kIOServicePlane, &parent);

        if (err != kIOReturnSuccess || parent == MACH_PORT_NULL)
        {
            IOObjectRelease(object);
            return kIOReturnNoResources;
        }

        object = parent;
    }

    if (IOObjectConformsTo(object, kIOBlockStorageDeviceClass))
    {
        Boolean hasSMART1 = FALSE;
        BOOL hasSMART2 = FALSE;
        Boolean hasSMART3 = FALSE;
           CFTypeRef data;

        data = IORegistryEntryCreateCFProperty(object, CFSTR(kIOPropertySMARTCapableKey), kCFAllocatorDefault, 0);
        if (data)
        {
            hasSMART1 = CFBooleanGetValue((CFBooleanRef) data);
            CFRelease(data);
        }

        data = IORegistryEntryCreateCFProperty(object, CFSTR(kIOUserClientClassKey), kCFAllocatorDefault, 0);
        if (data)
        {
            hasSMART2 = [(__bridge NSString *)data isEqualToString:@"ATASMARTUserClient"];
            CFRelease(data);
        }
        data = IORegistryEntryCreateCFProperty(object, CFSTR("NVMe SMART Capable"), kCFAllocatorDefault, 0);
        if (data)
        {
            hasSMART3 = CFBooleanGetValue((CFBooleanRef) data);
            CFRelease(data);
        }
        

        if (hasSMART1 || hasSMART2)
        {
            IOCFPlugInInterface **cfPlugInInterface = NULL;
            IOATASMARTInterface **smartInterface = NULL;
            HRESULT herr = S_OK;
            SInt32 score = 0;

            err = IOCreatePlugInInterfaceForService(object, kIOATASMARTUserClientTypeID, kIOCFPlugInInterfaceID, &cfPlugInInterface, &score);

            if (err == kIOReturnSuccess)
            {
                herr = (*cfPlugInInterface)->QueryInterface(cfPlugInInterface, CFUUIDGetUUIDBytes(kIOATASMARTInterfaceID), (LPVOID) &smartInterface);

                if ((herr == S_OK) && (smartInterface != NULL))
                {
                    err = (*smartInterface)->SMARTEnableDisableOperations(smartInterface, true);
                    if (err == kIOReturnSuccess)
                    {
                        err = (*smartInterface)->SMARTEnableDisableAutosave(smartInterface, true);
                        if (err == kIOReturnSuccess)
                        {
                            ATASMARTData        smartdata;
                            VendorSpecificData    dataVendorSpecific;
                            ATASMARTDataThresholds smartThresholds;
                            VendorSpecificDataThresholds smartThresholdVendorSpecifics;

                            bzero(&smartdata, sizeof(smartdata));
                            bzero(&dataVendorSpecific, sizeof(dataVendorSpecific));

                            err =  (*smartInterface)->SMARTReadData(smartInterface, &smartdata);
                            if (err == kIOReturnSuccess)
                            {
                                err = (*smartInterface)->SMARTValidateReadData(smartInterface, &smartdata);
                                if (err == kIOReturnSuccess)
                                {
                                    err = (*smartInterface)->SMARTReadDataThresholds(smartInterface, &smartThresholds);
                                    if (err == kIOReturnSuccess)
                                    {
                                        err = (*smartInterface)->SMARTValidateReadData(smartInterface, (ATASMARTData *)&smartThresholds);
                                        if (err == kIOReturnSuccess)
                                        {
                                            dataVendorSpecific = *((VendorSpecificData *) &(smartdata.vendorSpecific1));
                                            smartThresholdVendorSpecifics = *((VendorSpecificDataThresholds *)&(smartThresholds.vendorSpecific1));

                                            for (int i = 0; i < 30; i++)
                                            {
                                                SMARTAttribute attr = dataVendorSpecific.vendorAttributes[i];
                                                ThresholdAttribute thres = smartThresholdVendorSpecifics.thresholdEntries[i];

                                                if (attr.attributeID)
                                                {
                                                    UInt64 rawValue =    (((UInt64)attr.rawValue[5])  << 40) +
                                                                        (((UInt64)attr.rawValue[4]) << 32) +
                                                                        (((UInt64)attr.rawValue[3]) << 24) +
                                                                        (((UInt64)attr.rawValue[2]) << 16) +
                                                                        (((UInt64)attr.rawValue[1]) << 8) +
                                                                        attr.rawValue[0];

                                                    UInt8 threshold = (attr.attributeID == thres.attributeId) ? thres.thresholdValue : 0;

                                                    attributes[@(attr.attributeID)] = @{@"currentValue" : @(attr.currentValue),
                                                                                        @"worstValue" : @(attr.currentValue),
                                                                                        @"rawValue" : @(rawValue),
                                                                                        @"threshold" : @(threshold),
                                                                                        @"isPrefail" : @(attr.flag & 0x01),
                                                                                        @"isOnline" : @((attr.flag & 0x02) > 0 ? 1 : 0)};
                                                }
                                            }

                                            (*smartInterface)->SMARTEnableDisableAutosave(smartInterface, false);
                                            (*smartInterface)->SMARTEnableDisableOperations(smartInterface, false);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    (*smartInterface)->Release(smartInterface);
                    smartInterface = NULL;
                }
                else
                    err = herr;

                IODestroyPlugInInterface(cfPlugInInterface);
            }
            found = true;
        }
        else if (hasSMART3) // reverse engineering thanks to https://smallhacks.wordpress.com/2017/09/20/how-to-monitor-nvme-drives-in-the-osx/
        {
            // this either needs to run outside the sandbox or have this entitlement: <key>com.apple.security.temporary-exception.iokit-user-client-class</key> <array> <string>AppleNVMeSMARTUserClient</string> </array>

#define kIONVMeSMARTUserClientTypeID CFUUIDGetConstantUUIDWithBytes(NULL, 0xAA, 0x0F, 0xA6, 0xF9, 0xC2, 0xD6, 0x45, 0x7F, 0xB1, 0x0B, 0x59, 0xA1, 0x32, 0x53, 0x29, 0x2F)
#define kIONVMeSMARTInterfaceID CFUUIDGetConstantUUIDWithBytes(NULL, 0xcc, 0xd1, 0xdb, 0x19, 0xfd, 0x9a, 0x4d, 0xaf, 0xbf, 0x95, 0x12, 0x45, 0x4b, 0x23, 0xa, 0xb6)
            IOCFPlugInInterface **cfPlugInInterface = NULL;
            IONVMeSMARTInterface **smartInterface = NULL;
            HRESULT herr = S_OK;
            SInt32 score = 0;
            
            err = IOCreatePlugInInterfaceForService(object, kIONVMeSMARTUserClientTypeID, kIOCFPlugInInterfaceID, &cfPlugInInterface, &score);
            
            if (err == kIOReturnSuccess)
            {
                herr = (*cfPlugInInterface)->QueryInterface(cfPlugInInterface, CFUUIDGetUUIDBytes(kIONVMeSMARTInterfaceID), (LPVOID) &smartInterface);
                
                if ((herr == S_OK) && (smartInterface != NULL))
                {
                    struct NVMESMARTData smartdata;
                    
                    bzero(&smartdata, sizeof(smartdata));
                    
                    err =  (*smartInterface)->SMARTReadData(smartInterface, &smartdata);
                    if (err == kIOReturnSuccess)
                    {
                        UInt8 cw = smartdata.criticalWarning;
                        UInt16 t = (UInt16) (((((UInt32)smartdata.temperature[1]) << 8) + smartdata.temperature[0]) - 273); // hello kelvin
                        UInt8 as = smartdata.availableSpare;
                        UInt8 ast = smartdata.availableSpareThreshold;
                        UInt8 pu = smartdata.percentageUsed;
                        UInt64 dur =    (((UInt64)smartdata.dataUnitsRead[7]) << 56) +
                                        (((UInt64)smartdata.dataUnitsRead[6]) << 48) +
                                        (((UInt64)smartdata.dataUnitsRead[5]) << 40) +
                                        (((UInt64)smartdata.dataUnitsRead[4]) << 32) +
                                        (((UInt64)smartdata.dataUnitsRead[3]) << 24) +
                                        (((UInt64)smartdata.dataUnitsRead[2]) << 16) +
                                        (((UInt64)smartdata.dataUnitsRead[1]) << 8) +
                                        smartdata.dataUnitsRead[0];
                        UInt64 duw =    (((UInt64)smartdata.dataUnitsWritten[7]) << 56) +
                                        (((UInt64)smartdata.dataUnitsWritten[6]) << 48) +
                                        (((UInt64)smartdata.dataUnitsWritten[5]) << 40) +
                                        (((UInt64)smartdata.dataUnitsWritten[4]) << 32) +
                                        (((UInt64)smartdata.dataUnitsWritten[3]) << 24) +
                                        (((UInt64)smartdata.dataUnitsWritten[2]) << 16) +
                                        (((UInt64)smartdata.dataUnitsWritten[1]) << 8) +
                                        smartdata.dataUnitsWritten[0];
                        UInt64 hrc =    (((UInt64)smartdata.hostReadCommands[7]) << 56) +
                                        (((UInt64)smartdata.hostReadCommands[6]) << 48) +
                                        (((UInt64)smartdata.hostReadCommands[5]) << 40) +
                                        (((UInt64)smartdata.hostReadCommands[4]) << 32) +
                                        (((UInt64)smartdata.hostReadCommands[3]) << 24) +
                                        (((UInt64)smartdata.hostReadCommands[2]) << 16) +
                                        (((UInt64)smartdata.hostReadCommands[1]) << 8) +
                                        smartdata.hostReadCommands[0];
                        UInt64 hwc =    (((UInt64)smartdata.hostWriteCommands[7]) << 56) +
                                        (((UInt64)smartdata.hostWriteCommands[6]) << 48) +
                                        (((UInt64)smartdata.hostWriteCommands[5]) << 40) +
                                        (((UInt64)smartdata.hostWriteCommands[4]) << 32) +
                                        (((UInt64)smartdata.hostWriteCommands[3]) << 24) +
                                        (((UInt64)smartdata.hostWriteCommands[2]) << 16) +
                                        (((UInt64)smartdata.hostWriteCommands[1]) << 8) +
                                        smartdata.hostWriteCommands[0];
                        UInt64 cbt =    (((UInt64)smartdata.controllerBusyTime[7]) << 56) +
                                        (((UInt64)smartdata.controllerBusyTime[6]) << 48) +
                                        (((UInt64)smartdata.controllerBusyTime[5]) << 40) +
                                        (((UInt64)smartdata.controllerBusyTime[4]) << 32) +
                                        (((UInt64)smartdata.controllerBusyTime[3]) << 24) +
                                        (((UInt64)smartdata.controllerBusyTime[2]) << 16) +
                                        (((UInt64)smartdata.controllerBusyTime[1]) << 8) +
                                        smartdata.controllerBusyTime[0];
                        UInt64 pc =     (((UInt64)smartdata.powerCycles[1]) << 32) + smartdata.powerCycles[0];
                        UInt64 poh =    (((UInt64)smartdata.powerOnHours[1]) << 32) + smartdata.powerOnHours[0];
                        UInt64 us =    (((UInt64)smartdata.unsafeShutdowns[1]) << 32) + smartdata.unsafeShutdowns[0];
                        UInt64 me =    (((UInt64)smartdata.mediaAndDataIntegrityErrors[1]) << 32) + smartdata.mediaAndDataIntegrityErrors[0];
                        UInt64 le =    (((UInt64)smartdata.numberOfErrorLogEntries[1]) << 32) + smartdata.numberOfErrorLogEntries[0];


                        
                        attributes[@(900)] = @{@"currentValue" : @(cw), @"isOnline" : @(1)};
                        attributes[@(901)] = @{@"currentValue" : @(t), @"isOnline" : @(1)};
                        attributes[@(902)] = @{@"currentValue" : @(as), @"threshold": @(ast),  @"isOnline" : @(1)};
                        attributes[@(903)] = @{@"currentValue" : @(ast), @"isOnline" : @(1)};
                        attributes[@(904)] = @{@"currentValue" : @(pu), @"isOnline" : @(1)};
                        attributes[@(905)] = @{@"currentValue" : @(dur), @"isOnline" : @(1)};
                        attributes[@(906)] = @{@"currentValue" : @(duw), @"isOnline" : @(1)};
                        attributes[@(907)] = @{@"currentValue" : @(hrc), @"isOnline" : @(1)};
                        attributes[@(908)] = @{@"currentValue" : @(hwc), @"isOnline" : @(1)};
                        attributes[@(909)] = @{@"currentValue" : @(cbt), @"isOnline" : @(1)};
                        attributes[@(910)] = @{@"currentValue" : @(pc), @"isOnline" : @(1)};
                        attributes[@(911)] = @{@"currentValue" : @(poh), @"isOnline" : @(1)};
                        attributes[@(912)] = @{@"currentValue" : @(us), @"isOnline" : @(1)};
                        attributes[@(913)] = @{@"currentValue" : @(me), @"isOnline" : @(1)};
                        attributes[@(914)] = @{@"currentValue" : @(le), @"isOnline" : @(1)};
                    }
                    else
                    {
                        cc_log_debug(@"S.M.A.R.T. check disk: %i  SMARTReadData() failed with %x",  bsdDeviceNumber, err);
                    }
                    (*smartInterface)->Release(smartInterface);
                    smartInterface = NULL;
                }
                else
                {
                    err = herr;
                    cc_log_debug(@"S.M.A.R.T. check disk: %i QueryInterface() failed with %x", bsdDeviceNumber, err);
                }
                
                IODestroyPlugInInterface(cfPlugInInterface);
            }
            else
                cc_log_debug(@"S.M.A.R.T. check disk: %i is NVME but could not open interface - probably blocked by sandbox", bsdDeviceNumber);
            
            found = true;
        }
        else
            cc_log_debug(@"S.M.A.R.T. check disk: %i not SMART capable", bsdDeviceNumber);
    }
    else
        cc_log_debug(@"S.M.A.R.T. check disk: %i not of kIOBlockStorageDeviceClass", bsdDeviceNumber);
    
    
    if (object != MACH_PORT_NULL)
        IOObjectRelease(object);
    
    return (found == false) ? kIOReturnNoResources : err;
}
#pragma clang diagnostic pop
#endif
