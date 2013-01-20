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

@synthesize cancelBlock, otherBlock;

- (void)show
{
    self.delegate = self;
    
    [super show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [self cancelButtonIndex])
    {
        if (cancelBlock)
            cancelBlock();
    }
    else
    {
        if (otherBlock)
            otherBlock();
    }
}


+ (void)performBlock:(BasicBlock)block withProgressAlertTitled:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@" " delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 70, 30, 30)];
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [alert addSubview:progress];
    [progress startAnimating];

    [alert show];

    dispatch_after_main(0.1, ^(void)
	{
        block();
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    });
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
