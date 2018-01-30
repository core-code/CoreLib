//
//  AppDelegate.m
//  CrashHelper
//
//  Created by CoreCode on 23/11/16.
//  Copyright © 2018 CoreCode Limited. All rights reserved.
//

#import "CrashAppDelegate.h"


static NSString *inputString;


@implementation AppDelegate

+ (NSData *)dataFromHexString:(NSString*)string
{
    const char *bytes = [string cStringUsingEncoding:NSUTF8StringEncoding];
    if (!bytes) return nil;
    NSUInteger length = strlen(bytes);
    unsigned char *r = (unsigned char *)malloc(length / 2 + 1);
    unsigned char *index = r;
    
    while ((*bytes) && (*(bytes +1)))
    {
        char encoder[3] = {'\0','\0','\0'};
        encoder[0] = *bytes;
        encoder[1] = *(bytes+1);
        *index = (unsigned char)strtol(encoder, NULL, 16);
        index++;
        bytes+=2;
    }
    *index = '\0';
    
    NSData *result = [NSData dataWithBytes:r length:length / 2];
    free(r);
    return result;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSData *data = [AppDelegate dataFromHexString:inputString];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:&err];
    
    if (!dict || err)
    {
        NSLog(@"Error: JSON read fails! input %@ dict %@ err %@", self, dict, err);
    }

    {
        NSString *title = (dict[@"title"]) ? (dict[@"title"]) : @"";
        NSString *message = (dict[@"message"]) ? (dict[@"message"]) : @"";
        NSString *mailto = (dict[@"mailto"]) ? (dict[@"mailto"]) : @"";


        if (NSRunAlertPanel(title, message, @"Send to support", @"Quit", nil) == NSAlertDefaultReturn)
        {
            NSString *escaped =   [mailto stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *url = [NSURL URLWithString:escaped];

            [NSWorkspace.sharedWorkspace openURL:url];
        }
    }
    exit(1);
}

@end



int main(int argc, const char * argv[])
{
	if (argc >= 2)
		inputString = [NSString stringWithUTF8String:argv[1]];
	else
		exit(1);


	return NSApplicationMain(argc, argv);
}
