//
//  JMAppMovedHandler.m
//  CoreLib
//
//  Created by CoreCode on 25.07.10.
/*    Copyright © 2019 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMAppMovedHandler.h"
#import "JMHostInformation.h"


static int bundleFileDescriptor;



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
        if ( eventFlags[i] == kFSEventStreamEventFlagRootChanged)
        {
         //   printf("Change %llu in %s, flags %lu\n", eventIds[i], paths[i], eventFlags[i]);

            char *newPath = calloc(4096, sizeof(char));

            fcntl(bundleFileDescriptor, F_GETPATH, newPath);

            cc_log(@"Info: move detection triggered, offering to restart app");

            //    printf("new path: %s\n", newPath);

            alert_apptitled(makeLocalizedString(@"%@ has been moved, but applications should never be moved while they are running.", cc.appName), makeLocalizedString(@"Restart %@", cc.appName), nil, nil);
            NSURL *url = @(newPath).fileURL;
            NSRunningApplication *newInstance = [NSWorkspace.sharedWorkspace launchApplicationAtURL:url
                                                                                            options:(NSWorkspaceLaunchOptions)(NSWorkspaceLaunchAsync | NSWorkspaceLaunchNewInstance)
                                                                                      configuration:@{} error:NULL];

            free(newPath);
            
            if (newInstance)
                [NSApp terminate:nil];
            else
            {
                alert_apptitled(makeLocalizedString(@"%@ could not restart itself. Please do so yourself.", cc.appName), @"Quit".localized, nil, nil);

                [NSApp terminate:nil];
            }
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
    if ([self.path hasPrefix:oldVolume])
    {
        NSURL *newVolumeURL = not.userInfo[NSWorkspaceVolumeURLKey];
        NSString *newVolume = newVolumeURL.path;
        
        cc_log(@"Info: volume rename detection triggered, offering to restart app");

        
        alert_apptitled(makeLocalizedString(@"%@ has been moved, but applications should never be moved while they are running.", cc.appName), makeLocalizedString(@"Restart %@", cc.appName), nil, nil);
        NSString *newAppPath = [self.path replaced:oldVolume with:newVolume];
        NSRunningApplication *newInstance = [NSWorkspace.sharedWorkspace launchApplicationAtURL:newAppPath.fileURL
                                                                                        options:(NSWorkspaceLaunchOptions)(NSWorkspaceLaunchAsync | NSWorkspaceLaunchNewInstance)
                                                                                  configuration:@{} error:NULL];
        
        
        if (newInstance)
            [NSApp terminate:nil];
        else
        {
            alert_apptitled(makeLocalizedString(@"%@ could not restart itself. Please do so yourself.", cc.appName), @"Quit".localized, nil, nil);
            
            [NSApp terminate:nil];
        }
    }
}
@end


@implementation JMAppMovedHandler

+ (void)startMoveObservation
{
    if ([JMHostInformation isRunningTranslocated])
        return;

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

