//
//  JMWKWebView.m
//  CoreLib
//
//  Created by CoreCode on 06.03.19.
/*    Copyright © 2022 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMWKWebView.h"

@interface JMWKWebView ()
@property (atomic, assign) BOOL didFinishInitialNavigation;
@end

@implementation JMWKWebView

- (void)awakeFromNib
{
    self.navigationDelegate = self;
    
    self.layer.borderWidth = 1;
    
    if (@available(macOS 10.14, *))
    {
        if ([NSApp.effectiveAppearance.name contains:NSAppearanceNameDarkAqua])
            self.layer.borderColor = [NSColor colorWithCalibratedWhite:0.27 alpha:1].CGColor;
        else
            self.layer.borderColor = [NSColor colorWithCalibratedWhite:0.72 alpha:1].CGColor;
    }
    else
    {
        self.layer.borderColor = [NSColor colorWithCalibratedWhite:0.72 alpha:1].CGColor;
    }
}

- (void)scrollWheel:(NSEvent *)event
{
    if ((self.zoomFactor && !IS_FLOAT_EQUAL(self.zoomFactor.floatValue, 1.0f)) ||
            self.disableScrolling)
        [[self nextResponder] scrollWheel:event];
    else
        [super scrollWheel:event];
}

- (void)viewWillDraw
{
    ONCE_PER_OBJECT(self, ^
    {
        dispatch_async_main(^
        {
        if (self.localHTMLName && self.localHTMLName.length)
            [self loadRequest:self.localHTMLName.resourceURL.request];
        else
            self.didFinishInitialNavigation = YES; // no need to wait until local file has loaded

        if (self.remoteHTMLURL && self.remoteHTMLURL.length)
        {
            dispatch_after_back(0.05f, ^
            {
                while (!self.didFinishInitialNavigation)
                    [NSThread sleepForTimeInterval:0.05];

                dispatch_async_main(^
                {
                    NSString *remoteURL = [self.remoteHTMLURL replaced:@"$(CFBundleIdentifier)" with:cc.appBundleIdentifier];

                    [self loadRequest:remoteURL.URL.request];
                });
            });
        }
        else if (self.scrollToAnchor.length)
        {
            dispatch_after_main(0.5f, ^{ [self evaluateJavaScript:makeString(@"document.getElementById('%@').scrollIntoView(true);", self.scrollToAnchor) completionHandler:^(NSString *result, NSError *error) { }]; });
        }
        });
   })
}

#pragma mark WebViewPolicyDelegate


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *localHTMLPath = self.localHTMLName.resourceURL.absoluteString;
    NSString *remoteHTMLURL = [self.remoteHTMLURL replaced:@"$(CFBundleIdentifier)" with:cc.appBundleIdentifier];
    NSString *requestURLString = navigationAction.request.URL.absoluteString;
    LOGFUNCPARAM(requestURLString);
    
    if ((localHTMLPath && [requestURLString hasPrefix:localHTMLPath]) ||
        (remoteHTMLURL && [requestURLString hasPrefix:remoteHTMLURL]) ||
        [requestURLString isEqualToString:@"about:blank"] ||
        (self.openOnlyClicksInBrowser && (navigationAction.navigationType != WKNavigationTypeLinkActivated)))
        decisionHandler(WKNavigationActionPolicyAllow);
    else
    {
        [navigationAction.request.URL open];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    LOGFUNC
    
    if (self.zoomFactor && !IS_FLOAT_EQUAL(self.zoomFactor.floatValue, 1.0f))
    {
        [self evaluateJavaScript:makeString(@"document.documentElement.style.zoom = \"%.4f\"", self.zoomFactor.doubleValue)
               completionHandler:^(id m, NSError * error) { }];
        self.zoomFactor = nil;
    }
    
    self.didFinishInitialNavigation = YES;
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
//{
//    LOGFUNC
//    decisionHandler(WKNavigationResponsePolicyAllow);
//}

//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
//{
//    LOGFUNC
//}
//
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
//{
//    LOGFUNC
//}
//
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
//{
//    LOGFUNC
//}
//
//- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
//{
//    LOGFUNC
//}

//- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
//{
//    LOGFUNC
//}

@end
