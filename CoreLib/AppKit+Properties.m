//
//  AppKit+Properties.m
//  CoreLib
//
//  Created by CoreCode on 09.02.14.
/*	Copyright (c) 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "AppKit+Properties.h"

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@implementation NSControl (Properties)

@dynamic stringValue, intValue, floatValue, doubleValue, tag, action, target;

@end


@implementation NSCell (Properties)

@dynamic acceptsFirstResponder,allowsEditingTextAttributes,allowsUndo,importsGraphics,refusesFirstResponder,sendsActionOnEndEditing,wraps,truncatesLastVisibleLine,usesSingleLineMode,doubleValue,floatValue,objectValue,representedObject,target,intValue,attributedStringValue,backgroundStyle,type,controlTint,focusRingType,font,image,state,tag,integerValue,lineBreakMode,menu,keyEquivalent,stringValue,title,alignment,userInterfaceLayoutDirection,controlView,baseWritingDirection,action, bezeled, bordered, continuous, editable, enabled, highlighted, scrollable, selectable;

@end


@implementation NSButton (Properties)

@dynamic allowsMixedState,attributedAlternateTitle,attributedTitle,imagePosition,alternateImage,image,state,sound,alternateTitle,keyEquivalent,title,keyEquivalentModifierMask;

@end


@implementation NSTableView (Properties)

@dynamic allowsColumnReordering,allowsColumnResizing,allowsColumnSelection,allowsEmptySelection,allowsMultipleSelection,autosaveTableColumns,usesAlternatingRowBackgroundColors,verticalMotionCanBeginDrag,allowsTypeSelect,floatsGroupRows,rowHeight,dataSource,delegate,sortDescriptors,backgroundColor,gridColor,intercellSpacing,autosaveName,highlightedTableColumn,headerView,columnAutoresizingStyle,draggingDestinationFeedbackStyle,gridStyleMask,rowSizeStyle,selectionHighlightStyle,cornerView,doubleAction;

@end


@implementation NSTableColumn (Properties)

@dynamic editable,hidden,resizable,maxWidth,minWidth,width,dataCell,headerCell,sortDescriptorPrototype,identifier,headerToolTip,tableView,resizingMask;

@end


@implementation NSTextFieldCell (Properties)

@dynamic backgroundColor, drawsBackground, textColor, bezelStyle, placeholderString, placeholderAttributedString;

@end


@implementation NSView (Properties)

@dynamic autoresizesSubviews,canDraw,needsDisplay,postsBoundsChangedNotifications,postsFrameChangedNotifications,acceptsTouchEvents,canDrawSubviewsIntoLayer,layerUsesCoreImageFilters,wantsLayer,wantsRestingTouches,layer,boundsRotation,frameRotation,alphaValue,compositingFilter,backgroundFilters,contentFilters,focusRingType,frame,shadow,toolTip,userInterfaceLayoutDirection,nextKeyView,opaqueAncestor,layerContentsPlacement,layerContentsRedrawPolicy,tag,bounds,isFlipped,isRotatedFromBase,isRotatedOrScaledFromBase,window,superview,subviews,isOpaque;

@end


@implementation NSEvent (Properties)

@dynamic hasPreciseScrollingDeltas,isARepeat,isDirectionInvertedFromDevice,isEnteringProximity,CGEvent,deltaX,deltaY,deltaZ,magnification,scrollingDeltaX,scrollingDeltaY,pressure,rotation,tangentialPressure,vendorDefined,momentumPhase,phase,type,context,absoluteX,absoluteY,absoluteZ,buttonNumber,clickCount,data1,data2,eventNumber,trackingNumber,windowNumber,locationInWindow,tilt,pointingDeviceType,characters,charactersIgnoringModifiers,timestamp,trackingArea,buttonMask,capabilityMask,deviceID,modifierFlags,pointingDeviceID,pointingDeviceSerialNumber,systemTabletID,tabletID,vendorID,vendorPointingDeviceType,window,subtype,uniqueID,keyCode;
@end


@implementation NSSegmentedControl (Properties)

@dynamic segmentCount, selectedSegment, segmentStyle;

@end


@implementation NSToolbarItem (Properties)

@dynamic itemIdentifier, toolbar, allowsDuplicatesInToolbar, label, paletteLabel, toolTip, menuFormRepresentation, tag, target, action, enabled, image, view, minSize, maxSize, visibilityPriority, autovalidates;


@end
#endif

