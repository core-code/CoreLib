//
//  Foundation+Properties.h
//  CoreLib
//
//  Created by CoreCode on 09.02.14.
/*	Copyright (c) 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "CoreLib.h"


@interface NSInvocationOperation (FProperties)

@property (readonly, nonatomic) NSInvocation *invocation;
@property (readonly, nonatomic) id result;

@end


@interface NSStream (FProperties)

@property (readonly, nonatomic) NSError *streamError;
@property (readonly, nonatomic) NSStreamStatus streamStatus;
@property (assign, nonatomic) id <NSStreamDelegate> delegate;

@end


@interface NSPort (FProperties)

@property (readonly, nonatomic) BOOL isValid;
@property (assign, nonatomic) id <NSPortDelegate> delegate;
@property (readonly, nonatomic) NSUInteger reservedSpaceLength;

@end


@interface NSString (FProperties)

@property (readonly, nonatomic) NSString *stringByStandardizingPath;
@property (readonly, nonatomic) NSArray *pathComponents;
@property (readonly, nonatomic) BOOL isAbsolutePath;
@property (readonly, nonatomic) NSDictionary *propertyListFromStringsFileFormat;
@property (readonly, nonatomic) NSString *decomposedStringWithCanonicalMapping;
@property (readonly, nonatomic) NSStringEncoding smallestEncoding;
@property (readonly, nonatomic) NSString *uppercaseString;
@property (readonly, nonatomic) double doubleValue;
@property (readonly, nonatomic) NSStringEncoding fastestEncoding;
@property (readonly, nonatomic) NSString *decomposedStringWithCompatibilityMapping;
@property (readonly, nonatomic) NSString *precomposedStringWithCanonicalMapping;
@property (readonly, nonatomic) NSString *stringByResolvingSymlinksInPath;
@property (readonly, nonatomic) NSString *lowercaseString;
@property (readonly, nonatomic) NSString *pathExtension;
@property (readonly, nonatomic) NSString *precomposedStringWithCompatibilityMapping;
@property (readonly, nonatomic) NSUInteger hash;
@property (readonly, nonatomic) NSString *description;
@property (readonly, nonatomic) NSString *lastPathComponent;
@property (readonly, nonatomic) float floatValue;
@property (readonly, nonatomic) NSString *stringByDeletingPathExtension;
@property (readonly, nonatomic) int intValue;
@property (readonly, nonatomic) NSString *stringByExpandingTildeInPath;
@property (readonly, nonatomic) NSString *capitalizedString;
@property (readonly, nonatomic) id propertyList;
@property (readonly, nonatomic) NSUInteger length;
@property (readonly, nonatomic) NSString *stringByDeletingLastPathComponent;
@property (readonly, nonatomic) NSString *stringByAbbreviatingWithTildeInPath;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@interface NSConnection (FProperties)

@property (readonly, nonatomic) NSDistantObject *rootProxy;
@property (readonly, nonatomic) NSDictionary *statistics;
@property (readonly, nonatomic) BOOL multipleThreadsEnabled;
@property (readonly, nonatomic) NSArray *requestModes;
@property (assign, nonatomic) NSTimeInterval replyTimeout;
@property (assign, nonatomic) NSTimeInterval requestTimeout;
@property (readonly, nonatomic) NSPort *sendPort;
@property (strong, nonatomic) id rootObject;
@property (readonly, nonatomic) NSPort *receivePort;
@property (assign, nonatomic) id <NSConnectionDelegate> delegate;
@property (readonly, nonatomic) BOOL isValid;
@property (readonly, nonatomic) NSArray *remoteObjects;
@property (assign, nonatomic) BOOL independentConversationQueueing;
@property (readonly, nonatomic) NSArray *localObjects;

@end
#endif

@interface NSUserDefaults (FProperties)

@property (readonly, nonatomic) BOOL synchronize;
@property (readonly, nonatomic) NSDictionary *dictionaryRepresentation;
@property (readonly, nonatomic) NSArray *volatileDomainNames;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSXMLDTDNode (FProperties)

@property (copy, nonatomic) NSString *systemID;
@property (copy, nonatomic) NSString *notationName;
@property (copy, nonatomic) NSString *publicID;
@property (assign, nonatomic) NSXMLDTDNodeKind DTDKind;
@property (readonly, nonatomic) BOOL isExternal;

@end
#endif

@interface NSCompoundPredicate (FProperties)

@property (readonly, nonatomic) NSArray *subpredicates;
@property (readonly, nonatomic) NSCompoundPredicateType compoundPredicateType;

@end


@interface NSPointerArray (FProperties)

@property (assign, nonatomic) NSUInteger count;
@property (readonly, nonatomic) NSArray *allObjects;
@property (readonly, nonatomic) NSPointerFunctions *pointerFunctions;

@end


@interface NSProcessInfo (FProperties)

@property (readonly, nonatomic) NSString *hostName;
@property (readonly, nonatomic) NSString *operatingSystemVersionString;
@property (readonly, nonatomic) NSDictionary *environment;
@property (copy, nonatomic) NSString *processName;
@property (readonly, nonatomic) int processIdentifier;
@property (readonly, nonatomic) NSString *operatingSystemName;
@property (readonly, nonatomic) NSArray *arguments;
@property (readonly, nonatomic) NSString *globallyUniqueString;
@property (readonly, nonatomic) NSUInteger operatingSystem;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSScriptClassDescription (FProperties)

@property (readonly, nonatomic) FourCharCode appleEventCode;
@property (readonly, nonatomic) NSString *implementationClassName;
@property (readonly, nonatomic) NSString *defaultSubcontainerAttributeKey;
@property (readonly, nonatomic) NSString *suiteName;
@property (readonly, nonatomic) NSString *className;
@property (readonly, nonatomic) NSScriptClassDescription *superclassDescription;

@end

#endif


@interface NSDate (FProperties)

@property (readonly, nonatomic) NSTimeInterval timeIntervalSinceReferenceDate;
@property (readonly, nonatomic) NSString *description;
@property (readonly, nonatomic) NSTimeInterval timeIntervalSinceNow;

@end


@interface NSData (FProperties)

@property (readonly, nonatomic) NSUInteger length;
@property (readonly, nonatomic) const void *bytes;
@property (readonly, nonatomic) NSString *description;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSScriptCommand (FProperties)

@property (readonly, nonatomic) id evaluatedReceivers;
@property (strong, nonatomic) id directParameter;
@property (readonly, nonatomic) NSDictionary *evaluatedArguments;
@property (readonly, nonatomic) id performDefaultImplementation;
@property (readonly, nonatomic) id executeCommand;
@property (copy, nonatomic) NSString *scriptErrorString;
@property (readonly, nonatomic) NSScriptCommandDescription *commandDescription;
@property (assign, nonatomic) int scriptErrorNumber;
@property (strong, nonatomic) NSScriptObjectSpecifier *receiversSpecifier;
@property (readonly, nonatomic) BOOL isWellFormed;
@property (readonly, nonatomic) NSAppleEventDescriptor *appleEvent;
@property (strong, nonatomic) NSDictionary *arguments;

@end


@interface NSXMLElement (FProperties)

@property (strong, nonatomic) NSArray *attributes;
@property (strong, nonatomic) NSDictionary *attributesAsDictionary;
- (NSDictionary *)attributesAsDictionary UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSArray *children;
- (NSArray *)children UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSArray *namespaces;
@property (strong, nonatomic) NSDictionary *attributesWithDictionary;
- (NSDictionary *)attributesWithDictionary UNAVAILABLE_ATTRIBUTE;

@end
#endif

@interface NSMutableURLRequest (FProperties)

@property (assign, nonatomic) NSTimeInterval timeoutInterval;
- (NSTimeInterval)timeoutInterval UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSDictionary *allHTTPHeaderFields;
- (NSDictionary *)allHTTPHeaderFields UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSURL *URL;
- (NSURL *)URL UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSData *HTTPBody;
- (NSData *)HTTPBody UNAVAILABLE_ATTRIBUTE;
@property (copy, nonatomic) NSString *HTTPMethod;
- (NSString *)HTTPMethod UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSInputStream *HTTPBodyStream;
- (NSInputStream *)HTTPBodyStream UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) BOOL HTTPShouldHandleCookies;
- (BOOL)HTTPShouldHandleCookies UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSURL *mainDocumentURL;
- (NSURL *)mainDocumentURL UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) NSURLRequestCachePolicy cachePolicy;
- (NSURLRequestCachePolicy)cachePolicy UNAVAILABLE_ATTRIBUTE;

@end


@interface NSProxy (FProperties)

@property (readonly, nonatomic) NSString *debugDescription;
@property (readonly, nonatomic) NSString *description;

@end


#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
@interface NSUbiquitousKeyValueStore (FProperties)

@property (readonly, nonatomic) BOOL synchronize;
@property (readonly, nonatomic) NSDictionary *dictionaryRepresentation;

@end
#endif


@interface NSMetadataQueryResultGroup (FProperties)

@property (readonly, nonatomic) NSString *attribute;
@property (readonly, nonatomic) NSUInteger resultCount;
@property (readonly, nonatomic) NSArray *results;
@property (readonly, nonatomic) id value;
@property (readonly, nonatomic) NSArray *subgroups;

@end


@interface NSPipe (FProperties)

@property (readonly, nonatomic) NSFileHandle *fileHandleForReading;
@property (readonly, nonatomic) NSFileHandle *fileHandleForWriting;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSHost (FProperties)

@property (readonly, nonatomic) NSString *address;
@property (readonly, nonatomic) NSArray *addresses;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSArray *names;

@end


@interface NSNameSpecifier (FProperties)

@property (copy, nonatomic) NSString *name;

@end

#endif


@interface NSMetadataItem (FProperties)

@property (readonly, nonatomic) NSArray *attributes;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSAppleEventDescriptor (FProperties)

@property (readonly, nonatomic) AEEventID eventID;
@property (readonly, nonatomic) AEReturnID returnID;
@property (readonly, nonatomic) AETransactionID transactionID;
@property (readonly, nonatomic) OSType enumCodeValue;
@property (readonly, nonatomic) OSType typeCodeValue;
@property (readonly, nonatomic) id initListDescriptor;
@property (readonly, nonatomic) NSInteger numberOfItems;
@property (readonly, nonatomic) id initRecordDescriptor;
@property (readonly, nonatomic) const AEDesc *aeDesc;
@property (readonly, nonatomic) NSString *stringValue;
@property (readonly, nonatomic) AEEventClass eventClass;
@property (readonly, nonatomic) Boolean booleanValue;
@property (readonly, nonatomic) NSData *data;
@property (readonly, nonatomic) DescType descriptorType;

@end


@interface NSURLDownload (FProperties)

@property (assign, nonatomic) BOOL deletesFileUponFailure;
@property (readonly, nonatomic) NSData *resumeData;
@property (readonly, nonatomic) NSURLRequest *request;

@end

#endif

@interface NSInputStream (FProperties)

@property (readonly, nonatomic) BOOL hasBytesAvailable;

@end


@interface NSCoder (FProperties)

@property (readonly, nonatomic) NSData *decodeDataObject;
@property (readonly, nonatomic) id decodePropertyList;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@property (readonly, nonatomic) NSRect decodeRect;
@property (readonly, nonatomic) NSPoint decodePoint;
@property (readonly, nonatomic) NSSize decodeSize;
#endif
@property (readonly, nonatomic) id decodeObject;

@property (readonly, nonatomic) unsigned systemVersion;
@property (readonly, nonatomic) BOOL allowsKeyedCoding;

@end


@interface NSURLCache (FProperties)

@property (readonly, nonatomic) NSUInteger currentMemoryUsage;
@property (assign, nonatomic) NSUInteger memoryCapacity;
@property (readonly, nonatomic) NSUInteger currentDiskUsage;
@property (assign, nonatomic) NSUInteger diskCapacity;

@end


@interface NSDateComponents (FProperties)

@property (assign, nonatomic) NSInteger hour;
@property (assign, nonatomic) NSInteger weekdayOrdinal;
@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger second;
@property (assign, nonatomic) NSInteger era;
@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger minute;
@property (assign, nonatomic) NSInteger weekday;

@end


@interface NSHTTPCookie (FProperties)

@property (readonly, nonatomic) NSString *comment;
@property (readonly, nonatomic) NSString *domain;
@property (readonly, nonatomic) BOOL isSecure;
@property (readonly, nonatomic) BOOL isHTTPOnly;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) BOOL isSessionOnly;
@property (readonly, nonatomic) NSArray *portList;
@property (readonly, nonatomic) NSDate *expiresDate;
@property (readonly, nonatomic) NSString *value;
@property (readonly, nonatomic) NSURL *commentURL;
@property (readonly, nonatomic) NSUInteger version;
@property (readonly, nonatomic) NSString *path;
@property (readonly, nonatomic) NSDictionary *properties;

@end


@interface NSDateFormatter (FProperties)

@property (strong, nonatomic) NSDate *defaultDate;
@property (strong, nonatomic) NSArray *shortMonthSymbols;
@property (strong, nonatomic) NSArray *eraSymbols;
@property (copy, nonatomic) NSString *AMSymbol;
@property (assign, nonatomic) NSDateFormatterStyle timeStyle;
@property (strong, nonatomic) NSLocale *locale;
@property (assign, nonatomic) NSDateFormatterStyle dateStyle;
@property (copy, nonatomic) NSString *dateFormat;
@property (copy, nonatomic) NSString *PMSymbol;
@property (assign, nonatomic) NSDateFormatterBehavior formatterBehavior;

@property (strong, nonatomic) NSArray *weekdaySymbols;
@property (strong, nonatomic) NSArray *monthSymbols;
@property (strong, nonatomic) NSArray *shortWeekdaySymbols;
@property (strong, nonatomic) NSTimeZone *timeZone;
@property (strong, nonatomic) NSCalendar *calendar;
@property (assign, nonatomic) BOOL generatesCalendarDates;
@property (strong, nonatomic) NSDate *twoDigitStartDate;
@property (assign, nonatomic, getter=isLenient) BOOL lenient;

@end


@interface NSUndoManager (FProperties)

@property (readonly, nonatomic) BOOL isRedoing;
@property (readonly, nonatomic) NSInteger groupingLevel;
@property (readonly, nonatomic) NSString *undoActionName;
@property (readonly, nonatomic) BOOL isUndoRegistrationEnabled;
@property (readonly, nonatomic) BOOL canUndo;
@property (strong, nonatomic) NSArray *runLoopModes;
@property (assign, nonatomic) NSUInteger levelsOfUndo;
@property (assign, nonatomic) BOOL groupsByEvent;
@property (readonly, nonatomic) NSString *redoMenuItemTitle;
@property (readonly, nonatomic) BOOL isUndoing;
@property (readonly, nonatomic) BOOL canRedo;
@property (copy, nonatomic) NSString *actionName;
- (NSString *)actionName UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSString *redoActionName;
@property (readonly, nonatomic) NSString *undoMenuItemTitle;

@end


@interface NSTimer (FProperties)

@property (strong, nonatomic) NSDate *fireDate;
@property (readonly, nonatomic) NSTimeInterval timeInterval;
@property (readonly, nonatomic) id userInfo;
@property (readonly, nonatomic) BOOL isValid;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSRangeSpecifier (FProperties)

@property (strong, nonatomic) NSScriptObjectSpecifier *endSpecifier;
@property (strong, nonatomic) NSScriptObjectSpecifier *startSpecifier;

@end

#endif

@interface NSNetService (FProperties)

@property (readonly, nonatomic) NSData *TXTRecordData;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSQuitCommand (FProperties)

@property (readonly, nonatomic) NSSaveOptions saveOptions;

@end
#endif

@interface NSURLResponse (FProperties)

@property (readonly, nonatomic) NSURL *URL;
@property (readonly, nonatomic) NSString *MIMEType;
@property (readonly, nonatomic) long long expectedContentLength;
@property (readonly, nonatomic) NSString *suggestedFilename;
@property (readonly, nonatomic) NSString *textEncodingName;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE


@interface NSAffineTransform (FProperties)

@property (assign, nonatomic) NSAffineTransformStruct transformStruct;

@end


@interface NSMoveCommand (FProperties)

@property (readonly, nonatomic) NSScriptObjectSpecifier *keySpecifier;

@end

#endif


@interface NSCharacterSet (FProperties)

@property (readonly, nonatomic) NSCharacterSet *invertedSet;
@property (readonly, nonatomic) NSData *bitmapRepresentation;

@end


@interface NSBundle (FProperties)

@property (readonly, nonatomic) BOOL load;
@property (readonly, nonatomic) NSString *builtInPlugInsPath;
@property (readonly, nonatomic) NSString *developmentLocalization;
@property (readonly, nonatomic) NSArray *preferredLocalizations;
@property (readonly, nonatomic) BOOL unload;
@property (readonly, nonatomic) NSString *sharedFrameworksPath;
@property (readonly, nonatomic) NSString *resourcePath;
@property (readonly, nonatomic) NSDictionary *infoDictionary;
@property (readonly, nonatomic) BOOL isLoaded;
@property (readonly, nonatomic) NSArray *localizations;
@property (readonly, nonatomic) NSDictionary *localizedInfoDictionary;
@property (readonly, nonatomic) NSString *privateFrameworksPath;
@property (readonly, nonatomic) NSString *bundleIdentifier;
@property (readonly, nonatomic) Class principalClass;
@property (readonly, nonatomic) NSString *executablePath;
@property (readonly, nonatomic) NSString *sharedSupportPath;
@property (readonly, nonatomic) NSString *bundlePath;

@end


@interface NSMetadataQueryAttributeValueTuple (FProperties)

@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) NSString *attribute;
@property (readonly, nonatomic) id value;

@end


@interface NSObject (FProperties)

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@property (readonly, nonatomic) NSScriptObjectSpecifier *objectSpecifier;
@property (readonly, nonatomic) NSClassDescription *classDescription;
#endif
@property (readonly, nonatomic) NSArray *attributeKeys;
@property (readonly, nonatomic) Class classForPortCoder;
@property (readonly, nonatomic) FourCharCode classCode;
@property (readonly, nonatomic) Class classForArchiver;
@property (strong, nonatomic) NSDictionary *scriptingProperties;
@property (copy, nonatomic) NSString *nilValueForKey;
- (NSString *)nilValueForKey UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) Class classForCoder;
@property (readonly, nonatomic) NSArray *toOneRelationshipKeys;
@property (readonly, nonatomic) NSString *className;
@property (strong, nonatomic) NSDictionary *valuesForKeysWithDictionary;
- (NSDictionary *)valuesForKeysWithDictionary UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSArray *toManyRelationshipKeys;
@property (readonly, nonatomic) Class classForKeyedArchiver;
@property (assign, nonatomic) void *observationInfo;

@end


@interface NSThread (FProperties)

@property (readonly, nonatomic) NSMutableDictionary *threadDictionary;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSIndexSpecifier (FProperties)

@property (assign, nonatomic) NSInteger index;

@end

#endif

@interface NSPredicate (FProperties)

@property (readonly, nonatomic) NSString *predicateFormat;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSWhoseSpecifier (FProperties)

@property (strong, nonatomic) NSScriptWhoseTest *test;
@property (assign, nonatomic) NSInteger startSubelementIndex;
@property (assign, nonatomic) NSWhoseSubelementIdentifier endSubelementIdentifier;
@property (assign, nonatomic) NSInteger endSubelementIndex;
@property (assign, nonatomic) NSWhoseSubelementIdentifier startSubelementIdentifier;

@end


@interface NSUniqueIDSpecifier (FProperties)

@property (strong, nonatomic) id uniqueID;

@end


@interface NSDeleteCommand (FProperties)

@property (readonly, nonatomic) NSScriptObjectSpecifier *keySpecifier;

@end


@interface NSUnarchiver (FProperties)

@property (readonly, nonatomic) BOOL isAtEnd;
@property (readonly, nonatomic) unsigned systemVersion;

@end


@interface NSCloneCommand (FProperties)

@property (readonly, nonatomic) NSScriptObjectSpecifier *keySpecifier;

@end

#endif


@interface NSMutableSet (FProperties)

@property (strong, nonatomic) NSSet *set;
- (NSSet *)set UNAVAILABLE_ATTRIBUTE;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE


@interface NSCreateCommand (FProperties)

@property (readonly, nonatomic) NSDictionary *resolvedKeyDictionary;
@property (readonly, nonatomic) NSScriptClassDescription *createClassDescription;

@end


@interface NSPositionalSpecifier (FProperties)

@property (readonly, nonatomic) NSString *insertionKey;
@property (readonly, nonatomic) BOOL insertionReplaces;
@property (readonly, nonatomic) id insertionContainer;
@property (strong, nonatomic) NSScriptClassDescription *insertionClassDescription;
- (NSScriptClassDescription *)insertionClassDescription UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSInteger insertionIndex;

@end

#endif

@interface NSKeyedUnarchiver (FProperties)

@property (assign, nonatomic) id <NSKeyedUnarchiverDelegate> delegate;

@end


@interface NSMutableAttributedString (FProperties)

@property (readonly, nonatomic) NSMutableString *mutableString;
@property (copy, nonatomic) NSAttributedString *attributedString;
- (NSAttributedString *)attributedString UNAVAILABLE_ATTRIBUTE;

@end


@interface NSAttributedString (FProperties)

@property (readonly, nonatomic) NSUInteger length;
@property (readonly, nonatomic) NSString *string;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSXMLDocument (FProperties)

@property (copy, nonatomic) NSString *MIMEType;
@property (assign, nonatomic) NSXMLDocumentContentKind documentContentKind;
@property (assign, nonatomic, getter=isStandalone) BOOL standalone;
@property (copy, nonatomic) NSString *characterEncoding;
@property (strong, nonatomic) NSXMLDTD *DTD;
@property (strong, nonatomic) NSXMLElement *rootElement;
@property (copy, nonatomic) NSString *version;
@property (readonly, nonatomic) NSData *XMLData;
@property (strong, nonatomic) NSArray *children;
- (NSArray *)children UNAVAILABLE_ATTRIBUTE;

@end


@interface NSAppleScript (FProperties)

@property (readonly, nonatomic) NSString *source;
@property (readonly, nonatomic) BOOL isCompiled;

@end

#endif


@interface NSError (FProperties)

@property (readonly, nonatomic) id recoveryAttempter;
@property (readonly, nonatomic) NSString *domain;
@property (readonly, nonatomic) NSInteger code;
@property (readonly, nonatomic) NSString *localizedDescription;
@property (readonly, nonatomic) NSString *localizedFailureReason;
@property (readonly, nonatomic) NSArray *localizedRecoveryOptions;
@property (readonly, nonatomic) NSString *helpAnchor;
@property (readonly, nonatomic) NSString *localizedRecoverySuggestion;
@property (readonly, nonatomic) NSDictionary *userInfo;

@end


@interface NSCountedSet (FProperties)

@property (readonly, nonatomic) NSEnumerator *objectEnumerator;

@end


@interface NSValue (FProperties)

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@property (readonly, nonatomic) NSPoint pointValue;
@property (readonly, nonatomic) NSRect rectValue;
@property (readonly, nonatomic) NSSize sizeValue;
#else
@property (readonly, nonatomic) CGPoint CGPointValue;
@property (readonly, nonatomic) CGRect CGRectValue;
@property (readonly, nonatomic) CGSize CGSizeValue;
#endif
@property (readonly, nonatomic) NSRange rangeValue;
@property (readonly, nonatomic) void *pointerValue;
@property (readonly, nonatomic) const char *objCType;

@property (readonly, nonatomic) id nonretainedObjectValue;

@end


#if (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1090)) || (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= 70000))
@interface NSProgress (FProperties)

@property (readonly, nonatomic) NSDictionary *userInfo;

@end
#endif


@interface NSIndexSet (FProperties)

@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) NSUInteger firstIndex;
@property (readonly, nonatomic) NSUInteger lastIndex;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSScriptCommandDescription (FProperties)

@property (readonly, nonatomic) FourCharCode appleEventCode;
@property (readonly, nonatomic) FourCharCode appleEventClassCode;
@property (readonly, nonatomic) NSString *commandClassName;
@property (readonly, nonatomic) NSString *suiteName;
@property (readonly, nonatomic) NSString *commandName;
@property (readonly, nonatomic) FourCharCode appleEventCodeForReturnType;
@property (readonly, nonatomic) NSArray *argumentNames;
@property (readonly, nonatomic) NSString *returnType;
@property (readonly, nonatomic) NSScriptCommand *createCommandInstance;

@end

#endif

@interface NSEnumerator (FProperties)

@property (readonly, nonatomic) id nextObject;
@property (readonly, nonatomic) NSArray *allObjects;

@end


@interface NSNumber (FProperties)

@property (readonly, nonatomic) long long longLongValue;
@property (readonly, nonatomic) unsigned long unsignedLongValue;
@property (readonly, nonatomic) BOOL boolValue;
@property (readonly, nonatomic) float floatValue;
@property (readonly, nonatomic) long longValue;
@property (readonly, nonatomic) double doubleValue;
@property (readonly, nonatomic) unsigned long long unsignedLongLongValue;
@property (readonly, nonatomic) int intValue;
@property (readonly, nonatomic) short shortValue;
@property (readonly, nonatomic) unsigned char unsignedCharValue;
@property (readonly, nonatomic) unsigned short unsignedShortValue;
@property (readonly, nonatomic) NSDecimal decimalValue;
@property (readonly, nonatomic) NSString *stringValue;
@property (readonly, nonatomic) unsigned int unsignedIntValue;
@property (readonly, nonatomic) char charValue;

@end


@interface NSURLAuthenticationChallenge (FProperties)

@property (readonly, nonatomic) NSURLProtectionSpace *protectionSpace;
@property (readonly, nonatomic) id<NSURLAuthenticationChallengeSender> sender;
@property (readonly, nonatomic) NSURLResponse *failureResponse;
@property (readonly, nonatomic) NSError *error;
@property (readonly, nonatomic) NSInteger previousFailureCount;
@property (readonly, nonatomic) NSURLCredential *proposedCredential;

@end


@interface NSURLCredentialStorage (FProperties)

@property (readonly, nonatomic) NSDictionary *allCredentials;

@end


@interface NSURLCredential (FProperties)

@property (readonly, nonatomic) BOOL hasPassword;
@property (readonly, nonatomic) NSString *password;
@property (readonly, nonatomic) SecIdentityRef identity;
@property (readonly, nonatomic) NSString *user;
@property (readonly, nonatomic) NSURLCredentialPersistence persistence;

@end


@interface NSNumberFormatter (FProperties)

@property (copy, nonatomic) NSString *paddingCharacter;
@property (copy, nonatomic) NSString *internationalCurrencySymbol;
@property (strong, nonatomic) NSLocale *locale;
@property (copy, nonatomic) NSString *format;
@property (strong, nonatomic) NSNumber *multiplier;
@property (assign, nonatomic) NSUInteger formatWidth;
@property (copy, nonatomic) NSAttributedString *attributedStringForNotANumber;
@property (assign, nonatomic) BOOL usesGroupingSeparator;
@property (strong, nonatomic) NSDictionary *textAttributesForNegativeValues;
@property (strong, nonatomic) NSDecimalNumberHandler *roundingBehavior;
@property (strong, nonatomic) NSDictionary *textAttributesForZero;
@property (copy, nonatomic) NSString *notANumberSymbol;
@property (copy, nonatomic) NSString *negativeInfinitySymbol;
@property (copy, nonatomic) NSString *negativeSuffix;
@property (copy, nonatomic) NSString *groupingSeparator;
@property (copy, nonatomic) NSString *perMillSymbol;
@property (copy, nonatomic) NSString *currencyCode;
@property (strong, nonatomic) NSDictionary *textAttributesForNegativeInfinity;
@property (assign, nonatomic) BOOL localizesFormat;
@property (assign, nonatomic) NSNumberFormatterBehavior formatterBehavior;
@property (copy, nonatomic) NSString *plusSign;
@property (strong, nonatomic) NSNumber *minimum;
@property (copy, nonatomic) NSString *percentSymbol;
@property (assign, nonatomic) BOOL allowsFloats;
@property (assign, nonatomic) NSNumberFormatterStyle numberStyle;
@property (strong, nonatomic) NSDictionary *textAttributesForPositiveValues;
@property (assign, nonatomic) BOOL generatesDecimalNumbers;
@property (copy, nonatomic) NSString *positiveInfinitySymbol;
@property (copy, nonatomic) NSString *positiveFormat;
@property (copy, nonatomic) NSString *exponentSymbol;
@property (strong, nonatomic) NSDictionary *textAttributesForNil;
@property (strong, nonatomic) NSNumber *roundingIncrement;
@property (copy, nonatomic) NSString *negativePrefix;
@property (assign, nonatomic) NSNumberFormatterPadPosition paddingPosition;
@property (strong, nonatomic) NSDictionary *textAttributesForNotANumber;
@property (copy, nonatomic) NSString *nilSymbol;
@property (copy, nonatomic) NSString *currencySymbol;
@property (copy, nonatomic) NSAttributedString *attributedStringForZero;
@property (copy, nonatomic) NSAttributedString *attributedStringForNil;
@property (strong, nonatomic) NSDictionary *textAttributesForPositiveInfinity;
@property (assign, nonatomic) NSUInteger maximumIntegerDigits;
@property (assign, nonatomic) NSUInteger minimumFractionDigits;
@property (copy, nonatomic) NSString *thousandSeparator;
@property (assign, nonatomic) NSUInteger maximumFractionDigits;
@property (assign, nonatomic) NSUInteger minimumIntegerDigits;
@property (copy, nonatomic) NSString *decimalSeparator;
@property (copy, nonatomic) NSString *negativeFormat;
@property (assign, nonatomic) BOOL alwaysShowsDecimalSeparator;
@property (assign, nonatomic) NSUInteger secondaryGroupingSize;
@property (copy, nonatomic) NSString *positiveSuffix;
@property (strong, nonatomic) NSNumber *maximum;
@property (copy, nonatomic) NSString *currencyDecimalSeparator;
@property (copy, nonatomic) NSString *positivePrefix;
@property (assign, nonatomic) NSNumberFormatterRoundingMode roundingMode;
@property (assign, nonatomic) BOOL hasThousandSeparators;
@property (assign, nonatomic) NSUInteger groupingSize;
@property (copy, nonatomic) NSString *zeroSymbol;
@property (copy, nonatomic) NSString *minusSign;

@end


#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_8
@interface NSUUID (FProperties)

@property (readonly, nonatomic) NSString *UUIDString;

@end
#endif

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSRelativeSpecifier (FProperties)

@property (strong, nonatomic) NSScriptObjectSpecifier *baseSpecifier;
@property (assign, nonatomic) NSRelativePosition relativePosition;

@end

#endif
@interface NSArray (FProperties)

@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) NSEnumerator *reverseObjectEnumerator;
@property (readonly, nonatomic) NSEnumerator *objectEnumerator;
@property (readonly, nonatomic) NSString *description;
@property (readonly, nonatomic) NSData *sortedArrayHint;
@property (readonly, nonatomic) id lastObject;

@end


@interface NSHTTPURLResponse (FProperties)

@property (readonly, nonatomic) NSDictionary *allHeaderFields;
@property (readonly, nonatomic) NSInteger statusCode;

@end


@interface NSFileManager (FProperties)

@property (readonly, nonatomic) NSString *currentDirectoryPath;

@end


@interface NSURLRequest (FProperties)

@property (readonly, nonatomic) NSTimeInterval timeoutInterval;
@property (readonly, nonatomic) NSDictionary *allHTTPHeaderFields;
@property (readonly, nonatomic) NSURL *URL;
@property (readonly, nonatomic) NSData *HTTPBody;
@property (readonly, nonatomic) NSString *HTTPMethod;
@property (readonly, nonatomic) NSInputStream *HTTPBodyStream;
@property (readonly, nonatomic) BOOL HTTPShouldHandleCookies;
@property (readonly, nonatomic) NSURL *mainDocumentURL;
@property (readonly, nonatomic) NSURLRequestCachePolicy cachePolicy;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSSpellServer (FProperties)

@property (assign, nonatomic) id <NSSpellServerDelegate> delegate;

@end
#endif

@interface NSMetadataQuery (FProperties)

@property (strong, nonatomic) NSPredicate *predicate;
@property (readonly, nonatomic) NSUInteger resultCount;
@property (readonly, nonatomic) NSDictionary *valueLists;
@property (readonly, nonatomic) NSArray *groupedResults;
@property (assign, nonatomic) NSTimeInterval notificationBatchingInterval;
@property (strong, nonatomic) NSArray *searchScopes;
@property (readonly, nonatomic) BOOL startQuery;
@property (readonly, nonatomic) BOOL isStarted;
@property (readonly, nonatomic) NSArray *results;
@property (strong, nonatomic) NSArray *sortDescriptors;
@property (assign, nonatomic) id <NSMetadataQueryDelegate> delegate;
@property (strong, nonatomic) NSArray *valueListAttributes;
@property (readonly, nonatomic) BOOL isGathering;
@property (readonly, nonatomic) BOOL isStopped;
@property (strong, nonatomic) NSArray *groupingAttributes;

@end


@interface NSHTTPCookieStorage (FProperties)

@property (readonly, nonatomic) NSArray *cookies;
@property (strong, nonatomic) NSHTTPCookie *cookie;
- (NSHTTPCookie *)cookie UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) NSHTTPCookieAcceptPolicy cookieAcceptPolicy;

@end


@interface NSDecimalNumber (FProperties)

@property (readonly, nonatomic) NSDecimal decimalValue;
@property (readonly, nonatomic) double doubleValue;
@property (readonly, nonatomic) const char *objCType;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_8
@interface NSXPCListener (FProperties)

@property (readonly, nonatomic) NSXPCListenerEndpoint *endpoint;

@end
#endif
#endif

@interface NSRunLoop (FProperties)

@property (readonly, nonatomic) CFRunLoopRef getCFRunLoop;
@property (readonly, nonatomic) NSString *currentMode;

@end


@interface NSFileWrapper (FProperties)

@property (readonly, nonatomic) NSData *serializedRepresentation;
@property (readonly, nonatomic) BOOL isSymbolicLink;
@property (readonly, nonatomic) NSData *regularFileContents;
@property (readonly, nonatomic) NSDictionary *fileWrappers;
@property (copy, nonatomic) NSString *filename;
@property (readonly, nonatomic) BOOL isDirectory;
@property (readonly, nonatomic) NSString *symbolicLinkDestination;
@property (copy, nonatomic) NSString *preferredFilename;
@property (readonly, nonatomic) BOOL isRegularFile;
@property (strong, nonatomic) NSDictionary *fileAttributes;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSDistributedNotificationCenter (FProperties)

@property (assign, nonatomic) BOOL suspended;

@end


@interface NSClassDescription (FProperties)

@property (readonly, nonatomic) NSArray *attributeKeys;
@property (readonly, nonatomic) NSArray *toManyRelationshipKeys;
@property (readonly, nonatomic) NSArray *toOneRelationshipKeys;

@end


@interface NSProtocolChecker (FProperties)

@property (readonly, nonatomic) Protocol *protocol;
@property (readonly, nonatomic) NSObject *target;

@end

#endif


@interface NSBlockOperation (FProperties)

@property (readonly, nonatomic) NSArray *executionBlocks;

@end


@interface NSNotification (FProperties)

@property (readonly, nonatomic) id object;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSDictionary *userInfo;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSDistantObject (FProperties)

@property (readonly, nonatomic) NSConnection *connectionForProxy;
@property (strong, nonatomic) Protocol *protocolForProxy;
- (Protocol *)protocolForProxy UNAVAILABLE_ATTRIBUTE;

@end

#endif

@interface NSMutableData (FProperties)

@property (assign, nonatomic) NSUInteger length;
@property (strong, nonatomic) NSData *data;
@property (readonly, nonatomic) void *mutableBytes;

@end


@interface NSMapTable (FProperties)

@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) NSEnumerator *objectEnumerator;
@property (readonly, nonatomic) NSPointerFunctions *keyPointerFunctions;
@property (readonly, nonatomic) NSEnumerator *keyEnumerator;
@property (readonly, nonatomic) NSDictionary *dictionaryRepresentation;
@property (readonly, nonatomic) NSPointerFunctions *valuePointerFunctions;

@end


@interface NSSet (FProperties)

@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) id anyObject;
@property (readonly, nonatomic) NSEnumerator *objectEnumerator;
@property (readonly, nonatomic) NSString *description;
@property (readonly, nonatomic) NSArray *allObjects;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@interface NSDistributedLock (FProperties)

@property (readonly, nonatomic) NSDate *lockDate;
@property (readonly, nonatomic) BOOL tryLock;

@end


@interface NSArchiver (FProperties)

@property (readonly, nonatomic) NSMutableData *archiverData;

@end
#endif

@interface NSCondition (FProperties)

@property (copy, nonatomic) NSString *name;

@end


@interface NSScanner (FProperties)

@property (readonly, nonatomic) NSString *string;
@property (assign, nonatomic) BOOL caseSensitive;
@property (strong, nonatomic) id locale;
@property (strong, nonatomic) NSCharacterSet *charactersToBeSkipped;
@property (readonly, nonatomic) BOOL isAtEnd;
@property (assign, nonatomic) NSUInteger scanLocation;

@end


@interface NSKeyedArchiver (FProperties)

@property (assign, nonatomic) NSPropertyListFormat outputFormat;
@property (assign, nonatomic) id <NSKeyedArchiverDelegate> delegate;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE


@interface NSScriptObjectSpecifier (FProperties)

@property (assign, nonatomic) BOOL containerIsRangeContainerObject;
@property (copy, nonatomic) NSString *key;
@property (strong, nonatomic) NSScriptObjectSpecifier *childSpecifier;
@property (assign, nonatomic) NSInteger evaluationErrorNumber;
@property (readonly, nonatomic) NSScriptClassDescription *keyClassDescription;
@property (strong, nonatomic) NSScriptClassDescription *containerClassDescription;
@property (assign, nonatomic) BOOL containerIsObjectBeingTested;
@property (readonly, nonatomic) NSScriptObjectSpecifier *evaluationErrorSpecifier;
@property (strong, nonatomic) NSScriptObjectSpecifier *containerSpecifier;
@property (readonly, nonatomic) id objectsByEvaluatingSpecifier;

@end

#endif

@interface NSDictionary (FProperties)

@property (readonly, nonatomic) NSNumber *fileGroupOwnerAccountID;
@property (readonly, nonatomic) NSInteger fileSystemNumber;
@property (readonly, nonatomic) NSArray *allValues;
@property (readonly, nonatomic) NSString *fileGroupOwnerAccountName;
@property (readonly, nonatomic) NSArray *allKeys;
@property (readonly, nonatomic) NSDate *fileCreationDate;
@property (readonly, nonatomic) NSDate *fileModificationDate;
@property (readonly, nonatomic) NSEnumerator *objectEnumerator;
@property (readonly, nonatomic) BOOL fileExtensionHidden;
@property (readonly, nonatomic) NSString *fileType;
@property (readonly, nonatomic) BOOL fileIsImmutable;
@property (readonly, nonatomic) NSString *descriptionInStringsFileFormat;
@property (readonly, nonatomic) OSType fileHFSCreatorCode;
@property (readonly, nonatomic) NSString *description;
@property (readonly, nonatomic) NSEnumerator *keyEnumerator;
@property (readonly, nonatomic) BOOL fileIsAppendOnly;
@property (readonly, nonatomic) NSString *fileOwnerAccountName;
@property (readonly, nonatomic) unsigned long long fileSize;
@property (readonly, nonatomic) NSUInteger fileSystemFileNumber;
@property (readonly, nonatomic) OSType fileHFSTypeCode;
@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) NSUInteger filePosixPermissions;
@property (readonly, nonatomic) NSNumber *fileOwnerAccountID;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE


#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_8
@interface NSUserScriptTask (FProperties)

@property (readonly, nonatomic) NSURL *scriptURL;

@end
#endif


@interface NSPortCoder (FProperties)

@property (readonly, nonatomic) BOOL isByref;
@property (readonly, nonatomic) BOOL isBycopy;
@property (readonly, nonatomic) NSPort *decodePortObject;

@end

#endif


@interface NSURLProtectionSpace (FProperties)

@property (readonly, nonatomic) NSString *proxyType;
@property (readonly, nonatomic) NSString *realm;
@property (readonly, nonatomic) NSString *host;
@property (readonly, nonatomic) BOOL receivesCredentialSecurely;
@property (readonly, nonatomic) NSString *protocol;
@property (readonly, nonatomic) NSString *authenticationMethod;
@property (readonly, nonatomic) NSInteger port;
@property (readonly, nonatomic) BOOL isProxy;

@end


@interface NSComparisonPredicate (FProperties)

@property (readonly, nonatomic) SEL customSelector;
@property (readonly, nonatomic) NSExpression *leftExpression;
@property (readonly, nonatomic) NSComparisonPredicateModifier comparisonPredicateModifier;
@property (readonly, nonatomic) NSExpression *rightExpression;
@property (readonly, nonatomic) NSComparisonPredicateOptions options;
@property (readonly, nonatomic) NSPredicateOperatorType predicateOperatorType;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_8
@interface NSXPCConnection (FProperties)

@property (readonly, nonatomic) id remoteObjectProxy;

@end
#endif
#endif

@interface NSOutputStream (FProperties)

@property (readonly, nonatomic) BOOL hasSpaceAvailable;

@end


@interface NSSortDescriptor (FProperties)

@property (readonly, nonatomic) SEL selector;
@property (readonly, nonatomic) id reversedSortDescriptor;
@property (readonly, nonatomic) NSString *key;
@property (readonly, nonatomic) BOOL ascending;

@end


@interface NSDirectoryEnumerator (FProperties)

@property (readonly, nonatomic) NSDictionary *directoryAttributes;
@property (readonly, nonatomic) NSDictionary *fileAttributes;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@interface NSSocketPort (FProperties)

@property (readonly, nonatomic) int socketType;
@property (readonly, nonatomic) int protocol;
@property (readonly, nonatomic) NSSocketNativeHandle socket;
@property (readonly, nonatomic) NSData *address;
@property (readonly, nonatomic) int protocolFamily;

@end


@interface NSScriptSuiteRegistry (FProperties)

@property (readonly, nonatomic) NSArray *suiteNames;

@end
#endif

@interface NSCache (FProperties)

@property (assign, nonatomic) NSUInteger countLimit;
@property (assign, nonatomic) BOOL evictsObjectsWithDiscardedContent;
@property (assign, nonatomic) NSUInteger totalCostLimit;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) id <NSCacheDelegate> delegate;

@end


@interface NSOperation (FProperties)

@property (readonly, nonatomic) BOOL isReady;
@property (readonly, nonatomic) BOOL isFinished;
@property (readonly, nonatomic) BOOL isExecuting;
@property (readonly, nonatomic) BOOL isCancelled;
@property (assign, nonatomic) NSOperationQueuePriority queuePriority;
@property (readonly, nonatomic) NSArray *dependencies;
@property (readonly, nonatomic) BOOL isConcurrent;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@interface NSScriptWhoseTest (FProperties)

@property (readonly, nonatomic) BOOL isTrue;

@end
#endif

@interface NSXMLParser (FProperties)

@property (readonly, nonatomic) NSInteger columnNumber;
@property (readonly, nonatomic) NSString *publicID;
@property (readonly, nonatomic) BOOL parse;
@property (readonly, nonatomic) NSString *systemID;
@property (assign, nonatomic) id <NSXMLParserDelegate> delegate;
@property (readonly, nonatomic) NSError *parserError;
@property (readonly, nonatomic) NSInteger lineNumber;
@property (assign, nonatomic) BOOL shouldResolveExternalEntities;
@property (assign, nonatomic) BOOL shouldProcessNamespaces;
@property (assign, nonatomic) BOOL shouldReportNamespacePrefixes;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@interface NSSetCommand (FProperties)

@property (readonly, nonatomic) NSScriptObjectSpecifier *keySpecifier;

@end


@interface NSScriptExecutionContext (FProperties)

@property (strong, nonatomic) id objectBeingTested;
@property (strong, nonatomic) id rangeContainerObject;
@property (strong, nonatomic) id topLevelObject;

@end

#endif


#if (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1090)) || (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= 70000))

@interface NSURLComponents (FProperties)

@property (readonly, nonatomic) NSURL *URL;

@end
#endif

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSXMLNode (FProperties)

@property (readonly, nonatomic) NSString *XPath;
@property (readonly, nonatomic) NSUInteger index;
@property (readonly, nonatomic) NSXMLNodeKind kind;
@property (readonly, nonatomic) NSXMLNode *previousNode;
@property (copy, nonatomic) NSString *name;
@property (readonly, nonatomic) NSXMLNode *parent;
@property (readonly, nonatomic) NSUInteger level;
@property (readonly, nonatomic) NSString *description;
@property (readonly, nonatomic) NSXMLNode *nextNode;
@property (readonly, nonatomic) NSXMLNode *nextSibling;
@property (copy, nonatomic) NSString *URI;
@property (readonly, nonatomic) NSString *localName;
@property (readonly, nonatomic) NSArray *children;
@property (readonly, nonatomic) NSString *prefix;
@property (readonly, nonatomic) NSXMLDocument *rootDocument;
@property (copy, nonatomic) NSString *stringValue;
@property (readonly, nonatomic) NSXMLNode *previousSibling;
@property (readonly, nonatomic) NSUInteger childCount;
@property (readonly, nonatomic) NSString *XMLString;
@property (strong, nonatomic) id objectValue;

@end

#endif

@interface NSHashTable (FProperties)

@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) id anyObject;
@property (readonly, nonatomic) NSEnumerator *objectEnumerator;
@property (readonly, nonatomic) NSPointerFunctions *pointerFunctions;
@property (readonly, nonatomic) NSSet *setRepresentation;
@property (readonly, nonatomic) NSArray *allObjects;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSAppleEventManager (FProperties)

@property (readonly, nonatomic) NSAppleEventManagerSuspensionID suspendCurrentAppleEvent;
@property (readonly, nonatomic) NSAppleEventDescriptor *currentReplyAppleEvent;
@property (assign, nonatomic) NSAppleEventManagerSuspensionID currentAppleEventAndReplyEventWithSuspensionID;
- (NSAppleEventManagerSuspensionID)currentAppleEventAndReplyEventWithSuspensionID UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSAppleEventDescriptor *currentAppleEvent;

@end

#endif

@interface NSException (FProperties)

@property (readonly, nonatomic) NSString *reason;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSDictionary *userInfo;

@end


@interface NSMutableArray (FProperties)

@property (strong, nonatomic) NSArray *array;
- (NSArray *)array UNAVAILABLE_ATTRIBUTE;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@interface NSCloseCommand (FProperties)

@property (readonly, nonatomic) NSSaveOptions saveOptions;

@end
#endif


@interface NSIndexPath (FProperties)

@property (readonly, nonatomic) NSIndexPath *indexPathByRemovingLastIndex;
@property (readonly, nonatomic) NSUInteger length;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@interface NSPortMessage (FProperties)

@property (readonly, nonatomic) NSPort *receivePort;
@property (readonly, nonatomic) NSPort *sendPort;
@property (readonly, nonatomic) NSArray *components;

@end


@interface NSDistantObjectRequest (FProperties)

@property (readonly, nonatomic) NSInvocation *invocation;
@property (readonly, nonatomic) id conversation;
@property (readonly, nonatomic) NSConnection *connection;

@end
#endif


@interface NSOperationQueue (FProperties)

@property (readonly, nonatomic) NSArray *operations;
@property (assign, nonatomic, getter=isSuspended) BOOL suspended;
@property (assign, nonatomic) NSInteger maxConcurrentOperationCount;

@end


@interface NSMutableDictionary (FProperties)

@property (strong, nonatomic) NSDictionary *dictionary;
- (NSDictionary *)dictionary UNAVAILABLE_ATTRIBUTE;

@end


@interface NSMutableString (FProperties)

@property (copy, nonatomic) NSString *string;
- (NSString *)string UNAVAILABLE_ATTRIBUTE;

@end


@interface NSExpression (FProperties)

@property (readonly, nonatomic) NSString *function;
@property (readonly, nonatomic) id constantValue;
@property (readonly, nonatomic) NSExpressionType expressionType;
@property (readonly, nonatomic) NSExpression *operand;
@property (readonly, nonatomic) NSArray *arguments;
@property (readonly, nonatomic) NSString *variable;
@property (readonly, nonatomic) NSString *keyPath;

@end


@interface NSCachedURLResponse (FProperties)

@property (readonly, nonatomic) NSURLCacheStoragePolicy storagePolicy;
@property (readonly, nonatomic) NSData *data;
@property (readonly, nonatomic) NSURLResponse *response;
@property (readonly, nonatomic) NSDictionary *userInfo;

@end


@interface NSInvocation (FProperties)

@property (readonly, nonatomic) BOOL argumentsRetained;
@property (readonly, nonatomic) NSMethodSignature *methodSignature;
@property (assign, nonatomic) id target;
@property (assign, nonatomic) void *returnValue;
- (void *)returnValue UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) SEL selector;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@interface NSTask (FProperties)

@property (strong, nonatomic) id standardOutput;
@property (readonly, nonatomic) BOOL suspend;
@property (readonly, nonatomic) BOOL isRunning;
@property (strong, nonatomic) id standardError;
@property (readonly, nonatomic) BOOL resume;
@property (readonly, nonatomic) int terminationStatus;
@property (strong, nonatomic) NSDictionary *environment;
@property (copy, nonatomic) NSString *currentDirectoryPath;
@property (readonly, nonatomic) int processIdentifier;
@property (strong, nonatomic) id standardInput;
@property (strong, nonatomic) NSArray *arguments;
@property (copy, nonatomic) NSString *launchPath;

@end
#endif


@interface NSURL (FProperties)

@property (readonly, nonatomic) NSURL *absoluteURL;
@property (readonly, nonatomic) NSString *password;
@property (readonly, nonatomic) NSString *resourceSpecifier;
@property (readonly, nonatomic) NSString *absoluteString;
@property (readonly, nonatomic) NSString *parameterString;
@property (readonly, nonatomic) NSString *fragment;
@property (readonly, nonatomic) NSString *relativePath;
@property (readonly, nonatomic) NSURL *standardizedURL;
@property (readonly, nonatomic) BOOL isFileURL;
@property (readonly, nonatomic) NSURL *baseURL;
@property (readonly, nonatomic) NSString *host;
@property (readonly, nonatomic) NSString *relativeString;
@property (readonly, nonatomic) NSString *query;
@property (readonly, nonatomic) NSString *path;
@property (readonly, nonatomic) NSString *scheme;
@property (readonly, nonatomic) NSNumber *port;
@property (readonly, nonatomic) NSString *user;

@end


@interface NSRecursiveLock (FProperties)

@property (readonly, nonatomic) BOOL tryLock;

@end


@interface NSURLProtocol (FProperties)

@property (readonly, nonatomic) NSCachedURLResponse *cachedResponse;
@property (readonly, nonatomic) id <NSURLProtocolClient> client;
@property (readonly, nonatomic) NSURLRequest *request;

@end


#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
@interface NSOrderedSet (FProperties)

@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) NSEnumerator *reverseObjectEnumerator;
@property (readonly, nonatomic) NSEnumerator *objectEnumerator;
@property (readonly, nonatomic) NSString *description;
@property (readonly, nonatomic) id lastObject;
@property (readonly, nonatomic) NSSet *set;
@property (readonly, nonatomic) id firstObject;
@property (readonly, nonatomic) NSOrderedSet *reversedOrderedSet;
@property (readonly, nonatomic) NSArray *array;

@end
#endif

@interface NSCalendar (FProperties)

@property (strong, nonatomic) NSLocale *locale;
@property (strong, nonatomic) NSTimeZone *timeZone;
@property (assign, nonatomic) NSUInteger minimumDaysInFirstWeek;
@property (assign, nonatomic) NSUInteger firstWeekday;
@property (readonly, nonatomic) NSString *calendarIdentifier;

@end


@interface NSLock (FProperties)

@property (readonly, nonatomic) BOOL tryLock;

@end


@interface NSMethodSignature (FProperties)

@property (readonly, nonatomic) NSUInteger methodReturnLength;
@property (readonly, nonatomic) NSUInteger numberOfArguments;
@property (readonly, nonatomic) const char *methodReturnType;
@property (readonly, nonatomic) NSUInteger frameLength;
@property (readonly, nonatomic) BOOL isOneway;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@interface NSXMLDTD (FProperties)

@property (copy, nonatomic) NSString *systemID;
@property (copy, nonatomic) NSString *publicID;
@property (strong, nonatomic) NSArray *children;
- (NSArray *)children UNAVAILABLE_ATTRIBUTE;

@end
#endif


@interface NSTimeZone (FProperties)

@property (readonly, nonatomic) NSInteger secondsFromGMT;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *abbreviation;
@property (readonly, nonatomic) BOOL isDaylightSavingTime;
@property (readonly, nonatomic) NSData *data;
@property (readonly, nonatomic) NSString *description;

@end


@interface NSLocale (FProperties)

@property (readonly, nonatomic) NSString *localeIdentifier;

@end


@interface NSFileHandle (FProperties)

@property (readonly, nonatomic) unsigned long long seekToEndOfFile;
@property (readonly, nonatomic) NSData *readDataToEndOfFile;
@property (readonly, nonatomic) NSData *availableData;
@property (readonly, nonatomic) unsigned long long offsetInFile;
@property (readonly, nonatomic) int fileDescriptor;

@end


@interface NSConditionLock (FProperties)

@property (readonly, nonatomic) BOOL tryLock;
@property (readonly, nonatomic) NSInteger condition;

@end



