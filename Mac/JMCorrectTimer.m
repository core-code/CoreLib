//
//  JMCorrectTimer.m
//  TestSport
//
//  Created by Julian Mayer on 28.04.13.
//  Copyright (c) 2013 CoreCode. All rights reserved.
//

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
	NSTimer *t = [[NSTimer alloc] initWithFireDate:_date
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

- (void)cleanupTimer
{
	[self.timer invalidate];
	self.timer = nil;
}

- (void)timer:(id)sender
{
	asl_NSLog_debug(@"JMCorrectTimer: timerDate: %@   now: %@", [[_timer fireDate] description], [[NSDate date] description]);

	_timerBlock();
	
	[self cleanupTimer];

	self.timerBlock = nil;
	self.dropBlock = nil;
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
}

- (void)receiveWakeNote:(id)sender
{
	[self cleanupTimer];

	if ([[NSDate date] timeIntervalSinceDate:_date] > 0.0)
	{
		asl_NSLog_debug(@"JMCorrectTimer: Dropping Timer as we have been sleeping");
		_dropBlock();

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
	
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
	
#if ! __has_feature(objc_arc)
	[super dealloc];
#endif
}
@end
