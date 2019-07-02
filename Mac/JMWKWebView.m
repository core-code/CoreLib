//
//  JMWKWebView.m
//  CoreLib
//
//  Created by CoreCode on 06.03.19.
/*    Copyright © 2019 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMWKWebView.h"



@implementation JMWKWebView

- (void)awakeFromNib
{
    self.navigationDelegate = self;
    
    
    self.layer.borderWidth = 1;
    if ([NSAppearance.currentAppearance.name contains:@"NSAppearanceNameDarkAqua"])
        self.layer.borderColor = [NSColor colorWithCalibratedWhite:0.27 alpha:1].CGColor;
    else
        self.layer.borderColor = [NSColor colorWithCalibratedWhite:0.72 alpha:1].CGColor;
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
        if (self.localHTMLName && self.localHTMLName.length)
        {
            [self loadRequest:self.localHTMLName.resourceURL.request];
        }

        if (self.remoteHTMLURL && self.remoteHTMLURL.length)
        {
            NSString *remoteURL = [self.remoteHTMLURL replaced:@"$(CFBundleIdentifier)" with:cc.appBundleIdentifier];
            dispatch_async_main(^
            {
                [self loadRequest:remoteURL.URL.request];
            });
        }
    })
}

#pragma mark WebViewPolicyDelegate

//- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request
//          frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
//{    
//    NSString *localHTMLPath = self.localHTMLName.resourceURL.absoluteString;
//    NSString *remoteHTMLURL = [self.remoteHTMLURL replaced:@"$(CFBundleIdentifier)" with:cc.appBundleIdentifier];
//    NSNumber *actionType = actionInformation[WebActionNavigationTypeKey];
//    NSString *requestURLString = request.URL.absoluteString;
//    
//    if ((localHTMLPath && [requestURLString hasPrefix:localHTMLPath]) ||
//        (remoteHTMLURL && [requestURLString hasPrefix:remoteHTMLURL]) ||
//        [requestURLString isEqualToString:@"about:blank"] ||
//        (self.openOnlyClicksInBrowser && (actionType.intValue != WebNavigationTypeLinkClicked)))
//        [listener use];
//    else
//    {
//        [request.URL open];
//        [listener ignore];
//    }
//}
//
//#pragma mark WebResourceLoadDelegate
//
//- (void)webView:(WebView *)sender resource:(id)identifier didFinishLoadingFromDataSource:(WebDataSource *)dataSource
//{
//    if (self.zoomFactor && !IS_FLOAT_EQUAL(self.zoomFactor.floatValue, 1.0f))
//    {
//        [sender stringByEvaluatingJavaScriptFromString:makeString(@"document.documentElement.style.zoom = \"%.4f\"", self.zoomFactor.doubleValue)];
//        self.zoomFactor = nil;
//    }
//}
//
//- (void)webView:(WebView *)sender resource:(id)identifier didFailLoadingWithError:(NSError *)error fromDataSource:(WebDataSource *)dataSource
//{
//    NSString *url = error.userInfo[NSURLErrorFailingURLStringErrorKey];
//    if (error.code == -1009 &&
//        [url isEqualToString:self.remoteHTMLURL] &&
//        self.localHTMLName.length)
//    {
//        [self loadRequest:self.localHTMLName.resourceURL.request];  // online version failed, fall back to offline
//    }
//}



- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
    
{
    
    LOGFUNC;
    decisionHandler(WKNavigationActionPolicyAllow);

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    
    LOGFUNC;
    decisionHandler(WKNavigationResponsePolicyAllow);


}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    LOGFUNC;

    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
    LOGFUNC;

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    LOGFUNC;

}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    LOGFUNC;
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    LOGFUNC;
    
    if (self.zoomFactor && !IS_FLOAT_EQUAL(self.zoomFactor.floatValue, 1.0f))
    {
        [self evaluateJavaScript:makeString(@"document.documentElement.style.zoom = \"%.4f\"", self.zoomFactor.doubleValue)
               completionHandler:^(id m, NSError * error) { }];
        self.zoomFactor = nil;
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    LOGFUNC;
    
}

@end
