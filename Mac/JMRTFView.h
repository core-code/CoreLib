//
//  JMRTFView
//  CoreLib
//
//  Created by CoreCode on 06.03.15.
//  Copyright (c) 2015 CoreCode. All rights reserved.
//


#import "CoreLib.h"


@interface JMRTFView : NSTextView

@property (strong, nonatomic) NSString *localRTFName;	// this is loaded first
@property (strong, nonatomic) NSString *remoteHTMLURL;	// if this is set and internet is online the contents are replaced with the live version

@end
