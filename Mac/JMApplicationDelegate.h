//
//  JMApplicationDelegate.h
//  CoreLib
//
//  Created by CoreCode on 05.05.15.
/*	Copyright © 2022 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "CoreLib.h"


CC_ENUM(uint8_t, purchaseActivationType)
{
    kPurchaseActivationFree = 0,
    kPurchaseActivationPaid = 1,
    kPurchaseActivationPro = 2
};


#ifdef USE_SPARKLE
#if __has_feature(modules)
@import Sparkle;
#else
#import <Sparkle/Sparkle.h>
#endif
#endif

@interface JMApplicationDelegate : NSObject
#ifdef USE_SPARKLE
#if USE_SPARKLE == 2
    <SPUStandardUserDriverDelegate, SPUUpdaterDelegate>
#elif USE_SPARKLE == 1
    <SUUpdaterDelegate>
#endif
#endif
{
    
#ifdef USE_SPARKLE
#if USE_SPARKLE == 2
    SPUUpdater *updater;
    SPUStandardUserDriver *userDriver;
#else
    SUUpdater *updater;
#endif
#endif
}

- (IBAction)openWindow:(__strong NSWindow **)window nibName:(NSString *)nibName;
- (IBAction)openURL:(NSObject *)sender;

@property (readonly, nonatomic) BOOL isRateable;


- (void)increaseUsagesBy:(int)usageIncrease
        allowRatingsWith:(int)allowReviewLimit
     requestFeedbackWith:(int)requestReviewLimit
            feedbackText:(NSString *)feedbackText
        allowFeedbackNow:(BOOL)allowNow
        forceFeedbackNow:(BOOL)forceAppearance;

- (void)welcomeOrExpireDemo:(int)demoLimit welcomeText:(NSString *)welcomeText expiryText:(NSString *)expiryText;
- (void)checkBetaExpiryForDate:(const char *)preprocessorDateString days:(uint8_t)expiryDays;
- (void)checkMASReceipt;
#ifndef SANDBOX
- (void)checkAndReportCrashesContaining:(NSArray <NSString *>*)neccessarySubstringsOrNil to:(NSString *)destinationMail;
- (void)checkAndReportCrashesContaining:(NSArray <NSString *> *)neccessarySubstringsOrNil blacklistedStrings:(NSArray <NSString *> *)blacklistedStringsOrNil to:(NSString *)destinationMail;
#endif

#ifdef USE_SPARKLE
- (IBAction)initUpdateCheck;
- (IBAction)setUpdateCheck:(NSObject *)sender;
- (IBAction)checkForUpdatesAction:(id)sender;
- (void)selectCurrentUpdateIntervalMenuItem:(NSMenu *)menu;
#endif


// PURCHASE
- (IBAction)purchaseDeactivateClicked:(id)sender;
- (IBAction)purchaseDetailsClicked:(id)sender;
- (IBAction)purchaseActivateClicked:(id)sender;
- (IBAction)purchaseRecoverClicked:(id)sender;
@property (assign, nonatomic) BOOL purchaseEnabled;
@property (assign, nonatomic) purchaseActivationType purchaseActivated;
@property (strong, nonatomic) NSString *purchaseEmail;
@property (strong, nonatomic) NSString *purchaseLicense;


@end


#define kUsagesThisVersionKey makeString(@"corelib_%@_usages", cc.appVersionString)
#define kUsagesAllVersionKey @"corelib_usages"
CONST_KEY_DECLARATION(UpdatecheckMenuindex)
