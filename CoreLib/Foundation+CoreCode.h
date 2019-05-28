//
//  Foundation+CoreCode.h
//  CoreLib
//
//  Created by CoreCode on 15.03.12.
/*	Copyright © 2019 CoreCode Limited
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "CoreLib.h"



@interface NSArray <ObjectType> (CoreCode)

@property (readonly, nonatomic) NSArray *flattenedArray;
@property (readonly, nonatomic) NSArray <ObjectType> *reverseArray;
@property (readonly, nonatomic) NSMutableArray <ObjectType> *mutableObject;
@property (readonly, nonatomic) BOOL empty;
@property (readonly, nonatomic) NSData *XMLData;
@property (readonly, nonatomic) NSData *JSONData;
@property (readonly, nonatomic) NSString *string;
@property (readonly, nonatomic) NSString *path;
@property (readonly, nonatomic) NSArray <ObjectType> *sorted;
@property (readonly, nonatomic) NSString *literalString;
@property (readonly, nonatomic) NSDictionary *dictionary; // will yield a dictionary that has the array contents as keys and @(1) as objects

- (NSArray <ObjectType>*)arrayByAddingNewObject:(ObjectType)anObject;			// adds the object only if it is not identical (contentwise) to existing entry
- (NSArray <ObjectType>*)arrayByDeletingObjectIdenticalTo:(ObjectType)anObject;
- (NSArray <ObjectType>*)arrayByDeletingObjectsIdenticalTo:(NSArray <ObjectType>*)objects;
- (NSArray <ObjectType>*)arrayByDeletingObjectAtIndex:(NSUInteger)index;
- (NSArray <ObjectType>*)arrayByDeletingObjectsAtIndexes:(NSIndexSet *)indexSet;
- (NSArray <ObjectType>*)arrayByReplacingObject:(ObjectType)anObject withObject:(ObjectType)newObject;
- (ObjectType)safeObjectAtIndex:(NSUInteger)index;
- (BOOL)containsDictionaryWithKey:(NSString *)key equalTo:(NSString *)value;
- (NSArray <ObjectType>*)sortedArrayByKey:(NSString *)key;
- (NSArray <ObjectType>*)sortedArrayByKey:(NSString *)key ascending:(BOOL)ascending;
- (BOOL)contains:(ObjectType)object;                                // shortcut = containsObject
- (BOOL)containsObjectIdenticalTo:(ObjectType)object;               // similar: indexOfObjectIdenticalTo != NSNotFound

- (CCIntRange2D)calculateExtentsOfPoints:(CCIntPoint (^)(ObjectType input))block;
- (CCIntRange1D)calculateExtentsOfValues:(int (^)(ObjectType input))block;



- (NSArray <ObjectType>*)subarrayFromIndex:(NSUInteger)index;       //  containing the characters of the receiver from the one at anIndex to the end (DOES include index)  similar to -[NSString subarrayFromIndex:]
- (NSArray <ObjectType>*)subarrayToIndex:(NSUInteger)index;         //  containing the characters of the receiver up to, but not including, the one at anIndex. (does NOT include index) similar to -[NSString substringToIndex:]
- (NSArray <ObjectType>*)slicingSubarrayToIndex:(NSInteger)index;


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSString *)runAsTask;
- (NSString *)runAsTaskWithTerminationStatus:(NSInteger *)terminationStatus usePolling:(BOOL)usePollingToAvoidRunloop;
- (NSString *)runAsTaskWithProgressBlock:(StringInBlock)progressBlock;
- (NSString *)runAsTaskWithProgressBlock:(StringInBlock)progressBlock terminationStatus:(NSInteger *)terminationStatus;
#endif
- (NSArray *)mapped:(id (^)(ObjectType input))block;
- (NSArray <ObjectType>*)filtered:(BOOL (^)(ObjectType input))block;
- (NSArray <ObjectType>*)filteredUsingPredicateString:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (NSInteger)reduce:(int (^)(ObjectType input))block;

// versions similar to cocoa methods
- (void)apply:(void (^)(ObjectType input))block;				// similar = enumerateObjectsUsingBlock:

// forwards for less typing
- (NSString *)joined:(NSString *)sep;							// shortcut = componentsJoinedByString:

@property (readonly, nonatomic) NSSet <ObjectType> *set;
@property (readonly, nonatomic) NSOrderedSet <ObjectType> *orderedSet;

@property (readonly, nonatomic) ObjectType mostFrequentObject;
@property (readonly, nonatomic) ObjectType randomObject;

@end



@interface NSMutableArray <ObjectType>(CoreCode)

@property (readonly, nonatomic) NSArray <ObjectType> *immutableObject;

- (void)addNewObject:(ObjectType)anObject;
- (void)addObjectSafely:(ObjectType)anObject;
- (void)map:(ObjectType (^)(ObjectType input))block;
- (void)filter:(int (^)(ObjectType input))block;
- (void)filterUsingPredicateString:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (void)removeFirstObject;
- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)removeObjectPassingTest:(int (^)(ObjectType input))block;

@end



@interface NSString (CoreCode)

// filesystem support
@property (readonly, nonatomic) NSArray <NSString *> *directoryContents;
@property (readonly, nonatomic) NSArray <NSString *> *directoryContentsRecursive;
@property (readonly, nonatomic) NSArray <NSString *> *directoryContentsAbsolute;
@property (readonly, nonatomic) NSArray <NSString *> *directoryContentsRecursiveAbsolute;
@property (readonly, nonatomic) NSString *uniqueFile;
@property (readonly, nonatomic) BOOL fileExists;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@property (readonly, nonatomic) BOOL fileIsRestricted;
@property (readonly, nonatomic) BOOL fileIsAlias;
@property (readonly, nonatomic) BOOL fileIsSymlink;
@property (readonly, nonatomic) NSString *fileAliasTarget;
#endif
@property (readonly, nonatomic) unsigned long long fileSize;
@property (readonly, nonatomic) unsigned long long directorySize;
@property (readonly, nonatomic) BOOL isWriteablePath;
@property (readonly, nonatomic) NSString *stringByResolvingSymlinksInPathFixed;



@property (readonly, nonatomic) NSRange fullRange;
@property (readonly, nonatomic) NSString *literalString;


// path string to url
@property (readonly, nonatomic) NSURL *fileURL;
@property (readonly, nonatomic) NSURL *URL;
// url string download
@property (readonly, nonatomic) NSData *download;
// path string filedata
@property (assign, nonatomic) NSData *contents;



// NSUserDefaults support
@property (copy, nonatomic) id defaultObject;
@property (copy, nonatomic) NSString *defaultString;
@property (copy, nonatomic) NSArray *defaultArray;
@property (copy, nonatomic) NSDictionary *defaultDict;
@property (copy, nonatomic) NSURL *defaultURL;
@property (assign, nonatomic) NSInteger defaultInt;
@property (assign, nonatomic) float defaultFloat;


@property (readonly, nonatomic) NSString *localized;

//  bundle contents to path
@property (readonly, nonatomic) NSString *resourcePath;
@property (readonly, nonatomic) NSURL *resourceURL;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@property (readonly, nonatomic) NSImage *namedImage;
#else
@property (readonly, nonatomic) UIImage *namedImage;
#endif

// string things
@property (readonly, nonatomic) NSArray <NSString *> *lines;
@property (readonly, nonatomic) NSArray <NSString *> *words;
@property (readonly, nonatomic) unichar firstCharacter;
@property (readonly, nonatomic) unichar lastCharacter;

@property (readonly, nonatomic) NSString *expanded;						// shortcut = stringByExpandingTildeInPath
@property (readonly, nonatomic) NSString *strippedOfWhitespace;     // deletes from interior of string too, in contrast to TRIMMING which deletes only from front and back ... shortcut for stringByDeletingCharactersInSet:whitespaceCharSet
@property (readonly, nonatomic) NSString *trimmedOfWhitespace;
@property (readonly, nonatomic) NSString *trimmedOfWhitespaceAndNewlines;
@property (readonly, nonatomic) NSString *unescaped;
@property (readonly, nonatomic) NSString *escaped; // URL escaping
@property (readonly, nonatomic) NSString *encoded; // total encoding, wont work with OPEN anymore as it encodes everything except numbers and letters, useful for single CGI params

@property (readonly, nonatomic) NSMutableString *mutableObject;

@property (readonly, nonatomic) NSString *rot13;
#ifdef USE_SECURITY
@property (readonly, nonatomic) NSString *SHA1;
#endif
@property (readonly, nonatomic) NSString *language;


@property (readonly, nonatomic) NSString *titlecaseString;
@property (readonly, nonatomic) NSString *propercaseString;
@property (readonly, nonatomic) BOOL isIntegerNumber;
@property (readonly, nonatomic) BOOL isIntegerNumberOnly;
@property (readonly, nonatomic) BOOL isFloatNumber;
@property (readonly, nonatomic) BOOL isValidEmail;
@property (readonly, nonatomic) BOOL isValidEmails;
@property (readonly, nonatomic) BOOL isNumber;

@property (readonly, nonatomic) NSData *data;	// data of string contents
@property (readonly, nonatomic) NSData *dataFromHexString;
@property (readonly, nonatomic) NSData *dataFromBase64String;

@property (readonly, nonatomic) NSCharacterSet *characterSet;


- (NSArray <NSArray <NSString *> *> *)parsedDSVWithDelimiter:(NSString *)delimiter;

- (NSString *)stringValue;

- (NSUInteger)count:(NSString *)str; // peviously called countOccurencesOfString
- (BOOL)contains:(NSString *)otherString insensitive:(BOOL)insensitive;         // similar: rangeOfString options != NSNotFound
- (BOOL)contains:(NSString *)otherString;                                       // similar: rangeOfString != NSNotFound
- (BOOL)hasAnyPrefix:(NSArray <NSString *>*)possiblePrefixes;
- (BOOL)hasAnySuffix:(NSArray <NSString *>*)possibleSuffixes;
- (BOOL)containsAny:(NSArray <NSString *>*)otherStrings;
- (BOOL)containsAny:(NSArray <NSString *>*)otherStrings insensitive:(BOOL)insensitive;
- (BOOL)containsAll:(NSArray <NSString *>*)otherStrings;
- (BOOL)equalsAny:(NSArray <NSString *>*)otherStrings;
- (NSString *)stringByReplacingMultipleStrings:(NSDictionary <NSString *, NSString *>*)replacements;
- (NSString *)clamp:(NSUInteger)maximumLength;

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSAttributedString *)attributedStringWithColor:(NSColor *)color;
#endif
- (NSAttributedString *)attributedStringWithHyperlink:(NSURL *)url;

- (NSString *)capitalizedStringWithUppercaseWords:(NSArray <NSString *> *)uppercaseWords;
- (NSString *)titlecaseStringWithLowercaseWords:(NSArray <NSString *> *)lowercaseWords andUppercaseWords:(NSArray <NSString *> *)uppercaseWords;

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByDeletingCharactersInSet:(NSCharacterSet *)characterSet;


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (CGSize)sizeUsingFont:(NSFont *)font maxWidth:(CGFloat)maxWidth;
// FSEvents directory observing
- (NSValue *)startObserving:(ObjectInBlock)block withFileLevelEvents:(BOOL)fileLevelEvents;
- (void)stopObserving:(NSValue *)token;
#endif

- (NSString *)removed:(NSString *)stringToRemove;

- (NSString *)slicingSubstringToIndex:(NSInteger)index;  // index should be negative and tell how many chars to remove -1 removes one char from the end


// forwards for less typing
- (NSString *)replaced:(NSString *)str1 with:(NSString *)str2;			// shortcut = stringByReplacingOccurencesOfString:withString:
- (NSArray <NSString *> *)split:(NSString *)sep;						// shortcut = componentsSeparatedByString:
- (NSString *)appended:(NSString *)str;                                 // shortcut = stringByAppendingString

@end



@interface NSMutableString (CoreCode)

@property (readonly, nonatomic) NSString *immutableObject;

@end



@interface NSURL (CoreCode)

+ (NSURL *)URLWithHost:(NSString *)host path:(NSString *)path query:(NSString *)query;
+ (NSURL *)URLWithHost:(NSString *)host path:(NSString *)path query:(NSString *)query user:(NSString *)user password:(NSString *)password fragment:(NSString *)fragment scheme:(NSString *)scheme port:(NSNumber *)port;
- (NSData *)performBlockingPOST:(double)timeoutSeconds;
- (NSData *)performBlockingGET:(double)timeoutSeconds;
- (void)performGET:(void (^)(NSData *data))completion;
- (void)performPOST:(void (^)(NSData *data))completion;

- (NSData *)readFileHeader:(NSUInteger)maximumByteCount;

- (NSURL *)add:(NSString *)component;
- (void)open;

@property (readonly, nonatomic) BOOL fileIsDirectory;
//@property (readonly, nonatomic) NSString *path;
@property (readonly, nonatomic) NSArray <NSURL *> *directoryContents;
@property (readonly, nonatomic) NSArray <NSURL *> *directoryContentsRecursive;
@property (readonly, nonatomic) NSURL *uniqueFile;
@property (readonly, nonatomic) BOOL fileExists;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@property (readonly, nonatomic) BOOL fileIsRestricted;
@property (readonly, nonatomic) BOOL fileIsAlias;
@property (readonly, nonatomic) BOOL fileIsSymlink;
@property (readonly, nonatomic) NSURL *fileAliasTarget;
#endif
@property (readonly, nonatomic) NSDate *fileCreationDate;
@property (readonly, nonatomic) unsigned long long fileSize;
@property (readonly, nonatomic) unsigned long long fileOrDirectorySize;
@property (readonly, nonatomic) unsigned long long directorySize;

@property (readonly, nonatomic) NSString *fileChecksumSHA;


@property (readonly, nonatomic) NSURLRequest *request;
@property (readonly, nonatomic) NSMutableURLRequest *mutableRequest;
@property (readonly, nonatomic) BOOL isWriteablePath;
// url string download
@property (readonly, nonatomic) NSData *download;
// path string filedata
@property (assign, nonatomic) NSData *contents;

@end



@interface NSData (CoreCode)

@property (readonly, nonatomic) NSMutableData *mutableObject;
@property (readonly, nonatomic) NSString *string;
@property (readonly, nonatomic) NSString *stringUTF8;
@property (readonly, nonatomic) NSString *hexString;
@property (readonly, nonatomic) NSString *base64String;
@property (readonly, nonatomic) NSDictionary *JSONDictionary;
@property (readonly, nonatomic) NSArray *JSONArray;
#ifdef USE_SNAPPY
@property (readonly, nonatomic) NSData *snappyCompressed;
@property (readonly, nonatomic) NSData *snappyDecompressed;
#endif
#ifdef USE_SECURITY
@property (readonly, nonatomic) NSString *SHA1;
@property (readonly, nonatomic) NSString *MD5;
@property (readonly, nonatomic) NSString *SHA256;
#endif

@end



@interface NSDate (CoreCode)

// date format strings:   dd.MM.yyyy HH:mm:ss
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)dateFormat localeIdentifier:(NSString *)localeIdentifier;
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)dateFormat;
+ (NSDate *)dateWithPreprocessorDate:(const char *)preprocessorDateString;
+ (NSDate *)dateWithRFC822Date:(NSString *)rfcDateString;
+ (NSDate *)dateWithISO8601Date:(NSString *)iso8601DateString;
- (NSString *)stringUsingFormat:(NSString *)dateFormat;
- (NSString *)stringUsingFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone;
- (NSString *)stringUsingDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

@end



@interface NSDateFormatter (CoreCode)

+ (NSString *)formattedTimeFromTimeInterval:(NSTimeInterval)timeInterval;

@end



@interface NSDictionary <KeyType, ObjectType>(CoreCode)

@property (readonly, nonatomic) NSString *literalString;
@property (readonly, nonatomic) NSData *JSONData;
@property (readonly, nonatomic) NSData *XMLData;
@property (readonly, nonatomic) NSMutableDictionary <KeyType, ObjectType> *mutableObject;
- (NSDictionary *)dictionaryBySettingValue:(ObjectType)value forKey:(KeyType)key; // does replace too
- (NSDictionary *)dictionaryByDeletingKey:(KeyType)key;
- (NSDictionary *)dictionaryByDeletingKeys:(NSArray <KeyType> *)keys;
- (NSDictionary *)dictionaryByReplacingNSNullWithEmptyStrings;
- (BOOL)containsAny:(NSArray <NSString *>*)keys;
- (BOOL)containsAll:(NSArray <NSString *>*)keys;

@end


@interface NSMutableDictionary <KeyType, ObjectType>(CoreCode)

@property (readonly, nonatomic) NSDictionary <KeyType, ObjectType> *immutableObject;

// 'defaultdict'
- (void)addObject:(id)object toMutableArrayAtKey:(KeyType)key; // the point here is that it will add a mutablearray with the single object if the key doesn't exist - a poor mans 'defaultdict'

@end



@interface NSFileHandle (CoreCode)

- (float)readFloat;
- (int)readInt;

@end



@interface NSLocale (CoreCode)

+ (NSArray <NSString *> *)preferredLanguages2Letter;
+ (NSArray <NSString *> *)preferredLanguages3Letter;

@end



@interface NSObject (CoreCode)

@property (readonly, nonatomic) id id;
@property (retain, nonatomic) id associatedValue;
- (id)associatedValueForKey:(const NSString *)key;
- (void)setAssociatedValue:(id)value forKey:(const NSString *)key;
+ (instancetype)newWith:(NSDictionary *)dict;
@property (readonly, nonatomic) NSString *literalString;

@end



@interface NSCharacterSet (CoreCode)

@property (readonly, nonatomic) NSMutableCharacterSet *mutableObject;
@property (readonly, nonatomic) NSString *stringRepresentation;
@property (readonly, nonatomic) NSString *stringRepresentationLong;

@end



@interface NSMutableCharacterSet (CoreCode)

@property (readonly, nonatomic) NSCharacterSet *immutableObject;

@end



@interface NSNumber (CoreCode)

@property (readonly, nonatomic) NSString *literalString;

@end



@interface NSMutableOrderedSet <ObjectType> (CoreCode)

@property (readonly, nonatomic) NSOrderedSet <ObjectType> *immutableObject;

@end



@interface NSOrderedSet <ObjectType> (CoreCode)

@property (readonly, nonatomic) NSMutableOrderedSet <ObjectType> *mutableObject;

@end



@interface NSMutableSet <ObjectType> (CoreCode)

@property (readonly, nonatomic) NSSet <ObjectType> *immutableObject;

@end



@interface NSSet <ObjectType> (CoreCode)

@property (readonly, nonatomic) NSMutableSet <ObjectType> *mutableObject;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@interface NSTask (CoreCode)

- (BOOL)waitUntilExitWithTimeout:(NSTimeInterval)timeout;

@end

#ifndef SANDBOX
@interface NSUserDefaults (CoreCode)

- (NSString *)stringForKey:(NSString *)defaultName ofForeignApp:(NSString *)bundleID;

@end
#endif
#endif
