//
//  JMVisibilityManager.m
//  CoreLib
//
//  Created by CoreCode on So Jan 20 2013.
/*    Copyright © 2019 CoreCode Limited
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
CONST_KEY(JMVisibilityManagerOptionValue)
CONST_KEY_IMPLEMENTATION(VisibilitySettingDidChangeNotification)



@interface VisibilityManager ()
{
    visibilitySettingEnum _visibilitySetting;
    visibilityOptionEnum _visibilityOption;
    NSImage *_dockIcon;
    NSImage *_menubarIcon;
    BOOL _windowIsOpen;
    BOOL _currentlyVisibleInDock;
}

@property (strong, nonatomic) NSStatusItem *statusItem;

@end



@implementation VisibilityManager

@dynamic visibilitySetting, visibilityOption, dockIcon, menubarIcon, menuTooltip, visibleInDock, visibleInMenubar;

    
+ (void)initialize
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];

    defaultValues[kJMVisibilityManagerValueKey] = @(kVisibleDock);

    [NSUserDefaults.standardUserDefaults registerDefaults:defaultValues];
}

- (instancetype)init
{
    if ((self = [super init]))
    {
#ifdef DEBUG
        assert([(NSString *)[NSBundle.mainBundle objectForInfoDictionaryKey:@"LSUIElement"] boolValue]);
#endif
        
        _visibilitySetting = kVisibleNowhere;
        _templateSetting = kTemplateNever;
        _visibilityOption = (visibilityOptionEnum) kJMVisibilityManagerOptionValueKey.defaultInt;

        BOOL optionDown = ([NSEvent modifierFlags] & NSEventModifierFlagOption) != 0;
        visibilitySettingEnum storedSetting = (visibilitySettingEnum) kJMVisibilityManagerValueKey.defaultInt;

        if (storedSetting == kVisibleNowhere && optionDown)
            self.visibilitySetting = kVisibleDock;
        else
            self.visibilitySetting = storedSetting;
        
    }

    return self;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdirect-ivar-access"

- (void)_redisplay
{
    [self _showOrHideDockIcon];
    
    self.menubarIcon = _menubarIcon;
    self.dockIcon = _dockIcon;
}
    
- (void)_showOrHideDockIcon
{
    if (_currentlyVisibleInDock && ![self visibleInDock])
        [self _transform:NO];
    else if (!_currentlyVisibleInDock && [self visibleInDock])
        [self _transform:YES];
}
    
- (void)setVisibilityOption:(visibilityOptionEnum)newOption
{
    _visibilityOption = newOption;

    [self _redisplay];
    

    kJMVisibilityManagerOptionValueKey.defaultInt = newOption;
    [NSUserDefaults.standardUserDefaults synchronize];
}
    
- (visibilityOptionEnum)visibilityOption
{
    return _visibilityOption;
}
    
- (void)setVisibilitySetting:(visibilitySettingEnum)newSetting
{
    //[self willChangeValueForKey:@"visibilitySetting"];
    _visibilitySetting = newSetting;
    //[self didChangeValueForKey:@"visibilitySetting"];

    [self _redisplay];

    kJMVisibilityManagerValueKey.defaultInt = newSetting;
    [NSUserDefaults.standardUserDefaults synchronize];
    
    [notificationCenter postNotificationName:kVisibilitySettingDidChangeNotificationKey object:self];
}

- (visibilitySettingEnum)visibilitySetting
{
    return _visibilitySetting;
}

- (BOOL)visibleInDock
{
    return ((_visibilitySetting == kVisibleDock) ||
            (_visibilitySetting == kVisibleDockAndMenubar) ||
            ((_visibilitySetting == kVisibleMenubar) &&  (_visibilityOption == kDynamicVisibilityAddDockIconWhenWindowOpen) && _windowIsOpen));
}

- (BOOL)visibleInMenubar
{
    BOOL visible = ((_visibilitySetting == kVisibleMenubar) || (_visibilitySetting == kVisibleDockAndMenubar));
    
    return visible;
}
    
    

- (void)setDockIcon:(NSImage *)newDockIcon
{
    _dockIcon = newDockIcon;

    if ([self visibleInDock] && _dockIcon)
        NSApp.applicationIconImage = _dockIcon;
}

- (NSImage *)dockIcon
{
    return _dockIcon;
}

- (void)setMenubarIcon:(NSImage *)newMenubarIcon
{
    if ((self.templateSetting == kTemplateAlways) ||
        ((self.templateSetting == kTemplateWhenDarkMenubar) && [[NSAppearance currentAppearance].name contains:@"NSAppearanceNameVibrantDark"]))
        newMenubarIcon.template = YES;
    else
        newMenubarIcon.template = NO;

    _menubarIcon = newMenubarIcon;
    
    if ([self visibleInMenubar])
    {
        if (self.statusItem == nil)
        {
            self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

            [self.statusItem setHighlightMode:YES];
            [self.statusItem setEnabled:YES];
        }
        
        (self.statusItem).menu = self.statusItemMenu;
        (self.statusItem).image = _menubarIcon;
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
    _statusItem.toolTip = menuTooltip;
}

- (NSString *)menuTooltip
{
    return _statusItem.toolTip;
}
#pragma GCC diagnostic pop

- (void)handleAppReopen
{
    BOOL optionDown = ([NSEvent modifierFlags] & NSEventModifierFlagOption) != 0;

    if (self.visibilitySetting == kVisibleNowhere && optionDown)
        self.visibilitySetting = kVisibleDock;
}
    
- (void)handleWindowOpened
{
    _windowIsOpen = YES;
    [self _redisplay];
}
    
- (void)handleWindowClosed
{
    _windowIsOpen = NO;
    [self _redisplay];
}
    
    
    
- (void)_transform:(BOOL)foreground
{
    ProcessSerialNumber psn = {0, kCurrentProcess};
    TransformProcessType(&psn, foreground ? kProcessTransformToForegroundApplication : kProcessTransformToUIElementApplication);
    [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
    _currentlyVisibleInDock = foreground;
}
@end
