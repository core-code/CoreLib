//
//  JMWebView.m
//  UninstallPKG
//
//  Created by Julian Mayer on 06.03.15.
//  Copyright (c) 2015 CoreCode. All rights reserved.
//

#import "JMWebView.h"

@implementation JMWebView

- (void)awakeFromNib
{
    [self.mainFrame loadRequest:self.toolTip.URL.request];
}
@end
