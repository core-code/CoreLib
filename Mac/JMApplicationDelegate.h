//
//  JMApplicationDelegate.h
//  CoreLib
//
//  Created by CoreCode on 05.05.15.
/*	Copyright © 2017 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "CoreLib.h"
#ifdef USE_SPARKLE
#if __has_feature(modules)
@import Sparkle.SUUpdater;
#else
#import <Sparkle/SUUpdater.h>
#endif
#endif


@interface JMApplicationDelegate : NSObject
#ifdef USE_SPARKLE
	<SUUpdaterDelegate>
#endif
- (IBAction)openWindow:(__strong NSWindow **)window nibName:(NSString *)nibName;
- (IBAction)openURL:(id)sender;
@property (readonly, nonatomic) BOOL isRateable;


- (void)welcomeOrExpireDemo:(int)demoLimit welcomeText:(NSString *)welcomeText expiryText:(NSString *)expiryText;
- (void)increaseUsages:(int)allowReviewLimit requestReview:(int)requestReviewLimit feedbackText:(NSString *)feedbackText debugForce:(BOOL)forceAppearance;
- (void)checkBetaExpiryForDate:(const char *)preprocessorDateString days:(uint8_t)expiryDays;
- (void)checkMASReceipt;
#ifndef SANDBOX
- (void)checkAndReportCrashesContaining:(NSArray <NSString *>*)neccessarySubstringsOrNil to:(NSString *)destinationMail;
#endif

#ifdef USE_SPARKLE
- (IBAction)initUpdateCheck;
- (IBAction)setUpdateCheck:(id)sender;
- (IBAction)checkForUpdatesAction:(id)sender;
CONST_KEY_DECLARATION(UpdatecheckMenuindex)
#endif


@end
