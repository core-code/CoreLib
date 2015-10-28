//
//  Foundation+CoreCode.h
//  CoreLib
//
//  Created by CoreCode on 15.03.12.
/*	Copyright (c) 2015 CoreCode
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
#if (MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7) || (__IPHONE_OS_VERSION_MIN_REQUIRED >= 50000)
@property (readonly, nonatomic) NSData *JSONData;
#endif
@property (readonly, nonatomic) NSString *string;
@property (readonly, nonatomic) NSString *path;
@property (readonly, nonatomic) NSArray <ObjectType> *sorted;
@property (readonly, nonatomic) NSString *literalString;

- (NSArray <ObjectType>*)arrayByAddingNewObject:(ObjectType)anObject;			// adds the object only if it is not identical (contentwise) to existing entry
- (NSArray <ObjectType>*)arrayByRemovingObjectIdenticalTo:(ObjectType)anObject;
- (NSArray <ObjectType>*)arrayByRemovingObjectsIdenticalTo:(NSArray <ObjectType>*)objects;
- (NSArray <ObjectType>*)arrayByRemovingObjectAtIndex:(NSUInteger)index;
- (NSArray <ObjectType>*)arrayByRemovingObjectsAtIndexes:(NSIndexSet *)indexSet;
- (NSArray <ObjectType>*)arrayByReplacingObject:(ObjectType)anObject withObject:(ObjectType)newObject;
- (ObjectType)safeObjectAtIndex:(NSUInteger)index;
- (BOOL)containsDictionaryWithKey:(NSString *)key equalTo:(NSString *)value;
- (NSArray <ObjectType>*)sortedArrayByKey:(NSString *)key;
- (NSArray <ObjectType>*)sortedArrayByKey:(NSString *)key ascending:(BOOL)ascending;
- (BOOL)contains:(ObjectType)object;
- (CCIntRange2D)calculateExtentsOfPoints:(CCIntPoint (^)(ObjectType input))block;
- (CCIntRange1D)calculateExtentsOfValues:(int (^)(ObjectType input))block;

- (NSArray <ObjectType>*)subarrayFromIndex:(NSUInteger)index;
- (NSArray <ObjectType>*)subarrayToIndex:(NSUInteger)index;



#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (NSString *)runAsTask;
- (NSString *)runAsTaskWithTerminationStatus:(NSInteger *)terminationStatus;
#endif
- (NSArray *)mapped:(id (^)(ObjectType input))block;
- (NSArray <ObjectType>*)filtered:(BOOL (^)(ObjectType input))block;
- (NSArray <ObjectType>*)filteredUsingPredicateString:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (NSInteger)reduce:(int (^)(ObjectType input))block;

// versions similar to cocoa methods
- (void)apply:(void (^)(ObjectType input))block;								// enumerateObjectsUsingBlock:

// forwards for less typing
- (NSString *)joined:(NSString *)sep;							// = componentsJoinedByString:

@property (readonly, nonatomic) NSSet <ObjectType> *set;


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
@property (readonly, nonatomic) NSArray <NSString *> *dirContents;
@property (readonly, nonatomic) NSArray <NSString *> *dirContentsRecursive;
@property (readonly, nonatomic) NSArray <NSString *> *dirContentsAbsolute;
@property (readonly, nonatomic) NSArray <NSString *> *dirContentsRecursiveAbsolute;
@property (readonly, nonatomic) NSString *uniqueFile;
@property (readonly, nonatomic) BOOL fileExists;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@property (readonly, nonatomic) BOOL fileIsRestricted;
@property (readonly, nonatomic) BOOL fileIsAlias;
@property (readonly, nonatomic) NSString *fileAliasTarget;
#endif
@property (readonly, nonatomic) unsigned long long fileSize;
@property (readonly, nonatomic) unsigned long long directorySize;
@property (readonly, nonatomic) BOOL isWriteablePath;
@property (readonly, nonatomic) NSRange fullRange;
@property (readonly, nonatomic) NSString *literalString;

@property (readonly, nonatomic) NSString *stringByResolvingSymlinksInPathFixed;

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

@property (readonly, nonatomic) NSString *expanded;						// = stringByExpandingTildeInPath
@property (readonly, nonatomic) NSString *trimmedOfWhitespace;
@property (readonly, nonatomic) NSString *trimmedOfWhitespaceAndNewlines;
@property (readonly, nonatomic) NSString *unescaped;
@property (readonly, nonatomic) NSString *escaped; // URL escaping
//@property (readonly, nonatomic) NSString *encoded; // total encoding, wont work with OPEN anymore as it encodes the slashes

@property (readonly, nonatomic) NSMutableString *mutableObject;
#ifdef USE_SECURITY
@property (readonly, nonatomic) NSString *SHA1;
#endif


@property (readonly, nonatomic) NSString *titlecaseString;
@property (readonly, nonatomic) NSString *propercaseString;
@property (readonly, nonatomic) BOOL isIntegerNumber;
@property (readonly, nonatomic) BOOL isIntegerNumberOnly;
@property (readonly, nonatomic) BOOL isFloatNumber;
@property (readonly, nonatomic) BOOL isValidEmail;



@property (readonly, nonatomic) NSData *data;	// data of string contents
@property (readonly, nonatomic) NSData *dataFromHexString;


- (NSArray <NSArray <NSString *> *> *)parsedDSVWithDelimiter:(NSString *)delimiter;

- (NSString *)stringValue;

- (NSUInteger)countOccurencesOfString:(NSString *)str;
- (BOOL)contains:(NSString *)otherString insensitive:(BOOL)insensitive;
- (BOOL)contains:(NSString *)otherString;
- (BOOL)containsAny:(NSArray *)otherStrings;
- (NSString *)stringByReplacingMultipleStrings:(NSDictionary *)replacements;
- (NSString *)clamp:(NSUInteger)maximumLength;
//- (NSString *)arg:(id)arg, ...;



- (NSAttributedString *)hyperlinkWithURL:(NSURL *)url;


- (NSString *)capitalizedStringWithUppercaseWords:(NSArray <NSString *> *)uppercaseWords;
- (NSString *)titlecaseStringWithLowercaseWords:(NSArray <NSString *> *)lowercaseWords andUppercaseWords:(NSArray <NSString *> *)uppercaseWords;

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (CGSize)sizeUsingFont:(NSFont *)font maxWidth:(float)maxWidth;
// FSEvents directory observing
- (void)startObserving:(BasicBlock)block;
- (void)stopObserving;
#endif

- (NSString *)removed:(NSString *)stringToRemove;

// forwards for less typing
- (NSString *)replaced:(NSString *)str1 with:(NSString *)str2;			// = stringByReplacingOccurencesOfString:withString:
- (NSArray <NSString *> *)split:(NSString *)sep;								// = componentsSeparatedByString:



@end


@interface NSMutableString (CoreCode)

@property (readonly, nonatomic) NSString *immutableObject;

@end



@interface NSURL (CoreCode)

- (NSURL *)add:(NSString *)component;
- (void)open;

@property (readonly, nonatomic) BOOL fileIsDirectory;
//@property (readonly, nonatomic) NSString *path;
@property (readonly, nonatomic) NSArray <NSURL *> *dirContents;
@property (readonly, nonatomic) NSArray <NSURL *> *dirContentsRecursive;
@property (readonly, nonatomic) NSURL *uniqueFile;
@property (readonly, nonatomic) BOOL fileExists;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@property (readonly, nonatomic) BOOL fileIsRestricted;
@property (readonly, nonatomic) BOOL fileIsAlias;
@property (readonly, nonatomic) NSURL *fileAliasTarget;
#endif
@property (readonly, nonatomic) unsigned long long fileSize;
@property (readonly, nonatomic) unsigned long long directorySize;
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
@property (readonly, nonatomic) NSString *hexString;
#if (MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7) || (__IPHONE_OS_VERSION_MIN_REQUIRED >= 50000)
@property (readonly, nonatomic) NSDictionary *JSONDictionary;
@property (readonly, nonatomic) NSArray *JSONArray;
#endif

#ifdef USE_SNAPPY
@property (readonly, nonatomic) NSData *snappyCompressed;
@property (readonly, nonatomic) NSData *snappyDecompressed;
#endif

#ifdef USE_SECURITY
@property (readonly, nonatomic) NSString *SHA1;
#endif

@end



@interface NSDate (CoreCode)

// date format strings:   dd.MM.yyyy HH:mm:ss
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)dateFormat localeIdentifier:(NSString *)localeIdentifier;
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)dateFormat;
+ (NSDate *)dateWithPreprocessorDate:(const char *)preprocessorDateString;
- (NSString *)stringUsingFormat:(NSString *)dateFormat;
- (NSString *)stringUsingDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

@end



@interface NSDateFormatter (CoreCode)

+ (NSString *)formattedTimeFromTimeInterval:(NSTimeInterval)timeInterval;

@end



@interface NSDictionary <KeyType, ObjectType>(CoreCode)

#if (MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7) || (__IPHONE_OS_VERSION_MIN_REQUIRED >= 50000)
@property (readonly, nonatomic) NSData *JSONData;
#endif
@property (readonly, nonatomic) NSData *XMLData;
@property (readonly, nonatomic) NSMutableDictionary <KeyType, ObjectType> *mutableObject;
- (NSDictionary *)dictionaryByAddingValue:(ObjectType)value forKey:(KeyType)key;
- (NSDictionary *)dictionaryByRemovingKey:(KeyType)key;
- (NSDictionary *)dictionaryByRemovingKeys:(NSArray <KeyType> *)keys;
@property (readonly, nonatomic) NSString *literalString;

@end


@interface NSMutableDictionary <KeyType, ObjectType>(CoreCode)

@property (readonly, nonatomic) NSDictionary <KeyType, ObjectType> *immutableObject;

@end



@interface NSFileHandle (CoreCode)

- (float)readFloat;
- (int)readInt;

@end



@interface NSLocale (CoreCode)

+ (NSArray <NSString *> *)preferredLanguages3Letter;

@end




@interface NSObject (CoreCode)

@property (readonly, nonatomic) id id;
- (id)associatedValueForKey:(const NSString *)key;
- (void)setAssociatedValue:(id)value forKey:(const NSString *)key;
@property (retain, nonatomic) id associatedValue;
+ (instancetype)newWith:(NSDictionary *)dict;

@end



@interface NSCharacterSet (CoreCode)

@property (readonly, nonatomic) NSMutableCharacterSet *mutableObject;
@property (readonly, nonatomic) NSString *stringRepresentation;

@end

@interface NSMutableCharacterSet (CoreCode)

@property (readonly, nonatomic) NSCharacterSet *immutableObject;

@end



@interface NSNumber (CoreCode)

@property (readonly, nonatomic) NSString *literalString;

@end
