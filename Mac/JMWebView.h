//
//  JMWebView.h
//  UninstallPKG
//
//  Created by Julian Mayer on 06.03.15.
//  Copyright (c) 2015 CoreCode. All rights reserved.
//


#if __has_feature(modules)
@import WebKit;
#else
#import <WebKit/WebKit.h>
#endif

@interface JMWebView : WebView

@end
