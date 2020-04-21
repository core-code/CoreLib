//
//  JMApplicationDelegate.m
//  CoreLib
//
//  Created by CoreCode on 05.05.15.
/*	Copyright © 2020 CoreCode Limited
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


@implementation JMApplicationDelegate


@dynamic isRateable;

#ifndef SANDBOX
- (void)checkAndReportCrashesContaining:(NSArray <NSString *> *)neccessarySubstringsOrNil blacklistedStrings:(NSArray <NSString *> *)blacklistedStringsOrNil to:(NSString *)destinationMail
{
    CheckAndReportCrashes(destinationMail, neccessarySubstringsOrNil, blacklistedStringsOrNil);
}
- (void)checkAndReportCrashesContaining:(NSArray <NSString *> *)neccessarySubstringsOrNil to:(NSString *)destinationMail
{
	CheckAndReportCrashes(destinationMail, neccessarySubstringsOrNil, nil);
}
#endif


- (void)welcomeOrExpireDemo:(int)demoLimit welcomeText:(NSString *)welcomeText expiryText:(NSString *)expiryText
{
#ifdef TRYOUT // check for demo limitation
    expiryText = [expiryText replaced:@"[USAGES_LEFT]" with:@(demoLimit - kUsagesThisVersionKey.defaultInt).stringValue];
    expiryText = [expiryText replaced:@"[USAGES_MAX]" with:@(demoLimit).stringValue];
    expiryText = [expiryText replaced:@"[APPNAME]" with:cc.appName];
    
    welcomeText = [welcomeText replaced:@"[USAGES_LEFT]" with:@(demoLimit - kUsagesThisVersionKey.defaultInt).stringValue];
    welcomeText = [welcomeText replaced:@"[USAGES_MAX]" with:@(demoLimit).stringValue];
    welcomeText = [welcomeText replaced:@"[APPNAME]" with:cc.appName];
    
	if (kUsagesThisVersionKey.defaultInt >= demoLimit)
	{
		alert(cc.appName, expiryText, @"OK", nil, nil);
		[cc openURL:openAppStoreWebsite];
		exit(1);
	}
	else
	{
		alert(cc.appName, welcomeText, @"OK", nil, nil);
	}
    // TODO: this needs a facility so we can call it at "operation" time to, not just start
    // TODO: we also want to support the model where we restrict features but don't expire
#endif
}

- (void)increaseUsagesBy:(int)usageIncrease
        allowRatingsWith:(int)allowReviewLimit
     requestFeedbackWith:(int)requestReviewLimit
            feedbackText:(NSString *)feedbackText
        allowFeedbackNow:(BOOL)allowNow
        forceFeedbackNow:(BOOL)forceAppearance
{
#ifndef SKIP_RATINGWINDOW
	self.minimumUsagesForRating = allowReviewLimit;

	kUsagesAllVersionKey.defaultInt = kUsagesAllVersionKey.defaultInt + usageIncrease;
	kUsagesThisVersionKey.defaultInt = kUsagesThisVersionKey.defaultInt + usageIncrease;

    BOOL showDialog = forceAppearance;

    // TODO: this should not require linking the rating window if you don't want the feature

    if (!allowNow) return;
    
#ifndef TRYOUT
	NSString *askedThisVersionKey = makeString(@"corelib_%@_asked", cc.appVersionString);
    NSDate *lastAskDate = @"corelib_askdate".defaultObject;

	if 	(!@"corelib_dontaskagain".defaultInt &&
         !askedThisVersionKey.defaultInt &&
         kUsagesThisVersionKey.defaultInt >= requestReviewLimit &&
         (([NSDate.date timeIntervalSinceDate:lastAskDate] > SECONDS_PER_WEEKS(14)) || (!lastAskDate)))
	{
        showDialog = YES;

		askedThisVersionKey.defaultInt = 1;
        @"corelib_askdate".defaultObject = NSDate.date;
	}
#endif
    
    if (showDialog)
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
#endif
}

- (void)checkBetaExpiryForDate:(const char *)preprocessorDateString days:(uint8_t)expiryDays
{
#if !defined(APPSTORE_VALIDATERECEIPT) && !defined(PADDLE) && !defined(TRYOUT)
	LOGFUNC

	cc_log(@"Warning: this version will expire");
    
	dispatch_after_main(60, ^
	{
		if ([[NSDate date] timeIntervalSinceDate:[NSDate dateWithPreprocessorDate:preprocessorDateString]] > SECONDS_PER_DAYS(expiryDays))
		{
			alert_apptitled(@"Sorry, this test-version has expired".localized,
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

- (IBAction)openURL:(NSObject *)sender
{
	LOGFUNC

    NSNumber *tagNum = [sender valueForKey:@"tag"];
	int tag = tagNum.intValue;

	[cc openURL:(openChoice)tag];
}

- (BOOL)isRateable
{
   return (self.minimumUsagesForRating > 0 && kUsagesAllVersionKey.defaultInt > self.minimumUsagesForRating);
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
    
    if (!*window)
    {
        NSString *nibPath = @[cc.resDir, @"Base.lproj", makeString(@"%@.nib", nibName)].path;
        
        cc_log_error(@"Error: openWindow:nibName:(%@) failed %i", nibName, nibPath.fileExists);
    }
    
	assert((*window).delegate == (id <NSWindowDelegate>)self);
    assert(*window);
}

- (IBAction)terminate:(id)sender
{
	[application terminate:self];
}


CONST_KEY_IMPLEMENTATION(UpdatecheckMenuindex)


- (IBAction)checkForUpdatesAction:(id)sender
{
#ifdef USE_SPARKLE
	LOGFUNC
	if (updater)
#if USE_SPARKLE == 2
        [updater checkForUpdates];
#else
		[updater checkForUpdates:self];
#endif
	else
		cc_log(@"Warning: the sparkle updater is not available!");
#else
    let url = (NSString *)[bundle objectForInfoDictionaryKey:@"SUFeedURL"];
    let feed = url.download.stringUTF8;
    let version = [[feed splitAfterNull:@"sparkle:version=\""] splitBeforeNull:@"\""];
    if ([version isIntegerNumberOnly])
    {
        let newestBuildNumber = version.intValue;
        if (newestBuildNumber > cc.appBuildNumber)
        {
            let svs = [[feed splitAfterNull:@"sparkle:shortVersionString=\""] splitBeforeNull:@"\""];
            if (alert(@"Update Available",
                      makeString(@"An Update is available. You have version '%@ (%i)' but the newest version is '%@ (%i)'. Please use our 'MacUpdater' to keep to update to the newest version - it can also update your other apps!", cc.appVersionString, cc.appBuildNumber, svs, newestBuildNumber),
                      @"Open MacUpdater Homepage", @"Cancel", nil) == NSAlertFirstButtonReturn)
                 [@"https://www.corecode.io/macupdater/".URL open];
        }
        else
            alert(@"No Update Available", @"This app is fully up-to-date.", @"Cool", nil, nil);
    }
    else
        alert(@"Update Check Failed", @"The update-check failed - please check your internet connection and try again.", @"OK", nil, nil);
#endif
}

- (IBAction)initUpdateCheck
{
#ifdef USE_SPARKLE
#if USE_SPARKLE == 2
    userDriver = [[SPUStandardUserDriver alloc] initWithHostBundle:bundle delegate:self];
    updater = [[SPUUpdater alloc] initWithHostBundle:bundle applicationBundle:bundle userDriver:userDriver delegate:self];
#else
    updater = [SUUpdater new];
    updater.delegate = self;
#endif
    assert(kUpdatecheckMenuindexKey.defaultObject);
    [self setUpdateCheck:@{@"tag" : kUpdatecheckMenuindexKey.defaultObject}];
#endif
}

- (IBAction)setUpdateCheck:(NSObject *)sender
{
#ifdef USE_SPARKLE
    NSNumber *tagNum = [sender valueForKey:@"tag"];
	NSUInteger intervalIndex = tagNum.unsignedIntegerValue;
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
            [item setState:NSControlStateValueOn];
        else
            [item setState:NSControlStateValueOff];
    }
#endif
}

#if defined(USE_SPARKLE) && USE_SPARKLE == 1
- (void)updater:(SUUpdater *)updater didFindValidUpdate:(SUAppcastItem *)item
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@ %@", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__), item.description), 30);
}
- (void)updater:(SUUpdater *)updater didDismissUpdateAlertPermanently:(BOOL)permanently forItem:(SUAppcastItem *)item
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@ %@ %i", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__), item.description, permanently), 30);
}
- (void)updaterDidNotFindUpdate:(SUUpdater *)updater
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__)), 30);
}
- (void)updater:(SUUpdater *)updater userDidSkipThisVersion:(SUAppcastItem *)item
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@ %@", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__), item.description), 30);
}
- (void)updater:(SUUpdater *)updater didDownloadUpdate:(SUAppcastItem *)item
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@ %@", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__), item.description), 30);
}
- (void)updater:(SUUpdater *)updater failedToDownloadUpdate:(SUAppcastItem *)item error:(NSError *)error
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@ %@ %@", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__), item.description, error.description), 30);
}
- (void)userDidCancelDownload:(SUUpdater *)updater
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__)), 30);
}
- (void)updater:(SUUpdater *)updater didExtractUpdate:(SUAppcastItem *)item
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@ %@", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__), item.description), 30);
}
- (void)updater:(SUUpdater *)updater willInstallUpdate:(SUAppcastItem *)item
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@ %@", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__), item.description), 30);
}
- (void)updaterWillRelaunchApplication:(SUUpdater *)updater
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__)), 30);
}
- (void)updaterDidShowModalAlert:(SUUpdater *)updater
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__)), 30);
}
- (void)updater:(SUUpdater *)updater didAbortWithError:(NSError *)error
{
    cc_defaults_addtoarray(@"CC_SPARKLE_EVENTS", makeString(@"%@ %@ %@", NSDate.date.shortDateAndTimeString, @(__PRETTY_FUNCTION__), error.description), 30);
}
#endif

#pragma mark PADDLE

- (IBAction)paddleDeactivateClicked:(id)sender
{
    [self doesNotRecognizeSelector:_cmd];
}


- (IBAction)paddleDetailsClicked:(id)sender
{
    [self doesNotRecognizeSelector:_cmd];
}

- (IBAction)paddleActivateClicked:(id)sender
{
    [self doesNotRecognizeSelector:_cmd];
}

- (IBAction)paddleRecoverClicked:(id)sender
{
    [self doesNotRecognizeSelector:_cmd];
}
@end
