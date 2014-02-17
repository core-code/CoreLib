//
//  NSWindow+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 14.02.14.
/*	Copyright (c) 2012 - 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */



#import "NSWindow+CoreCode.h"


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

static CONST_KEY(CCProgressDetailInfo)
static CONST_KEY(CCProgressSheet)
static CONST_KEY(CCProgressIndicator)

@implementation NSWindow (CoreCode)


- (void)setProgressMessage:(NSString *)message
{
    dispatch_async_main(^
	{
		NSTextField *progressDetailInfo = [self associatedValueForKey:kCCProgressDetailInfoKey];

		[progressDetailInfo setStringValue:message];
	});
}

- (void)beginProgress:(NSString *)title
{
    dispatch_async_main(^
	{
		NSWindow *progressPanel = [[NSWindow alloc] initWithContentRect:NSMakeRect(0.0f, 0.0f, 400.0f, 120.0f)
													   styleMask:NSTitledWindowMask
														 backing:NSBackingStoreBuffered
														   defer:NO];


		NSTextField *progressInfo = [[NSTextField alloc] initWithFrame:NSMakeRect(18.0f, 90.0f, 364.0f, 17.0f)];
		NSTextField *progressDetailInfo = [[NSTextField alloc] initWithFrame:NSMakeRect(18.0f, 65.0f, 364.0f, 17.0f)];
		NSTextField *waitLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(18.0f, 14.0f, 364.0f, 17.0f)];
		NSProgressIndicator *progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(20.0f, 41.0f, 360.0f, 20.0f)];




		[progressInfo setStringValue:title];
		[progressDetailInfo setStringValue:@""];
		[waitLabel setStringValue:@"Please wait until the operation finishes…"];

		[progressInfo setFont:[NSFont boldSystemFontOfSize:13]];

		for (NSTextField *textField in @[progressInfo, progressDetailInfo, waitLabel])
		{
			[textField setAlignment:NSCenterTextAlignment];
			[textField setBezeled:NO];
			[textField setDrawsBackground:NO];
			[textField setEditable:NO];
			[textField setSelectable:NO];
			[[progressPanel contentView] addSubview:textField];
		}

		[[progressPanel contentView] addSubview:progressIndicator];

		[progressPanel setReleasedWhenClosed:YES];

		[self setAssociatedValue:progressDetailInfo forKey:kCCProgressDetailInfoKey];
		[self setAssociatedValue:progressPanel forKey:kCCProgressSheetKey];
		[self setAssociatedValue:progressIndicator forKey:kCCProgressIndicatorKey];

		[NSApp activateIgnoringOtherApps:YES];
		[NSApp beginSheet:progressPanel
		   modalForWindow:self
			modalDelegate:nil
		   didEndSelector:nil
			  contextInfo:NULL];

		[progressIndicator startAnimation:self];
	});
}

- (void)endProgress
{
    dispatch_async_main(^
	{
		NSWindow *progressPanel = [self associatedValueForKey:kCCProgressSheetKey];
		NSProgressIndicator *progressIndicator = [self associatedValueForKey:kCCProgressIndicatorKey];

		[progressIndicator stopAnimation:self];
		[NSApp activateIgnoringOtherApps:YES];
		[NSApp endSheet:progressPanel];
		[progressPanel orderOut:self];

		[self setAssociatedValue:nil forKey:kCCProgressDetailInfoKey];
		[self setAssociatedValue:nil forKey:kCCProgressSheetKey];
		[self setAssociatedValue:nil forKey:kCCProgressIndicatorKey];
	});
}

@end

#endif