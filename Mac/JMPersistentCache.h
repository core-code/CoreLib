//
//  JMPersistentCache.h
//  CoreLibTests
//
//  Created by Julian Mayer on 27/10/2019.
//  Copyright © 2019 CoreCode Limited. All rights reserved.
//


@interface JMPersistentCache : NSObject

@property (readonly, class, nonatomic) JMPersistentCache *sharedCache;

- (BOOL)save;


// subscripting
- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key;

// fast enumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state  objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block;

@end
