//
//  JMVisibilityManager.h
//  CoreLib
//
//  Created by CoreCode on So Jan 20 2013.
/*	Copyright © 2022 CoreCode Limited
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "CoreLib.h"

typedef NS_ENUM(uint8_t, visibilitySettingEnum)
{
	kVisibleNowhere = 0,
	kVisibleDock,
	kVisibleMenubar,
	kVisibleDockAndMenubar
};

typedef NS_ENUM(uint8_t, visibilityOptionEnum)
{
    kStaticVisibility = 0,
    kDynamicVisibilityAddDockIconWhenWindowOpen,
};


typedef NS_ENUM(uint8_t, templateSettingEnum)
{
	kTemplateNever = 0,
	kTemplateWhenDarkMenubar,
	kTemplateAlways
};


CONST_KEY_DECLARATION(VisibilitySettingDidChangeNotification)
CONST_KEY_DECLARATION(VisibilityAlertWindowDidResignNotification)
CONST_KEY_DECLARATION(VisibilityShiftLeftClickNotification)

@interface VisibilityManager : NSObject

@property (assign, nonatomic) templateSettingEnum templateSetting;
@property (assign, nonatomic) visibilitySettingEnum visibilitySetting;
@property (assign, nonatomic) visibilityOptionEnum visibilityOption;
@property (strong, nonatomic) NSImage *dockIcon;
@property (strong, nonatomic) NSImage *menubarIcon;
@property (strong, nonatomic) NSMenu *statusItemMenu;
@property (strong, nonatomic) NSPopover *statusItemPopover;
@property (strong, nonatomic) NSString *menuTooltip;

@property (readonly, nonatomic) NSStatusItem *statusItem;       // shouldn't really be messed with expect things like changing accessibility values on the button
@property (readonly, nonatomic) BOOL permanentlyVisibleInDock;  // true if displaying in dock or displaying in dock and menubar
@property (readonly, nonatomic) BOOL currentlyVisibleInDock; // true if permanetly visible in dock or currently visible because the window is open
@property (readonly, nonatomic) BOOL visibleInMenubar;

- (void)handleAppReopen;
- (void)handleWindowOpened;
- (void)handleWindowClosed;

- (void)hidePopover;
- (void)showPopoverWithAnimation:(BOOL)shouldAnimate;
- (void)_setDebugBit:(unsigned char)bitPosition;

@end
