//
//  JMFontPopUpButton.m
//  CoreLib
//
//  Created by CoreCode on 28.03.14
/*	Copyright © 2017 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMFontPopUpButton.h"


@implementation JMFontPopUpButtonCell

- (NSAttributedString*)attributedTitle
{
#if ! __has_feature(objc_arc)
	return [[[NSAttributedString alloc] initWithString:[self title] attributes:nil] autorelease];
#else
	return [[NSAttributedString alloc] initWithString:[self title] attributes:nil];
#endif
}

@end


@implementation JMFontMenu

- (void)insertItem:(NSMenuItem *)newItem atIndex:(NSInteger)index
{
	NSFont *font = [NSFont fontWithName:[newItem title] size:12];

	if (font)
	{
		NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:[newItem title] attributes:@{NSFontAttributeName : font}];
		[newItem setAttributedTitle:attributedTitle];
		[super insertItem:newItem atIndex:index];
#if ! __has_feature(objc_arc)
		[attributedTitle release];
#endif
	}
	else
		asl_NSLog(ASL_LEVEL_WARNING, @"Warning: font with name '%@' is damaged and can not be instantiated.", [newItem title]);
}

@end