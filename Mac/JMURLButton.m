//
//  JMURLButton.m
//  CoreLib
//
//  Created by CoreCode on 07/10/2016.
/*	Copyright © 2017 CoreCode Limited
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
        [self.targetURL.URL open];
    else if (self.escapedTargetURL.length)
        [self.escapedTargetURL.escaped.URL open];
    else if (self.resourceURL.length)
        [self.resourceURL.resourceURL open];
    else if (self.fileURL.length)
        [self.fileURL.fileURL open];
    else
        cc_log(@"JMURLButton clicked but no data!");
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    [_targetURL release];
    [_escapedTargetURL release];
    [_resourceURL release];
    [_fileURL release];

    [super dealloc];
}
#endif

@end
