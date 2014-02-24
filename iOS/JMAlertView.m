//
//  JMAlertView.m
//  CoreLib
//
//  Created by CoreCode on 21.12.11.
/*	Copyright (c) 2011 - 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "JMAlertView.h"


@implementation JMAlertView


+ (JMAlertView *)localizedAlertWithName:(NSString *)name
{
	JMAlertView *alert = [[JMAlertView alloc] initWithTitle:NSLocalizedString([name stringByAppendingString:@"_TITLE"], nil)
													message:NSLocalizedString([name stringByAppendingString:@"_MESSAGE"], nil)
												   delegate:self
										  cancelButtonTitle:NSLocalizedString([name stringByAppendingString:@"_BUTTON"], nil)
										  otherButtonTitles:nil];

	int i = 2;
	do
	{
		NSString *buttonKey = [name stringByAppendingFormat:@"_BUTTON%i", i++];
		NSString *localizedButton = [[NSBundle mainBundle] localizedStringForKey:buttonKey value:nil table:nil];

		if (!localizedButton)
			break;

		[alert addButtonWithTitle:NSLocalizedString(localizedButton, nil)];
	} while (true);


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
        if (self.cancelBlock)
            self.cancelBlock();
    }
    else
    {
        if (self.otherBlock)
			self.otherBlock((int)(buttonIndex - [self firstOtherButtonIndex]));
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
