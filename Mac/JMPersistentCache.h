//
//  JMPersistentCache.h
//  CoreLibTests
//
//  Created by CoreCode on 27/10/2019.
//  Copyright © 2020 CoreCode Limited. All rights reserved.
//


@interface JMPersistentCache : NSObject

@property (readonly, class, nonatomic) JMPersistentCache *sharedCache;

- (BOOL)save:(NSError * __autoreleasing *)error;


// subscripting
- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key;

// fast enumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state  objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block;

@end
