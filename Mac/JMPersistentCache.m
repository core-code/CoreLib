//
//  JMPersistentCache.m
//  CoreLibTests
//
//  Created by CoreCode on 27/10/2019.
//  Copyright © 2022 CoreCode Limited. All rights reserved.
//

#import "CoreLib.h"
#import "JMPersistentCache.h"
#include <sys/errno.h>

@interface JMPersistentCache()

@property (nonatomic, strong) NSMutableDictionary *cache;
@property (nonatomic, strong) NSLock *lock;

@end


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdirect-ivar-access"


@implementation JMPersistentCache

+ (instancetype)sharedCache
{
  static JMPersistentCache *__sharedCache = nil;
  static dispatch_once_t once;
  dispatch_once(&once, ^
  {
    __sharedCache = [[[self class] alloc] init];
  });
  return __sharedCache;
}

- (instancetype)init
{
    if ((self = [super init]))
    {
        NSURL *savedCacheURL = [cc.suppURL add:@"persistentCache.dict"];
        NSData *savedData = savedCacheURL.contents;
        
        if (savedData)
        {
            NSError *err;
            self.cache = [NSKeyedUnarchiver unarchivedObjectOfClasses:@[NSNumber.class, NSString.class, NSData.class, NSDictionary.class, NSDate.class].set fromData:savedData error:&err]; // weirdly we have to specify NSDate too although it isnt root - can i smell another bug in the rotten apple? furthermore we have to specify NSNumber and NSString to avoid warnings.
            assert(self.cache);
            if (!self.cache)
                cc_log_error(@"Error: JMPersistentCache cannot read file at path %@", savedCacheURL.path);
        }
            
        if (!self.cache) // error, or first launch
            self.cache = makeMutableDictionary();
            
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

- (BOOL)save:(NSError * __autoreleasing *)error
{
    [_lock lock];
    NSError *err1;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.cache requiringSecureCoding:YES error:&err1];

    if (!data || err1)
    {
        cc_log_error(@"Error: JMPersistentCache cannot encode cach with error %@", err1.description);
        assert_custom(0);
        [_lock unlock];
        if (error) *error = err1;
        return NO;
    }
    NSError *err2;
    NSURL *savedCacheURL = [cc.suppURL add:@"persistentCache.dict"];
    BOOL success = [data writeToURL:savedCacheURL options:NSDataWritingAtomic error:&err2];

    if (!success || err2)
    {
        NSString *errorMsg = makeString(@"Error: JMPersistentCache cannot write file %@ with error %@", savedCacheURL.path, err2.description);
        cc_log_error(@"%@", errorMsg);
        NSError *underlyingError = err2.userInfo[NSUnderlyingErrorKey];
        
        
        assert_custom_info(err2.code == NSFileWriteOutOfSpaceError || err2.code == NSFileWriteNoPermissionError || underlyingError.code == ENFILE, err2.description);
        [_lock unlock];
        if (error) *error = err2;
        return NO;
    }
    
    [_lock unlock];
    return YES;
}

- (id)objectForKeyedSubscript:(NSString *)key
{
    [_lock lock];
    id obj = _cache[key];
    [_lock unlock];
    return obj;
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key
{
    [_lock lock];
    _cache[key] = obj;
    [_lock unlock];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    [_lock lock];
    NSUInteger count = [_cache countByEnumeratingWithState:state objects:buffer count:len];
    [_lock unlock];
    return count;
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
  if (block)
  {
      [_lock lock];
      [_cache enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
      {
         block(key, obj, stop);
      }];
      [_lock unlock];
  }
}


@end

#pragma GCC diagnostic pop
