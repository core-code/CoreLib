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

@property (assign, atomic) int i1;
@property (assign, atomic) int i2;
@property (assign, atomic) int i3;
@property (assign, atomic) int i4;
@property (assign, atomic) int i5;
@property (assign, atomic) int i6;
@property (assign, atomic) int i7;
@property (assign, atomic) int i8;
@property (assign, atomic) int i9;
@property (assign, atomic) int i10;

@end


@implementation JMCorrectTimer

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}
#pragma clang diagnostic pop

- (instancetype)initWithFireDate:(NSDate *)d timerBlock:(void (^)(void))timerBlock dropBlock:(void (^)(void))dropBlock
{
    LOGFUNC
    if ((self = [super init]))
    {
        self.i1++;
        
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
    self.i2++;
    
    NSTimer *t = [[NSTimer alloc] initWithFireDate:self.date
                                          interval:0
                                            target:self
                                          selector:@selector(timer:)
                                          userInfo:NULL repeats:NO];

    [NSRunLoop.currentRunLoop addTimer:t forMode:NSDefaultRunLoopMode];
    t.tolerance = 0.1;
    self.timer = t;
    
    assert_custom_info(self.timer && self.dropBlock && self.timerBlock, self.info);
}

- (void)invalidate
{
    LOGFUNC
    self.i3++;
    
    
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
    self.i4++;
    
    __strong JMCorrectTimer *strongSelf = self;

    assert_custom_info(self.timer && self.dropBlock && self.timerBlock, self.info);
    self.timerBlock();

    [self invalidate];

    strongSelf = nil;
}

- (void)receiveSleepNote:(id)sender
{
    LOGFUNC
    self.i5++;
    
    assert_custom_info(self.timer && self.dropBlock && self.timerBlock, self.info);

    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)receiveWakeNote:(id)sender
{
    self.i6++;
    
    if (self.timer)
    {
        cc_log(@"Error: JMCorrectTimer: receiveWakeNote but timer"); // this happens sometimes, WAKE called without SLEEP beforehand
        [self.timer invalidate];
        self.timer = nil;
    }
    
    assert_custom_info(self.dropBlock, self.info);


    if ([[NSDate date] timeIntervalSinceDate:self.date] > 0.01)
    {
        LOGFUNCPARAM(makeString(@"dropping Timer as we have been sleeping, missed target by: %f", -[[NSDate date] timeIntervalSinceDate:self.date]))

        self.i8++;

        assert_custom_info(self.dropBlock, self.info);

        if (self.dropBlock)
        {
            __strong JMCorrectTimer *strongSelf = self;

            self.dropBlock();

            self.timerBlock = nil;
            self.dropBlock = nil;


            [NSWorkspace.sharedWorkspace.notificationCenter removeObserver:self name:NSWorkspaceWillSleepNotification object:NULL];
            [NSWorkspace.sharedWorkspace.notificationCenter removeObserver:self name:NSWorkspaceDidWakeNotification object:NULL];
            
            self.i9++;

            strongSelf = nil;
        }
    }
    else
    {
        LOGFUNCPARAM(makeString(@"rescheduling timer, still time left to reschedule: %f", -[[NSDate date] timeIntervalSinceDate:self.date]))

        [self scheduleTimer];
        self.i10++;
    }
}

- (void)dealloc
{
    LOGFUNC
    self.i7++;
    
    assert_custom_info(!_timer, self.info);
}

- (NSString *)info
{
    return makeString(@"%i %i %i %i %i %i %i %i %i %i - %p %p %p", self.i1, self.i2, self.i3, self.i4, self.i5, self.i6, self.i7, self.i8, self.i9, self.i10, (__bridge void *)self.timer, (__bridge void *)self.timerBlock, (__bridge void *)self.dropBlock);
}
@end
