//
//  JMAlertView.m
//  CoreLib
//
//  Created by CoreCode on 21.12.11.
/*	Copyright (c) 2011 - 2013 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "JMAlertView.h"


@implementation JMAlertView


+ (JMAlertView *)localizedAlertWithTitle:(NSString *)title numberOfButtons:(int)buttonCount
{
	assert(buttonCount > 0);
	JMAlertView *alert = [[JMAlertView alloc] initWithTitle:NSLocalizedString([title stringByAppendingString:@"_TITLE"], nil)
													message:NSLocalizedString([title stringByAppendingString:@"_MESSAGE"], nil)
												   delegate:self
										  cancelButtonTitle:NSLocalizedString([title stringByAppendingString:@"_BUTTON"], nil)
										  otherButtonTitles:nil];

	for (int i = 1; i < buttonCount;i++)
	{
		NSString *buttonTitle = [title stringByAppendingFormat:@"_BUTTON%i", i+1];
		[alert addButtonWithTitle:NSLocalizedString(buttonTitle, nil)];
	}

	return alert;
}

- (void)show
{
    self.delegate = self;
    
    [super show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [self cancelButtonIndex])
    {
        if (_cancelBlock)
            _cancelBlock();
    }
    else
    {
        if (_otherBlock)
			_otherBlock(buttonIndex - [self firstOtherButtonIndex]);
    }
    }

- (id)initWithTitle:(NSString *)title
			message:(NSString *)message
		cancelBlock:(BasicBlock)cancelBlock
  cancelButtonTitle:(NSString *)cancelButtonTitle
		 otherBlock:(IntInBlock)otherBlock
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{

	if ((self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil]))
	{
		va_list args;
		va_start(args, otherButtonTitles);
		for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
		{
			[self addButtonWithTitle:arg];
		}
		va_end(args);

		self.cancelBlock = cancelBlock;
		self.otherBlock = otherBlock;
	}

	return self;
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
	self.cancelBlock = nil;
	self.otherBlock = nil;
	
	[super dealloc];
}
#endif
@end
