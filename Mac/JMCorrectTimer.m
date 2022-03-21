//
//  JMCorrectTimer.m
//  CoreLib
//
//  Created by CoreCode on 28.04.13.
/*    Copyright © 2022 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMCorrectTimer.h"



@interface JMCorrectTimer ()

@property (strong, atomic) NSTimer *timer;
@property (strong, atomic) id target;
@property (strong, atomic) NSDate *date;
@property (copy, atomic) void (^timerBlock)(void);
@property (copy, atomic) void (^dropBlock)(void);

@end


@implementation JMCorrectTimer

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
#pragma clang diagnostic ignored "-Wunused-but-set-variable"

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithFireDate:(NSDate *)d timerBlock:(void (^)(void))timerBlock dropBlock:(void (^)(void))dropBlock
{
    LOGFUNC
    if ((self = [super init]))
    {        
        self.timerBlock = timerBlock;
        self.dropBlock = dropBlock;
        self.date = d;

        [self scheduleTimer];

        [NSWorkspace.sharedWorkspace.notificationCenter addObserver:self
                                                               selector:@selector(receiveSleepNote:)
                                                                   name:NSWorkspaceWillSleepNotification object:NULL];
        [NSWorkspace.sharedWorkspace.notificationCenter addObserver:self
                                                               selector:@selector(receiveWakeNote:)
                                                                   name:NSWorkspaceDidWakeNotification object:NULL];
        
    }
    return self;
}

- (void)scheduleTimer
{
    LOGFUNCPARAM(makeString(@"timerDate: %@   now: %@", self.date, NSDate.date.description))

    
    NSTimer *t = [[NSTimer alloc] initWithFireDate:self.date
                                          interval:0
                                            target:self
                                          selector:@selector(timer:)
                                          userInfo:NULL repeats:NO];

    [NSRunLoop.currentRunLoop addTimer:t forMode:NSDefaultRunLoopMode];
    t.tolerance = 0.1;
    self.timer = t;
    
    assert(self.timer && self.dropBlock && self.timerBlock);
}

- (void)invalidate
{
    LOGFUNC
    
    
    if (self.timer)
        [self.timer invalidate];
    self.timer = nil;
    self.timerBlock = nil;
    self.dropBlock = nil;
    
    [NSWorkspace.sharedWorkspace.notificationCenter removeObserver:self name:NSWorkspaceWillSleepNotification object:NULL];
    [NSWorkspace.sharedWorkspace.notificationCenter removeObserver:self name:NSWorkspaceDidWakeNotification object:NULL];
}

- (void)timer:(id)sender
{
    LOGFUNCPARAM(makeString(@"timerDate: %@   now: %@", self.timer.fireDate.description, NSDate.date.description))
    
    __strong JMCorrectTimer *strongSelf = self;

    assert(self.timer && self.dropBlock && self.timerBlock);
    self.timerBlock();

    [self invalidate];

    strongSelf = nil;
}

- (void)receiveSleepNote:(id)sender
{
    LOGFUNC
    
    assert(self.timer && self.dropBlock && self.timerBlock);

    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)receiveWakeNote:(id)sender
{
    
    if (self.timer)
    {
        cc_log(@"Error: JMCorrectTimer: receiveWakeNote but timer"); // this happens sometimes, WAKE called without SLEEP beforehand
        [self.timer invalidate];
        self.timer = nil;
    }
    
    assert(self.dropBlock);


    if ([[NSDate date] timeIntervalSinceDate:self.date] > 0.01)
    {
        LOGFUNCPARAM(makeString(@"dropping Timer as we have been sleeping, missed target by: %f", -[[NSDate date] timeIntervalSinceDate:self.date]))

        assert(self.dropBlock);

        if (self.dropBlock)
        {
            __strong JMCorrectTimer *strongSelf = self;

            self.dropBlock();

            self.timerBlock = nil;
            self.dropBlock = nil;


            [NSWorkspace.sharedWorkspace.notificationCenter removeObserver:self name:NSWorkspaceWillSleepNotification object:NULL];
            [NSWorkspace.sharedWorkspace.notificationCenter removeObserver:self name:NSWorkspaceDidWakeNotification object:NULL];
            
            strongSelf = nil;
        }
    }
    else
    {
        LOGFUNCPARAM(makeString(@"rescheduling timer, still time left to reschedule: %f", -[[NSDate date] timeIntervalSinceDate:self.date]))

        [self scheduleTimer];
    }
}
#pragma clang diagnostic pop
@end
