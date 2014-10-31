//
//  JMHostInformation.m
//  CoreLib
//
//  Created by CoreCode on 16.01.05.
/*	Copyright (c) 2014 CoreCode
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
// Some code here is derived from Apple Sample Code, but changes have been made

#import "JMHostInformation.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <SystemConfiguration/SystemConfiguration.h>
#include <IOKit/storage/IOMedia.h>

#if defined(USE_DISKARBITRATION) || defined(USE_SYSTEMCONFIGURATION)

#if ! __has_feature(objc_arc)
#define BRIDGE
#else
#define BRIDGE __bridge
#endif

#endif

#ifdef USE_DISKARBITRATION
#ifdef FORCE_LOG
#define LOGMOUNTEDHARDDISK asl_NSLog_debug
#else
#define LOGMOUNTEDHARDDISK(x, ...) 
#endif
#endif

#pragma GCC diagnostic ignored "-Wcast-align"

#ifdef USE_IOKIT
static kern_return_t FindEthernetInterfaces(io_iterator_t *matchingServices);
static kern_return_t GetMACAddress(io_iterator_t intfIterator, UInt8 *MACAddress);
#endif

@implementation JMHostInformation

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <strings.h>
#include <pwd.h>
#include <grp.h>

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
	NSString *userPath = [@"~/Library/PreferencePanes/Growl.prefPane/Contents/Resources/GrowlHelperApp.app" stringByExpandingTildeInPath];
	NSString *systemPath = @"/Library/PreferencePanes/Growl.prefPane/Contents/Resources/GrowlHelperApp.app";
	NSURL *url = nil;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:appPath])
		url	= [NSURL fileURLWithPath:appPath];
	else if ([[NSFileManager defaultManager] fileExistsAtPath:userPath])
		url	= [NSURL fileURLWithPath:userPath];
	else if ([[NSFileManager defaultManager] fileExistsAtPath:systemPath])
		url	= [NSURL fileURLWithPath:systemPath];
	
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
		asl_NSLog(ASL_LEVEL_ERR, @"Error:	FindEthernetInterfaces returned 0x%08x", kernResult);
	else
	{
		kernResult = GetMACAddress(intfIterator, MACAddress);

		if (KERN_SUCCESS != kernResult)
			asl_NSLog(ASL_LEVEL_ERR, @"Error:	GetMACAddress returned 0x%08x", kernResult);
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

+ (NSString *)ipAddress:(bool)ipv6
{
//	NSArray *a = [[NSHost currentHost] addresses]; // [NSHost currentHost]  broken
//	NSMutableArray *b = [NSMutableArray arrayWithCapacity:[a count]];
//	unsigned char i;
//	unsigned char longestitem = 0, longest = 0;
//
//	for (i = 0; i < [a count]; i++)
//	{
//		if ([[a objectAtIndex:i] rangeOfString:ipv6 ? @":" : @"."].location != NSNotFound)
//			[b addObject:[a objectAtIndex:i]];
//	}
//
//
//	if ([b count] <= 1)
//		return [b objectAtIndex:0];
//
//	[b removeObjectIdenticalTo:ipv6 ? @"::1" : @"127.0.0.1"];
//
//	if ([b count] <= 1)
//		return [b objectAtIndex:0];
//
//
//	for (i = 0; i < [b count]; i++)
//	{
//		if ([(NSString *)[b objectAtIndex:i] length] > longest)
//		{
//			longest = [(NSString *)[b objectAtIndex:i] length];
//			longestitem = i;
//		}
//	}
//
//
//	return [b objectAtIndex:longestitem];
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

				if (![[NSString stringWithUTF8String:ifa->ifa_name] hasPrefix:@"lo"])
				{
					freeifaddrs(myaddrs);
					NSString *ip = [NSString stringWithUTF8String:buf];
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

				if (![[NSString stringWithUTF8String:ifa->ifa_name] hasPrefix:@"lo"])
				{
					freeifaddrs(myaddrs);
					NSString *ip = [NSString stringWithUTF8String:buf];
					if (ip)
						return ip;
				}
			}
		}
	}

	freeifaddrs(myaddrs);

	return ipv6 ? @"::1" : @"127.0.0.1";
}

#ifdef USE_SYSTEMCONFIGURATION
+ (NSString *)ipName
{
	//return [[NSHost currentHost] name]; // [NSHost currentHost]  broken

	SCDynamicStoreRef dynRef = SCDynamicStoreCreate(kCFAllocatorSystemDefault, (CFStringRef)@"SMARTReporter", NULL, NULL);
    NSString *hostname = (BRIDGE NSString *)SCDynamicStoreCopyLocalHostName(dynRef);
#if ! __has_feature(objc_arc)
	[hostname autorelease];
#endif
    CFRelease(dynRef);

    if (hostname)
		return [hostname stringByAppendingString:@".local"];
	else
		return @"";
}
#endif

NSString *_machineType();

+ (NSString *)machineType
{
	return _machineType();
}

+ (NSInteger)bootDiskBSDNum
{
	static NSInteger num = -100;
	
	if (num == -100)
	{
		struct statfs buffer;
		statfs("/", &buffer);
		NSString *bootDiskString = [NSString stringWithUTF8String:buffer.f_mntfromname];
		if (![bootDiskString hasPrefix:@"/dev/disk"])
			return -1;
		NSString *bsdNumStr = [[[bootDiskString substringFromIndex:9] componentsSeparatedByString:@"s"] objectAtIndex:0];
		num = [bsdNumStr integerValue];
	}
	
	return num;
}

+ (void)_addDiskToList:(NSMutableArray *)array number:(NSNumber *)num name:(NSString *)name detail:(NSString *)detail
{
	BOOL found = FALSE;
	
	for (NSMutableDictionary *disk in array)  
	{
		if ([[disk objectForKey:kDiskNumberKey] isEqualToNumber:num])
		{
			NSString *currentName = [disk objectForKey:kDiskNameKey];
			[disk setObject:[name stringByAppendingFormat:@", %@", currentName] forKey:kDiskNameKey];
			
			//asl_NSLog_debug(@"_addDiskToList replace name unique %@\n", [disk description]);

			found = TRUE;
		}
	}

	if (!found)
	{
		NSMutableDictionary *diskDict = [NSMutableDictionary dictionary];

		[diskDict setObject:num forKey:kDiskNumberKey];
		[diskDict setObject:((detail) ? makeString(@"%@ (%@)", name, detail) : name) forKey:kDiskNameKey];
		
		//asl_NSLog_debug(@"_addDiskToList add unique %@\n", [diskDict description]);
		
		[array addObject:diskDict];
	}
}

#ifdef USE_DISKARBITRATION

+ (NSString *)_serialNumberForIOKitObject:(io_object_t)ggparent
{
    NSString *serial = nil;
    
    CFTypeRef s = IORegistryEntrySearchCFProperty(ggparent, kIOServicePlane, CFSTR("Serial Number"), kCFAllocatorDefault, kIORegistryIterateRecursively | kIORegistryIterateParents);
    if (s)
    {
        asl_NSLog_debug(@"Serial Number: %@", (BRIDGE NSString *) s);
        serial = [(BRIDGE NSString *)s copy];
        CFRelease(s);
    }
    else
    {
        s = IORegistryEntrySearchCFProperty(ggparent, kIOServicePlane, CFSTR("device serial"), kCFAllocatorDefault, kIORegistryIterateRecursively | kIORegistryIterateParents);
        if (s)
        {
            asl_NSLog_debug(@"Serial Number: %@", (BRIDGE NSString *) s);
            serial = [(BRIDGE NSString *)s copy];
            CFRelease(s);
        }
        else
        {	
            s = IORegistryEntrySearchCFProperty(ggparent, kIOServicePlane, CFSTR("USB Serial Number"), kCFAllocatorDefault, kIORegistryIterateRecursively | kIORegistryIterateParents);
            if (s)
            {
                asl_NSLog_debug(@"USB Serial Number: %@", (BRIDGE NSString *) s);
                serial = [(BRIDGE NSString *)s copy];
                
                CFRelease(s);
            }
            //																							else
            //																								asl_NSLog(ASL_LEVEL_ERR, @"Error: couldn't get serial number");
        }
    }
    
    NSString *info = serial ? [serial stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"NOSERIAL";

#if ! __has_feature(objc_arc)
    [serial release];
#endif
    
    return info;
}


+ (void)_findZFSBacking:(BOOL *)foundBacking_p volNameAsCFString:(CFStringRef)volNameAsCFString nonRemovableVolumes:(NSMutableArray *)nonRemovableVolumes bsdNum:(NSInteger)bsdNum
{
    kern_return_t				kernResult;
    CFMutableDictionaryRef		matchingDict;
    io_iterator_t				iter;
    
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
                
                CFTypeRef	bsdVolume = NULL;
                
                bsdVolume = IORegistryEntryCreateCFProperty(object, CFSTR("BSD Name"), kCFAllocatorDefault, 0);
                if (bsdVolume)
                {
					                    
                    if ([(BRIDGE NSString *)bsdVolume isEqualToString:[NSString stringWithFormat:@"disk%li", bsdNum]])
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
											LOGMOUNTEDHARDDISK(@"mountedHarddisks ZFS found match %@", (BRIDGE NSString *)data);


                                            NSMutableDictionary *diskDict2 = [NSMutableDictionary dictionary];
                                            
                                            
                                            if ([(BRIDGE NSString *)data hasPrefix:@"disk"] && ([(BRIDGE NSString *)data length] >= 5))
                                            {
                                                NSInteger num = [[(BRIDGE NSString *)data substringFromIndex:4] integerValue];
                                                [diskDict2 setObject:[NSNumber numberWithInteger:num] forKey:kDiskNumberKey];
                                            }
                                            else
                                                asl_NSLog(ASL_LEVEL_ERR, @"Error: bsd name doesn't look good %@", (BRIDGE NSString *) data);
                                            
                                            CFRelease(data);
                                            
                                            
                                            
                                            if ([diskDict2 objectForKey:kDiskNumberKey])
                                            {
                                                NSString *serial = [self _serialNumberForIOKitObject:gparent];
                                                
                                                [self _addDiskToList:nonRemovableVolumes
                                                              number:[diskDict2 objectForKey:kDiskNumberKey]
                                                                name:(BRIDGE NSString *)volNameAsCFString
                                                              detail:serial];
                                                
                                                LOGMOUNTEDHARDDISK(@"mountedHarddisks found zfs backing %@", [diskDict2 description]);
                                                
                                                *foundBacking_p = true;
                                                //	NSLog(@"disk Dict %@", diskDict2);
                                                
                                            }
                                        }
                                        else
                                            asl_NSLog(ASL_LEVEL_ERR, @"Error: couldn't get bsd name");
                                        
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

+ (BOOL)_findRAIDBacking:(NSString *)bsdName props:(NSDictionary *)props volNameAsCFString:(CFStringRef)volNameAsCFString nonRemovableVolumes:(NSMutableArray *)nonRemovableVolumes
{
    BOOL foundBacking = false;
    LOGMOUNTEDHARDDISK(@"mountedHarddisks found props %@", bsdName);
    
    CFUUIDRef DAMediaUUID = (BRIDGE CFUUIDRef)[props objectForKey:@"DAMediaUUID"];
    if (DAMediaUUID)
    {
        
        NSString *uuid = (BRIDGE NSString *)CFUUIDCreateString(kCFAllocatorDefault, DAMediaUUID);
#if ! __has_feature(objc_arc)
        [uuid autorelease];
#endif
        
        LOGMOUNTEDHARDDISK(@"mountedHarddisks found UUID %@ %@", bsdName, uuid);
        
        
        kern_return_t				kernResult;
        CFMutableDictionaryRef		matchingDict;
        io_iterator_t				iter;
        
        
        matchingDict = IOServiceMatching(kIOMediaClass);
        if (matchingDict != NULL)
        {
            kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &iter);
            
            if ((KERN_SUCCESS == kernResult) && (iter != 0))
            {
                io_object_t object;
                
                while ((object = IOIteratorNext(iter)))
                {
                    CFTypeRef	ourUUID = IORegistryEntryCreateCFProperty(object, CFSTR(kIOMediaUUIDKey), kCFAllocatorDefault, 0);
                    if (ourUUID)
                    {
                        if ([(BRIDGE NSString *)ourUUID isEqualToString:uuid])
                        {
                            LOGMOUNTEDHARDDISK(@"mountedHarddisks found matching UUID %@", bsdName);
                            
                            
                            CFTypeRef	d = NULL;
                            d = IORegistryEntryCreateCFProperty(object, CFSTR("SoftRAID Provider Array"), kCFAllocatorDefault, 0);
                            if (d)
                            {
                                LOGMOUNTEDHARDDISK(@"mountedHarddisks SOFTRAID");
                                
                                for (NSString *name in (BRIDGE NSArray *)d)
                                {	
                                    if ([name hasPrefix:@"disk"] && ([name length] >= 5))
                                    {
                                        NSString *numStr = [(NSString *)name substringFromIndex:4];
                                        NSInteger num;
                                        if ([numStr contains:@"s"])
                                            num = [[[numStr componentsSeparatedByString:@"s"] objectAtIndex:0] integerValue];
                                        else
                                            num = [numStr integerValue];
                                        
                                        [self _addDiskToList:nonRemovableVolumes number:[NSNumber numberWithInteger:num] name:(BRIDGE NSString *)volNameAsCFString detail:name];
                                        
                                        LOGMOUNTEDHARDDISK(@"mountedHarddisks found1\n");
                                        
                                        foundBacking = true;
                                    }
                                    else
                                        asl_NSLog(ASL_LEVEL_ERR, @"Error: 1bsd name doesn't look good %@", (NSString *) name);
                                    
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
                                                        
                                                        CFTypeRef	data = NULL;
                                                        NSMutableDictionary *diskDict2 = [NSMutableDictionary dictionary];
                                                        
                                                        
                                                        data = IORegistryEntrySearchCFProperty(ggparent, kIOServicePlane, CFSTR("BSD Name"), kCFAllocatorDefault, kIORegistryIterateRecursively | kIORegistryIterateParents);
                                                        if (data)
                                                        {																			
                                                            if ([(BRIDGE NSString *)data hasPrefix:@"disk"] && ([(BRIDGE NSString *)data length] >= 5))
                                                            {
                                                                NSInteger num = [[(BRIDGE NSString *)data substringFromIndex:4] integerValue];
                                                                [diskDict2 setObject:[NSNumber numberWithInteger:num] forKey:kDiskNumberKey];
                                                            }
                                                            else
                                                                asl_NSLog(ASL_LEVEL_ERR, @"Error: bsd name doesn't look good %@", (BRIDGE NSString *) data);
                                                            
                                                            CFRelease(data);
                                                            
                                                            
                                                            
                                                            if ([diskDict2 objectForKey:kDiskNumberKey])
                                                            {	                                                            NSString *serial = [self _serialNumberForIOKitObject:ggparent];
                                                                
                                                                [self _addDiskToList:nonRemovableVolumes
                                                                              number:[diskDict2 objectForKey:kDiskNumberKey]
                                                                                name:(BRIDGE NSString *)volNameAsCFString
                                                                              detail:serial];
                                                                
                                                                LOGMOUNTEDHARDDISK(@"mountedHarddisks found %@", [diskDict2 description]);
                                                                
                                                                foundBacking = true;
                                                                //	NSLog(@"disk Dict %@", diskDict2);
                                                            }
                                                            
                                                        }
                                                        else
                                                            asl_NSLog(ASL_LEVEL_ERR, @"Error: couldn't get bsd name");
                                                        
                                                        
                                                        
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
    }
    return foundBacking;
}

+ (NSMutableArray *)mountedHarddisks:(BOOL)includeRAIDBackingDevices
{
	OSErr           result = noErr;
	ItemCount       volumeIndex;
    NSMutableArray	*volumeNamesToIgnore = [NSMutableArray array];
    NSMutableArray	*volumePathsToIgnore = [NSMutableArray array];
    NSMutableArray  *nonRemovableVolumes = [NSMutableArray array];
	
    for (NSString *name in [[NSWorkspace sharedWorkspace] mountedRemovableMedia])
    {
        if ([name hasPrefix:@"/Volumes/"])
            [volumeNamesToIgnore addObject:[name substringFromIndex:[@"/Volumes/" length]]];
        else
            [volumeNamesToIgnore addObject:name];
		
		[volumePathsToIgnore addObject:name];
    }
	
	for (NSString *path in [[NSWorkspace sharedWorkspace] mountedLocalVolumePaths])
	{		
		NSString *description, *type;
		BOOL removable = NO, writable, unmountable;
		
		[[NSWorkspace sharedWorkspace] getFileSystemInfoForPath:path
		                                            isRemovable:&removable
				                                     isWritable:&writable
							                      isUnmountable:&unmountable
										            description:&description
													       type:&type];
		
		if (removable)
			[volumePathsToIgnore addObject:path];
	}

	
	DASessionRef session = NULL;
	if (includeRAIDBackingDevices)
		session = DASessionCreate(kCFAllocatorDefault);

	LOGMOUNTEDHARDDISK(@"mountedHarddisks removableVolumeNames %@", ([volumeNamesToIgnore description]));

	// Iterate across all mounted volumes using FSGetVolumeInfo. This will return nsvErr
	// (no such volume) when volumeIndex becomes greater than the number of mounted volumes.
	for (volumeIndex = 1; result == noErr || result != nsvErr; volumeIndex++)
	{
		FSVolumeRefNum	actualVolume;
		HFSUniStr255	volumeName;
		FSVolumeInfo	volumeInfo;
		FSRef			volumeFSRef;

		bzero((void *) &volumeInfo, sizeof(volumeInfo));
        
		// We're mostly interested in the volume reference number (actualVolume)
		// TODO: deprecated in 10.8 use NSFileManager's mountedVolumeURLsIncludingResourceValuesForKeys:options:
		result = FSGetVolumeInfo(kFSInvalidVolumeRefNum,
								 volumeIndex,
								 &actualVolume,
								 kFSVolInfoFSInfo,
								 &volumeInfo,
								 &volumeName,
								 &volumeFSRef);
        
		if (result == noErr)
		{
			GetVolParmsInfoBuffer volumeParms;
			result = FSGetVolumeParms (actualVolume, &volumeParms, sizeof(volumeParms));


			if (result != noErr)
				asl_NSLog(ASL_LEVEL_ERR, @"Error:	FSGetVolumeParms returned %d", result);
			else
			{
				if ((char *)volumeParms.vMDeviceID != NULL)
				{
					NSURL *mountURL = (BRIDGE NSURL *)CFURLCreateFromFSRef(NULL, &volumeFSRef);
#if ! __has_feature(objc_arc)
					[mountURL autorelease];
#endif
					// This code is just to convert the volume name from a HFSUniCharStr to
					// a plain C string so we can print it with printf. It'd be preferable to
					// use CoreFoundation to work with the volume name in its Unicode form.
					CFStringRef	volNameAsCFString;
                    
					volNameAsCFString = CFStringCreateWithCharacters(kCFAllocatorDefault,
																	 volumeName.unicode,
																	 volumeName.length);
                    
#if ! __has_feature(objc_arc)
					[(NSString *)volNameAsCFString autorelease];
#endif
                    //NSLog((NSString *)volNameAsCFString);
					LOGMOUNTEDHARDDISK(@"mountedHarddisks found IOKit name %@", (BRIDGE NSString *)volNameAsCFString);

                    if ([volumeNamesToIgnore indexOfObject:(BRIDGE NSString *)volNameAsCFString] == NSNotFound &&
						[volumePathsToIgnore indexOfObject:[mountURL path]] == NSNotFound) // not removable
                    {
						
						NSString *bsdName = [NSString stringWithUTF8String:(char *)volumeParms.vMDeviceID];
						
						LOGMOUNTEDHARDDISK(@"mountedHarddisks has BSD name %@", bsdName);

						if (![bsdName hasPrefix:@"disk"])
							continue;
                        NSString *bsdNumStr = [[[bsdName substringFromIndex:4] componentsSeparatedByString:@"s"] objectAtIndex:0];
                        NSInteger bsdNum = [bsdNumStr integerValue];
                        BOOL found = FALSE;
                        
                        for (NSMutableDictionary *disk in nonRemovableVolumes)  // check if we already added the disk because of another partition
                        {
                            if ([[disk objectForKey:kDiskNumberKey] integerValue] == bsdNum)
                            {
                                NSString *currentName = [disk objectForKey:kDiskNameKey];
                                [disk setObject:[currentName stringByAppendingFormat:@", %@", (BRIDGE NSString *)volNameAsCFString] forKey:kDiskNameKey];
                                found = TRUE;
                            }
                        }
                        
                        if (!found) // new disk
                        {
							BOOL foundBacking = false;
							
							
							if (includeRAIDBackingDevices)
							{
								NSString *bsdname = [NSString stringWithFormat:@"/dev/disk%li", bsdNum];
								
								DADiskRef disk = DADiskCreateFromBSDName(kCFAllocatorDefault, session, [bsdname UTF8String]);
								NSDictionary *props = (BRIDGE NSDictionary *)DADiskCopyDescription(disk);
#if ! __has_feature(objc_arc)
								[props autorelease];
#endif
								
								CFRelease(disk);
								disk = NULL;
								
								LOGMOUNTEDHARDDISK(@"mountedHarddisks checking for raid backing %@", bsdName);

                                if ([[props objectForKey:@"DAVolumeKind"] isEqualToString:@"zfs"])
                                {
                                    [self _findZFSBacking:&foundBacking volNameAsCFString:volNameAsCFString nonRemovableVolumes:nonRemovableVolumes bsdNum:bsdNum];
                                }
								else if ([props objectForKey:@"DAMediaLeaf"] && [[props objectForKey:@"DAMediaLeaf"] intValue])
								{
                                    foundBacking = [self _findRAIDBacking:bsdName props:props volNameAsCFString:volNameAsCFString nonRemovableVolumes:nonRemovableVolumes];	
								}
							}
							
							if (!foundBacking)
							{
								[self _addDiskToList:nonRemovableVolumes
											  number:[NSNumber numberWithInteger:bsdNum]
												name:(BRIDGE NSString *)volNameAsCFString
											  detail:nil];

								
								LOGMOUNTEDHARDDISK(@"mountedHarddisks is new disk without backing %@", bsdName);
							}
							else
								LOGMOUNTEDHARDDISK(@"mountedHarddisks ignoring volume with raid/zfs backing %@", bsdName);
                        }
                    }
            
				}
				else
					asl_NSLog(ASL_LEVEL_ERR, @"Error: mountedHarddisks volumeParms.vMDeviceID == NULL");
			}
		}
	}
    
	if (includeRAIDBackingDevices)
		CFRelease(session);

	
	if ([nonRemovableVolumes count] >= 2) // move boot volume to first spot
	{
		NSInteger bootDisk = [self bootDiskBSDNum];

		for (NSUInteger i = 1; i < [nonRemovableVolumes count]; i++)
		{
			NSDictionary *disk = [nonRemovableVolumes objectAtIndex:i];
			
			if ([[disk objectForKey:kDiskNumberKey] integerValue] == bootDisk)
			{
				[nonRemovableVolumes exchangeObjectAtIndex:0 withObjectAtIndex:i];
				 
				break;
			}
		}
	}

	return nonRemovableVolumes;
}

#endif

+ (NSString *)nameForDevice:(NSInteger)deviceNumber
{
	NSMutableString *name = [NSMutableString stringWithCapacity:12];
	OSStatus			result = noErr;
	ItemCount			volumeIndex;


	// Iterate across all mounted volumes using FSGetVolumeInfo. This will return nsvErr
	// (no such volume) when volumeIndex becomes greater than the number of mounted volumes.
	for (volumeIndex = 1; result == noErr || result != nsvErr; volumeIndex++)
	{
		FSVolumeRefNum	actualVolume;
		HFSUniStr255	volumeName;
		FSVolumeInfo	volumeInfo;

		bzero((void *) &volumeInfo, sizeof(volumeInfo));

		// We're mostly interested in the volume reference number (actualVolume)
		result = FSGetVolumeInfo(kFSInvalidVolumeRefNum,
								 volumeIndex,
								 &actualVolume,
								 kFSVolInfoFSInfo,
								 &volumeInfo,
								 &volumeName,
								 NULL);

		if (result == noErr)
		{
			GetVolParmsInfoBuffer volumeParms;

			result = FSGetVolumeParms (actualVolume, &volumeParms, sizeof(volumeParms));

			if (result != noErr)
				asl_NSLog(ASL_LEVEL_ERR, @"Error:	FSGetVolumeParms returned %d", result);
			else
			{
				if ((char *)volumeParms.vMDeviceID != NULL)
				{
					NSString *bsdName = [NSString stringWithUTF8String:(char *)volumeParms.vMDeviceID];

					if ([bsdName hasPrefix:@"disk"])
					{
						NSString *shortBSDName = [bsdName substringFromIndex:4];

						NSArray *components = [shortBSDName componentsSeparatedByString:@"s"];

						if (([components count] > 1) && (!([shortBSDName isEqualToString:[components objectAtIndex:0]])))
						{
							if ([[components objectAtIndex:0] integerValue] == deviceNumber)
							{
								if (![name isEqualToString:@""])
									[name appendString:@", "];

								[name appendString:[NSString stringWithCharacters:volumeName.unicode length:volumeName.length]];
							}
						}
					}
				}
				else
					asl_NSLog(ASL_LEVEL_ERR, @"Error: nameForDevice	volumeParms.vMDeviceID == NULL");
			}
		}
	}

	return [NSString stringWithString:name];
}

+ (NSString *)bsdPathForVolume:(NSString *)volume	// TODO: merge with above
{
	OSStatus			result = noErr;
	ItemCount			volumeIndex;

	// Iterate across all mounted volumes using FSGetVolumeInfo. This will return nsvErr
	// (no such volume) when volumeIndex becomes greater than the number of mounted volumes.
	for (volumeIndex = 1; result == noErr || result != nsvErr; volumeIndex++)
	{
		FSVolumeRefNum	actualVolume;
		HFSUniStr255	volumeName;
		FSVolumeInfo	volumeInfo;

		bzero((void *) &volumeInfo, sizeof(volumeInfo));

		// We're mostly interested in the volume reference number (actualVolume)
		result = FSGetVolumeInfo(kFSInvalidVolumeRefNum,
								 volumeIndex,
								 &actualVolume,
								 kFSVolInfoFSInfo,
								 &volumeInfo,
								 &volumeName,
								 NULL);

		if (result == noErr)
		{
			GetVolParmsInfoBuffer volumeParms;
			result = FSGetVolumeParms (actualVolume, &volumeParms, sizeof(volumeParms));


			if (result != noErr)
				asl_NSLog(ASL_LEVEL_ERR, @"Error:	FSGetVolumeParms returned %d", result);
			else
			{
				if ((char *)volumeParms.vMDeviceID != NULL)
				{
					// This code is just to convert the volume name from a HFSUniCharStr to
					// a plain C string so we can print it with printf. It'd be preferable to
					// use CoreFoundation to work with the volume name in its Unicode form.
					NSString *volNameAsCFString = CFBridgingRelease(CFStringCreateWithCharacters(kCFAllocatorDefault,
																	 volumeName.unicode,
																	 volumeName.length));

//#if ! __has_feature(objc_arc)
//					[(NSString *)volNameAsCFString autorelease];
//#endif

					if ([volume isEqualToString:volNameAsCFString])
						return [NSString stringWithFormat:@"/dev/rdisk%@", [[[[NSString stringWithUTF8String:(char *)volumeParms.vMDeviceID] substringFromIndex:4] componentsSeparatedByString:@"s"] objectAtIndex:0]];
				}
				else
					asl_NSLog(ASL_LEVEL_ERR, @"Error: bsdPathForVolume volumeParms.vMDeviceID == NULL");
			}
		}
	}

	return nil;
}

#ifdef USE_IOKIT
+ (BOOL)runsOnBattery
{
	CFTypeRef		blob = IOPSCopyPowerSourcesInfo();
	if (!blob)		return FALSE;
	CFArrayRef		array = IOPSCopyPowerSourcesList(blob);
	BOOL			ret = FALSE;
	
	if (array)
	{
		for (int i = 0 ; i < CFArrayGetCount(array); i++)
		{
			CFDictionaryRef	dict = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(array, i));
			CFStringRef		str = (CFStringRef)CFDictionaryGetValue(dict, CFSTR(kIOPSPowerSourceStateKey));

			if (CFEqual(str, CFSTR(kIOPSBatteryPowerValue)))
				ret = TRUE;
		}
		CFRelease(array);
	}
	CFRelease(blob);

	return ret;
}
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
		asl_NSLog(ASL_LEVEL_ERR, @"Error:	IOMasterPort returned %d", kernResult);
		return kernResult;
	}

	// Ethernet interfaces are instances of class kIOEthernetInterfaceClass.
	// IOServiceMatching is a convenience function to create a dictionary with the key kIOProviderClassKey and
	// the specified value.
	matchingDict = IOServiceMatching(kIOEthernetInterfaceClass);

	// Note that another option here would be:
	// matchingDict = IOBSDMatching("en0");

	if (NULL == matchingDict)
		asl_NSLog(ASL_LEVEL_ERR, @"Error:	IOServiceMatching returned a NULL dictionary.");
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
			asl_NSLog(ASL_LEVEL_ERR, @"Error:	CFDictionaryCreateMutable returned a NULL dictionary.");
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
		asl_NSLog(ASL_LEVEL_ERR, @"Error:	IOServiceGetMatchingServices returned %d", kernResult);

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
			asl_NSLog(ASL_LEVEL_ERR, @"Error:	IORegistryEntryGetParentEntry returned 0x%08x", kernResult);
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
#endif
