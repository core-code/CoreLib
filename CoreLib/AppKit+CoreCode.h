//
//  AppKit+CoreCode.h
//  CoreLib
//
//  Created by CoreCode on 15.05.11.
/*	Copyright © 2018 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "CoreLib.h"


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSWindow (CoreCode)

// progress with indeterminate bar
- (void)setProgressMessage:(NSString * _Nonnull)message;
- (void)beginProgress:(NSString * _Nonnull)title;
- (void)endProgress;


// progress with determinate bar from 0 to 100 %
- (void)setCountedProgress:(double)progress message:(NSString * _Nonnull)message;
- (void)beginCountedProgress:(NSString * _Nonnull)title;
- (void)endCountedProgress;

// progress with second detail text field
- (void)setExtendedProgressMessage:(NSString * _Nonnull)message;
- (void)setExtendedProgressDetail:(NSString * _Nonnull)detail;
- (void)beginExtendedProgress:(NSString * _Nonnull)title;
- (void)endExtendedProgress:(BOOL)forceForeground;


// borderless windows cant be closed normally
- (IBAction)performBorderlessClose:(id _Nullable)sender;

@end



@interface NSView (CoreCode)

- (nonnull __kindof NSView *)assertedViewWithTag:(NSInteger)tag;

- (NSView * _Nullable)viewWithClass:(Class _Nonnull)classofview;

- (NSArray <NSView *> * _Nonnull)allSubviews;

@end



@interface NSTextField (NSTextField_AutoFontsize)

- (void)adjustFontSize;

@end



@interface NSControl (NSControl_BlockAction)

@property (copy, nonatomic) ObjectInBlock _Nullable actionBlock;

@end



@interface NSTabView (CoreCode)

@property (readonly, nonatomic) NSInteger selectedTabViewIndex;

@end

@interface NSImage (CoreCode)

- (NSImage * _Nullable)resizedImage:(NSSize)newSize;

@end

#else


@interface UIView (UIView_RemoveSubviews)

- (void)removeAllSubviews;

@end
#endif
