//
//  JMApplicationDelegate.m
//  CoreLib
//
//  Created by CoreCode on 05.05.15.
/*	Copyright © 2018 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "JMApplicationDelegate.h"
#import "JMCrashReporter.h"
#ifndef SKIP_RATINGWINDOW
#import "JMRatingWindowController.h"
#endif
#import "CoreLib.h"
#if defined(APPSTORE_VALIDATERECEIPT) || defined(APPSTORE)
#import "JMReceiptValidation.h"
#endif


@interface JMApplicationDelegate ()
	@property (assign, nonatomic) NSInteger minimumUsagesForRating;
#ifndef SKIP_RATINGWINDOW
    @property (strong, nonatomic) JMRatingWindowController *ratingWindowController;
#endif
@end


#if (!defined(SKIP_RATINGWINDOW) || !SKIP_RATINGWINDOW)
#define usagesThisVersionKey makeString(@"corelib_%@_usages", cc.appVersionString)
#endif
#define usagesAllVersionKey @"corelib_usages"

@implementation JMApplicationDelegate


@dynamic isRateable;

#ifndef SANDBOX
- (void)checkAndReportCrashesContaining:(NSArray <NSString *> *)neccessarySubstringsOrNil to:(NSString *)destinationMail
{
	CheckAndReportCrashes(destinationMail, neccessarySubstringsOrNil);;
}
#endif


- (void)welcomeOrExpireDemo:(int)demoLimit welcomeText:(NSString *)welcomeText expiryText:(NSString *)expiryText
{
#ifdef TRYOUT // check for demo limitation
    expiryText = [expiryText replaced:@"[USAGES_LEFT]" with:@(demoLimit - usagesThisVersionKey.defaultInt).stringValue];
    expiryText = [expiryText replaced:@"[USAGES_MAX]" with:@(demoLimit).stringValue];
    expiryText = [expiryText replaced:@"[APPNAME]" with:cc.appName];
    
    welcomeText = [welcomeText replaced:@"[USAGES_LEFT]" with:@(demoLimit - usagesThisVersionKey.defaultInt).stringValue];
    welcomeText = [welcomeText replaced:@"[USAGES_MAX]" with:@(demoLimit).stringValue];
    welcomeText = [welcomeText replaced:@"[APPNAME]" with:cc.appName];
    
	if (usagesThisVersionKey.defaultInt >= demoLimit)
	{
		alert(cc.appName, expiryText, @"OK", nil, nil);
		[cc openURL:openAppStoreWebsite];
		exit(1);
	}
	else
	{
		alert(cc.appName, welcomeText, @"OK", nil, nil);
	}
    // XXX: this needs a facility so we can call it at "operation" time to, not just start
    // XXX: we also want to support the model where we restrict features but don't expire
#endif
}

#ifndef SKIP_RATINGWINDOW
- (void)increaseUsagesBy:(int)usageIncrease
        allowRatingsWith:(int)allowReviewLimit
     requestFeedbackWith:(int)requestReviewLimit
            feedbackText:(NSString *)feedbackText
        allowFeedbackNow:(BOOL)allowNow
        forceFeedbackNow:(BOOL)forceAppearance
{
	self.minimumUsagesForRating = allowReviewLimit;

	usagesAllVersionKey.defaultInt = usagesAllVersionKey.defaultInt + usageIncrease;
	usagesThisVersionKey.defaultInt = usagesThisVersionKey.defaultInt + usageIncrease;

    BOOL showDialoge = forceAppearance;

    // XXX: this should not require linking the rating window if you don't want the feature

    if (!allowNow) return;
    
#ifndef TRYOUT
	NSString *askedThisVersionKey = makeString(@"corelib_%@_asked", cc.appVersionString);

	if 	(!@"corelib_dontaskagain".defaultInt &&
         !askedThisVersionKey.defaultInt &&
         usagesThisVersionKey.defaultInt >= requestReviewLimit)
	{
        showDialoge = YES;

		askedThisVersionKey.defaultInt = 1;
	}
#endif
    
    if (showDialoge)
    {
        feedbackText = [feedbackText replaced:@"[USAGES_ASKREVIEW]" with:@(requestReviewLimit).stringValue];
        feedbackText = [feedbackText replaced:@"[APPNAME]" with:cc.appName];
        
        
        if (!self.ratingWindowController)
        {
            self.ratingWindowController = [JMRatingWindowController new];
            
            __weak JMApplicationDelegate *weakSelf = self;
            self.ratingWindowController.closeBlock = ^{weakSelf.ratingWindowController = nil;};
        }
        [self.ratingWindowController showWindow:nil];
        self.ratingWindowController.introTextField.stringValue = feedbackText;
    }
}
#endif
    
- (void)checkBetaExpiryForDate:(const char *)preprocessorDateString days:(uint8_t)expiryDays
{
#if !defined(APPSTORE_VALIDATERECEIPT) && !defined(PADDLE) && !defined(TRYOUT)
	LOGFUNC;

	cc_log(@"Warning: this version will expire");
	
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
	dispatch_after_main(10.0, ^
	{
		RVNValidateApplication();

		RVNCheckInvalidReceiptHash();
	});
#elif defined(APPSTORE) && APPSTORE
	RVNCheckBundleIDAndVersion();
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
		[NSBundle.mainBundle loadNibNamed:nibName owner:self topLevelObjects:NULL];

	if ((*window).minSize.height > 680)
	{
		for (int i = 0; i < 10; i++)
		{
			cc_log_debug(@"WARNING: opened window with height %i but it should be below 680 (Macbook Air 11) or better below 630 (Macbook 12 native) to fit on every screen", (int)[*window frame].size.height);
		}
	}


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
#endif

- (IBAction)checkForUpdatesAction:(id)sender
{
#ifdef USE_SPARKLE
	LOGFUNC;
	if (updater)
		[updater checkForUpdates:self];
	else
		cc_log(@"Warning: the sparkle updater is not available!");
#endif
}

- (IBAction)initUpdateCheck
{
#ifdef USE_SPARKLE
	updater = [[SUUpdater alloc] init];
	assert(kUpdatecheckMenuindexKey.defaultObject);
	[self setUpdateCheck:@{@"tag" : kUpdatecheckMenuindexKey.defaultObject}];
#endif
}

- (IBAction)setUpdateCheck:(id)sender
{
#ifdef USE_SPARKLE
	NSUInteger intervalIndex = [[sender valueForKey:@"tag"] unsignedIntegerValue];
    NSArray <NSNumber *> *itemToDays = @[@0, @1, @2, @7, @14, @28];

    int newIntervalInDays = itemToDays[intervalIndex].intValue;
    int newIntervalInSeconds = newIntervalInDays * SECONDS_PER_DAYS(1);


	if (newIntervalInSeconds >= 1)
	{
		[updater setAutomaticallyChecksForUpdates:TRUE];
		[updater setUpdateCheckInterval:newIntervalInSeconds];
	}
	else
		[updater setAutomaticallyChecksForUpdates:FALSE];

    kUpdatecheckMenuindexKey.defaultObject = @(intervalIndex);
    
    if ([sender isKindOfClass:NSMenuItem.class])
        [self selectCurrentUpdateIntervalMenuItem:((NSMenuItem *)sender).menu];
#endif
}

- (void)selectCurrentUpdateIntervalMenuItem:(NSMenu *)menu
{
#ifdef USE_SPARKLE
    NSTimeInterval currentIntervalInSeconds = [updater automaticallyChecksForUpdates] ? [updater updateCheckInterval] : 0;
    
    NSArray <NSNumber *> *itemToDays = @[@0, @1, @2, @7, @14, @28];

    
    for (NSMenuItem *item in [menu itemArray])
    {
        int itemIntervalInDays = itemToDays[(NSUInteger)item.tag].intValue;
        int itemIntervalInSeconds = itemIntervalInDays * SECONDS_PER_DAYS(1);
        
        if (IS_FLOAT_EQUAL((float)currentIntervalInSeconds, itemIntervalInSeconds))
            [item setState:NSOnState];
        else
            [item setState:NSOffState];
    }
#endif
}

#pragma mark PADDLE

- (IBAction)paddleDeactivateClicked:(id)sender
{
    [self doesNotRecognizeSelector:_cmd];
}


- (IBAction)paddleDetailsClicked:(id)sender
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
