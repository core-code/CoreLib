//
//  AppKit+CoreCode.h
//  CoreLib
//
//  Created by CoreCode on 09.02.14.
/*	Copyright (c) 2012 - 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "CoreLib.h"


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSControl (CoreCode)

// properties for implemented methods
@property (copy, nonatomic) NSString *stringValue;
@property (assign, nonatomic) id target;
@property (assign, nonatomic) SEL action;
@property (assign, nonatomic) int intValue;
@property (assign, nonatomic) float floatValue;
@property (assign, nonatomic) double doubleValue;
@property (assign, nonatomic) NSInteger tag;

@end


@interface NSCell (CoreCode)

// properties for implemented methods
@property (assign, nonatomic) BOOL acceptsFirstResponder;
@property (assign, nonatomic) BOOL allowsEditingTextAttributes;
@property (assign, nonatomic) BOOL allowsUndo;
@property (assign, nonatomic) BOOL importsGraphics;
@property (assign, nonatomic, getter=isBezeled) BOOL bezeled;
@property (assign, nonatomic, getter=isBordered) BOOL bordered;
@property (assign, nonatomic, getter=isContinuous) BOOL continuous;
@property (assign, nonatomic, getter=isEditable) BOOL editable;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (assign, nonatomic, getter=isHighlighted) BOOL highlighted;
@property (assign, nonatomic, getter=isScrollable) BOOL scrollable;
@property (assign, nonatomic, getter=isSelectable) BOOL selectable;
@property (assign, nonatomic) BOOL refusesFirstResponder;
@property (assign, nonatomic) BOOL sendsActionOnEndEditing;
@property (assign, nonatomic) BOOL wraps;
@property (assign, nonatomic) BOOL truncatesLastVisibleLine;
@property (assign, nonatomic) BOOL usesSingleLineMode;
@property (assign, nonatomic) double doubleValue;
@property (assign, nonatomic) float floatValue;
@property (assign, nonatomic) id objectValue;
@property (assign, nonatomic) id representedObject;
@property (assign, nonatomic) id target;
@property (assign, nonatomic) int intValue;
@property (copy, nonatomic) NSAttributedString *attributedStringValue;
@property (assign, nonatomic) NSBackgroundStyle backgroundStyle;
@property (assign, nonatomic) NSCellType type;
@property (assign, nonatomic) NSControlTint controlTint;
@property (assign, nonatomic) NSFocusRingType focusRingType;
@property (strong, nonatomic) NSFont *font;
@property (strong, nonatomic) NSImage *image;
@property (assign, nonatomic) NSInteger state;
@property (assign, nonatomic) NSInteger tag;
@property (assign, nonatomic) NSInteger integerValue;
@property (assign, nonatomic) NSLineBreakMode lineBreakMode;
@property (strong, nonatomic) NSMenu *menu;
@property (copy, nonatomic) NSString *keyEquivalent;
@property (copy, nonatomic) NSString *stringValue;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSTextAlignment alignment;
@property (assign, nonatomic) NSUserInterfaceLayoutDirection userInterfaceLayoutDirection;
@property (strong, nonatomic) NSView *controlView;
@property (assign, nonatomic) NSWritingDirection baseWritingDirection;
@property (assign, nonatomic) SEL action;

@end


@interface NSButton (CoreCode)

// properties for implemented methods

@property (assign, nonatomic) BOOL allowsMixedState;
@property (copy, nonatomic) NSAttributedString * attributedAlternateTitle;
@property (copy, nonatomic) NSAttributedString * attributedTitle;
@property (assign, nonatomic) NSCellImagePosition imagePosition;
@property (strong, nonatomic) NSImage * alternateImage;
@property (strong, nonatomic) NSImage * image;
@property (assign, nonatomic) NSInteger state;
@property (strong, nonatomic) NSSound * sound;
@property (copy, nonatomic) NSString * alternateTitle;
@property (copy, nonatomic) NSString * keyEquivalent;
@property (copy, nonatomic) NSString * title;
@property (assign, nonatomic) NSUInteger keyEquivalentModifierMask;

@end


@interface NSTableView (CoreCode)

// properties for implemented methods

@property (readonly, nonatomic) NSInteger numberOfColumns;
@property (readonly, nonatomic) NSInteger numberOfRows;
@property (readonly, nonatomic) NSArray *tableColumns;
@property (assign, nonatomic) BOOL allowsColumnReordering;
@property (assign, nonatomic) BOOL allowsColumnResizing;
@property (assign, nonatomic) BOOL allowsColumnSelection;
@property (assign, nonatomic) BOOL allowsEmptySelection;
@property (assign, nonatomic) BOOL allowsMultipleSelection;
@property (assign, nonatomic) BOOL autosaveTableColumns;
@property (assign, nonatomic) BOOL usesAlternatingRowBackgroundColors;
@property (assign, nonatomic) BOOL verticalMotionCanBeginDrag;
@property (assign, nonatomic) BOOL allowsTypeSelect;
@property (assign, nonatomic) BOOL floatsGroupRows;
@property (assign, nonatomic) CGFloat rowHeight;
@property (assign, nonatomic) id <NSTableViewDataSource> dataSource;
@property (assign, nonatomic) id <NSTableViewDelegate> delegate;
@property (strong, nonatomic) NSArray * sortDescriptors;
@property (strong, nonatomic) NSColor * backgroundColor;
@property (strong, nonatomic) NSColor * gridColor;
@property (assign, nonatomic) NSSize intercellSpacing;
@property (copy, nonatomic) NSString * autosaveName;
@property (strong, nonatomic) NSTableColumn * highlightedTableColumn;
@property (strong, nonatomic) NSTableHeaderView * headerView;
@property (assign, nonatomic) NSTableViewColumnAutoresizingStyle columnAutoresizingStyle;
@property (assign, nonatomic) NSTableViewDraggingDestinationFeedbackStyle draggingDestinationFeedbackStyle;
@property (assign, nonatomic) NSTableViewGridLineStyle gridStyleMask;
@property (assign, nonatomic) NSTableViewRowSizeStyle rowSizeStyle;
@property (assign, nonatomic) NSTableViewSelectionHighlightStyle selectionHighlightStyle;
@property (strong, nonatomic) NSView * cornerView;
@property (assign, nonatomic) SEL doubleAction;


@end


@interface NSTableColumn (CoreCode)

// properties for implemented methods

@property (assign, nonatomic, getter=isEditable) BOOL editable;
@property (assign, nonatomic, getter=isHidden) BOOL hidden;
@property (assign, nonatomic, getter=isResizable) BOOL resizable;
@property (assign, nonatomic) CGFloat maxWidth;
@property (assign, nonatomic) CGFloat minWidth;
@property (assign, nonatomic) CGFloat width;
@property (strong, nonatomic) NSCell * dataCell;
@property (strong, nonatomic) NSTableHeaderCell * headerCell;
@property (strong, nonatomic) NSSortDescriptor * sortDescriptorPrototype;
@property (copy, nonatomic) NSString * identifier;
@property (copy, nonatomic) NSString * headerToolTip;
@property (strong, nonatomic) NSTableView * tableView;
@property (assign, nonatomic) NSUInteger resizingMask;

@end


@interface NSTextFieldCell (CoreCode)

// properties for implemented methods

@property (strong, nonatomic) NSColor * backgroundColor;
@property (assign, nonatomic) BOOL drawsBackground;
@property (strong, nonatomic) NSColor * textColor;
@property (assign, nonatomic) NSTextFieldBezelStyle bezelStyle;
@property (copy, nonatomic) NSString * placeholderString;
@property (copy, nonatomic) NSAttributedString * placeholderAttributedString;

@end


@interface NSView (CoreCode)

// properties for implemented methods

@property (assign, nonatomic) BOOL autoresizesSubviews;
@property (assign, nonatomic) BOOL canDraw;
@property (assign, nonatomic) BOOL needsDisplay;
@property (assign, nonatomic) BOOL postsBoundsChangedNotifications;
@property (assign, nonatomic) BOOL postsFrameChangedNotifications;
@property (assign, nonatomic) BOOL acceptsTouchEvents;
@property (assign, nonatomic) BOOL canDrawSubviewsIntoLayer;
@property (assign, nonatomic) BOOL layerUsesCoreImageFilters;
@property (assign, nonatomic) BOOL wantsLayer;
@property (assign, nonatomic) BOOL wantsRestingTouches;
@property (strong, nonatomic) CALayer * layer;
@property (assign, nonatomic) CGFloat boundsRotation;
@property (assign, nonatomic) CGFloat frameRotation;
@property (assign, nonatomic) CGFloat alphaValue;
@property (strong, nonatomic) CIFilter * compositingFilter;
@property (copy, nonatomic) NSArray * backgroundFilters;
@property (copy, nonatomic) NSArray * contentFilters;
@property (assign, nonatomic) NSFocusRingType focusRingType;
@property (assign, nonatomic) NSRect frame;
@property (strong, nonatomic) NSShadow * shadow;
@property (copy, nonatomic) NSString * toolTip;
@property (assign, nonatomic) NSUserInterfaceLayoutDirection userInterfaceLayoutDirection;
@property (strong, nonatomic) NSView * nextKeyView;
@property (strong, nonatomic) NSView * opaqueAncestor;
@property (assign, nonatomic) NSViewLayerContentsPlacement layerContentsPlacement;
@property (assign, nonatomic) NSViewLayerContentsRedrawPolicy layerContentsRedrawPolicy;

@property (readonly, nonatomic) NSInteger tag;
@property (readonly, nonatomic) NSRect bounds;
@property (readonly, nonatomic) BOOL isFlipped;
@property (readonly, nonatomic) BOOL isRotatedFromBase;
@property (readonly, nonatomic) BOOL isRotatedOrScaledFromBase;
@property (readonly, nonatomic) NSWindow * window;
@property (readonly, nonatomic) NSView * superview;
@property (readonly, nonatomic) NSArray * subviews;
@property (readonly, nonatomic) BOOL isOpaque;


@end


@interface NSEvent (CoreCode)

// properties for implemented methods

@property (readonly, nonatomic) BOOL hasPreciseScrollingDeltas;
@property (readonly, nonatomic) BOOL isARepeat;
@property (readonly, nonatomic) BOOL isDirectionInvertedFromDevice;
@property (readonly, nonatomic) BOOL isEnteringProximity;
@property (readonly, nonatomic) CGEventRef CGEvent;
@property (readonly, nonatomic) CGFloat deltaX;
@property (readonly, nonatomic) CGFloat deltaY;
@property (readonly, nonatomic) CGFloat deltaZ;
@property (readonly, nonatomic) CGFloat magnification;
@property (readonly, nonatomic) CGFloat scrollingDeltaX;
@property (readonly, nonatomic) CGFloat scrollingDeltaY;
@property (readonly, nonatomic) float pressure;
@property (readonly, nonatomic) float rotation;
@property (readonly, nonatomic) float tangentialPressure;
@property (readonly, nonatomic) id vendorDefined;
@property (readonly, nonatomic) NSEventPhase momentumPhase;
@property (readonly, nonatomic) NSEventPhase phase;
@property (readonly, nonatomic) NSEventType type;
@property (readonly, nonatomic) NSGraphicsContext* context;
@property (readonly, nonatomic) NSInteger absoluteX;
@property (readonly, nonatomic) NSInteger absoluteY;
@property (readonly, nonatomic) NSInteger absoluteZ;
@property (readonly, nonatomic) NSInteger buttonNumber;
@property (readonly, nonatomic) NSInteger clickCount;
@property (readonly, nonatomic) NSInteger data1;
@property (readonly, nonatomic) NSInteger data2;
@property (readonly, nonatomic) NSInteger eventNumber;
@property (readonly, nonatomic) NSInteger trackingNumber;
@property (readonly, nonatomic) NSInteger windowNumber;
@property (readonly, nonatomic) NSPoint locationInWindow;
@property (readonly, nonatomic) NSPoint tilt;
@property (readonly, nonatomic) NSPointingDeviceType pointingDeviceType;
@property (readonly, nonatomic) NSString * characters;
@property (readonly, nonatomic) NSString * charactersIgnoringModifiers;
@property (readonly, nonatomic) NSTimeInterval timestamp;
@property (readonly, nonatomic) NSTrackingArea * trackingArea;
@property (readonly, nonatomic) NSUInteger buttonMask;
@property (readonly, nonatomic) NSUInteger capabilityMask;
@property (readonly, nonatomic) NSUInteger deviceID;
@property (readonly, nonatomic) NSUInteger modifierFlags;
@property (readonly, nonatomic) NSUInteger pointingDeviceID;
@property (readonly, nonatomic) NSUInteger pointingDeviceSerialNumber;
@property (readonly, nonatomic) NSUInteger systemTabletID;
@property (readonly, nonatomic) NSUInteger tabletID;
@property (readonly, nonatomic) NSUInteger vendorID;
@property (readonly, nonatomic) NSUInteger vendorPointingDeviceType;
@property (readonly, nonatomic) NSWindow * window;
@property (readonly, nonatomic) short subtype;
@property (readonly, nonatomic) unsigned long long uniqueID;
@property (readonly, nonatomic) unsigned short keyCode;

@end


@interface NSSegmentedControl (CoreCode)

@property (assign, nonatomic) NSInteger segmentCount;
@property (assign, nonatomic) NSInteger selectedSegment;
@property (assign, nonatomic) NSSegmentStyle segmentStyle;

@end


@interface NSToolbarItem (CoreCode)

@property (readonly, nonatomic) NSString *itemIdentifier;
@property (readonly, nonatomic) NSToolbar *toolbar;
@property (readonly, nonatomic) BOOL allowsDuplicatesInToolbar;
@property (copy, nonatomic) NSString *label;
@property (copy, nonatomic) NSString *paletteLabel;
@property (copy, nonatomic) NSString *toolTip;
@property (strong, nonatomic) NSMenuItem *menuFormRepresentation;
@property (assign, nonatomic) NSInteger tag;
@property (assign, nonatomic) id target;
@property (assign, nonatomic) SEL action;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (strong, nonatomic) NSImage *image;
@property (strong, nonatomic) NSView *view;
@property (assign, nonatomic) NSSize minSize;
@property (assign, nonatomic) NSSize maxSize;
@property (assign, nonatomic) NSInteger visibilityPriority;
@property (assign, nonatomic) BOOL autovalidates;

@end
#endif
