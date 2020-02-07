//
//  HTTPDownloader.m
//  CoreLib
//
//  Created by CoreCode on 06/12/2017.
/*    Copyright © 2020 CoreCode Limited
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import "CoreLib.h"
#import "JMHTTPDownloader.h"

@interface JMHTTPDownloader ()
{
    dispatch_semaphore_t sem;
    NSMutableData *dataToDownload;
}
@end



@implementation JMHTTPDownloader

- (NSData *)downloadRequest:(NSURLRequest *)r disableCache:(BOOL)disableCache
{
    NSMutableURLRequest *request = r.mutableCopy;

    
    sem = dispatch_semaphore_create(0);

    
    dataToDownload = [[NSMutableData alloc] init];

    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = 1; // else they could just call two delegate methods at once
    
    NSURLSessionConfiguration *config = NSURLSessionConfiguration.defaultSessionConfiguration;
    
	if (disableCache)
    {
	    if (@available(macOS 10.15, *))
    	    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    	else
        	request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        	
         if (@available(macOS 10.15, *))
		    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
	    else
	        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    	config.URLCache = nil;
    }


    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:queue];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];


    [dataTask resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    [session invalidateAndCancel];
        
    return dataToDownload;
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [dataToDownload appendData:data];
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    if (error)
        dataToDownload = nil;
    
    if ([task.response isKindOfClass:NSHTTPURLResponse.class])
    {
        NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
        
        if (statusCode != 200)
            dataToDownload = nil;
    }
    dispatch_semaphore_signal(sem);
}
@end
