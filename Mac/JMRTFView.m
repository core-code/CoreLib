//
//  JMWebView.m
//  CoreLib
//
//  Created by CoreCode on 06.03.15.
//  Copyright (c) 2015 CoreCode. All rights reserved.
//

#import "JMRTFView.h"


@interface JMRTFView ()
@property (assign, nonatomic) dispatch_once_t onceToken;
@end


@implementation JMRTFView

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdirect-ivar-access"
- (void)viewWillDraw
{
	dispatch_once(&_onceToken, ^
	{
		if (self.localRTFName && self.localRTFName.length)
		{
			NSAttributedString *rtfStr = [[NSAttributedString alloc] initWithURL:self.localRTFName.resourceURL documentAttributes:NULL];
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
	});
}
#pragma GCC diagnostic pop

@end
