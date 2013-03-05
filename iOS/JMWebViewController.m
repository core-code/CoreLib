//
//  JMWebViewController.m
//  CoreLib
//
//  Created by Julian Mayer on 04.03.13.
/*	Copyright (c) 2011 - 2013 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMWebViewController.h"


@interface JMWebViewController ()

@property (strong, nonatomic) UIWebView *webView;

@end



@implementation JMWebViewController

- (void)viewDidLoad
{
	_webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[self.view addSubview:_webView];
	
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.title = _navigationTitle;
	
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [_webView loadRequest:request];

	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	_webView.frame = self.view.frame;
	
	[super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
@end