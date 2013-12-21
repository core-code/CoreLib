//
//  JMCorrectTimer.m
//  TestSport
//
//  Created by CoreCode on 28.04.13.
/*	Copyright (c) 2010 - 2013 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMCorrectTimer.h"

@interface JMCorrectTimer ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) id target;
@property (strong, nonatomic) NSDate *date;
@property (copy, nonatomic) void (^timerBlock)();
@property (copy, nonatomic) void (^dropBlock)();

@end


@implementation JMCorrectTimer

- (id)init
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (id)initWithFireDate:(NSDate *)d timerBlock:(void (^)(void))timerBlock dropBlock:(void (^)(void))dropBlock
{
	if ((self = [super init]))
	{
		self.timerBlock = timerBlock;
		self.dropBlock = dropBlock;
		self.date = d;

		[self scheduleTimer];

		[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
															   selector:@selector(receiveWakeNote:)
																   name:NSWorkspaceDidWakeNotification object:NULL];
	}
	return self;
}

- (void)scheduleTimer
{
	asl_NSLog_debug(@"JMCorrectTimer: scheduleTimer");
	
	NSTimer *t = [[NSTimer alloc] initWithFireDate:self.date
										  interval:0
											target:self
										  selector:@selector(timer:)
										  userInfo:NULL repeats:NO];

	[[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];

#if ! __has_feature(objc_arc)
	[t autorelease];
#endif
	self.timer = t;
}

- (void)invalidate
{
	asl_NSLog_debug(@"JMCorrectTimer: invalidate");
	[self.timer invalidate];
	self.timer = nil; // crash
}

- (void)timer:(id)sender
{
	asl_NSLog_debug(@"JMCorrectTimer: timerDate: %@   now: %@", [[self.timer fireDate] description], [[NSDate date] description]);

	self.timerBlock();
	
	[self invalidate];

	self.timerBlock = nil;
	self.dropBlock = nil;
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
}

- (void)receiveWakeNote:(id)sender
{
	[self invalidate];

	if ([[NSDate date] timeIntervalSinceDate:self.date] > 0.0)
	{
		asl_NSLog_debug(@"JMCorrectTimer: Dropping Timer as we have been sleeping");
		self.dropBlock();

		self.timerBlock = nil;
		self.dropBlock = nil;
	}
	else
	{
		asl_NSLog_debug(@"JMCorrectTimer: Rescheduling timer");
		
		[self scheduleTimer];
	}
}

- (void)dealloc
{
	if (_timer)
	{
		asl_NSLog(ASL_LEVEL_ERR, @"JMCorrectTimer: error dealloced while still in use");
	}
	else
		asl_NSLog_debug(@"JMCorrectTimer: dealloc");
	
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
	
#if ! __has_feature(objc_arc)
	[super dealloc];
#endif
}
@end
