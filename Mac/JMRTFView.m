//
//  JMWebView.m
//  CoreLib
//
//  Created by CoreCode on 06.03.15.
/*	Copyright (c) 2016 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMRTFView.h"


@interface JMRTFView ()
@end


@implementation JMRTFView


- (void)viewWillDraw
{
	id block = ^
	{
		if (self.localRTFName && self.localRTFName.length)
		{
            NSAttributedString *rtfStr;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wpartial-availability"
            if (OS_IS_POST_10_10)
                rtfStr = [[NSAttributedString alloc] initWithURL:self.localRTFName.resourceURL options:@{} documentAttributes:NULL error:NULL];
            else
                rtfStr = [[NSAttributedString alloc] initWithURL:self.localRTFName.resourceURL documentAttributes:NULL];
#pragma clang diagnostic pop
			assert(rtfStr);
			[self.textStorage setAttributedString:rtfStr];
#if ! __has_feature(objc_arc)
			[rtfStr release];
#endif
			if (self.remoteHTMLURL && self.remoteHTMLURL.length)
			{
				dispatch_async_back(^
				{
					NSAttributedString *htmlStr = [[NSAttributedString alloc] initWithHTML:self.remoteHTMLURL.URL.download documentAttributes:NULL];
					if (htmlStr && htmlStr.length)
					{
						dispatch_async_main(^
						{
							[self.textStorage setAttributedString:htmlStr];
#if ! __has_feature(objc_arc)
							[htmlStr release];
#endif
						});
					}
					else if (htmlStr)
					{
#if ! __has_feature(objc_arc)
						[htmlStr release];
#endif
					}
				});
			}
		}
		else
			asl_NSLog(ASL_LEVEL_ERR, @"Error: localHTMLName not set on JMRTFView");
	};

	ONCE_PER_OBJECT(self, block);
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    self.localRTFName = nil;
    self.remoteHTMLURL = nil;

    [super dealloc];
}
#endif

@end
