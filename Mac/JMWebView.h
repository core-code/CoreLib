//
//  JMWebView.h
//  CoreLib
//
//  Created by CoreCode on 06.03.15.
//  Copyright (c) 2015 CoreCode. All rights reserved.
//


#include "CoreLib.h"

#if __has_feature(modules)
@import WebKit;
#else
#import <WebKit/WebKit.h>
#endif


@interface JMWebView : WebView // <WebPolicyDelegate, WebResourceLoadDelegate>

@property (strong, nonatomic) NSString *localHTMLName;	// this is loaded first
@property (strong, nonatomic) NSString *remoteHTMLURL;	// if this is set and internet is online the contents are replaced with the live version
@property (strong, nonatomic) NSNumber *zoomFactor;	

@end
