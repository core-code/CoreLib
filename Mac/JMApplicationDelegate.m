//
//  JMApplicationDelegate.m
//  CoreLib
//
//  Created by CoreCode on 05.05.15.
/*	Copyright (c) 2015 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "JMApplicationDelegate.h"
#import "JMCrashReporter.h"
#import "JMAppMovedHandler.h"
#import "CoreLib.h"


@interface JMApplicationDelegate ()
	@property (assign, nonatomic) NSInteger minimumUsagesForRating;
@end


#define usagesThisVersionKey makeString(@"corelib_%@_usages", cc.appVersionString)
#define usagesAllVersionKey @"corelib_usages"

@implementation JMApplicationDelegate


@dynamic isRateable;

#ifndef SANDBOX
- (void)checkAndReportCrashesContaining:(NSArray <NSString *> *)neccessarySubstringsOrNil to:(NSString *)destinationMail
{
	CheckAndReportCrashes(destinationMail, neccessarySubstringsOrNil);;
}
#endif

- (void)checkAppMovements
{
	[JMAppMovedHandler startMoveObservation];
}

- (void)welcomeOrExpireDemo:(int)demoLimit welcomeText:(NSString *)welcomeText expiryText:(NSString *)expiryText
{
#ifdef TRYOUT // check for demo limitation
	if (usagesThisVersionKey.defaultInt >= demoLimit)
	{
		alert(cc.appName, expiryText, @"OK", nil, nil);
		[cc openURL:openAppStoreWebsite];
		exit(1);
	}
	else
	{
		alert(cc.appName, makeString(welcomeText, , demoLimit - usagesThisVersionKey.defaultInt)), @"OK", nil, nil);
	}
#endif
}

- (void)increaseUsages:(int)allowReviewLimit requestReview:(int)requestReviewLimit feedbackText:(NSString *)feedbackText
{
	self.minimumUsagesForRating = allowReviewLimit;

	usagesAllVersionKey.defaultInt = usagesAllVersionKey.defaultInt + 1;
	usagesThisVersionKey.defaultInt = usagesThisVersionKey.defaultInt + 1;


#ifndef TRYOUT
	NSString *askedThisVersionKey = makeString(@"corelib_%@_asked", cc.appVersionString);

	if 	(!askedThisVersionKey.defaultInt && usagesThisVersionKey.defaultInt >= requestReviewLimit)
	{
		NSInteger res = alert(makeString(@"Rate %@?", cc.appName),
							  feedbackText, @"Rate on MacAppStore", @"Don't rate", @"Rate on MacUpdate");

		if (res == NSAlertFirstButtonReturn)
			[cc openURL:openAppStoreApp];
		if (res == NSAlertThirdButtonReturn)
			[cc openURL:openMacupdateWebsite];

		askedThisVersionKey.defaultInt = 1;
	}
#endif
}

- (void)checkBetaExpiryForDate:(const char *)preprocessorDateString days:(uint8_t)expiryDays
{
#if !defined(APPSTORE_VALIDATERECEIPT) && !defined(TRYOUT)
	dispatch_after_main(60, ^
	{
		if ([[NSDate date] timeIntervalSinceDate:[NSDate dateWithPreprocessorDate:preprocessorDateString]] > 60 * 60 * 24 * expiryDays)
		{
			alert_apptitled(@"Sorry this test-version has expired".localized,
							@"OK".localized, nil, nil);
			exit(1);
		}
	});
#endif
}

- (void)checkMASReceipt
{
#ifdef APPSTORE_VALIDATERECEIPT
	dispatch_after_main(^
	{
		RVNValidateApplication();

		RVNCheckInvalidReceiptHash();
	});
#endif
}

- (IBAction)openURL:(id)sender
{
	LOGFUNC;

	int tag = [[sender valueForKey:@"tag"] intValue];

	[cc openURL:(openChoice)tag];
}

- (BOOL)isRateable
{
   return (self.minimumUsagesForRating > 0 && usagesAllVersionKey.defaultInt > self.minimumUsagesForRating);
}

+ (NSSet *)keyPathsForValuesAffectingIsRateable
{
	return @[@"minimumUsagesForRating"].set;
}

- (IBAction)openWindow:(__strong NSWindow **)window nibName:(NSString *)nibName
{
	LOGFUNCPARAM(nibName);

	if (!*window)
		[[NSBundle mainBundle] loadNibNamed:nibName owner:self topLevelObjects:NULL];

	[NSApp activateIgnoringOtherApps:YES];
	[*window makeKeyAndOrderFront:self];
	assert((*window).delegate == (id <NSWindowDelegate>)self);
}

- (IBAction)terminate:(id)sender
{
	[application terminate:self];
}

#ifdef USE_SPARKLE

static SUUpdater *updater;
CONST_KEY_IMPLEMENTATION(UpdatecheckMenuindex)

- (IBAction)checkForUpdatesAction:(id)sender
{
	LOGFUNC;
	if (updater)
		[updater checkForUpdates:self];
	else
		asl_NSLog(ASL_LEVEL_WARNING, @"Warning: the sparkle updater is not available!");
}

- (IBAction)initUpdateCheck
{
	updater = [[SUUpdater alloc] init];
	[updater setDelegate:self];
	assert(kUpdatecheckMenuindexKey.defaultObject);
	[self setUpdateCheck:@{@"tag" : kUpdatecheckMenuindexKey.defaultObject}];
}

- (IBAction)setUpdateCheck:(id)sender
{
	int intervalIndex = [[sender valueForKey:@"tag"] intValue];
	NSTimeInterval newInterval = 0;

	if (intervalIndex == 0)
		newInterval = 0;
	else if (intervalIndex == 1)
		newInterval = 86400;
	else if (intervalIndex == 2)
		newInterval = 2 * 86400;
	else if (intervalIndex == 3)
		newInterval = 7 * 86400;
	else if (intervalIndex == 4)
		newInterval = 14 * 86400;
	else if (intervalIndex == 5)
		newInterval = 28 * 86400;

	if (newInterval >= 0.1)
	{
		[updater setAutomaticallyChecksForUpdates:TRUE];
		[updater setUpdateCheckInterval:newInterval];
	}
	else
		[updater setAutomaticallyChecksForUpdates:FALSE];
}
#endif

@end