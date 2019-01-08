//
//  JMRatingWindowController.m
//  CoreLib
//
//  Created by CoreCode on 18/04/2017.
/*    Copyright © 2019 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMRatingWindowController.h"
#ifdef APPSTORE_VALIDATERECEIPT
#if __has_feature(modules)
@import StoreKit;
#else
#import <StoreKit/StoreKit.h>
#endif
#endif
@interface JMRatingWindowController ()

@property (weak, nonatomic) IBOutlet NSView *initialView;
@property (weak, nonatomic) IBOutlet NSView *happyView;
@property (weak, nonatomic) IBOutlet NSView *angryView;
@property (weak, nonatomic) IBOutlet NSTextField *feedbackTextField;
@property (weak, nonatomic) IBOutlet NSButton *ratemacupdateButton;
@property (weak, nonatomic) IBOutlet NSButton *rateappstoreButton;
@property (weak, nonatomic) IBOutlet NSButton *notnowButton;
@property (weak, nonatomic) IBOutlet NSButton *happyButton;
@property (weak, nonatomic) IBOutlet NSButton *notsureButton;
@property (weak, nonatomic) IBOutlet NSButton *problemButton;
@property (weak, nonatomic) IBOutlet NSButton *feedbackButton;
@property (weak, nonatomic) IBOutlet NSTextFieldCell *awesomeText;
@property (weak, nonatomic) IBOutlet NSTextField *introText;
@property (weak, nonatomic) IBOutlet NSTextField *sorryText;

@end


@implementation JMRatingWindowController


- (instancetype)init
{
    return [super initWithWindowNibName: @"JMRatingWindow"];
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.initialView.hidden = NO;
    self.angryView.hidden = YES;
    self.happyView.hidden = YES;


    if (@available(macOS 10.11, *)) // doing this directly in the NIB would warn when deploying to < 10.11
    {
        for (NSButton *button in @[self.ratemacupdateButton, self.rateappstoreButton, self.notnowButton, self.happyButton, self.notsureButton, self.problemButton, self.feedbackButton])
            button.font = [NSFont systemFontOfSize:18 weight:NSFontWeightLight];
        for (NSButton *tf in @[self.awesomeText, self.introText, self.sorryText])
            tf.font = [NSFont systemFontOfSize:14 weight:NSFontWeightLight];
    }
}

- (IBAction)happyClicked:(id)sender
{
    self.initialView.hidden = YES;
    self.angryView.hidden = YES;
    self.happyView.hidden = NO;
    
    if (!((NSString *)[NSBundle.mainBundle objectForInfoDictionaryKey:@"StoreProductPage"]).length)
    {
        if (!((NSString *)[NSBundle.mainBundle objectForInfoDictionaryKey:@"AlternativetoProductPage"]).length)
            self.rateappstoreButton.enabled = NO;
        else
            self.rateappstoreButton.title = [self.rateappstoreButton.title stringByReplacingOccurrencesOfString:@"App Store" withString:@"AlternativeTo"];
    }
    
    if (!((NSString *)[NSBundle.mainBundle objectForInfoDictionaryKey:@"MacupdateProductPage"]).length)
    {
        if (!((NSString *)[NSBundle.mainBundle objectForInfoDictionaryKey:@"FilehorseProductPage"]).length)
            self.ratemacupdateButton.enabled = NO;
        else
            self.ratemacupdateButton.title = [self.ratemacupdateButton.title stringByReplacingOccurrencesOfString:@"MacUpdate" withString:@"FileHorse"];
    }
}

- (IBAction)notsureClicked:(id)sender
{
    [self.window close];
}

- (IBAction)problemsClicked:(id)sender
{
    self.initialView.hidden = YES;
    self.angryView.hidden = NO;
    self.happyView.hidden = YES;
}

- (IBAction)notnowClicked:(id)sender
{
    [self.window close];
}

- (IBAction)closeClicked:(id)sender
{
    [self.window close];
}

- (IBAction)dontshowClicked:(id)sender
{
    [self.window close];

    
    NSInteger res = alert(@"Confirmation".localized, makeLocalizedString(@"%@ asks for your feedback only rarely and at maximum only once per app-version. Are you sure you want to turn this off completely?", cc.appName),
                          @"Cancel", @"Turn off feedback dialog", nil);
    
    if (res == NSAlertSecondButtonReturn)
        @"corelib_dontaskagain".defaultInt = 1;
}

- (IBAction)ratemacupdateClicked:(id)sender
{
    [cc openURL:openMacupdateWebsite];

   [self.window close];
}

- (IBAction)rateappstoreClicked:(id)sender
{
#ifdef APPSTORE_VALIDATERECEIPT
    if (@available(macOS 10.14, *))
    {
        [SKStoreReviewController requestReview];
    }
    else
#endif
    {
        [cc openURL:openAppStoreApp];
    }
    [self.window close];
}

- (IBAction)sendfeedbackClicked:(id)sender
{
    [cc sendSupportRequestMail:self.feedbackTextField.stringValue];
    [self.window close];
}

- (void)windowWillClose:(NSNotification *)notification
{
    if (self.closeBlock)
        self.closeBlock();
}

@end
