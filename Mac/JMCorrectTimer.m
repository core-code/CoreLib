//
//  JMCorrectTimer.m
//  CoreLib
//
//  Created by CoreCode on 28.04.13.
/*    Copyright © 2019 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMCorrectTimer.h"

// allows clients to get more info about failures
#ifdef TIMER_ASSERT_FUNCTION
void TIMER_ASSERT_FUNCTION(NSString * text);
#define assert_timer(e) (__builtin_expect(!(e), 0) ? TIMER_ASSERT_FUNCTION(makeString(@"%@ %@ %i %@", @(__func__), @(__FILE__), __LINE__, @(#e))) : (void)0)
#else
#define assert_timer(e)
#endif


@interface JMCorrectTimer ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) id target;
@property (strong, nonatomic) NSDate *date;
@property (copy, nonatomic) void (^timerBlock)(void);
@property (copy, nonatomic) void (^dropBlock)(void);
@property (assign, nonatomic) BOOL didInvalidate;

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
    LOGFUNC;
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
    LOGFUNCPARAM(makeString(@"timerDate: %@   now: %@", self.date, NSDate.date.description));

    NSTimer *t = [[NSTimer alloc] initWithFireDate:self.date
                                          interval:0
                                            target:self
                                          selector:@selector(timer:)
                                          userInfo:NULL repeats:NO];

    [NSRunLoop.currentRunLoop addTimer:t forMode:NSDefaultRunLoopMode];

    t.tolerance = 0.1;


    self.timer = t;
    
    if (!self.timer)
    {
        cc_log_error(@"JMCorrectTimer: could not create timer");
        assert_timer(0);
    }
}

- (void)invalidate
{
    LOGFUNC;

    self.didInvalidate = YES;
    
    if (self.timer)
        [self.timer invalidate];
    self.timer = nil;

    
    [NSWorkspace.sharedWorkspace.notificationCenter removeObserver:self name:NSWorkspaceWillSleepNotification object:NULL];
    [NSWorkspace.sharedWorkspace.notificationCenter removeObserver:self name:NSWorkspaceDidWakeNotification object:NULL];
}

- (void)timer:(id)sender
{
    LOGFUNCPARAM(makeString(@"timerDate: %@   now: %@", self.timer.fireDate.description, NSDate.date.description));

    __strong JMCorrectTimer *strongSelf = self;

    self.timerBlock();


    [self invalidate];
    self.timerBlock = nil;
    self.dropBlock = nil;

    strongSelf = nil;
}

- (void)receiveSleepNote:(id)sender
{
    LOGFUNC;

    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    else
    {
        cc_log_error(@"JMCorrectTimer: receiveSleepNote but no timer");
        assert_timer(0);
        assert_timer(self.dropBlock);
        assert_timer(self.didInvalidate);
    }
}

- (void)receiveWakeNote:(id)sender
{
    if (self.timer)
    {
        cc_log_error(@"JMCorrectTimer: receiveWakeNote but timer");
        assert_timer(0);
        [self.timer invalidate];
        self.timer = nil;
    }


    if ([[NSDate date] timeIntervalSinceDate:self.date] > 0.01)
    {
        LOGFUNCPARAM(makeString(@"dropping Timer as we have been sleeping, missed target by: %f", -[[NSDate date] timeIntervalSinceDate:self.date]));

        if (self.dropBlock)
        {
            __strong JMCorrectTimer *strongSelf = self;

            self.dropBlock();

            self.timerBlock = nil;
            self.dropBlock = nil;


            strongSelf = nil;
        }
        else
        {
            cc_log_error(@"JMCorrectTimer: error dropBlock was nil");
            assert_timer(0);
            assert_timer(self.didInvalidate);
        }
    }
    else
    {
        LOGFUNCPARAM(makeString(@"rescheduling timer, still time left to reschedule: %f", -[[NSDate date] timeIntervalSinceDate:self.date]));

        [self scheduleTimer];
    }
}

- (void)dealloc
{
    LOGFUNC;

    if (_timer)
    {
        cc_log_error(@"JMCorrectTimer: error dealloced while still in use");
        assert_timer(0);
        assert_timer(self.dropBlock);
        assert_timer(self.didInvalidate);
    }
}
@end
