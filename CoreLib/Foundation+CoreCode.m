//
//  Foundation+CoreCode.m
//  CoreLib
//
//  Created by CoreCode on 15.03.12.
/*    Copyright © 2018 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "Foundation+CoreCode.h"

#if __has_feature(modules)
#ifdef USE_SECURITY
#include <CommonCrypto/CommonDigest.h>
#endif
@import ObjectiveC.runtime;
#else
#ifdef USE_SECURITY
#include <CommonCrypto/CommonDigest.h>
#endif
#import <objc/runtime.h>
#endif


#ifdef USE_SNAPPY
    #import <snappy/snappy-c.h>
#endif

#if __has_feature(modules)
@import Darwin.POSIX.sys.stat;
#else
#include <sys/stat.h>
#endif


CONST_KEY(CoreCodeAssociatedValue)



@implementation NSArray (CoreCode)


@dynamic mutableObject, empty, set, reverseArray, string, path, sorted, XMLData, flattenedArray, literalString, orderedSet, JSONData, mostFrequentObject;


- (NSString *)literalString
{
    NSMutableString *tmp = [NSMutableString stringWithString:@"@["];

    for (id obj in self)
        [tmp appendFormat:@"%@, ", [obj literalString]];

    [tmp replaceCharactersInRange:NSMakeRange(tmp.length-2, 2)                // replace trailing ', '
                       withString:@"]"];                        // with terminating ']'

    return tmp;
}

- (id)mostFrequentObject
{
    NSCountedSet *set = [[NSCountedSet alloc] initWithArray:self];
    id mostFrequentObject = nil;
    NSUInteger highestCount = 0;
    
    for (id obj in set)
    {
        NSUInteger count = [set countForObject:obj];
        
        if (count > highestCount)
        {
            highestCount = count;
            mostFrequentObject = obj;
        }
    }
    
    return mostFrequentObject;
}

- (NSArray *)sorted
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wselector"
    return [self sortedArrayUsingSelector:@selector(compare:)];
#pragma clang diagnostic pop
}


- (NSData *)JSONData
{
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:(NSJSONWritingOptions)0 error:&err];

    if (!data || err)
    {
        cc_log_error(@"Error: JSON write fails! input %@ data %@ err %@", self, data, err);
        return nil;
    }

    return data;
}


- (NSData *)XMLData
{
    NSError *err;
    NSData *data =  [NSPropertyListSerialization dataWithPropertyList:self
                                                               format:NSPropertyListXMLFormat_v1_0
                                                              options:(NSPropertyListWriteOptions)0
                                                                error:&err];

    if (!data || err)
    {
        cc_log_error(@"Error: XML write fails! input %@ data %@ err %@", self, data, err);
        return nil;
    }

    return data;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-statement-expression"

- (CCIntRange2D)calculateExtentsOfPoints:(ObjectInPointOutBlock)block
{
    CCIntRange2D range = {{INT_MAX, INT_MAX}, {INT_MIN, INT_MIN}, {-1, -1}};

    if (self.count)
    {
        for (NSObject *o in self)
        {
            CCIntPoint p = block(o);

            range.max.x = MAX(range.max.x, p.x);
            range.max.y = MAX(range.max.y, p.y);
            range.min.x = MIN(range.min.x, p.x);
            range.min.y = MIN(range.min.y, p.y);
        }

        range.length.x = range.max.x - range.min.x;
        range.length.y = range.max.y - range.min.y;
    }



    return range;
}


- (CCIntRange1D)calculateExtentsOfValues:(ObjectInIntOutBlock)block
{
    CCIntRange1D range = {INT_MAX, INT_MIN, -1};

    if (self.count)
    {
        for (NSObject *o in self)
        {
            int p = block(o);

            range.min = MIN(range.min, p);
            range.max = MAX(range.max, p);
        }

        range.length = range.max - range.min;
    }
    
    return range;
}
#pragma clang diagnostic pop


+ (void)_addArrayContents:(NSArray *)array toArray:(NSMutableArray *)newArray
{
    for (id object in array)
    {
        if ([object isKindOfClass:[NSArray class]])
            [NSArray _addArrayContents:object toArray:newArray];
        else
            [newArray addObject:object];
    }
}


- (NSArray *)flattenedArray
{
    NSMutableArray *tmp = [NSMutableArray array];

    [NSArray _addArrayContents:self toArray:tmp];

    return tmp.immutableObject;
}


- (NSString *)string
{
    NSString *ret = @"";

    for (NSString *str in self)
        ret = [ret stringByAppendingString:VALID_STR(str)];

    return ret;
}


- (NSString *)path
{
    NSString *ret = @"";
    
    for (NSString *str in self)
        ret = [ret stringByAppendingPathComponent:str];

    return ret;
}


- (BOOL)contains:(id)object
{
    return [self indexOfObject:object] != NSNotFound;
}


- (NSArray *)reverseArray
{
    return [self reverseObjectEnumerator].allObjects;
}


- (NSOrderedSet *)orderedSet
{
    return [NSOrderedSet orderedSetWithArray:self];
}


- (NSSet *)set
{
    return [NSSet setWithArray:self];
}


- (NSArray *)arrayByAddingNewObject:(id)anObject
{
    if ([self indexOfObject:anObject] == NSNotFound)
        return [self arrayByAddingObject:anObject];
    else
        return self;
}


- (NSArray *)arrayByDeletingObjectIdenticalTo:(id)anObject
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];

    [array removeObjectIdenticalTo:anObject];

    return [NSArray arrayWithArray:array];
}


- (NSArray *)arrayByDeletingObjectsIdenticalTo:(NSArray *)objects
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];

    for (id obj in objects)
        [array removeObjectIdenticalTo:obj];

    return [NSArray arrayWithArray:array];
}


- (NSArray *)arrayByDeletingObjectsAtIndexes:(NSIndexSet *)indexSet
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];

    [array removeObjectsAtIndexes:indexSet];

    return [NSArray arrayWithArray:array];
}


- (NSArray *)arrayByDeletingObjectAtIndex:(NSUInteger)index
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];

    [array removeObjectAtIndex:index];

    return [NSArray arrayWithArray:array];
}


- (NSArray *)arrayByReplacingObject:(id)anObject withObject:(id)newObject
{
    NSMutableArray *mut = self.mutableObject;

    mut[[mut indexOfObject:anObject]] = newObject;

    return mut.immutableObject;
}


- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (self.count > index)
        return self[index];
    else
        return nil;
}


- (BOOL)containsDictionaryWithKey:(NSString *)key equalTo:(NSString *)value
{
    for (NSDictionary *dict in self)
        if ([[dict valueForKey:key] isEqual:value])
            return TRUE;

    return FALSE;
}


- (NSArray *)sortedArrayByKey:(NSString *)key
{
    return [self sortedArrayByKey:key ascending:YES];
}


- (NSArray *)sortedArrayByKey:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];

    return [self sortedArrayUsingDescriptors:@[sd]];
}


- (NSArray *)subarrayFromIndex:(NSUInteger)location
{
    return [self subarrayWithRange:NSMakeRange(location, self.count-location)];
}

- (NSArray *)subarrayToIndex:(NSUInteger)location
{
    return [self subarrayWithRange:NSMakeRange(0, location)];
}

- (NSArray *)slicingSubarrayToIndex:(NSInteger)location
{
    if (location < 0)
    {
        NSInteger max = (NSInteger)self.count + location;
        return [self subarrayToIndex:(NSUInteger)max];
    }
    else
        return [self subarrayToIndex:(NSUInteger)location];
}


- (NSMutableArray *)mutableObject
{
    return [NSMutableArray arrayWithArray:self];
}


- (BOOL)empty
{
    return self.count == 0;
}


- (NSArray *)mapped:(ObjectInOutBlock)block
{
    NSMutableArray *resultArray = [NSMutableArray new];

    for (id object in self)
    {
        id result = block(object);
        if (result)
            [resultArray addObject:result];
    }

    return [NSArray arrayWithArray:resultArray];
}


- (NSInteger)reduce:(ObjectInIntOutBlock)block
{
    NSInteger value = 0;

    for (id object in self)
        value += block(object);

    return value;
}


- (NSArray *)filtered:(BOOL (^)(id input))block
{
    NSMutableArray *resultArray = [NSMutableArray new];

    for (id object in self)
        if (block(object))
            [resultArray addObject:object];

    return [NSArray arrayWithArray:resultArray];
}

- (void)apply:(ObjectInBlock)block                                // enumerateObjectsUsingBlock:
{
    for (id object in self)
        block(object);
}

// forwards for less typing
- (NSString *)joined:(NSString *)sep                            // componentsJoinedByString:
{
    return [self componentsJoinedByString:sep];
}

- (NSArray *)filteredUsingPredicateString:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSPredicate *pred = [NSPredicate predicateWithFormat:format arguments:args];
    va_end(args);

    return [self filteredArrayUsingPredicate:pred];
}


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSString *)runAsTask
{
    return [self runAsTaskWithTerminationStatus:NULL usePolling:NO];
}

- (NSString *)runAsTaskWithTerminationStatus:(NSInteger *)terminationStatus usePolling:(BOOL)usePollingToAvoidRunloop
{
    NSTask *task = [NSTask new];
    NSPipe *taskPipe = [NSPipe pipe];
    NSFileHandle *file = taskPipe.fileHandleForReading;

    task.launchPath = self[0];
    task.standardOutput = taskPipe;
    task.standardError = taskPipe;
    task.arguments = [self subarrayWithRange:NSMakeRange(1, self.count-1)];

    if ([task.arguments reduce:^int(NSString *input) { return (int)input.length; }] > 200000)
        cc_log_error(@"Error: task argument size approaching or above limit, spawn will fail");

    @try
    {
        [task launch];
    }
    @catch (NSException *)
    {
        return nil;
    }

    NSData *data = [file readDataToEndOfFile];

    
    if (!usePollingToAvoidRunloop)
    {
        [task waitUntilExit];
#ifdef DEBUG
        if ([NSThread currentThread] == [NSThread mainThread])
            cc_log(@"Warning: -[NSTask waitUntilExit] on main thread considered harmful");
#endif
    }
    else
    {
        while (task.isRunning)
        {
            [NSThread sleepForTimeInterval:0.05];
        }
    }

    NSString *string = data.string;


    if (terminationStatus)
        (*terminationStatus) = task.terminationStatus;

    return string;
}

- (NSString *)runAsTaskWithProgressBlock:(StringInBlock)progressBlock
{
    return [self runAsTaskWithProgressBlock:progressBlock terminationStatus:NULL];
}

- (NSString *)runAsTaskWithProgressBlock:(StringInBlock)progressBlock terminationStatus:(NSInteger *)terminationStatus
{
    __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSMutableString *jobOutput = makeMutableString();
    
    NSTask *task = [[NSTask alloc] init];
    NSPipe *taskPipe = [NSPipe pipe];
    task.launchPath = self[0];
    task.standardOutput = taskPipe;
    task.standardError = taskPipe;
    task.arguments = [self subarrayWithRange:NSMakeRange(1, self.count-1)];

    NSFileHandle *fileHandle = taskPipe.fileHandleForReading;
    
    [fileHandle setReadabilityHandler:^(NSFileHandle *file)
    {
        NSData *data = file.availableData;
        NSString *string = data.string;
        
        if (string)
            [jobOutput appendString:string];
        
        progressBlock(string);
    }];
    
    [task setTerminationHandler:^(NSTask *t)
     {
         fileHandle.readabilityHandler = nil;
         
         assert(sema);
         dispatch_semaphore_signal(sema);
     }];
    
    
    [task launch];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    sema = NULL;
 
    if (terminationStatus)
        (*terminationStatus) = task.terminationStatus;

    
    return jobOutput;
}
#endif
@end


@implementation  NSMutableArray (CoreCode)

@dynamic immutableObject;

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    id object = self[fromIndex];
    [self removeObjectAtIndex:fromIndex];

    if (toIndex < self.count)
        [self insertObject:object atIndex:toIndex];
    else
        [self addObject:object];
}

- (void)removeObjectPassingTest:(ObjectInIntOutBlock)block
{
    NSUInteger idx = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger i, BOOL *s)
    {
        int res = block(obj);
        return (BOOL)res;
    }];

    if (idx != NSNotFound)
        [self removeObjectAtIndex:idx];
}

- (NSArray *)immutableObject
{
    return [NSArray arrayWithArray:self];
}

- (void)addNewObject:(id)anObject
{
    if (anObject && [self indexOfObject:anObject] == NSNotFound)
        [self addObject:anObject];
}

- (void)addObjectSafely:(id)anObject
{
    if (anObject)
        [self addObject:anObject];
}

- (void)map:(ObjectInOutBlock)block
{
    for (NSUInteger i = 0; i < self.count; i++)
    {
        id result = block(self[i]);

        self[i] = result;
    }
}

- (void)filter:(ObjectInIntOutBlock)block
{
    NSMutableIndexSet *indices = [NSMutableIndexSet new];

    for (NSUInteger i = 0; i < self.count; i++)
    {
        int result = block(self[i]);
        if (!result)
            [indices addIndex:i];
    }


    [self removeObjectsAtIndexes:indices];
}

- (void)filterUsingPredicateString:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSPredicate *pred = [NSPredicate predicateWithFormat:format arguments:args];
    va_end(args);

    [self filterUsingPredicate:pred];
}

- (void)removeFirstObject
{
    [self removeObjectAtIndex:0];
}
@end



@implementation NSString (CoreCode)

@dynamic words, lines, strippedOfWhitespace, trimmedOfWhitespace, trimmedOfWhitespaceAndNewlines, URL, fileURL, download, resourceURL, resourcePath, localized, defaultObject, defaultString, defaultInt, defaultFloat, defaultURL, directoryContents, directoryContentsRecursive, directoryContentsAbsolute, directoryContentsRecursiveAbsolute, fileExists, uniqueFile, expanded, defaultArray, defaultDict, isWriteablePath, fileSize, directorySize, contents, dataFromHexString, unescaped, escaped, namedImage,  isIntegerNumber, isIntegerNumberOnly, isFloatNumber, data, firstCharacter, lastCharacter, fullRange, stringByResolvingSymlinksInPathFixed, literalString, isNumber, rot13;

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@dynamic fileIsAlias, fileAliasTarget, fileIsSymlink, fileIsRestricted;
#endif

#ifdef USE_SECURITY
@dynamic SHA1;
#endif

- (NSString *)rot13
{
    const char *cstring = [self cStringUsingEncoding:NSASCIIStringEncoding];

    if (!cstring) return nil;

    char *newcstring = malloc(self.length+1);
    
    
    NSUInteger x;
    for(x = 0; x < self.length; x++)
    {
        unsigned int aCharacter = (unsigned int)cstring[x];
        
        if( 0x40 < aCharacter && aCharacter < 0x5B ) // A - Z
            newcstring[x] = (((aCharacter - 0x41) + 0x0D) % 0x1A) + 0x41;
        else if ( 0x60 < aCharacter && aCharacter < 0x7B ) // a-z
            newcstring[x] = (((aCharacter - 0x61) + 0x0D) % 0x1A) + 0x61;
        else  // Not an alpha character
            newcstring[x] = (char)aCharacter;
    }
    
    newcstring[x] = '\0';
    
    NSString *rotString = @(newcstring);
    free(newcstring);
    return rotString;
}

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSImage *)namedImage
{
    NSImage *image = [NSImage imageNamed:self];

    if (!image)
        cc_log_error(@"Error: there is no named image with name: %@", self);

    return image;
}
#else
- (UIImage *)namedImage
{
    UIImage *image = [UIImage imageNamed:self];

    if (!image)
        cc_log_error(@"Error: there is no named image with name: %@", self);

    return image;
}
#endif

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

- (BOOL)fileIsRestricted
{
    struct stat info;
    lstat(self.UTF8String, &info);
    return (info.st_flags & SF_RESTRICTED) > 0;
}

- (BOOL)fileIsAlias
{
    NSURL *url = [NSURL fileURLWithPath:self];
    CFURLRef cfurl = (__bridge CFURLRef) url;
    CFBooleanRef aliasBool = kCFBooleanFalse;
    Boolean success = CFURLCopyResourcePropertyForKey(cfurl, kCFURLIsAliasFileKey, &aliasBool, NULL);
    Boolean alias = CFBooleanGetValue(aliasBool);

    return alias && success;
}

- (BOOL)fileIsSymlink
{
    NSURL *url = [NSURL fileURLWithPath:self];
    CFURLRef cfurl = (__bridge CFURLRef) url;
    CFBooleanRef aliasBool = kCFBooleanFalse;
    Boolean success = CFURLCopyResourcePropertyForKey(cfurl, kCFURLIsSymbolicLinkKey, &aliasBool, NULL);
    Boolean alias = CFBooleanGetValue(aliasBool);
    
    return alias && success;
}

- (NSString *)stringByResolvingSymlinksInPathFixed
{
    NSString *ret = self.stringByResolvingSymlinksInPath;


    for (NSString *exception in @[@"/etc/", @"/tmp/", @"/var/"])
    {
        if ([ret hasPrefix:exception])
        {
            NSString *fixed = [@"/private" stringByAppendingPathComponent:ret];

            return fixed;
        }
    }

    return ret;
}



- (NSString *)fileAliasTarget
{
    CFErrorRef *err = NULL;
    CFDataRef bookmark = CFURLCreateBookmarkDataFromFile(NULL, (__bridge CFURLRef)self.fileURL, err);
    if (bookmark == nil)
        return nil;
    CFURLRef url = CFURLCreateByResolvingBookmarkData (NULL, bookmark, kCFBookmarkResolutionWithoutUIMask, NULL, NULL, NULL, err);
    __autoreleasing NSURL *nurl = [(__bridge NSURL *)url copy];
    CFRelease(bookmark);
    CFRelease(url);

    return nurl.path;

}

- (CGSize)sizeUsingFont:(NSFont *)font maxWidth:(CGFloat)maxWidth
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:self];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(maxWidth, DBL_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage beginEditing];
    [textStorage setAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, self.length)];
    [textStorage endEditing];

    (void) [layoutManager glyphRangeForTextContainer:textContainer];

    NSRect r = [layoutManager usedRectForTextContainer:textContainer];

    return r.size;
}
#endif

- (NSString *)literalString
{
    return makeString(@"@\"%@\"", self);
}

- (NSRange)fullRange
{
    return NSMakeRange(0, self.length);
}

- (unichar)firstCharacter
{
    if (self.length)
        return [self characterAtIndex:0];
    return 0;
}

- (unichar)lastCharacter
{
    NSUInteger len = self.length;
    if (len)
        return [self characterAtIndex:len-1];
    return 0;
}


- (unsigned long long)fileSize
{
    NSDictionary *attr = [fileManager attributesOfItemAtPath:self error:NULL];
    if (!attr) return 0;
    return [attr[NSFileSize] unsignedLongLongValue];
}

- (unsigned long long)directorySize
{
    return self.fileURL.directorySize;
}

- (BOOL)isIntegerNumber
{
    return [self rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
}

- (BOOL)isNumber
{
    if (!self.length)
        return NO;

    if (self.isIntegerNumberOnly)
        return YES;

    if (self.isFloatNumber)
        return YES;

    return NO;
}


- (BOOL)isIntegerNumberOnly
{
    return [self rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet].location == NSNotFound;
}

- (BOOL)isFloatNumber
{
    static NSCharacterSet *cs = nil;

    if (!cs)
    {
        NSMutableCharacterSet *tmp = [NSMutableCharacterSet characterSetWithCharactersInString:@",."];
        NSString *groupingSeparators = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        NSString *decimalSeparators = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];

        [tmp addCharactersInString:groupingSeparators];
        [tmp addCharactersInString:decimalSeparators];
        cs = tmp.immutableObject;
    }

    return    ([self rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound) && ([self rangeOfCharacterFromSet:cs].location != NSNotFound);
}

- (BOOL)isWriteablePath
{
    if (self.fileExists)
        return NO;

    if (![@"TEST" writeToFile:self atomically:YES encoding:NSUTF8StringEncoding error:NULL])
        return NO;

    [fileManager removeItemAtPath:self error:NULL];

    return YES;
}

- (BOOL)isValidEmails
{
    for (NSString *line in self.lines)
        if (!line.isValidEmail)
            return NO;
    
    return YES;
}

- (BOOL)isValidEmail
{
    if (self.length > 254)
        return NO;


    NSArray <NSString *> *portions = [self split:@"@"];

    if (portions.count != 2)
        return FALSE;

    NSString *local = portions[0];
    NSString *domain = portions[1];

    if (![domain contains:@"."])
        return FALSE;

    static NSCharacterSet *localValid = nil, *domainValid = nil;

    if (!localValid)
    {
        localValid = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$%&'*+-/=?^_`{|}~."];
        domainValid = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-."];
    }

    if ([local rangeOfCharacterFromSet:localValid.invertedSet options:(NSStringCompareOptions)0].location != NSNotFound)
        return NO;

    if ([domain rangeOfCharacterFromSet:domainValid.invertedSet options:(NSStringCompareOptions)0].location != NSNotFound)
        return NO;

    return YES;
}

- (NSArray <NSString *> *)directoryContents
{
    return [fileManager contentsOfDirectoryAtPath:self error:NULL];
}

- (NSArray <NSString *> *)directoryContentsRecursive
{
    return [fileManager subpathsOfDirectoryAtPath:self error:NULL];
}

- (NSArray <NSString *> *)directoryContentsAbsolute
{
    NSArray <NSString *> *c = self.directoryContents;
    return [c mapped:^NSString *(NSString *input) { return [self stringByAppendingPathComponent:input]; }];
}

- (NSArray <NSString *> *)directoryContentsRecursiveAbsolute
{
    NSArray <NSString *> *c = self.directoryContentsRecursive;
    return [c mapped:^NSString *(NSString *input) { return [self stringByAppendingPathComponent:input]; }];
}


- (NSString *)uniqueFile
{
    assert(fileManager);
    if (![fileManager fileExistsAtPath:self])
        return self;
    else
    {
        NSString *ext = self.pathExtension;
        NSString *namewithoutext = self.stringByDeletingPathExtension;
        int i = 0;

        while ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@-%i.%@", namewithoutext, i,ext]])
            i++;

        return [NSString stringWithFormat:@"%@-%i.%@", namewithoutext, i,ext];
    }
}

- (void)setContents:(NSData *)data
{
    NSError *err;

    if (![data writeToFile:self options:NSDataWritingAtomic error:&err])
        LOG(err);
}

- (NSData *)contents
{
    return [[NSData alloc] initWithContentsOfFile:self];
}

- (BOOL)fileExists
{
    assert(fileManager);
    return [fileManager fileExistsAtPath:self];
}

- (NSUInteger)countOccurencesOfString:(NSString *)str
{
    return [self componentsSeparatedByString:str].count - 1;
}

- (BOOL)hasAnyPrefix:(NSArray <NSString *>*)possiblePrefixes
{
    for (NSString *possiblePrefix in possiblePrefixes)
        if ([self hasPrefix:possiblePrefix])
            return YES;
    
    return NO;
}


- (BOOL)hasAnySuffix:(NSArray <NSString *>*)possibleSuffixes
{
    for (NSString *possibleSuffix in possibleSuffixes)
        if ([self hasSuffix:possibleSuffix])
            return YES;
    
    return NO;
}

- (BOOL)contains:(NSString *)otherString
{
    return ([self rangeOfString:otherString].location != NSNotFound);
}

- (BOOL)contains:(NSString *)otherString insensitive:(BOOL)insensitive
{
    return ([self rangeOfString:otherString options:insensitive ? NSCaseInsensitiveSearch : 0].location != NSNotFound);
}

- (BOOL)containsAny:(NSArray <NSString *>*)otherStrings
{
    for (NSString *otherString in otherStrings)
        if ([self rangeOfString:otherString].location != NSNotFound)
            return YES;

    return NO;
}


- (BOOL)containsAll:(NSArray <NSString *>*)otherStrings
{
    for (NSString *otherString in otherStrings)
        if ([self rangeOfString:otherString].location == NSNotFound)
            return NO;

    return YES;
}

- (BOOL)equalsAny:(NSArray <NSString *>*)otherStrings
{
    for (NSString *otherString in otherStrings)
        if ([self isEqualToString:otherString])
            return YES;
    
    return NO;
}

- (NSString *)localized
{
    return NSLocalizedString(self, nil);
}

- (NSString *)resourcePath
{
    return [bundle pathForResource:self ofType:nil];
}

- (NSURL *)resourceURL
{
    return [bundle URLForResource:self withExtension:nil];
}

- (NSURL *)URL
{
    return [NSURL URLWithString:self];
}

- (NSURL *)fileURL
{
    return [NSURL fileURLWithPath:self];
}

- (NSString *)expanded
{
    return self.stringByExpandingTildeInPath;
}

- (NSArray <NSString *> *)words
{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSArray <NSString *> *)lines
{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSAttributedString *)attributedStringWithColor:(NSColor *)color
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attributedString beginEditing];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:self.fullRange];
    [attributedString endEditing];
    
    return attributedString;
}
#endif

- (NSAttributedString *)attributedStringWithHyperlink:(NSURL *)url
{
    NSString *urlstring = url.absoluteString;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];

    [attributedString beginEditing];
    [attributedString addAttribute:NSLinkAttributeName value:urlstring range:self.fullRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:makeColor(0, 0, 1, 1) range:self.fullRange];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:self.fullRange];
    [attributedString endEditing];

    return attributedString;
}

- (NSString *)strippedOfWhitespace
{
    return [self stringByDeletingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimmedOfWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimmedOfWhitespaceAndNewlines
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)clamp:(NSUInteger)maximumLength
{
    return ((self.length <= maximumLength) ? self : [self substringToIndex:maximumLength]);
}


- (NSString *)stringByReplacingMultipleStrings:(NSDictionary <NSString *, NSString *>*)replacements
{
    NSString *ret = self;
    assert(![self contains:@"k9BBV15zFYi44YyB"]);

    for (NSString *key in replacements)
    {
        if ([[NSNull null] isEqual:key] || [[NSNull null] isEqual:replacements[key]])
            continue;
        ret = [ret stringByReplacingOccurrencesOfString:key
                                             withString:[key stringByAppendingString:@"k9BBV15zFYi44YyB"]];
    }

    BOOL replaced;
    do
    {
        replaced = FALSE;

        for (NSString *key in replacements)
        {
            id value = replacements[key];

            if ([[NSNull null] isEqual:key] || [[NSNull null] isEqual:value])
                continue;
            NSString *tmp = [ret stringByReplacingOccurrencesOfString:[key stringByAppendingString:@"k9BBV15zFYi44YyB"]
                                                           withString:value];

            if (![tmp isEqualToString:ret])
            {
                ret = tmp;
                replaced = YES;
            }
        }
    } while (replaced);

    return ret;
}

- (NSString *)capitalizedStringWithUppercaseWords:(NSArray <NSString *> *)uppercaseWords
{
    NSString *res = self.capitalizedString;

    for (NSString *word in uppercaseWords)
    {
        res = [res stringByReplacingOccurrencesOfString:makeString(@"(\\W)%@(\\W)", word.capitalizedString)
                                             withString:makeString(@"$1%@$2", word.uppercaseString)
                                                options:NSRegularExpressionSearch range: res.fullRange];
    }
    for (NSString *word in uppercaseWords)
    {
        res = [res stringByReplacingOccurrencesOfString:makeString(@"(\\W)%@(\\Z)", word.capitalizedString)
                                             withString:makeString(@"$1%@", word.uppercaseString)
                                                options:NSRegularExpressionSearch range:res.fullRange];
    }

    return res;
}

- (NSString *)titlecaseStringWithLowercaseWords:(NSArray <NSString *> *)lowercaseWords andUppercaseWords:(NSArray <NSString *> *)uppercaseWords
{
    NSString *res = [self capitalizedStringWithUppercaseWords:uppercaseWords];

    for (NSString *word in lowercaseWords)
    {
        res = [res stringByReplacingOccurrencesOfString:makeString(@"([^:,;,-]\\s)%@(\\s)", word.capitalizedString)
                                             withString:makeString(@"$1%@$2", word.lowercaseString)
                                                options:NSRegularExpressionSearch range: res.fullRange];

    }

    //    for (NSString *word in lowercaseWords)
    //    {
    //        res = [res stringByReplacingOccurrencesOfString:makeString(@"(\\s)%@(\\Z)", word.capitalizedString)
    //                                             withString:makeString(@"$1%@", word.lowercaseString)
    //                                                options:NSRegularExpressionSearch range: res.fullRange];
    //
    //    }

    return res;
}

- (NSString *)titlecaseString
{
    NSArray *words = @[@"a", @"an", @"the", @"and", @"but", @"for", @"nor", @"or", @"so", @"yet", @"at", @"by", @"for", @"in", @"of", @"off", @"on", @"out", @"to", @"up", @"via", @"to", @"c", @"ca", @"etc", @"e.g.", @"i.e.", @"vs.", @"vs", @"v", @"down", @"from", @"into", @"like", @"near", @"onto", @"over", @"than", @"with", @"upon"];

    return [self titlecaseStringWithLowercaseWords:words.id andUppercaseWords:nil];
}

- (NSString *)propercaseString
{
    if (self.length == 0)
        return @"";
    else if (self.length == 1)
        return self.uppercaseString;

    return makeString(@"%@%@",
                      [self substringToIndex:1].uppercaseString,
                      [self substringFromIndex:1].lowercaseString);
}

- (NSData *)download
{
#if defined(DEBUG) && !defined(SKIP_MAINTHREADDOWNLOAD_WARNING)
    if ([NSThread currentThread] == [NSThread mainThread])
        LOG(@"Warning: performing blocking download on main thread");
#endif
    NSData *d = [[NSData alloc] initWithContentsOfURL:self.URL];

    return d;
}


#ifdef USE_SECURITY
- (NSString *)SHA1
{
    const char *cStr = self.UTF8String;
    if (!cStr) return nil;

    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, (CC_LONG)strlen(cStr), result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19]
                   ];

    return s;
}
#endif

- (NSMutableString *)mutableObject
{
    return [NSMutableString stringWithString:self];
}

- (NSString *)language
{
    CFStringRef resultLanguage;
    
    resultLanguage = CFStringTokenizerCopyBestStringLanguage((CFStringRef)self, CFRangeMake(0, self.length > 500 ? 500 : (long)self.length));
    
    return CFBridgingRelease(resultLanguage);
    
    
//   NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:@[NSLinguisticTagSchemeLanguage] options:0];
//   tagger.string = self;
//
//   NSString *resultLanguage = [tagger tagAtIndex:0 scheme:NSLinguisticTagSchemeLanguage tokenRange:NULL sentenceRange:NULL];
//   return resultLanguage;
    


    
//    __block NSString *resultLanguage;
//    dispatch_queue_t queue;
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//    NSSpellChecker *spellChecker = NSSpellChecker.sharedSpellChecker;
//    spellChecker.automaticallyIdentifiesLanguages = YES;
//    [spellChecker requestCheckingOfString:self
//                                    range:(NSRange){0, self}
//                                    types:NSTextCheckingTypeOrthography
//                                  options:nil
//                   inSpellDocumentWithTag:0
//                        completionHandler:^(NSInteger sequenceNumber, NSArray *results, NSOrthography *orthography, NSInteger wordCount)
//     {
//         resultLanguage = orthography.dominantLanguage;
//         dispatch_semaphore_signal(sema);
//     }];
//
//
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    sema = NULL;
//
//    return resultLanguage;
}

- (NSString *)removed:(NSString *)stringToRemove
{
    return [self stringByReplacingOccurrencesOfString:stringToRemove withString:@""];
}

- (NSString *)replaced:(NSString *)str1 with:(NSString *)str2    // stringByReplacingOccurencesOfString:withString:
{
    return [self stringByReplacingOccurrencesOfString:str1 withString:str2];
}

- (NSArray <NSString *> *)split:(NSString *)sep                                // componentsSeparatedByString:
{
    return [self componentsSeparatedByString:sep];
}

- (NSArray *)defaultArray
{
    return [NSUserDefaults.standardUserDefaults arrayForKey:self];
}

- (void)setDefaultArray:(NSArray *)newDefault
{
    [NSUserDefaults.standardUserDefaults setObject:newDefault forKey:self];
}

- (NSDictionary *)defaultDict
{
    return [NSUserDefaults.standardUserDefaults dictionaryForKey:self];
}

- (void)setDefaultDict:(NSDictionary *)newDefault
{
    [NSUserDefaults.standardUserDefaults setObject:newDefault forKey:self];
}

- (id)defaultObject
{
    return [NSUserDefaults.standardUserDefaults objectForKey:self];
}

- (void)setDefaultObject:(id)newDefault
{
    [NSUserDefaults.standardUserDefaults setObject:newDefault forKey:self];
}

- (NSString *)defaultString
{
    return [NSUserDefaults.standardUserDefaults stringForKey:self];
}

- (void)setDefaultString:(NSString *)newDefault
{
    [NSUserDefaults.standardUserDefaults setObject:newDefault forKey:self];
}

- (NSURL *)defaultURL
{
    return [NSUserDefaults.standardUserDefaults URLForKey:self];
}

- (void)setDefaultURL:(NSURL *)newDefault
{
    [NSUserDefaults.standardUserDefaults setURL:newDefault forKey:self];
}

- (NSInteger)defaultInt
{
    return [NSUserDefaults.standardUserDefaults integerForKey:self];
}

- (void)setDefaultInt:(NSInteger)newDefault
{
    [NSUserDefaults.standardUserDefaults setInteger:newDefault forKey:self];
}

- (float)defaultFloat
{
    return [NSUserDefaults.standardUserDefaults floatForKey:self];
}

- (void)setDefaultFloat:(float)newDefault
{
    [NSUserDefaults.standardUserDefaults setFloat:newDefault forKey:self];
}

- (NSString *)stringValue
{
    return self;
}

//- (NSNumber *)numberValue
//{
//    return @(self.doubleValue);
//}

- (NSArray <NSArray <NSString *> *> *)parsedDSVWithDelimiter:(NSString *)delimiter
{    // credits to Drew McCormack
    NSMutableArray *rows = [NSMutableArray array];

    NSMutableCharacterSet *whitespaceCharacterSet = [NSMutableCharacterSet whitespaceCharacterSet];
    NSMutableCharacterSet *newlineCharacterSetMutable = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    [newlineCharacterSetMutable formIntersectionWithCharacterSet:whitespaceCharacterSet.invertedSet];
    [whitespaceCharacterSet removeCharactersInString:delimiter];
    NSCharacterSet *newlineCharacterSet = [NSCharacterSet characterSetWithBitmapRepresentation:newlineCharacterSetMutable.bitmapRepresentation];
    NSMutableCharacterSet *importantCharactersSetMutable = [NSMutableCharacterSet characterSetWithCharactersInString:[delimiter stringByAppendingString:@"\""]];
    [importantCharactersSetMutable formUnionWithCharacterSet:newlineCharacterSet];
    NSCharacterSet *importantCharactersSet = [NSCharacterSet characterSetWithBitmapRepresentation:importantCharactersSetMutable.bitmapRepresentation];

    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];

    while (!scanner.atEnd)
    {
        BOOL insideQuotes = NO;
        BOOL finishedRow = NO;
        NSMutableArray *columns = [NSMutableArray arrayWithCapacity:30];
        NSMutableString *currentColumn = [NSMutableString string];

        while (!finishedRow)
        {
            NSString *tempString;
            if ([scanner scanUpToCharactersFromSet:importantCharactersSet intoString:&tempString])
            {
                [currentColumn appendString:tempString];
            }

            if (scanner.atEnd)
            {
                if (![currentColumn isEqualToString:@""])
                    [columns addObject:currentColumn];

                finishedRow = YES;
            }
            else if ([scanner scanCharactersFromSet:newlineCharacterSet intoString:&tempString])
            {
                if (insideQuotes) 
                {
                    [currentColumn appendString:tempString];
                }
                else
                {
                    if (![currentColumn isEqualToString:@""])
                        [columns addObject:currentColumn];
                    finishedRow = YES;
                }
            }
            else if ([scanner scanString:@"\"" intoString:NULL])
            {
                if (insideQuotes && [scanner scanString:@"\"" intoString:NULL])
                {
                    [currentColumn appendString:@"\""];
                }
                else
                {
                    insideQuotes = !insideQuotes;
                }
            }
            else if ([scanner scanString:delimiter intoString:NULL])
            {
                if (insideQuotes)
                {
                    [currentColumn appendString:delimiter];
                }
                else
                {
                    [columns addObject:currentColumn];
                    currentColumn = [NSMutableString string];
                    [scanner scanCharactersFromSet:whitespaceCharacterSet intoString:NULL];
                }
            }
        }
        if (columns.count > 0)
            [rows addObject:columns];
    }

    return rows;
}

- (NSData *)data
{
    return [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}

- (NSData *)dataFromHexString
{
    const char *bytes = [self cStringUsingEncoding:NSUTF8StringEncoding];
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

- (NSString *)unescaped
{
    return self.stringByRemovingPercentEncoding;
}

- (NSString *)escaped
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)slicingSubstringToIndex:(NSInteger)location
{
    if (location < 0)
    {
        NSInteger max = (NSInteger)self.length + location;
        return [self substringToIndex:(NSUInteger)max];
    }
    else
        return [self substringToIndex:(NSUInteger)location];
}


- (NSString *)encoded
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
}

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSRange rangeOfFirstWantedCharacter = [self rangeOfCharacterFromSet:characterSet.invertedSet];
    if (rangeOfFirstWantedCharacter.location == NSNotFound)
        return @"";

    return [self substringFromIndex:rangeOfFirstWantedCharacter.location];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:characterSet.invertedSet
                                                               options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound)
        return @"";

    return [self substringToIndex:rangeOfLastWantedCharacter.location+1];
}

- (NSString *)stringByDeletingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSRange r = [self rangeOfCharacterFromSet:characterSet];
    NSString *new = self.copy;
    
    while (r.location != NSNotFound)
    {
        new = [new stringByReplacingCharactersInRange:r withString:@""];
        r = [new rangeOfCharacterFromSet:characterSet];
    }
    return new;
}

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
void directoryObservingReleaseCallback(const void *info)
{
    CFBridgingRelease(info);
}

void directoryObservingEventCallback(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[])
{
    NSMutableArray <NSDictionary *> *tmp = makeMutableArray();
    char **paths = eventPaths;
    for (NSUInteger i = 0; i < numEvents; i++)
    {
        char *eventPath = paths[i];

        if (eventPath)
        {
            NSString *eventPathString = @(eventPath);
            if (eventPathString)
                [tmp addObject:@{@"path" : eventPathString, @"flags" : @(eventFlags[i])}];
        }
    }

    void (^block)(id input) = (__bridge void (^)(id))(clientCallBackInfo);
    block(tmp);
//
//    void (^block)(void) = (__bridge void (^)(void))(clientCallBackInfo);
//    block();
}

CONST_KEY(CCDirectoryObserving)
- (NSValue *)startObserving:(ObjectInBlock)block withFileLevelEvents:(BOOL)fileLevelEvents
{
    void *ptr = (__bridge_retained void *)block;
    FSEventStreamContext context = {0, ptr, NULL, directoryObservingReleaseCallback, NULL};
    CFStringRef mypath = (__bridge CFStringRef)self.stringByExpandingTildeInPath;
    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&mypath, 1, NULL);
    FSEventStreamRef stream;
    CFAbsoluteTime latency = 2.0;


    assert(self.fileURL.fileIsDirectory);
    stream = FSEventStreamCreate(NULL, &directoryObservingEventCallback, &context, pathsToWatch, kFSEventStreamEventIdSinceNow, latency, fileLevelEvents ? kFSEventStreamCreateFlagFileEvents : 0);

    CFRelease(pathsToWatch);
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);

    FSEventStreamStart(stream);

    NSValue *token = [NSValue valueWithPointer:stream];
    [self setAssociatedValue:token forKey:kCCDirectoryObservingKey];
    return token;
}

- (void)stopObserving:(NSValue *)token
{
    NSValue *v = [self associatedValueForKey:kCCDirectoryObservingKey];
    if (!v)
        v = token;
    
    if (v)
    {
        FSEventStreamRef stream = v.pointerValue;

        FSEventStreamStop(stream);
        FSEventStreamInvalidate(stream);
        FSEventStreamRelease(stream);
    }
    else
        cc_log_debug(@"Warning: stopped observing on location which was never observed %@", self);
}
#endif
@end


@implementation  NSMutableString (CoreCode)

@dynamic immutableObject;

- (NSString *)immutableObject
{
    return [NSString stringWithString:self];
}
@end



@implementation NSURL (CoreCode)

@dynamic directoryContents, directoryContentsRecursive, fileExists, uniqueFile, request, mutableRequest, fileSize, directorySize, isWriteablePath, download, contents, fileIsDirectory, fileOrDirectorySize, fileChecksumSHA; // , path
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@dynamic fileIsAlias, fileAliasTarget, fileIsRestricted, fileIsSymlink;


- (NSString *)fileChecksumSHA
{
#ifdef USE_SECURITY
    if (self.fileExists)
    {
        NSData *d = [NSData dataWithContentsOfURL:self];
        unsigned char result[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1(d.bytes, (CC_LONG)d.length, result);
        NSMutableString *ms = [NSMutableString string];
        
        for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        {
            [ms appendFormat: @"%02x", (int)(result [i])];
        }
        
        return [ms copy];
    }
    else
        return @"NoFile";
#else
    return @"Unvailable";
#endif
}

- (BOOL)fileIsRestricted
{
    struct stat info;
    lstat(self.path.UTF8String, &info);
    return (info.st_flags & SF_RESTRICTED) > 0;
}

- (BOOL)fileIsAlias
{
    CFURLRef cfurl = (__bridge CFURLRef) self;
    CFBooleanRef aliasBool = kCFBooleanFalse;
    Boolean success = CFURLCopyResourcePropertyForKey(cfurl, kCFURLIsAliasFileKey, &aliasBool, NULL);
    Boolean alias = CFBooleanGetValue(aliasBool);

    return alias && success;
}

- (BOOL)fileIsSymlink
{
    CFURLRef cfurl = (__bridge CFURLRef) self;
    CFBooleanRef aliasBool = kCFBooleanFalse;
    Boolean success = CFURLCopyResourcePropertyForKey(cfurl, kCFURLIsSymbolicLinkKey, &aliasBool, NULL);
    Boolean alias = CFBooleanGetValue(aliasBool);
    
    return alias && success;
}

- (BOOL)fileIsDirectory
{
    NSNumber *value;
    [self getResourceValue:&value forKey:NSURLIsDirectoryKey error:NULL];
    return value.boolValue;
}

- (NSURL *)fileAliasTarget
{
    CFErrorRef *err = NULL;
    CFDataRef bookmark = CFURLCreateBookmarkDataFromFile(NULL, (__bridge CFURLRef)self, err);
    if (bookmark == nil)
        return nil;
    CFURLRef url = CFURLCreateByResolvingBookmarkData (NULL, bookmark, kCFBookmarkResolutionWithoutUIMask, NULL, NULL, NULL, err);
    __autoreleasing NSURL *nurl = [(__bridge NSURL *)url copy];
    CFRelease(bookmark);
    CFRelease(url);

    return nurl;
}
#endif

- (NSData *)readFileHeader:(NSUInteger)maximumByteCount
{
    int fd = open(self.path.UTF8String, O_RDONLY);
    if (fd == -1)
        return nil;
    
    NSUInteger length = maximumByteCount;
    NSMutableData *data = [[NSMutableData alloc] initWithLength:length];
    
    if (data)
    {
        void *buffer = [data mutableBytes];
        
        long actualBytes = read(fd, buffer, length);
        
        if (actualBytes <= 0)
            data = nil;
        else  if ((NSUInteger)actualBytes < length)
            [data setLength:(NSUInteger)actualBytes];
    }
    close(fd);
    
    return data;
}


- (NSURLRequest *)request
{
    return [NSURLRequest requestWithURL:self];
}

- (NSMutableURLRequest *)mutableRequest
{
    return [NSMutableURLRequest requestWithURL:self];
}

- (NSURL *)add:(NSString *)component
{
    return [self URLByAppendingPathComponent:component];
}

- (NSArray <NSURL *> *)directoryContents
{
    if (!self.fileURL) return nil;

    NSString *path = self.path;
    NSError *err;
    NSArray *c = [fileManager contentsOfDirectoryAtPath:path error:&err];

    return [c mapped:^id (NSString *input) { return [self URLByAppendingPathComponent:input]; }];
}

- (NSArray <NSURL *> *)directoryContentsRecursive
{
    NSDirectoryEnumerator *enumerator = [fileManager
                                         enumeratorAtURL:self
                                         includingPropertiesForKeys:nil
                                         options:0
                                         errorHandler:^(NSURL *url, NSError *error) { return YES; }];
    
    return enumerator.allObjects;
}

- (NSURL *)uniqueFile
{
    if (!self.fileURL) return nil;
    return self.path.uniqueFile.fileURL;
}

- (BOOL)fileExists
{
    NSString *path = self.path;
    return self.fileURL && [fileManager fileExistsAtPath:path];
}


- (unsigned long long)fileOrDirectorySize
{
    return (self.fileIsDirectory ? self.directorySize : self.fileSize);
}


- (unsigned long long)fileSize
{
    NSNumber *size;
    
    if ([self getResourceValue:&size forKey:NSURLFileSizeKey error:nil])
        return size.unsignedLongLongValue;
    else
        return 0;
}

- (unsigned long long)directorySize
{
    unsigned long long directorySize = 0;
    
    NSDirectoryEnumerator *enumerator = [fileManager
                                         enumeratorAtURL:self
                                         includingPropertiesForKeys:@[NSURLIsDirectoryKey, NSURLFileSizeKey]
                                         options:0
                                         errorHandler:^(NSURL *url, NSError *error) { return YES; }];
    
    for (NSURL *url in enumerator)
    {
        NSDictionary *values = [url resourceValuesForKeys:@[NSURLIsDirectoryKey, NSURLFileSizeKey] error:NULL];
        
        if (values && ![values[NSURLIsDirectoryKey] boolValue])
        {
            NSNumber *fileSize = values[NSURLFileSizeKey];
                
            directorySize += fileSize.unsignedLongLongValue;
        }
    }
    return directorySize;
}

- (void)open
{
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
    [NSWorkspace.sharedWorkspace openURL:self];
#else
    if (@available(iOS 10.0, *))
        [UIApplication.sharedApplication openURL:self options:@{} completionHandler:NULL];
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations" // we get a warning despite the @available, must be a compiler bug
        [UIApplication.sharedApplication openURL:self];
#pragma clang diagnostic pop
    }
#endif
}

- (BOOL)isWriteablePath
{
    if (self.fileExists)
        return NO;
    
    if (![@"TEST" writeToURL:self atomically:YES encoding:NSUTF8StringEncoding error:NULL])
        return NO;
    
    [fileManager removeItemAtURL:self error:NULL];
    
    return YES;
}


- (NSData *)download
{
#ifdef DEBUG
    if ([NSThread currentThread] == [NSThread mainThread] && !self.isFileURL)
        LOG(@"Warning: performing blocking download on main thread");
#endif
    
    NSData *d = [NSData dataWithContentsOfURL:self];
    
    return d;
}

- (void)setContents:(NSData *)data
{
    NSError *err;
    
    if (![data writeToURL:self options:NSDataWritingAtomic error:&err])
        LOG(err);
}

- (NSData *)contents
{
    return self.download;
}

+ (NSURL *)URLWithHost:(NSString *)host path:(NSString *)path query:(NSString *)query
{
    return [NSURL URLWithHost:host path:path query:query user:nil password:nil fragment:nil scheme:@"https" port:nil];
}

+ (NSURL *)URLWithHost:(NSString *)host path:(NSString *)path query:(NSString *)query user:(NSString *)user password:(NSString *)password fragment:(NSString *)fragment scheme:(NSString *)scheme port:(NSNumber *)port
{
    assert([path hasPrefix:@"/"]);
    assert(![query contains:@"k9BBV15zFYi44YyB"]);
    query = [query replaced:@"+" with:@"k9BBV15zFYi44YyB"];
    NSURLComponents *urlComponents = [NSURLComponents new];
    urlComponents.scheme = scheme;
    urlComponents.host = host;
    urlComponents.path = path;
    urlComponents.query = query;
    urlComponents.user = user;
    urlComponents.password = password;
    urlComponents.fragment = fragment;
    urlComponents.port = port;
    urlComponents.percentEncodedQuery = [urlComponents.percentEncodedQuery replaced:@"k9BBV15zFYi44YyB" with:@"%2B"];

    NSURL *url = urlComponents.URL;
    assert(url);

    return url;
}

- (NSData *)performBlockingPOST:(double)timeoutSeconds
{
    __block NSData *data;
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);

    [self performPOST:^(NSData *d)
     {
         data = d;
         dispatch_semaphore_signal(sem);
     }];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeoutSeconds * NSEC_PER_SEC));
    long res = dispatch_semaphore_wait(sem, popTime);
    if (res == 0)
        return data;
    else
        return nil; // got timeout
}

- (NSData *)performBlockingGET:(double)timeoutSeconds
{
    __block NSData *data;
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);

    [self performGET:^(NSData *d)
    {
        data = d;
        dispatch_semaphore_signal(sem);
    }];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeoutSeconds * NSEC_PER_SEC));
    long res = dispatch_semaphore_wait(sem, popTime);
    if (res == 0)
        return data;
    else
        return nil; // got timeout
}

- (void)performGET:(void (^)(NSData *data))completion
{
    NSURLSessionDataTask *dataTask = [NSURLSession.sharedSession dataTaskWithURL:self completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        completion(data);
    }];
    [dataTask resume];
}

- (void)performPOST:(void (^)(NSData *data))completion
{
    NSURL *newURL = [NSURL URLWithHost:self.host path:self.path query:nil user:self.user
                              password:self.password fragment:self.fragment scheme:self.scheme port:self.port]; // don't want the query in there
    NSMutableURLRequest *request = newURL.request.mutableCopy;

    request.HTTPBody = self.query.data;
    request.HTTPMethod = @"POST";
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *dataTask = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        completion(data);
    }];
    [dataTask resume];
}
@end



@implementation NSData (CoreCode)

@dynamic string, hexString, mutableObject, JSONArray, JSONDictionary;

#ifdef USE_SECURITY
@dynamic SHA1, MD5, SHA256;
#endif


#ifdef USE_SECURITY
- (NSString *)SHA1
{
    const char *cStr = self.bytes;
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, (CC_LONG)self.length, result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19]
                   ];

    return s;
}

- (NSString *)MD5
{
    const char *cStr = self.bytes;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)self.length, result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15]
                   ];

    return s;
}

- (NSString *)SHA256
{
    const char *cStr = self.bytes;
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cStr, (CC_LONG)self.length, result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19],
                   result[20], result[21], result[22], result[23],
                   result[24], result[25], result[26], result[27],
                   result[28], result[29], result[30], result[31]
                   ];

    return s;
}
#endif

#ifdef USE_SNAPPY
@dynamic snappyCompressed, snappyDecompressed;

- (NSData *)snappyDecompressed
{
    size_t uncompressedSize = 0;

    if( snappy_uncompressed_length(self.bytes, self.length, &uncompressedSize) != SNAPPY_OK )
    {
        cc_log_error(@"Error: can't calculate the uncompressed length!\n");
        return nil;
    }

    assert(uncompressedSize);

    char *buf = (char *)malloc(uncompressedSize);
    assert(buf);


    int res = snappy_uncompress(self.bytes, self.length, buf, &uncompressedSize);
    if(res != SNAPPY_OK)
    {
        cc_log_error(@"Error: can't uncompress the file!\n");
        free(buf);
        return nil;
    }


    NSData *d = [NSData dataWithBytesNoCopy:buf length:uncompressedSize];

    return d;
}

- (NSData *)snappyCompressed
{
    size_t output_length = snappy_max_compressed_length(self.length);
    char *buf = (char*)malloc(output_length);
    assert(buf);

    int res = snappy_compress(self.bytes, self.length, buf, &output_length);
    if (res != SNAPPY_OK )
    {
        cc_log_error(@"Error: problem compressing the file\n");
        free(buf);
        return nil;
    }

    NSData *d = [NSData dataWithBytesNoCopy:buf length:output_length];

    return d;
}
#endif

- (NSString *)string
{
    NSString *result;
    
    [NSString stringEncodingForData:self encodingOptions:nil convertedString:&result usedLossyConversion:nil];

    if (result)
        return result;

    for (NSNumber *num in @[@(NSUTF8StringEncoding), @(NSISOLatin1StringEncoding), @(NSASCIIStringEncoding), @(NSUTF16StringEncoding)])
    {
        NSString *s = [[NSString alloc] initWithData:self encoding:num.unsignedIntegerValue];

        if (!s)
            continue;

        return s;
    }

    cc_log_error(@"Error: could not create string from data %@", self);
    return nil;
}

- (NSString *)hexString
{
    const unsigned char *dataBuffer = (const unsigned char *)self.bytes;

    if (!dataBuffer)
        return [NSString string];

    NSUInteger          dataLength  = self.length;
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];

    for (NSUInteger i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];

    return [NSString stringWithString:hexString];
}

- (NSMutableData *)mutableObject
{
    return [NSMutableData dataWithData:self];
}

- (id)JSONObject
{
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self options:(NSJSONReadingOptions)0 error:&err];

    if (!dict || err)
    {
        cc_log_error(@"Error: JSON read fails! input %@ dict %@ err %@", self, dict, err);
        return nil;
    }

    return dict;
}

- (NSArray *)JSONArray
{
    id res = [self JSONObject];

    if (![res isKindOfClass:[NSArray class]])
    {
        cc_log_error(@"Error: JSON read fails! input is class %@ instead of array", [[res class] description]);
        return nil;
    }

    return res;
}

- (NSDictionary *)JSONDictionary
{
    id res = [self JSONObject];

    if (![res isKindOfClass:[NSDictionary class]])
    {
        cc_log_error(@"Error: JSON read fails! input is class %@ instead of dictionary", [[res class] description]);
        return nil;
    }

    return res;
}
@end



@implementation NSDate (CoreCode)

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)dateFormat localeIdentifier:(NSString *)localeIdentifier
{
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = dateFormat;
    NSLocale *l = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    df.locale = l;

    return [df dateFromString:dateString];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)dateFormat
{
    return [self dateWithString:dateString format:dateFormat localeIdentifier:@"en_US"];
}

+ (NSDate *)dateWithPreprocessorDate:(const char *)preprocessorDateString
{
    return [self dateWithString:@(preprocessorDateString) format:@"MMM d yyyy"];
}

+ (NSDate *)dateWithISO8601Date:(NSString *)iso8601DateString
{   // there is the NSISO8601DateFormatter but its 10.12+
    NSDateFormatter *df = NSDateFormatter.new;
    
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSDate *result = [df dateFromString:iso8601DateString];
    
    return result;
}

- (NSString *)stringUsingFormat:(NSString *)dateFormat
{
    return [self stringUsingFormat:dateFormat timeZone:nil];
}

- (NSString *)stringUsingFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone
{
    NSDateFormatter *df = [NSDateFormatter new];
    NSLocale *l = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    df.locale = l;
    df.dateFormat = dateFormat;
    if (timeZone)
        df.timeZone = timeZone;
    
    return [df stringFromDate:self];
}

- (NSString *)stringUsingDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
    NSDateFormatter *df = [NSDateFormatter new];

    df.locale = [NSLocale currentLocale];
    df.dateStyle = dateStyle;
    df.timeStyle = timeStyle;

    return [df stringFromDate:self];
}

@end


@implementation NSDateFormatter (CoreCode)

+ (NSString *)formattedTimeFromTimeInterval:(NSTimeInterval)timeInterval
{
    int minutes = (int)(timeInterval / 60);
    int seconds = (int)(timeInterval - (minutes * 60));


    if (minutes)
        return makeString(@"%im %is", minutes, seconds);
    else
        return makeString(@"%is", (int)timeInterval);
}

@end



@implementation NSDictionary (CoreCode)

@dynamic mutableObject, XMLData, literalString, JSONData;

- (NSString *)literalString
{
    NSMutableString *tmp = [NSMutableString stringWithString:@"@{"];

    for (id key in self)
        [tmp appendFormat:@"%@ : %@, ", [key literalString], [self[key] literalString]];

    [tmp replaceCharactersInRange:NSMakeRange(tmp.length-2, 2)                // replace trailing ', '
                       withString:@"}"];                                    // with terminating '}'

    return tmp;
}

- (NSData *)JSONData
{
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:(NSJSONWritingOptions)0 error:&err];

    if (!data || err)
    {
        cc_log_error(@"Error: JSON write fails! input %@ data %@ err %@", self, data, err);
        return nil;
    }

    return data;
}

- (NSData *)XMLData
{
    NSError *err;
    NSData *data =  [NSPropertyListSerialization dataWithPropertyList:self
                                                               format:NSPropertyListXMLFormat_v1_0
                                                              options:(NSPropertyListWriteOptions)0
                                                                error:&err];

    if (!data || err)
    {
        cc_log_error(@"Error: XML write fails! input %@ data %@ err %@", self, data, err);
        return nil;
    }

    return data;
}

- (NSMutableDictionary *)mutableObject
{
    return [NSMutableDictionary dictionaryWithDictionary:self];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wselector"
    return [super methodSignatureForSelector:@selector(valueForKey:)];
#pragma clang diagnostic pop
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *propertyName = NSStringFromSelector(invocation.selector);
    invocation.selector = @selector(valueForKey:);
    [invocation setArgument:&propertyName atIndex:2];
    [invocation invokeWithTarget:self];
}

- (NSDictionary *)dictionaryByReplacingNSNullWithEmptyStrings
{
    NSMutableDictionary *mutableCopy = self.mutableCopy;
    NSArray *keys = mutableCopy.allKeys;
    
    for (NSUInteger idx = 0, count = keys.count; idx < count; ++idx)
    {
        id const key = keys[idx];
        id const obj = mutableCopy[key];
        if (obj == NSNull.null)
            mutableCopy[key] = @"";
    }
    
    return mutableCopy.copy;
}

- (NSDictionary *)dictionaryBySettingValue:(id)value forKey:(id)key
{
    NSMutableDictionary *mutable = self.mutableObject;

    mutable[key] = value;

    return mutable.immutableObject;
}

- (NSDictionary *)dictionaryByDeletingKey:(id)key
{
    NSMutableDictionary *mutable = self.mutableObject;

    [mutable removeObjectForKey:key];

    return mutable.immutableObject;
}

- (NSDictionary *)dictionaryByDeletingKeys:(NSArray <NSString *>*)keys
{
    NSMutableDictionary *mutable = self.mutableObject;

    for (NSString *key in keys)
        [mutable removeObjectForKey:key];

    return mutable.immutableObject;
}

- (BOOL)containsAny:(NSArray <NSString *>*)keys
{
    for (NSString *key in keys)
        if (self[key] != nil)
             return YES;
    
    return NO;
}


- (BOOL)containsAll:(NSArray <NSString *>*)keys
{
    for (NSString *key in keys)
        if (self[key] == nil)
            return NO;
    
    return YES;
}

@end


@implementation NSMutableDictionary (CoreCode)

@dynamic immutableObject;

- (NSDictionary *)immutableObject
{
    return [NSDictionary dictionaryWithDictionary:self];
}

- (void)addObject:(id)object toMutableArrayAtKey:(id)key
{
    NSMutableArray *existingEntry = self[key];
    
    if (existingEntry)
        [existingEntry addObject:object];
    else
        self[key] = [NSMutableArray arrayWithObject:object];
}

@end



@implementation NSFileHandle (CoreCode)

- (float)readFloat
{
    float ret;
    [[self readDataOfLength:sizeof(float)] getBytes:&ret length:sizeof(float)];
    return ret;
}

- (int)readInt
{
    int ret;
    [[self readDataOfLength:sizeof(int)] getBytes:&ret length:sizeof(int)];
    return ret;
}
@end



@implementation NSLocale (CoreCode)

+ (NSArray *)preferredLanguages2Letter
{
    static NSMutableArray *languageCodes;
    
    if (!languageCodes)
    {
        languageCodes = makeMutableArray();
    
        for (NSString *l in [NSLocale preferredLanguages])
        {
            NSDictionary *d = [NSLocale componentsFromLocaleIdentifier:l];
            NSString *twoLetterCode = d[NSLocaleLanguageCode];
            [languageCodes addObject:twoLetterCode];
        }
    }
    
    return languageCodes;
}
+ (NSArray *)preferredLanguages3Letter
{
    NSDictionary *iso2LetterTo3Letter = @{@"aa" : @"aar", @"ab" : @"abk", @"ae" : @"ave", @"af" : @"afr", @"ak" : @"aka", @"am" : @"amh", @"an" : @"arg", @"ar" : @"ara", @"as" : @"asm", @"av" : @"ava", @"ay" : @"aym", @"az" : @"aze", @"ba" : @"bak", @"be" : @"bel", @"bg" : @"bul", @"bh" : @"bih", @"bi" : @"bis", @"bm" : @"bam", @"bn" : @"ben", @"bo" : @"tib", @"bo" : @"tib", @"br" : @"bre", @"bs" : @"bos", @"ca" : @"cat", @"ce" : @"che", @"ch" : @"cha", @"co" : @"cos", @"cr" : @"cre", @"cs" : @"cze", @"cs" : @"cze", @"cu" : @"chu", @"cv" : @"chv", @"cy" : @"wel", @"cy" : @"wel", @"da" : @"dan", @"de" : @"ger", @"de" : @"ger", @"dv" : @"div", @"dz" : @"dzo", @"ee" : @"ewe", @"el" : @"gre", @"el" : @"gre", @"en" : @"eng", @"eo" : @"epo", @"es" : @"spa", @"et" : @"est", @"eu" : @"baq", @"eu" : @"baq", @"fa" : @"per", @"fa" : @"per", @"ff" : @"ful", @"fi" : @"fin", @"fj" : @"fij", @"fo" : @"fao", @"fr" : @"fre", @"fr" : @"fre", @"fy" : @"fry", @"ga" : @"gle", @"gd" : @"gla", @"gl" : @"glg", @"gn" : @"grn", @"gu" : @"guj", @"gv" : @"glv", @"ha" : @"hau", @"he" : @"heb", @"hi" : @"hin", @"ho" : @"hmo", @"hr" : @"hrv", @"ht" : @"hat", @"hu" : @"hun", @"hy" : @"arm", @"hy" : @"arm", @"hz" : @"her", @"ia" : @"ina", @"id" : @"ind", @"ie" : @"ile", @"ig" : @"ibo", @"ii" : @"iii", @"ik" : @"ipk", @"io" : @"ido", @"is" : @"ice", @"is" : @"ice", @"it" : @"ita", @"iu" : @"iku", @"ja" : @"jpn", @"jv" : @"jav", @"ka" : @"geo", @"ka" : @"geo", @"kg" : @"kon", @"ki" : @"kik", @"kj" : @"kua", @"kk" : @"kaz", @"kl" : @"kal", @"km" : @"khm", @"kn" : @"kan", @"ko" : @"kor", @"kr" : @"kau", @"ks" : @"kas", @"ku" : @"kur", @"kv" : @"kom", @"kw" : @"cor", @"ky" : @"kir", @"la" : @"lat", @"lb" : @"ltz", @"lg" : @"lug", @"li" : @"lim", @"ln" : @"lin", @"lo" : @"lao", @"lt" : @"lit", @"lu" : @"lub", @"lv" : @"lav", @"mg" : @"mlg", @"mh" : @"mah", @"mi" : @"mao", @"mi" : @"mao", @"mk" : @"mac", @"mk" : @"mac", @"ml" : @"mal", @"mn" : @"mon", @"mr" : @"mar", @"ms" : @"may", @"ms" : @"may", @"mt" : @"mlt", @"my" : @"bur", @"my" : @"bur", @"na" : @"nau", @"nb" : @"nob", @"nd" : @"nde", @"ne" : @"nep", @"ng" : @"ndo", @"nl" : @"dut", @"nl" : @"dut", @"nn" : @"nno", @"no" : @"nor", @"nr" : @"nbl", @"nv" : @"nav", @"ny" : @"nya", @"oc" : @"oci", @"oj" : @"oji", @"om" : @"orm", @"or" : @"ori", @"os" : @"oss", @"pa" : @"pan", @"pi" : @"pli", @"pl" : @"pol", @"ps" : @"pus", @"pt" : @"por", @"qu" : @"que", @"rm" : @"roh", @"rn" : @"run", @"ro" : @"rum", @"ro" : @"rum", @"ru" : @"rus", @"rw" : @"kin", @"sa" : @"san", @"sc" : @"srd", @"sd" : @"snd", @"se" : @"sme", @"sg" : @"sag", @"si" : @"sin", @"sk" : @"slo", @"sk" : @"slo", @"sl" : @"slv", @"sm" : @"smo", @"sn" : @"sna", @"so" : @"som", @"sq" : @"alb", @"sq" : @"alb", @"sr" : @"srp", @"ss" : @"ssw", @"st" : @"sot", @"su" : @"sun", @"sv" : @"swe", @"sw" : @"swa", @"ta" : @"tam", @"te" : @"tel", @"tg" : @"tgk", @"th" : @"tha", @"ti" : @"tir", @"tk" : @"tuk", @"tl" : @"tgl", @"tn" : @"tsn", @"to" : @"ton", @"tr" : @"tur", @"ts" : @"tso", @"tt" : @"tat", @"tw" : @"twi", @"ty" : @"tah", @"ug" : @"uig", @"uk" : @"ukr", @"ur" : @"urd", @"uz" : @"uzb", @"ve" : @"ven", @"vi" : @"vie", @"vo" : @"vol", @"wa" : @"wln", @"wo" : @"wol", @"xh" : @"xho", @"yi" : @"yid", @"yo" : @"yor", @"za" : @"zha", @"zh" : @"chi", @"zh" : @"chi", @"zu" : @"zul"};

    NSMutableArray *tmp = [NSMutableArray new];
    
    for (NSString *twoLetterCode in [NSLocale preferredLanguages])
    {
        NSString *threeLetterCode = iso2LetterTo3Letter[twoLetterCode];
        
        if (threeLetterCode)
            [tmp addObject:threeLetterCode];
        else
        {
            NSDictionary *d = [NSLocale componentsFromLocaleIdentifier:twoLetterCode];
            NSString *backupTwoLetterCode = d[NSLocaleLanguageCode];
            NSString *backupThreeLetterCode = iso2LetterTo3Letter[backupTwoLetterCode];

            [tmp addObject:(OBJECT_OR(backupThreeLetterCode, twoLetterCode))];
        }
    }

    return [NSArray arrayWithArray:tmp];
}


@end



@implementation NSObject (CoreCode)

@dynamic associatedValue, id;


- (void)setAssociatedValue:(id)value forKey:(const NSString *)key
{
#if    TARGET_OS_IPHONE
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-objc-pointer-introspection"
    BOOL is64Bit = sizeof(void *) == 8;
    BOOL isTagged = ((uintptr_t)self & 0x1);
    assert(!(is64Bit && isTagged)); // associated values on tagged pointers broken on 64 bit iOS
#pragma clang diagnostic pop
#endif

    objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_RETAIN);
}

- (id)associatedValueForKey:(const NSString *)key
{
    id value = objc_getAssociatedObject(self, (__bridge const void *)(key));

    return value;
}

- (void)setAssociatedValue:(id)value
{
    [self setAssociatedValue:value forKey:kCoreCodeAssociatedValueKey];
}

- (id)associatedValue
{
    return [self associatedValueForKey:kCoreCodeAssociatedValueKey];
}

+ (instancetype)newWith:(NSDictionary *)dict
{
    NSObject *obj = [self new];
    for (NSString *key in dict)
    {
        [obj setValue:dict[key] forKey:key];
    }

    return obj;
}

- (id)id
{
    return (id)self;
}
@end




@implementation NSCharacterSet (CoreCode)

@dynamic stringRepresentation, stringRepresentationLong, mutableObject;

- (NSString *)stringRepresentation
{
    NSString *tmp = @"";
    unichar unicharBuffer[20];
    NSUInteger index = 0;

    for (unichar uc = 0; uc < (0xFFFF); uc ++)
    {
        if ([self characterIsMember:uc])
        {
            unicharBuffer[index] = uc;

            index ++;

            if (index == 20)
            {
                tmp = [tmp stringByAppendingString:[NSString stringWithCharacters:unicharBuffer length:index]];

                index = 0;
            }
        }
    }

    if (index != 0)
        tmp = [tmp stringByAppendingString:[NSString stringWithCharacters:unicharBuffer length:index]];

    return tmp;
}

- (NSString *)stringRepresentationLong
{
    NSString *tmp = @"";

    for (unichar uc = 0; uc < (0xFFFF); uc++)
    {
        if (uc && [self characterIsMember:uc])
        {
            tmp = [tmp stringByAppendingString:makeString(@"unichar %i: %@\n", uc, [NSString stringWithCharacters:&uc length:1])];
        }
    }

    return tmp;
}

- (NSMutableCharacterSet *)mutableObject
{
    return [NSMutableCharacterSet characterSetWithBitmapRepresentation:self.bitmapRepresentation];
}
@end


@implementation NSMutableCharacterSet (CoreCode)

@dynamic immutableObject;

- (NSCharacterSet *)immutableObject
{
    return [NSCharacterSet characterSetWithBitmapRepresentation:self.bitmapRepresentation];
}
@end


@implementation NSNumber (CoreCode)

@dynamic literalString;

- (NSString *)literalString
{
    return makeString(@"@(%@)", self.description);
}
@end



@implementation NSMutableOrderedSet (CoreCode)

@dynamic immutableObject;

- (NSOrderedSet *)immutableObject
{
    return [NSOrderedSet orderedSetWithOrderedSet:self];
}

@end



@implementation NSOrderedSet (CoreCode)

@dynamic mutableObject;


- (NSMutableOrderedSet *)mutableObject
{
    return [NSMutableOrderedSet orderedSetWithOrderedSet:self];
}


@end



@implementation NSMutableSet (CoreCode)

@dynamic immutableObject;

- (NSSet *)immutableObject
{
    return [NSSet setWithSet:self];
}

@end



@implementation NSSet (CoreCode)

@dynamic mutableObject;

- (NSMutableSet *)mutableObject
{
    return [NSMutableSet setWithSet:self];
}

@end



#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@implementation NSTask (CoreCode)

- (BOOL)waitUntilExitWithTimeout:(NSTimeInterval)timeout
{
    NSDate *killDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
    BOOL killed = NO;
    
    while (self.running)
    {
        if ([[NSDate date] laterDate:killDate] != killDate)
        {
            [self terminate];
            killed = YES;
        }
        [NSThread sleepForTimeInterval:0.05];
    }
    
    return killed;
}

@end



#ifndef SANDBOX

@implementation NSUserDefaults (CoreCode)

- (NSString *)stringForKey:(NSString *)defaultName ofForeignApp:(NSString *)bundleID
{
    if (!bundleID)
    {
        cc_log_error(@"Error: stringForKey:ofForeignApp: called with nil bundleID");
        return nil;
    }
    NSString *result;
    CFPropertyListRef value = CFPreferencesCopyAppValue((CFStringRef)defaultName, (CFStringRef)bundleID);
    
    if (value && CFGetTypeID(value) == CFStringGetTypeID())
    {
        result = [(__bridge NSString *)value copy];
        CFRelease(value);
    }
    else if (value)
        CFRelease(value);

    
    return result;
}
@end
#endif
#endif
