//
//  JMPersistentCache.m
//  CoreLibTests
//
//  Created by Julian Mayer on 27/10/2019.
//  Copyright © 2019 CoreCode Limited. All rights reserved.
//

#import "CoreLib.h"
#import "JMPersistentCache.h"

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
            self.cache = [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
            if (!self)
                cc_log_error(@"Error: JMPersistentCache cannot read file at path %@", savedCacheURL.path);
        }
            
        if (!self.cache) // error, or first launch
            self.cache = makeMutableDictionary();
            
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

- (BOOL)save
{
    [_lock lock];
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.cache requiringSecureCoding:YES error:&error];

    if (!data || error)
    {
        cc_log_error(@"Error: JMPersistentCache cannot encode cach with error %@", error.description);
        assert_custom(0);
        [_lock unlock];
        return NO;
    }
    
    NSURL *savedCacheURL = [cc.suppURL add:@"persistentCache.dict"];
    BOOL success = [data writeToURL:savedCacheURL options:NSDataWritingAtomic error:&error];

    if (!success || error)
    {
        let errorMsg = makeString(@"Error: JMPersistentCache cannot write file %@ with error %@", savedCacheURL.path, error.description);
        cc_log_error(@"%@", errorMsg);
        assert_custom_info(0, errorMsg);
        [_lock unlock];
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
