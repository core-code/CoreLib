//
//  AppKit+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 15.05.11.
/*	Copyright © 2017 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "AppKit+CoreCode.h"


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

#if __has_feature(modules)
@import ObjectiveC.runtime;
#else
#import <objc/runtime.h>
#endif



CONST_KEY(CCProgressDetailInfo)
CONST_KEY(CCProgressSheet)
CONST_KEY(CCProgressIndicator)

@implementation NSTabView (CoreCode)

@dynamic selectedTabViewIndex;

- (NSInteger)selectedTabViewIndex
{
	NSTabViewItem *selectedView = self.selectedTabViewItem;
	return [self indexOfTabViewItem:selectedView];
}

@end

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
		NSWindow *progressPanel = [[NSWindow alloc] initWithContentRect:NSMakeRect(0.0, 0.0, 400.0, 120.0)
													   styleMask:NSTitledWindowMask
														 backing:NSBackingStoreBuffered
														   defer:NO];


		NSTextField *progressInfo = [[NSTextField alloc] initWithFrame:NSMakeRect(18.0, 90.0, 364.0, 17.0)];
		NSTextField *progressDetailInfo = [[NSTextField alloc] initWithFrame:NSMakeRect(18.0, 65.0, 364.0, 17.0)];
		NSTextField *waitLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(18.0, 14.0, 364.0, 17.0)];
		NSProgressIndicator *progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(20.0, 41.0, 360.0, 20.0)];



		[progressInfo setStringValue:title];
		[progressDetailInfo setStringValue:@""];
		[waitLabel setStringValue:@"Please wait until the operation finishes…".localized];

		[progressInfo setFont:[NSFont boldSystemFontOfSize:13]];

		for (NSTextField *textField in @[progressInfo, progressDetailInfo, waitLabel])
		{
			[textField setAlignment:NSCenterTextAlignment];
			[textField setBezeled:NO];
			[textField setDrawsBackground:NO];
			[textField setEditable:NO];
			[textField setSelectable:NO];
			[progressPanel.contentView addSubview:textField];
		}

		[progressPanel.contentView addSubview:progressIndicator];
#if ! __has_feature(objc_arc)
		[progressIndicator release];
		[waitLabel release];
		[progressDetailInfo release];
		[progressInfo release];
#endif
		[progressPanel setReleasedWhenClosed:YES];

		[self setAssociatedValue:progressDetailInfo forKey:kCCProgressDetailInfoKey];
		[self setAssociatedValue:progressPanel forKey:kCCProgressSheetKey];
		[self setAssociatedValue:progressIndicator forKey:kCCProgressIndicatorKey];

		[NSApp activateIgnoringOtherApps:YES];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wpartial-availability"
        if (OS_IS_POST_10_8)
            [self beginSheet:progressPanel completionHandler:^(NSModalResponse resp){}];
        else
            [NSApp beginSheet:progressPanel modalForWindow:self
                modalDelegate:nil didEndSelector:nil contextInfo:NULL];
#pragma clang diagnostic pop

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wpartial-availability"
if (OS_IS_POST_10_8)
			[self endSheet:progressPanel];
		else
			[NSApp endSheet:progressPanel];
#pragma clang diagnostic pop
		[progressPanel orderOut:self];

		[self setAssociatedValue:nil forKey:kCCProgressDetailInfoKey];
		[self setAssociatedValue:nil forKey:kCCProgressSheetKey];
		[self setAssociatedValue:nil forKey:kCCProgressIndicatorKey];
	});
}

- (IBAction)performBorderlessClose:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(windowShouldClose:)])
	{
		if (![self.delegate windowShouldClose:self])
			return;
	}
	[self close];
}
@end


@implementation NSView (NSView_ClassSelection)

- (NSView *)viewWithClass:(Class)classofview
{
	if ([self isKindOfClass:classofview])
		return self;

	for (NSView *view in self.subviews)
		if ([view viewWithClass:classofview])
			return [view viewWithClass:classofview];

	return nil;
}


- (NSArray <NSView *> *)allSubviews
{
	NSMutableArray *allSubviews = [NSMutableArray arrayWithObject:self];

	NSArray *subviews = [self subviews];

	for (NSView *view in subviews)
		[allSubviews addObjectsFromArray:[view allSubviews]];

	return allSubviews.immutableObject;
}

- (nonnull __kindof NSView *)assertedViewWithTag:(NSInteger)tag
{
    __kindof NSView *view = [self viewWithTag:tag];
    
    assert(view);
    
    return view;
}

@end



@implementation NSTextField (NSTextField_AutoFontsize)

- (void)adjustFontSize
{
    double width = self.frame.size.width;
    NSFont *curr = self.font;
    int currentFontSize = (int)curr.pointSize;
    NSSize strSize;
    do
    {
        NSDictionary* attrs = @{NSFontAttributeName: [NSFont fontWithName:curr.fontName size:currentFontSize]};
        strSize = [self.stringValue sizeWithAttributes:attrs];

		currentFontSize --;

    } while (strSize.width > width);


    [self setFont:[NSFont fontWithName:curr.fontName size:currentFontSize+1]];
}
@end


@interface BlockWrapper : NSObject
@property (nonatomic, copy) ObjectInBlock block;
- (void)invoke:(id)sender;
@end
@implementation BlockWrapper
- (void)invoke:(id)sender { self.block(sender); }
#if ! __has_feature(objc_arc)
- (void)dealloc
{
    self.block = nil;

    [super dealloc];
}
#endif
@end


@implementation NSControl (NSControl_BlockAction)

@dynamic actionBlock;

static const char *actionBlockAssociatedObjectName = "CoreCode_NSControl_BlockAction";


- (void)setActionBlock:(ObjectInBlock)handler
{
	BlockWrapper *wrapper = [[BlockWrapper alloc] init];
	wrapper.block = handler;

	objc_setAssociatedObject(self, &actionBlockAssociatedObjectName, wrapper, OBJC_ASSOCIATION_RETAIN);


	self.target = wrapper;
	self.action = @selector(invoke:);

#if ! __has_feature(objc_arc)
	[wrapper release];
#endif
}

- (ObjectInBlock)actionBlock
{
	BlockWrapper *wrapper = objc_getAssociatedObject(self, &actionBlockAssociatedObjectName);
	return wrapper.block;
}
@end

#else

@implementation UIView (UIView_RemoveSubviews)

- (void)removeAllSubviews
{
	for (UIView *v in self.subviews)
		[v removeFromSuperview];
}
@end


#endif

