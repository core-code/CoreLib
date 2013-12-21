//
//  JMActionSheet.m
//  CoreLib
//
//  Created by CoreCode on 03.12.11.
/*	Copyright (c) 2011 - 2013 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "JMActionSheet.h"

@implementation JMActionSheet

@synthesize cancelBlock, alternativeBlock, destructiveBlock;

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    [self setDelegate:self];
    [super showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
    [self setDelegate:self];
    [super showFromRect:rect inView:view animated:animated ];
}

- (void)showFromTabBar:(UITabBar *)view
{
    [self setDelegate:self];
    [super showFromTabBar:view];
}

- (void)showFromToolbar:(UIToolbar *)view
{
    [self setDelegate:self];
    [super showFromToolbar:view];
}

- (void)showInView:(UIView *)view
{
    [self setDelegate:self];
    [super showInView:view];
}

#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [self cancelButtonIndex])
    {
        if (self.cancelBlock)
            self.cancelBlock();
    }
    else if (buttonIndex == [self destructiveButtonIndex])
    {
        if (self.destructiveBlock)
            self.destructiveBlock();
    }
    else if (buttonIndex >= [self firstOtherButtonIndex])
    {
        if (self.alternativeBlock)
		{
             int sub = [self firstOtherButtonIndex] >= 0 ? (int)[self firstOtherButtonIndex] : (([self destructiveButtonIndex] != -1) + ([self cancelButtonIndex] != -1));
             self.alternativeBlock((int)buttonIndex - sub);
		}
    }
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    [destructiveBlock release];
    [cancelBlock release];
    [alternativeBlock release];
    
    [super dealloc];
}
#endif

@end
