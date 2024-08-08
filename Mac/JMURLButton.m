//
//  JMURLButton.m
//  CoreLib
//
//  Created by CoreCode on 07/10/2016.
/*    Copyright © 2022 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "JMURLButton.h"

@implementation JMURLButton

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
        self.target = self;
        self.action = @selector(buttonClicked:);
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    if ((self = [super initWithCoder:coder]))
    {
        self.target = self;
        self.action = @selector(buttonClicked:);
    }
    return self;
}

- (void)buttonClicked:(NSButton *)button
{
    if (self.targetURL.length)
    {
        NSString *url = self.targetURL;
        if ([url containsString:@" "])
            url = url.escaped;
        [url.URL open];
    }
    else if (self.escapedTargetURL.length)
        [self.escapedTargetURL.escaped.URL open];
    else if (self.resourceURL.length)
        [self.resourceURL.resourceURL open];
    else if (self.fileURL.length)
        [self.fileURL.fileURL open];
    else
        cc_log(@"JMURLButton clicked but no data!");
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];

    [menu addItem:[[NSMenuItem alloc] initWithTitle:@"Show URL in Tooltip".localized action:@selector(showClicked:) keyEquivalent:@""]];
    [menu addItem:[[NSMenuItem alloc] initWithTitle:@"Open URL in Browser".localized action:@selector(buttonClicked:) keyEquivalent:@""]];
    [menu addItem:[[NSMenuItem alloc] initWithTitle:@"Copy URL to Clipboard".localized action:@selector(copyClicked:) keyEquivalent:@""]];
    
    [NSMenu popUpContextMenu:menu withEvent:theEvent forView:self];
    
}

- (void)showClicked:(id)sender
{
    [NSHelpManager.sharedHelpManager setContextHelp:[[NSAttributedString alloc] initWithString:NON_NIL_STR(self.targetURL)] forObject:self];
    [NSHelpManager.sharedHelpManager showContextHelpForObject:self locationHint:NSEvent.mouseLocation];
    [NSHelpManager.sharedHelpManager removeContextHelpForObject:self];
}

- (void)copyClicked:(id)sender
{
    [NSPasteboard.generalPasteboard declareTypes:@[NSPasteboardTypeString] owner:nil];
    [NSPasteboard.generalPasteboard setString:self.targetURL forType:NSPasteboardTypeString];
}
@end
