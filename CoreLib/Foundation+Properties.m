//
//  Foundation+Properties.m
//  CoreLib
//
//  Created by CoreCode on 09.02.14.
/*	Copyright (c) 2014 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "Foundation+Properties.h"


@implementation NSInvocationOperation (FProperties)

@dynamic invocation;
@dynamic result;

@end


@implementation NSStream (FProperties)

@dynamic streamError;
@dynamic streamStatus;
@dynamic delegate;

@end


@implementation NSPort (FProperties)

@dynamic isValid;
@dynamic delegate;
@dynamic reservedSpaceLength;

@end


@implementation NSString (FProperties)

@dynamic stringByStandardizingPath;
@dynamic pathComponents;
@dynamic isAbsolutePath;
@dynamic propertyListFromStringsFileFormat;
@dynamic decomposedStringWithCanonicalMapping;
@dynamic smallestEncoding;
@dynamic uppercaseString;
@dynamic doubleValue;
@dynamic fastestEncoding;
@dynamic decomposedStringWithCompatibilityMapping;
@dynamic precomposedStringWithCanonicalMapping;
@dynamic stringByResolvingSymlinksInPath;
@dynamic lowercaseString;
@dynamic pathExtension;
@dynamic precomposedStringWithCompatibilityMapping;
@dynamic hash;
@dynamic description;
@dynamic lastPathComponent;
@dynamic floatValue;
@dynamic stringByDeletingPathExtension;
@dynamic intValue;
@dynamic stringByExpandingTildeInPath;
@dynamic capitalizedString;
@dynamic propertyList;
@dynamic length;
@dynamic stringByDeletingLastPathComponent;
@dynamic stringByAbbreviatingWithTildeInPath;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@implementation NSConnection (FProperties)

@dynamic rootProxy;
@dynamic statistics;
@dynamic multipleThreadsEnabled;
@dynamic requestModes;
@dynamic replyTimeout;
@dynamic requestTimeout;
@dynamic sendPort;
@dynamic rootObject;
@dynamic receivePort;
@dynamic delegate;
@dynamic isValid;
@dynamic remoteObjects;
@dynamic independentConversationQueueing;
@dynamic localObjects;

@end
#endif

@implementation NSUserDefaults (FProperties)

@dynamic synchronize;
@dynamic dictionaryRepresentation;
@dynamic volatileDomainNames;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@implementation NSXMLDTDNode (FProperties)

@dynamic systemID;
@dynamic notationName;
@dynamic publicID;
@dynamic DTDKind;
@dynamic isExternal;

@end
#endif


@implementation NSCompoundPredicate (FProperties)

@dynamic subpredicates;
@dynamic compoundPredicateType;

@end


@implementation NSPointerArray (FProperties)

@dynamic count;
@dynamic allObjects;
@dynamic pointerFunctions;

@end


@implementation NSProcessInfo (FProperties)

@dynamic hostName;
@dynamic operatingSystemVersionString;
@dynamic environment;
@dynamic processName;
@dynamic processIdentifier;
@dynamic operatingSystemName;
@dynamic arguments;
@dynamic globallyUniqueString;
@dynamic operatingSystem;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSScriptClassDescription (FProperties)

@dynamic appleEventCode;
@dynamic implementationClassName;
@dynamic defaultSubcontainerAttributeKey;
@dynamic suiteName;
@dynamic className;
@dynamic superclassDescription;

@end
#endif

@implementation NSDate (FProperties)

@dynamic timeIntervalSinceReferenceDate;
@dynamic description;
@dynamic timeIntervalSinceNow;

@end


@implementation NSData (FProperties)

@dynamic length;
@dynamic bytes;
@dynamic description;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSScriptCommand (FProperties)

@dynamic evaluatedReceivers;
@dynamic directParameter;
@dynamic evaluatedArguments;
@dynamic performDefaultImplementation;
@dynamic executeCommand;
@dynamic scriptErrorString;
@dynamic commandDescription;
@dynamic scriptErrorNumber;
@dynamic receiversSpecifier;
@dynamic isWellFormed;
@dynamic appleEvent;
@dynamic arguments;

@end


@implementation NSXMLElement (FProperties)

@dynamic attributes;
@dynamic attributesAsDictionary;
@dynamic children;
@dynamic namespaces;
@dynamic attributesWithDictionary;

@end
#endif



@implementation NSMutableURLRequest (FProperties)

@dynamic timeoutInterval;
@dynamic allHTTPHeaderFields;
@dynamic URL;
@dynamic HTTPBody;
@dynamic HTTPMethod;
@dynamic HTTPBodyStream;
@dynamic HTTPShouldHandleCookies;
@dynamic mainDocumentURL;
@dynamic cachePolicy;

@end


@implementation NSProxy (FProperties)

@dynamic debugDescription;
@dynamic description;

@end


@implementation NSUbiquitousKeyValueStore (FProperties)

@dynamic synchronize;
@dynamic dictionaryRepresentation;

@end


@implementation NSMetadataQueryResultGroup (FProperties)

@dynamic attribute;
@dynamic resultCount;
@dynamic results;
@dynamic value;
@dynamic subgroups;

@end


@implementation NSPipe (FProperties)

@dynamic fileHandleForReading;
@dynamic fileHandleForWriting;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSHost (FProperties)

@dynamic address;
@dynamic addresses;
@dynamic name;
@dynamic names;

@end


@implementation NSNameSpecifier (FProperties)

@dynamic name;

@end
#endif


@implementation NSMetadataItem (FProperties)

@dynamic attributes;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSAppleEventDescriptor (FProperties)

@dynamic eventID;
@dynamic returnID;
@dynamic transactionID;
@dynamic enumCodeValue;
@dynamic typeCodeValue;
@dynamic initListDescriptor;
@dynamic numberOfItems;
@dynamic initRecordDescriptor;
@dynamic aeDesc;
@dynamic stringValue;
@dynamic eventClass;
@dynamic booleanValue;
@dynamic data;
@dynamic descriptorType;

@end


@implementation NSURLDownload (FProperties)

@dynamic deletesFileUponFailure;
@dynamic resumeData;
@dynamic request;

@end
#endif


@implementation NSInputStream (FProperties)

@dynamic hasBytesAvailable;

@end


@implementation NSCoder (FProperties)

@dynamic decodeDataObject;
@dynamic decodePropertyList;
#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@dynamic decodeRect;
@dynamic decodePoint;
@dynamic decodeSize;
#endif
@dynamic decodeObject;
@dynamic systemVersion;
@dynamic allowsKeyedCoding;

@end


@implementation NSURLCache (FProperties)

@dynamic currentMemoryUsage;
@dynamic memoryCapacity;
@dynamic currentDiskUsage;
@dynamic diskCapacity;

@end


@implementation NSDateComponents (FProperties)

@dynamic hour;
@dynamic weekdayOrdinal;
@dynamic month;
@dynamic second;
@dynamic era;
@dynamic year;
@dynamic day;
@dynamic minute;
@dynamic weekday;

@end


@implementation NSHTTPCookie (FProperties)

@dynamic comment;
@dynamic domain;
@dynamic isSecure;
@dynamic isHTTPOnly;
@dynamic name;
@dynamic isSessionOnly;
@dynamic portList;
@dynamic expiresDate;
@dynamic value;
@dynamic commentURL;
@dynamic version;
@dynamic path;
@dynamic properties;

@end


@implementation NSDateFormatter (FProperties)

@dynamic defaultDate;
@dynamic shortMonthSymbols;
@dynamic eraSymbols;
@dynamic AMSymbol;
@dynamic timeStyle;
@dynamic locale;
@dynamic dateStyle;
@dynamic dateFormat;
@dynamic PMSymbol;
@dynamic formatterBehavior;
@dynamic weekdaySymbols;
@dynamic monthSymbols;
@dynamic shortWeekdaySymbols;
@dynamic timeZone;
@dynamic calendar;
@dynamic generatesCalendarDates;
@dynamic twoDigitStartDate;
@dynamic lenient;

@end


@implementation NSUndoManager (FProperties)

@dynamic isRedoing;
@dynamic groupingLevel;
@dynamic undoActionName;
@dynamic isUndoRegistrationEnabled;
@dynamic canUndo;
@dynamic runLoopModes;
@dynamic levelsOfUndo;
@dynamic groupsByEvent;
@dynamic redoMenuItemTitle;
@dynamic isUndoing;
@dynamic canRedo;
@dynamic actionName;
@dynamic redoActionName;
@dynamic undoMenuItemTitle;

@end


@implementation NSTimer (FProperties)

@dynamic fireDate;
@dynamic timeInterval;
@dynamic userInfo;
@dynamic isValid;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSRangeSpecifier (FProperties)

@dynamic endSpecifier;
@dynamic startSpecifier;

@end
#endif

@implementation NSNetService (FProperties)

@dynamic TXTRecordData;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@implementation NSQuitCommand (FProperties)

@dynamic saveOptions;

@end
#endif


@implementation NSURLResponse (FProperties)

@dynamic URL;
@dynamic MIMEType;
@dynamic expectedContentLength;
@dynamic suggestedFilename;
@dynamic textEncodingName;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@implementation NSAffineTransform (FProperties)

@dynamic transformStruct;

@end


@implementation NSMoveCommand (FProperties)

@dynamic keySpecifier;

@end
#endif


@implementation NSCharacterSet (FProperties)

@dynamic invertedSet;
@dynamic bitmapRepresentation;

@end


@implementation NSBundle (FProperties)

@dynamic load;
@dynamic builtInPlugInsPath;
@dynamic developmentLocalization;
@dynamic preferredLocalizations;
@dynamic unload;
@dynamic sharedFrameworksPath;
@dynamic resourcePath;
@dynamic infoDictionary;
@dynamic isLoaded;
@dynamic localizations;
@dynamic localizedInfoDictionary;
@dynamic privateFrameworksPath;
@dynamic bundleIdentifier;
@dynamic principalClass;
@dynamic executablePath;
@dynamic sharedSupportPath;
@dynamic bundlePath;

@end


@implementation NSMetadataQueryAttributeValueTuple (FProperties)

@dynamic count;
@dynamic attribute;
@dynamic value;

@end


@implementation NSObject (FProperties)

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@dynamic objectSpecifier;
@dynamic classDescription;
#endif
@dynamic attributeKeys;
@dynamic classForPortCoder;
@dynamic classCode;
@dynamic classForArchiver;
@dynamic scriptingProperties;
@dynamic nilValueForKey;
@dynamic classForCoder;
@dynamic toOneRelationshipKeys;
@dynamic className;
@dynamic valuesForKeysWithDictionary;
@dynamic toManyRelationshipKeys;
@dynamic classForKeyedArchiver;
@dynamic observationInfo;

@end


@implementation NSThread (FProperties)

@dynamic threadDictionary;

@end




#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSIndexSpecifier (FProperties)

@dynamic index;

@end
#endif

@implementation NSPredicate (FProperties)

@dynamic predicateFormat;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@implementation NSWhoseSpecifier (FProperties)

@dynamic test;
@dynamic startSubelementIndex;
@dynamic endSubelementIdentifier;
@dynamic endSubelementIndex;
@dynamic startSubelementIdentifier;

@end


@implementation NSUniqueIDSpecifier (FProperties)

@dynamic uniqueID;

@end


@implementation NSDeleteCommand (FProperties)

@dynamic keySpecifier;

@end


@implementation NSUnarchiver (FProperties)

@dynamic isAtEnd;
@dynamic systemVersion;

@end


@implementation NSCloneCommand (FProperties)

@dynamic keySpecifier;

@end
#endif


@implementation NSMutableSet (FProperties)

@dynamic set;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSCreateCommand (FProperties)

@dynamic resolvedKeyDictionary;
@dynamic createClassDescription;

@end

@implementation NSPositionalSpecifier (FProperties)

@dynamic insertionKey;
@dynamic insertionReplaces;
@dynamic insertionContainer;
@dynamic insertionClassDescription;
@dynamic insertionIndex;

@end

#endif

@implementation NSKeyedUnarchiver (FProperties)

@dynamic delegate;

@end


@implementation NSMutableAttributedString (FProperties)

@dynamic mutableString;
@dynamic attributedString;

@end


@implementation NSAttributedString (FProperties)

@dynamic length;
@dynamic string;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSXMLDocument (FProperties)

@dynamic MIMEType;
@dynamic documentContentKind;
@dynamic standalone;
@dynamic characterEncoding;
@dynamic DTD;
@dynamic rootElement;
@dynamic version;
@dynamic XMLData;
@dynamic children;

@end


@implementation NSAppleScript (FProperties)

@dynamic source;
@dynamic isCompiled;

@end
#endif

@implementation NSError (FProperties)

@dynamic recoveryAttempter;
@dynamic domain;
@dynamic code;
@dynamic localizedDescription;
@dynamic localizedFailureReason;
@dynamic localizedRecoveryOptions;
@dynamic helpAnchor;
@dynamic localizedRecoverySuggestion;
@dynamic userInfo;

@end


@implementation NSCountedSet (FProperties)

@dynamic objectEnumerator;

@end


@implementation NSValue (FProperties)

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@dynamic sizeValue;
@dynamic pointValue;
@dynamic rectValue;
#else
@dynamic CGSizeValue;
@dynamic CGPointValue;
@dynamic CGRectValue;
#endif
@dynamic rangeValue;
@dynamic pointerValue;
@dynamic objCType;
@dynamic nonretainedObjectValue;

@end


#if (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1090)) || (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= 70000))

@implementation NSProgress (FProperties)

@dynamic userInfo;

@end

#endif

@implementation NSIndexSet (FProperties)

@dynamic count;
@dynamic firstIndex;
@dynamic lastIndex;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSScriptCommandDescription (FProperties)

@dynamic appleEventCode;
@dynamic appleEventClassCode;
@dynamic commandClassName;
@dynamic suiteName;
@dynamic commandName;
@dynamic appleEventCodeForReturnType;
@dynamic argumentNames;
@dynamic returnType;
@dynamic createCommandInstance;

@end
#endif

@implementation NSEnumerator (FProperties)

@dynamic nextObject;
@dynamic allObjects;

@end


@implementation NSNumber (FProperties)

@dynamic longLongValue;
@dynamic unsignedLongValue;
@dynamic boolValue;
@dynamic floatValue;
@dynamic longValue;
@dynamic doubleValue;
@dynamic unsignedLongLongValue;
@dynamic intValue;
@dynamic shortValue;
@dynamic unsignedCharValue;
@dynamic unsignedShortValue;
@dynamic decimalValue;
@dynamic stringValue;
@dynamic unsignedIntValue;
@dynamic charValue;

@end


@implementation NSURLAuthenticationChallenge (FProperties)

@dynamic protectionSpace;
@dynamic sender;
@dynamic failureResponse;
@dynamic error;
@dynamic previousFailureCount;
@dynamic proposedCredential;

@end


@implementation NSURLCredentialStorage (FProperties)

@dynamic allCredentials;

@end


@implementation NSURLCredential (FProperties)

@dynamic hasPassword;
@dynamic password;
@dynamic identity;
@dynamic user;
@dynamic persistence;

@end


@implementation NSNumberFormatter (FProperties)

@dynamic paddingCharacter;
@dynamic internationalCurrencySymbol;
@dynamic locale;
@dynamic format;
@dynamic multiplier;
@dynamic formatWidth;
@dynamic attributedStringForNotANumber;
@dynamic usesGroupingSeparator;
@dynamic textAttributesForNegativeValues;
@dynamic roundingBehavior;
@dynamic textAttributesForZero;
@dynamic notANumberSymbol;
@dynamic negativeInfinitySymbol;
@dynamic negativeSuffix;
@dynamic groupingSeparator;
@dynamic perMillSymbol;
@dynamic currencyCode;
@dynamic textAttributesForNegativeInfinity;
@dynamic localizesFormat;
@dynamic formatterBehavior;
@dynamic plusSign;
@dynamic minimum;
@dynamic percentSymbol;
@dynamic allowsFloats;
@dynamic numberStyle;
@dynamic textAttributesForPositiveValues;
@dynamic generatesDecimalNumbers;
@dynamic positiveInfinitySymbol;
@dynamic positiveFormat;
@dynamic exponentSymbol;
@dynamic textAttributesForNil;
@dynamic roundingIncrement;
@dynamic negativePrefix;
@dynamic paddingPosition;
@dynamic textAttributesForNotANumber;
@dynamic nilSymbol;
@dynamic currencySymbol;
@dynamic attributedStringForZero;
@dynamic attributedStringForNil;
@dynamic textAttributesForPositiveInfinity;
@dynamic maximumIntegerDigits;
@dynamic minimumFractionDigits;
@dynamic thousandSeparator;
@dynamic maximumFractionDigits;
@dynamic minimumIntegerDigits;
@dynamic decimalSeparator;
@dynamic negativeFormat;
@dynamic alwaysShowsDecimalSeparator;
@dynamic secondaryGroupingSize;
@dynamic positiveSuffix;
@dynamic maximum;
@dynamic currencyDecimalSeparator;
@dynamic positivePrefix;
@dynamic roundingMode;
@dynamic hasThousandSeparators;
@dynamic groupingSize;
@dynamic zeroSymbol;
@dynamic minusSign;

@end


@implementation NSUUID (FProperties)

@dynamic UUIDString;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSRelativeSpecifier (FProperties)

@dynamic baseSpecifier;
@dynamic relativePosition;

@end
#endif


@implementation NSArray (FProperties)

@dynamic count;
@dynamic reverseObjectEnumerator;
@dynamic objectEnumerator;
@dynamic description;
@dynamic sortedArrayHint;
@dynamic lastObject;

@end


@implementation NSHTTPURLResponse (FProperties)

@dynamic allHeaderFields;
@dynamic statusCode;

@end


@implementation NSFileManager (FProperties)

@dynamic currentDirectoryPath;

@end


@implementation NSURLRequest (FProperties)

@dynamic timeoutInterval;
@dynamic allHTTPHeaderFields;
@dynamic URL;
@dynamic HTTPBody;
@dynamic HTTPMethod;
@dynamic HTTPBodyStream;
@dynamic HTTPShouldHandleCookies;
@dynamic mainDocumentURL;
@dynamic cachePolicy;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSSpellServer (FProperties)

@dynamic delegate;

@end
#endif

@implementation NSMetadataQuery (FProperties)

@dynamic predicate;
@dynamic resultCount;
@dynamic valueLists;
@dynamic groupedResults;
@dynamic notificationBatchingInterval;
@dynamic searchScopes;
@dynamic startQuery;
@dynamic isStarted;
@dynamic results;
@dynamic sortDescriptors;
@dynamic delegate;
@dynamic valueListAttributes;
@dynamic isGathering;
@dynamic isStopped;
@dynamic groupingAttributes;

@end


@implementation NSHTTPCookieStorage (FProperties)

@dynamic cookies;
@dynamic cookie;
@dynamic cookieAcceptPolicy;

@end


@implementation NSDecimalNumber (FProperties)

@dynamic decimalValue;
@dynamic doubleValue;
@dynamic objCType;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSXPCListener (FProperties)

@dynamic endpoint;

@end
#endif

@implementation NSRunLoop (FProperties)

@dynamic getCFRunLoop;
@dynamic currentMode;

@end


@implementation NSFileWrapper (FProperties)

@dynamic serializedRepresentation;
@dynamic isSymbolicLink;
@dynamic regularFileContents;
@dynamic fileWrappers;
@dynamic filename;
@dynamic isDirectory;
@dynamic symbolicLinkDestination;
@dynamic preferredFilename;
@dynamic isRegularFile;
@dynamic fileAttributes;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSDistributedNotificationCenter (FProperties)

@dynamic suspended;

@end


@implementation NSClassDescription (FProperties)

@dynamic attributeKeys;
@dynamic toManyRelationshipKeys;
@dynamic toOneRelationshipKeys;

@end


@implementation NSProtocolChecker (FProperties)

@dynamic protocol;
@dynamic target;

@end
#endif

@implementation NSBlockOperation (FProperties)

@dynamic executionBlocks;

@end


@implementation NSNotification (FProperties)

@dynamic object;
@dynamic name;
@dynamic userInfo;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSDistantObject (FProperties)

@dynamic connectionForProxy;
@dynamic protocolForProxy;

@end
#endif


@implementation NSMutableData (FProperties)

@dynamic length;
@dynamic data;
@dynamic mutableBytes;

@end


@implementation NSMapTable (FProperties)

@dynamic count;
@dynamic objectEnumerator;
@dynamic keyPointerFunctions;
@dynamic keyEnumerator;
@dynamic dictionaryRepresentation;
@dynamic valuePointerFunctions;

@end


@implementation NSSet (FProperties)

@dynamic count;
@dynamic anyObject;
@dynamic objectEnumerator;
@dynamic description;
@dynamic allObjects;

@end

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE

@implementation NSDistributedLock (FProperties)

@dynamic lockDate;
@dynamic tryLock;

@end


@implementation NSArchiver (FProperties)

@dynamic archiverData;

@end
#endif

@implementation NSCondition (FProperties)

@dynamic name;

@end


@implementation NSScanner (FProperties)

@dynamic string;
@dynamic caseSensitive;
@dynamic locale;
@dynamic charactersToBeSkipped;
@dynamic isAtEnd;
@dynamic scanLocation;

@end


@implementation NSKeyedArchiver (FProperties)

@dynamic outputFormat;
@dynamic delegate;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSScriptObjectSpecifier (FProperties)

@dynamic containerIsRangeContainerObject;
@dynamic key;
@dynamic childSpecifier;
@dynamic evaluationErrorNumber;
@dynamic keyClassDescription;
@dynamic containerClassDescription;
@dynamic containerIsObjectBeingTested;
@dynamic evaluationErrorSpecifier;
@dynamic containerSpecifier;
@dynamic objectsByEvaluatingSpecifier;

@end
#endif


@implementation NSDictionary (FProperties)

@dynamic fileGroupOwnerAccountID;
@dynamic fileSystemNumber;
@dynamic allValues;
@dynamic fileGroupOwnerAccountName;
@dynamic allKeys;
@dynamic fileCreationDate;
@dynamic fileModificationDate;
@dynamic objectEnumerator;
@dynamic fileExtensionHidden;
@dynamic fileType;
@dynamic fileIsImmutable;
@dynamic descriptionInStringsFileFormat;
@dynamic fileHFSCreatorCode;
@dynamic description;
@dynamic keyEnumerator;
@dynamic fileIsAppendOnly;
@dynamic fileOwnerAccountName;
@dynamic fileSize;
@dynamic fileSystemFileNumber;
@dynamic fileHFSTypeCode;
@dynamic count;
@dynamic filePosixPermissions;
@dynamic fileOwnerAccountID;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSUserScriptTask (FProperties)

@dynamic scriptURL;

@end


@implementation NSPortCoder (FProperties)

@dynamic isByref;
@dynamic isBycopy;
@dynamic decodePortObject;

@end
#endif


@implementation NSURLProtectionSpace (FProperties)

@dynamic proxyType;
@dynamic realm;
@dynamic host;
@dynamic receivesCredentialSecurely;
@dynamic protocol;
@dynamic authenticationMethod;
@dynamic port;
@dynamic isProxy;

@end


@implementation NSComparisonPredicate (FProperties)

@dynamic customSelector;
@dynamic leftExpression;
@dynamic comparisonPredicateModifier;
@dynamic rightExpression;
@dynamic options;
@dynamic predicateOperatorType;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSXPCConnection (FProperties)

@dynamic remoteObjectProxy;

@end
#endif


@implementation NSOutputStream (FProperties)

@dynamic hasSpaceAvailable;

@end


@implementation NSSortDescriptor (FProperties)

@dynamic selector;
@dynamic reversedSortDescriptor;
@dynamic key;
@dynamic ascending;

@end


@implementation NSDirectoryEnumerator (FProperties)

@dynamic directoryAttributes;
@dynamic fileAttributes;

@end


@implementation NSSocketPort (FProperties)

@dynamic socketType;
@dynamic protocol;
@dynamic socket;
@dynamic address;
@dynamic protocolFamily;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSScriptSuiteRegistry (FProperties)

@dynamic suiteNames;

@end
#endif


@implementation NSCache (FProperties)

@dynamic countLimit;
@dynamic evictsObjectsWithDiscardedContent;
@dynamic totalCostLimit;
@dynamic name;
@dynamic delegate;

@end


@implementation NSOperation (FProperties)

@dynamic isReady;
@dynamic isFinished;
@dynamic isExecuting;
@dynamic isCancelled;
@dynamic queuePriority;
@dynamic dependencies;
@dynamic isConcurrent;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSScriptWhoseTest (FProperties)

@dynamic isTrue;

@end
#endif


@implementation NSXMLParser (FProperties)

@dynamic columnNumber;
@dynamic publicID;
@dynamic parse;
@dynamic systemID;
@dynamic delegate;
@dynamic parserError;
@dynamic lineNumber;
@dynamic shouldResolveExternalEntities;
@dynamic shouldProcessNamespaces;
@dynamic shouldReportNamespacePrefixes;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSSetCommand (FProperties)

@dynamic keySpecifier;

@end


@implementation NSScriptExecutionContext (FProperties)

@dynamic objectBeingTested;
@dynamic rangeContainerObject;
@dynamic topLevelObject;

@end
#endif


#if (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1090)) || (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= 70000))
@implementation NSURLComponents (FProperties)

@dynamic URL;

@end
#endif


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSXMLNode (FProperties)

@dynamic XPath;
@dynamic index;
@dynamic kind;
@dynamic previousNode;
@dynamic name;
@dynamic parent;
@dynamic level;
@dynamic description;
@dynamic nextNode;
@dynamic nextSibling;
@dynamic URI;
@dynamic localName;
@dynamic children;
@dynamic prefix;
@dynamic rootDocument;
@dynamic stringValue;
@dynamic previousSibling;
@dynamic childCount;
@dynamic XMLString;
@dynamic objectValue;

@end
#endif

@implementation NSHashTable (FProperties)

@dynamic count;
@dynamic anyObject;
@dynamic objectEnumerator;
@dynamic pointerFunctions;
@dynamic setRepresentation;
@dynamic allObjects;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSAppleEventManager (FProperties)

@dynamic suspendCurrentAppleEvent;
@dynamic currentReplyAppleEvent;
@dynamic currentAppleEventAndReplyEventWithSuspensionID;
@dynamic currentAppleEvent;

@end
#endif

@implementation NSException (FProperties)

@dynamic reason;
@dynamic name;
@dynamic userInfo;

@end


@implementation NSMutableArray (FProperties)

@dynamic array;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSCloseCommand (FProperties)

@dynamic saveOptions;

@end
#endif


@implementation NSIndexPath (FProperties)

@dynamic indexPathByRemovingLastIndex;
@dynamic length;

@end



#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSPortMessage (FProperties)

@dynamic receivePort;
@dynamic sendPort;
@dynamic components;

@end


@implementation NSDistantObjectRequest (FProperties)

@dynamic invocation;
@dynamic conversation;
@dynamic connection;

@end
#endif


@implementation NSOperationQueue (FProperties)

@dynamic operations;
@dynamic suspended;
@dynamic maxConcurrentOperationCount;

@end


@implementation NSMutableDictionary (FProperties)

@dynamic dictionary;

@end


@implementation NSMutableString (FProperties)

@dynamic string;

@end


@implementation NSExpression (FProperties)

@dynamic function;
@dynamic constantValue;
@dynamic expressionType;
@dynamic operand;
@dynamic arguments;
@dynamic variable;
@dynamic keyPath;

@end


@implementation NSCachedURLResponse (FProperties)

@dynamic storagePolicy;
@dynamic data;
@dynamic response;
@dynamic userInfo;

@end


@implementation NSInvocation (FProperties)

@dynamic argumentsRetained;
@dynamic methodSignature;
@dynamic target;
@dynamic returnValue;
@dynamic selector;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSTask (FProperties)

@dynamic standardOutput;
@dynamic suspend;
@dynamic isRunning;
@dynamic standardError;
@dynamic resume;
@dynamic terminationStatus;
@dynamic environment;
@dynamic currentDirectoryPath;
@dynamic processIdentifier;
@dynamic standardInput;
@dynamic arguments;
@dynamic launchPath;

@end
#endif


@implementation NSURL (FProperties)

@dynamic absoluteURL;
@dynamic password;
@dynamic resourceSpecifier;
@dynamic absoluteString;
@dynamic parameterString;
@dynamic fragment;
@dynamic relativePath;
@dynamic standardizedURL;
@dynamic isFileURL;
@dynamic baseURL;
@dynamic host;
@dynamic relativeString;
@dynamic query;
@dynamic path;
@dynamic scheme;
@dynamic port;
@dynamic user;

@end


@implementation NSRecursiveLock (FProperties)

@dynamic tryLock;

@end


@implementation NSURLProtocol (FProperties)

@dynamic cachedResponse;
@dynamic client;
@dynamic request;

@end


@implementation NSOrderedSet (FProperties)

@dynamic count;
@dynamic reverseObjectEnumerator;
@dynamic objectEnumerator;
@dynamic description;
@dynamic lastObject;
@dynamic set;
@dynamic firstObject;
@dynamic reversedOrderedSet;
@dynamic array;

@end


@implementation NSCalendar (FProperties)

@dynamic locale;
@dynamic timeZone;
@dynamic minimumDaysInFirstWeek;
@dynamic firstWeekday;
@dynamic calendarIdentifier;

@end


@implementation NSLock (FProperties)

@dynamic tryLock;

@end



@implementation NSMethodSignature (FProperties)

@dynamic methodReturnLength;
@dynamic numberOfArguments;
@dynamic methodReturnType;
@dynamic frameLength;
@dynamic isOneway;

@end


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
@implementation NSXMLDTD (FProperties)

@dynamic systemID;
@dynamic publicID;
@dynamic children;

@end
#endif


@implementation NSTimeZone (FProperties)

@dynamic secondsFromGMT;
@dynamic name;
@dynamic abbreviation;
@dynamic isDaylightSavingTime;
@dynamic data;
@dynamic description;

@end


@implementation NSLocale (FProperties)

@dynamic localeIdentifier;

@end


@implementation NSFileHandle (FProperties)

@dynamic seekToEndOfFile;
@dynamic readDataToEndOfFile;
@dynamic availableData;
@dynamic offsetInFile;
@dynamic fileDescriptor;

@end


@implementation NSConditionLock (FProperties)

@dynamic tryLock;
@dynamic condition;

@end
