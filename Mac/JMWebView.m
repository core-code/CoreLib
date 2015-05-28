//
//  JMWebView.m
//  CoreLib
//
//  Created by CoreCode on 06.03.15.
//  Copyright (c) 2015 CoreCode. All rights reserved.
//

#import "JMWebView.h"


@interface JMWebView ()
@property (assign, nonatomic) dispatch_once_t onceToken;
@end


@implementation JMWebView

- (void)awakeFromNib
{
	NSScrollView *sv = [[[[self mainFrame] frameView] documentView] enclosingScrollView];

	sv.borderType = NSBezelBorder;

	self.policyDelegate = self;

	if (self.zoomFactor.floatValue < 1.0)
		self.resourceLoadDelegate = self;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdirect-ivar-access"
- (void)viewWillDraw
{
	dispatch_once(&_onceToken, ^
	{
		if (self.localHTMLName && self.localHTMLName.length)
		{
			[self.mainFrame loadRequest:self.localHTMLName.resourceURL.request];
		}


		if (self.remoteHTMLURL && self.remoteHTMLURL.length)
		{
			dispatch_async_main(^
			{
				[self.mainFrame loadRequest:self.remoteHTMLURL.URL.request];
			});
		}
	});
}
#pragma GCC diagnostic pop

#pragma mark WebViewPolicyDelegate

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request
		  frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
	if ([request.URL.absoluteString isEqualToString:self.localHTMLName.resourceURL.absoluteString] ||
		[request.URL.absoluteString isEqualToString:self.remoteHTMLURL])
		[listener use];
	else
	{
		[request.URL open];
		[listener ignore];
	}
}

#pragma mark WebResourceLoadDelegate

- (void)webView:(WebView *)sender resource:(id)identifier didFinishLoadingFromDataSource:(WebDataSource *)dataSource
{
	[sender stringByEvaluatingJavaScriptFromString:makeString(@"document.documentElement.style.zoom = \"%.2f\"", self.zoomFactor.floatValue)];
}
@end
