//
//  JMVisibilityManager.m
//  CoreLib
//
//  Created by CoreCode on So Jan 20 2013.
/*	Copyright © 2018 CoreCode Limited
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMVisibilityManager.h"

#if __has_feature(modules)
@import Carbon;
#else
#import <Carbon/Carbon.h>
#endif


CONST_KEY(JMVisibilityManagerValue)


@interface VisibilityManager ()
{
	visibilitySettingEnum _visibilitySetting;
	NSImage *_dockIcon;
	NSImage *_menubarIcon;
}

@property (strong, nonatomic) NSStatusItem *statusItem;

@end



@implementation VisibilityManager

@dynamic visibilitySetting, dockIcon, menubarIcon, menuTooltip;

+ (void)initialize
{
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];

	defaultValues[kJMVisibilityManagerValueKey] = @(kVisibleDock);

	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (id)init
{
	if ((self = [super init]))
	{
#ifdef DEBUG
		assert([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"LSUIElement"] boolValue]);
#endif
		visibilitySettingEnum storedSetting = (visibilitySettingEnum) kJMVisibilityManagerValueKey.defaultInt;
		
		_visibilitySetting = kVisibleNowhere;

		_templateSetting = kTemplateNever;


        BOOL optionDown = ([NSEvent modifierFlags] & NSEventModifierFlagOption) != 0;

		if (storedSetting == kVisibleNowhere && optionDown)
			[self setVisibilitySetting:kVisibleDock];
		else
			[self setVisibilitySetting:storedSetting];
	}

	return self;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdirect-ivar-access"

- (void)setVisibilitySetting:(visibilitySettingEnum)newSetting
{
    if (_visibilitySetting % 2 == 1 && newSetting % 2 == 0)
    {
		[self _transform:NO];
	}
	else if (_visibilitySetting % 2 == 0 && newSetting % 2 == 1)
	{
		[self _transform:YES];
	}

	//[self willChangeValueForKey:@"visibilitySetting"];
	_visibilitySetting = newSetting;
	//[self didChangeValueForKey:@"visibilitySetting"];

	[self setMenubarIcon:_menubarIcon];
	[self setDockIcon:_dockIcon];

	kJMVisibilityManagerValueKey.defaultInt = newSetting;
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (visibilitySettingEnum)visibilitySetting
{
	return _visibilitySetting;
}

- (void)setDockIcon:(NSImage *)newDockIcon
{
	_dockIcon = newDockIcon;

	if (_visibilitySetting % 2 == 1)
	{
		if (_dockIcon)
			[NSApp setApplicationIconImage:_dockIcon];
	}
}

- (NSImage *)dockIcon
{
	return _dockIcon;
}

- (void)setMenubarIcon:(NSImage *)newMenubarIcon
{
	if ((self.templateSetting == kTemplateAlways) ||
		((self.templateSetting == kTemplateWhenDarkMenubar) && [[[NSAppearance currentAppearance] name] contains:@"NSAppearanceNameVibrantDark"]))
		newMenubarIcon.template = YES;
	else
		newMenubarIcon.template = NO;

	_menubarIcon = newMenubarIcon;
	
	if (_visibilitySetting > 1)
	{
        if (self.statusItem == nil)
        {
            self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

            [self.statusItem setHighlightMode:YES];
            [self.statusItem setEnabled:YES];
        }
		
		[self.statusItem setMenu:self.statusItemMenu];
		[self.statusItem setImage:_menubarIcon];
	}
	else
	{
        if (self.statusItem)
		{
			[[NSStatusBar systemStatusBar] removeStatusItem:_statusItem];
			_statusItem = nil;
		}
	}
}

- (NSImage *)menubarIcon
{
	return _menubarIcon;
}

- (void)setMenuTooltip:(NSString *)menuTooltip
{
	[_statusItem setToolTip:menuTooltip];
}

- (NSString *)menuTooltip
{
	return [_statusItem toolTip];
}
#pragma GCC diagnostic pop

- (void)handleAppReopen
{
    BOOL optionDown = ([NSEvent modifierFlags] & NSEventModifierFlagOption) != 0;

	if (self.visibilitySetting == kVisibleNowhere && optionDown)
		[self setVisibilitySetting:kVisibleDock];
}

- (void)_transform:(BOOL)foreground
{
	ProcessSerialNumber psn = {0, kCurrentProcess};
	TransformProcessType(&psn, foreground ? kProcessTransformToForegroundApplication : kProcessTransformToUIElementApplication);
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}
@end
