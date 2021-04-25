//
//  JMVisibilityManager.m
//  CoreLib
//
//  Created by CoreCode on So Jan 20 2013.
/*    Copyright © 2021 CoreCode Limited
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
CONST_KEY_IMPLEMENTATION(VisibilityAlertWindowDidResignNotification)
CONST_KEY_IMPLEMENTATION(VisibilityShiftLeftClickNotification)


@interface VisibilityManager ()
{
    visibilitySettingEnum _visibilitySetting;
    visibilityOptionEnum _visibilityOption;
    NSImage *_dockIcon;
    NSImage *_menubarIcon;
    BOOL _windowIsOpen;
    BOOL _dockIconIsCurrentlyVisible;
}

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) id globalEventMonitor;
@property (strong, nonatomic) id localEventMonitor;
@property (strong, nonatomic) id activeSpaceChangeObserver;
@end



@implementation VisibilityManager

@dynamic visibilitySetting, visibilityOption, dockIcon, menubarIcon, menuTooltip, currentlyVisibleInDock, permanentlyVisibleInDock, visibleInMenubar;

    
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

- (void)dealloc
{
    if (self.localEventMonitor)
    {
        [NSEvent removeMonitor:self.localEventMonitor];
    }
    if (self.globalEventMonitor)
    {
        [NSEvent removeMonitor:self.globalEventMonitor];
    }
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
    if (_dockIconIsCurrentlyVisible && ![self currentlyVisibleInDock])
        [self _transform:NO];
    else if (!_dockIconIsCurrentlyVisible && [self currentlyVisibleInDock])
        [self _transform:YES];
}
    
- (void)setVisibilityOption:(visibilityOptionEnum)newOption
{
    _visibilityOption = newOption;

    [self _redisplay];
    

    kJMVisibilityManagerOptionValueKey.defaultInt = newOption;
    [NSUserDefaults.standardUserDefaults synchronize];

    [notificationCenter postNotificationName:kVisibilitySettingDidChangeNotificationKey object:self];
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

- (BOOL)permanentlyVisibleInDock
{
    return ((_visibilitySetting == kVisibleDock) || (_visibilitySetting == kVisibleDockAndMenubar));
}

- (BOOL)currentlyVisibleInDock
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

    if ([self currentlyVisibleInDock] && _dockIcon)
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
            self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
            self.statusItem.button.enabled = YES;
            self.statusItem.button.target = nil;
            self.statusItem.button.action = nil;
        }
        
        if (self.statusItemPopover)
        {
            if (self.activeSpaceChangeObserver)
            {
                [NSNotificationCenter.defaultCenter removeObserver:self.activeSpaceChangeObserver];
            }
            [NSWorkspace.sharedWorkspace.notificationCenter addObserverForName:NSWorkspaceActiveSpaceDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note)
            {
                [self hidePopover];
            }];
            self.statusItem.menu = nil;
            if (self.statusItemPopover.isShown)
            {
                dispatch_after_main(0.25f, ^
                {
                    NSView *buttonView = (NSView *)self.statusItem.button;
                    if (buttonView)
                        [self.statusItemPopover showRelativeToRect:[buttonView bounds] ofView:buttonView preferredEdge:NSRectEdgeMaxY];
                    else
                        assert_custom(buttonView);
                });
            }
            // If statusItem.button is clicked, show/hide popup.
            // If some other part of the app is clicked, hide the popup.
            if (!self.localEventMonitor)
            {
                enum NSEventMask monitorMask = NSEventMaskLeftMouseDown | NSEventMaskRightMouseDown | NSEventMaskKeyDown;
                self.localEventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:monitorMask handler:^NSEvent *(NSEvent *event)
                {
                    // We want to show statusMenu if the user option clicks
                    BOOL gotCommandKey = (event.modifierFlags & NSEventModifierFlagCommand) == NSEventModifierFlagCommand;
                    BOOL gotOptionKey = (event.modifierFlags & NSEventModifierFlagOption) == NSEventModifierFlagOption;
                    BOOL gotRightClick = event.type == NSEventTypeRightMouseDown;
                    BOOL gotLeftClick = event.type == NSEventTypeLeftMouseDown;
                    BOOL gotShiftClick = (event.modifierFlags & NSEventModifierFlagShift) ? YES : NO;
                    
                    if (gotLeftClick && gotCommandKey) // let the system handle re-arrangement of the icon
                        return event;
                    
                    if (event.window == self.statusItem.button.window && gotLeftClick && gotShiftClick)
                    {
                        // Highligting the button, even if for a split second, lets the user know
                        // their click was detected by the app.
                        [self.statusItem.button highlight:YES];
                        dispatch_after_main(0.1f, ^
                        {
                            [self.statusItem.button highlight:NO];
                            dispatch_after_main(0.2f, ^
                            {
                                [NSNotificationCenter.defaultCenter postNotificationName:kVisibilityShiftLeftClickNotificationKey object:nil userInfo:nil];
                            });
                        });
                        return nil;
                    }
                    
                    if (event.window == self.statusItem.button.window && (gotOptionKey || gotRightClick))
                    {
                        [self.statusItem.button highlight:YES];
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        [self.statusItem popUpStatusItemMenu:self.statusItemMenu];
                    #pragma clang diagnostic pop
                        [self.statusItem.button highlight:NO];
                        return nil;
                    }
                    // If the popover is currently shown, then let the popover handle all the clicks (pass on the event as is)
                    if ((gotLeftClick || gotRightClick) && self.statusItemPopover)
                    {
                        if (self.statusItemPopover.isShown && event.window == self.statusItemPopover.contentViewController.view.window)
                        {
                            return event;
                        }
                    }
                    // If the button got a click and the popover is hidden, show it
                    if (event.window == self.statusItem.button.window && !self.statusItemPopover.isShown)
                    {
                        [self showPopoverWithAnimation:NO];
                        dispatch_after_main(0.75, ^
                        {
                            self.statusItemPopover.contentViewController.view.window.collectionBehavior = NSWindowCollectionBehaviorParticipatesInCycle;
                        });
                        // Returning a nil signifies that we've consumed this event.
                        // This has the side effect of avoiding the obnoxious NSBeep sound.
                        return nil;
                    }
                    // If the popover is currently hidden and the click was in some other window in this app itself,
                    // pass it on as it is so that the particular window / UI element can process it.
                    if ((gotLeftClick || gotRightClick) && self.statusItemPopover)
                    {
                        if (!self.statusItemPopover.isShown && event.window != self.statusItemPopover.contentViewController.view.window)
                            return event;
                    }
                    // If we got a keystroke other than ESC, pass it on as it is, so that other UI elements can process it.
                    if (event.type == NSEventTypeKeyDown && event.keyCode != 53)
                    {
                        return event;
                    }

                    Class c = event.window.class;
                    if (c == NSPanel.class || c == FakeAlertWindow.class || [NSStringFromClass(c) isEqualToString:@"_NSAlertPanel"])
                    {
                        __weak NSNotificationCenter *center = NSNotificationCenter.defaultCenter;
                        __block id token = [center addObserverForName:NSWindowDidResignKeyNotification
                                                               object:event.window
                                                                queue:[NSOperationQueue mainQueue]
                                                           usingBlock:^(NSNotification *note)
                        {
                            [center postNotificationName:kVisibilityAlertWindowDidResignNotificationKey object:nil userInfo:nil];
                            [center removeObserver:token];
                        }];
                        
                        return event;
                    }
                    // We're about to close the popover because all any circumstances under which we'd
                    // keep the popup open were unfulfilled. Tear down the global event monitor that we'd
                    // setup to detect clicks on external apps.
                    if (self.globalEventMonitor)
                    {
                        [NSEvent removeMonitor:self.globalEventMonitor];
                        self.globalEventMonitor = nil;
                    }
                    // Close popup and remove highlight
                    [self.statusItemPopover close];
                    [self.statusItem.button highlight:NO];
                    // Returning a nil signifies that we've consumed this event.
                    // This has the side effect of avoiding the obnoxious NSBeep sound.
                    return nil;
                }];
            }
        }
        else
        {
            self.statusItem.menu = self.statusItemMenu;
        }
        self.statusItem.button.image = _menubarIcon;
    }
    else
    {
        if (self.statusItem)
        {
            [NSStatusBar.systemStatusBar removeStatusItem:_statusItem];
            _statusItem = nil;
        }
    }
}

- (void)hidePopover
{
    if (self.statusItemPopover && self.self.statusItemPopover.isShown)
    {
        [self.statusItemPopover close];
        [self.statusItem.button highlight:NO];
    }
}

- (void)showPopoverWithAnimation:(BOOL)shouldAnimate
{
    if (self.statusItemPopover && !self.statusItemPopover.isShown)
    {
        [self.statusItem.button highlight:YES];
        self.statusItemPopover.animates = shouldAnimate;
        
        NSView *buttonView = (NSView *)self.statusItem.button;
        NSRect buttonBounds = buttonView.bounds;
        
        if (buttonView)
        {
    //        cc_log(@"showing popover relative to bounds %@", NSStringFromRect(buttonBounds) );
            
            // I'm getting a weird bug wherein, if the statusitem icon is changed more than once,
            // the popover shows up and then slightly slides down a pixel when the user clicks on
            // statusitem button. The second showRelativeToRect:ofView:preferredEdge: fixs it (!).
            [self.statusItemPopover showRelativeToRect:buttonBounds ofView:buttonView preferredEdge:NSRectEdgeMaxY];
            [self.statusItemPopover showRelativeToRect:buttonBounds ofView:buttonView preferredEdge:NSRectEdgeMaxY];
            // Setup a global event monitor to detect outside clicks so we can dismiss this popup
            if (self.globalEventMonitor)
            {
                [NSEvent removeMonitor:self.globalEventMonitor];
                self.globalEventMonitor = nil;
            }
            enum NSEventMask globalMonitorMask = NSEventMaskLeftMouseUp | NSEventMaskLeftMouseDown;
            self.globalEventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:globalMonitorMask handler:^(NSEvent *_event)
            {
                [self.statusItemPopover close];
                [self.statusItem.button highlight:NO];
                // We want to tear down the global monitor right after the first
                // outside click is detected and the popover is hidden.
                if (self.globalEventMonitor)
                {
                    [NSEvent removeMonitor:self.globalEventMonitor];
                    self.globalEventMonitor = nil;
                }
            }];
            
            // hack https://stackoverflow.com/questions/34913405/how-do-i-prevent-the-menu-bar-from-moving-down-when-my-popover-is-open
            NSWindow *popoverWindow = self.statusItemPopover.contentViewController.view.window;
            [popoverWindow.parentWindow removeChildWindow:popoverWindow];
        }
        else
            assert_custom(buttonView);
    }
}

- (NSImage *)menubarIcon
{
    return _menubarIcon;
}

- (void)setMenuTooltip:(NSString *)menuTooltip
{
    _statusItem.button.toolTip = menuTooltip;
}

- (NSString *)menuTooltip
{
    return _statusItem.button.toolTip;
}

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
    dispatch_after_main(0.1f,^{[NSApplication.sharedApplication activateIgnoringOtherApps:YES];});
    _dockIconIsCurrentlyVisible = foreground;
}
#pragma GCC diagnostic pop
@end
