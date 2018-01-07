//
//  JMWebView.m
//  CoreLib
//
//  Created by CoreCode on 06.03.15.
/*	Copyright © 2018 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMWebView.h"



@implementation JMWebView

- (void)awakeFromNib
{
	NSScrollView *sv = [[[[self mainFrame] frameView] documentView] enclosingScrollView];

	sv.borderType = NSBezelBorder;

	if ((self.zoomFactor && !IS_FLOAT_EQUAL(self.zoomFactor.floatValue, 1.0f)) ||
        self.disableScrolling)
	{
		sv.hasHorizontalScroller = NO;
		sv.hasVerticalScroller = NO;
		self.mainFrame.frameView.allowsScrolling = NO;
	}

	self.policyDelegate = self;
	self.resourceLoadDelegate = self;
}

- (void)viewWillDraw
{
	ONCE_PER_OBJECT(self, ^
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

#pragma mark WebViewPolicyDelegate

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request
		  frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    NSString *localHTMLPath = self.localHTMLName.resourceURL.absoluteString;

	if ([request.URL.absoluteString isEqualToString:localHTMLPath] ||
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
	if (self.zoomFactor && !IS_FLOAT_EQUAL(self.zoomFactor.floatValue, 1.0f))
	{
		[sender stringByEvaluatingJavaScriptFromString:makeString(@"document.documentElement.style.zoom = \"%.4f\"", self.zoomFactor.doubleValue)];
		self.zoomFactor = nil;
	}
}

- (void)webView:(WebView *)sender resource:(id)identifier didFailLoadingWithError:(NSError *)error fromDataSource:(WebDataSource *)dataSource
{
	if (error.code == -1009 &&
		[error.userInfo[NSURLErrorFailingURLStringErrorKey] isEqualToString:self.remoteHTMLURL] &&
		self.localHTMLName.length)
	{
		[self.mainFrame loadRequest:self.localHTMLName.resourceURL.request];  // online version failed, fall back to offline
	}
}
@end
