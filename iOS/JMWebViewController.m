//
//  JMWebViewController.m
//  CoreLib
//
//  Created by CoreCode on 04.03.13.
/*	Copyright © 2019 CoreCodeLimited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMWebViewController.h"


@interface JMWebViewController ()

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) id <UIWebViewDelegate> tmpDelegate;

@end



@implementation JMWebViewController

- (void)viewDidLoad
{
	UIWebView *wv = [[UIWebView alloc] initWithFrame:UIScreen.mainScreen.bounds];
	self.webView = wv;
	self.webView.delegate = self.tmpDelegate;
	self.tmpDelegate = nil;

	[self.view addSubview:self.webView];

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.title = self.navigationTitle;
	
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];

	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	self.webView.frame = self.view.frame;
	
	[super viewDidAppear:animated];
}

- (void)setDelegate:(id<UIWebViewDelegate>)delegate
{
	if (self.webView)
		self.webView.delegate = delegate;
	else
		self.tmpDelegate = delegate;
}

- (id<UIWebViewDelegate>)delegate
{
    return self.tmpDelegate ? self.tmpDelegate : self.webView.delegate;
}
@end
