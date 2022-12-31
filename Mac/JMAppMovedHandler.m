//
//  JMAppMovedHandler.m
//  CoreLib
//
//  Created by CoreCode on 25.07.10.
/*    Copyright © 2022 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMAppMovedHandler.h"
#import "JMHostInformation.h"


static int bundleFileDescriptor;

void RestartAppAtURL(NSURL *url)
{
    alert_apptitled(makeLocalizedString(@"%@ has been moved, but applications should never be moved while they are running.", cc.appName), makeLocalizedString(@"Restart %@", cc.appName), nil, nil);
    
#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 110000
    let config = [NSWorkspaceOpenConfiguration new];
    config.createsNewApplicationInstance = YES;
    [workspace openApplicationAtURL:bundle.bundleURL configuration:config completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error)
    {
        if (!app)
            dispatch_async_main(^
            {
                alert_apptitled(makeLocalizedString(@"%@ could not restart itself. Please do so yourself.", cc.appName), @"Quit".localized, nil, nil);
                [NSApp terminate:nil];
            });
    }];
#else
    NSRunningApplication *newInstance = [NSWorkspace.sharedWorkspace launchApplicationAtURL:url options:(NSWorkspaceLaunchOptions)(NSWorkspaceLaunchAsync | NSWorkspaceLaunchNewInstance) configuration:@{} error:NULL];
    
    if (!newInstance)
        alert_apptitled(makeLocalizedString(@"%@ could not restart itself. Please do so yourself.", cc.appName), @"Quit".localized, nil, nil);
    [NSApp terminate:nil];
#endif
}

void MoveCallbackFunction(ConstFSEventStreamRef streamRef,
                          void *clientCallBackInfo,
                          size_t numEvents,
                          void *eventPaths,
                          const FSEventStreamEventFlags eventFlags[],
                          const FSEventStreamEventId eventIds[])
{
    //char **paths = eventPaths;


    for (size_t i = 0; i < numEvents; i++)
    {
        if (eventFlags[i] == kFSEventStreamEventFlagRootChanged)
        {
         //   printf("Change %llu in %s, flags %lu\n", eventIds[i], paths[i], eventFlags[i]);

            char *newPath = calloc(4096, sizeof(char));

            fcntl(bundleFileDescriptor, F_GETPATH, newPath);

            cc_log(@"Info: move detection triggered, offering to restart app");

            //    printf("new path: %s\n", newPath);

            NSURL *newAppURL = @(newPath).fileURL;
            free(newPath); // pretty pointless a few milliseconds before quitting
            RestartAppAtURL(newAppURL);
        }
    }
}

@interface JMAppVolumeRenamedObserver : NSObject
@property (nonatomic, strong) NSString *path;
@end

@implementation JMAppVolumeRenamedObserver
- (void)watch:(NSNotification *)not
{
    NSURL *oldVolumeURL = not.userInfo[NSWorkspaceVolumeOldURLKey];
    NSString *oldVolume = oldVolumeURL.path;
    
    if (!oldVolume) return;
    
    if ([self.path hasPrefix:oldVolume] &&  // we are really on the renamed volume
        ![oldVolume isEqualToString:@"/"])  // renaming the boot value doesn't break things since its path always stays '/'
    {
        NSURL *newVolumeURL = not.userInfo[NSWorkspaceVolumeURLKey];
        NSString *newVolume = newVolumeURL.path;
        
        cc_log(@"Info: volume rename detection triggered, offering to restart app");

        let newAppURL = [self.path replaced:oldVolume with:newVolume].fileURL;
        RestartAppAtURL(newAppURL);
    }
}
@end


@implementation JMAppMovedHandler

+ (void)startMoveObservation
{
    CFStringRef mypath = (__bridge CFStringRef)NSBundle.mainBundle.bundlePath;
    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&mypath, 1, NULL);
    void *callbackInfo = NULL;
    FSEventStreamRef stream;
    CFAbsoluteTime latency = 3.0;


    bundleFileDescriptor = open(NSBundle.mainBundle.bundlePath.UTF8String, O_RDONLY, 0700);
    stream = FSEventStreamCreate(NULL,
                                 &MoveCallbackFunction,
                                 callbackInfo,
                                 pathsToWatch,
                                 kFSEventStreamEventIdSinceNow,
                                 latency,
                                 kFSEventStreamCreateFlagWatchRoot
                                 );
    CFRelease(pathsToWatch);
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);

    FSEventStreamStart(stream);
    
    
    static JMAppVolumeRenamedObserver *observer = nil;
    if (!observer)
    {
        observer = [[JMAppVolumeRenamedObserver alloc] init];
        observer.path = NSBundle.mainBundle.bundlePath;
        [NSWorkspace.sharedWorkspace.notificationCenter addObserver:observer
                                                           selector:@selector(watch:)
                                                               name:NSWorkspaceDidRenameVolumeNotification object:NULL];
    }
}
@end

