//
//  AppKit+Properties.h
//  CoreLib
//
//  Created by CoreCode on 09.02.14.
/*	Copyright (c) 2015 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "CoreLib.h"


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE



#ifndef MAC_OS_X_VERSION_10_9
#define MAC_OS_X_VERSION_10_9 1090
#endif

@interface NSDocument (Properties)

@property (strong, nonatomic) NSUndoManager *undoManager;
@property (readonly, nonatomic) NSWindow *windowForSheet;
@property (readonly, nonatomic) BOOL keepBackupFile;
@property (assign, nonatomic) BOOL hasUndoManager;
@property (readonly, nonatomic) NSString *autosavingFileType;
@property (strong, nonatomic) NSURL *autosavedContentsFileURL;
@property (readonly, nonatomic) BOOL fileNameExtensionWasHiddenInLastRunSavePanel;
@property (strong, nonatomic) NSDate *fileModificationDate;
@property (readonly, nonatomic) BOOL isDocumentEdited;
@property (readonly, nonatomic) BOOL autosavingIsImplicitlyCancellable NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSString *windowNibName;
@property (readonly, nonatomic) BOOL isInViewingMode NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) BOOL hasUnautosavedChanges;
@property (copy, nonatomic) NSString *fileType;
@property (readonly, nonatomic) BOOL isLocked NS_AVAILABLE_MAC(10_8);
@property (strong, nonatomic) NSWindow *window;
- (NSWindow *)window UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic, getter=isDraft) BOOL draft NS_AVAILABLE_MAC(10_8);
@property (readonly, nonatomic) BOOL shouldRunSavePanelWithAccessoryView;
@property (strong, nonatomic) NSURL *fileURL;
@property (readonly, nonatomic) NSString *fileTypeFromLastRunSavePanel;
@property (readonly, nonatomic) NSArray *windowControllers;
@property (readonly, nonatomic) NSPrintOperation *PDFPrintOperation NS_AVAILABLE_MAC(10_9);
@property (readonly, nonatomic) NSScriptObjectSpecifier *objectSpecifier;
@property (copy, nonatomic) NSString *displayName;
@property (readonly, nonatomic) NSString *defaultDraftName NS_AVAILABLE_MAC(10_8);
@property (readonly, nonatomic) BOOL isEntireFileLoaded NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSURL *backupFileURL NS_AVAILABLE_MAC(10_8);
@property (copy, nonatomic) NSString *lastComponentOfFileName;
@property (strong, nonatomic) NSPrintInfo *printInfo;

@end


@interface NSTableRowView (Properties)


@end


@interface NSScrollView (Properties)

@property (assign, nonatomic) id documentView;
@property (assign, nonatomic) NSScrollerKnobStyle scrollerKnobStyle NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) BOOL rulersVisible;
@property (assign, nonatomic) NSBorderType borderType;
@property (assign, nonatomic) CGFloat verticalLineScroll;
@property (assign, nonatomic) CGFloat verticalPageScroll;
@property (assign, nonatomic) BOOL hasHorizontalScroller;
@property (assign, nonatomic) BOOL hasVerticalScroller;
@property (assign, nonatomic) BOOL scrollsDynamically;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic) NSScrollElasticity horizontalScrollElasticity NS_AVAILABLE_MAC(10_7);
@property (strong, nonatomic) NSRulerView *horizontalRulerView;
@property (readonly, nonatomic) NSRect documentVisibleRect;
@property (readonly, nonatomic) NSSize contentSize;
@property (strong, nonatomic) NSScroller *verticalScroller;
@property (assign, nonatomic) BOOL hasHorizontalRuler;
@property (assign, nonatomic) CGFloat lineScroll;
@property (strong, nonatomic) NSScroller *horizontalScroller;
@property (assign, nonatomic) NSScrollViewFindBarPosition findBarPosition NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) NSScrollElasticity verticalScrollElasticity NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) BOOL autohidesScrollers;
@property (assign, nonatomic) BOOL hasVerticalRuler;
@property (assign, nonatomic) CGFloat horizontalPageScroll;
@property (strong, nonatomic) NSClipView *contentView;
@property (assign, nonatomic) CGFloat horizontalLineScroll;
@property (assign, nonatomic) NSScrollerStyle scrollerStyle NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) BOOL drawsBackground;
@property (assign, nonatomic) CGFloat pageScroll;
@property (assign, nonatomic) BOOL usesPredominantAxisScrolling NS_AVAILABLE_MAC(10_7);
@property (strong, nonatomic) NSRulerView *verticalRulerView;
@property (strong, nonatomic) NSCursor *documentCursor;

@end


@interface NSRunningApplication (Properties)

@property (readonly, nonatomic) BOOL terminate;
@property (readonly, nonatomic) BOOL hide;
@property (readonly, nonatomic) BOOL forceTerminate;
@property (readonly, nonatomic) BOOL unhide;

@end


@interface NSTextContainer (Properties)

@property (readonly, nonatomic) BOOL isSimpleRectangularTextContainer;
@property (assign, nonatomic) BOOL widthTracksTextView;
@property (assign, nonatomic) NSSize containerSize;
@property (assign, nonatomic) CGFloat lineFragmentPadding;
@property (assign, nonatomic) BOOL heightTracksTextView;
@property (strong, nonatomic) NSLayoutManager *layoutManager;
@property (strong, nonatomic) NSTextView *textView;

@end


@interface NSLayoutManager (Properties)

@property (readonly, nonatomic) NSTextView *textViewForBeginningOfSelection;
@property (readonly, nonatomic) BOOL hasNonContiguousLayout NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSRect extraLineFragmentRect;
@property (strong, nonatomic) NSGlyphGenerator *glyphGenerator;
@property (assign, nonatomic) BOOL showsInvisibleCharacters;
@property (assign, nonatomic) BOOL usesFontLeading;
@property (readonly, nonatomic) NSUInteger layoutOptions;
@property (readonly, nonatomic) NSRect extraLineFragmentUsedRect;
@property (readonly, nonatomic) NSUInteger firstUnlaidCharacterIndex;
@property (assign, nonatomic) NSTypesetterBehavior typesetterBehavior;
@property (readonly, nonatomic) NSTextContainer *extraLineFragmentTextContainer;
@property (assign, nonatomic) NSImageScaling defaultAttachmentScaling;
@property (assign, nonatomic) BOOL allowsNonContiguousLayout NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSUInteger firstUnlaidGlyphIndex;
@property (strong, nonatomic) NSTypesetter *typesetter;
@property (readonly, nonatomic) NSUInteger numberOfGlyphs;
@property (assign, nonatomic) BOOL usesScreenFonts;
@property (assign, nonatomic) float hyphenationFactor;
@property (assign, nonatomic) BOOL showsControlCharacters;
@property (readonly, nonatomic) NSArray *textContainers;
@property (assign, nonatomic) BOOL backgroundLayoutEnabled;
@property (readonly, nonatomic) NSTextView *firstTextView;
@property (strong, nonatomic) NSTextStorage *textStorage;
@property (assign, nonatomic) id <NSLayoutManagerDelegate> delegate;
@property (readonly, nonatomic) NSAttributedString *attributedString;

@end


@interface NSShadow (Properties)

@property (assign, nonatomic) NSSize shadowOffset;
@property (strong, nonatomic) NSColor *shadowColor;
@property (assign, nonatomic) CGFloat shadowBlurRadius;

@end


@interface NSString (Properties)


@end


@interface NSComboBox (Properties)

@property (assign, nonatomic) BOOL usesDataSource;
@property (readonly, nonatomic) NSInteger indexOfSelectedItem;
@property (readonly, nonatomic) NSArray *objectValues;
@property (assign, nonatomic) CGFloat itemHeight;
@property (assign, nonatomic) BOOL hasVerticalScroller;
@property (assign, nonatomic) id <NSComboBoxDataSource> dataSource;
@property (assign, nonatomic) BOOL completes;
@property (assign, nonatomic) NSInteger numberOfVisibleItems;
@property (readonly, nonatomic) NSInteger numberOfItems;
@property (assign, nonatomic, getter=isButtonBordered) BOOL buttonBordered;
@property (readonly, nonatomic) id objectValueOfSelectedItem;
@property (assign, nonatomic) NSSize intercellSpacing;

@end


@interface NSImage (Properties)

@property (assign, nonatomic) BOOL scalesWhenResized;
@property (assign, nonatomic) BOOL matchesOnMultipleResolution;
@property (assign, nonatomic) NSSize size;
@property (assign, nonatomic) NSRect alignmentRect NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) BOOL prefersColorMatch;
//@property (assign, nonatomic, getter=isTemplate) BOOL template NS_AVAILABLE_MAC(10_5);
@property (copy, nonatomic) NSString *accessibilityDescription NS_AVAILABLE_MAC(10_6);
- (NSString *)accessibilityDescription UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic, getter=isDataRetained) BOOL dataRetained;
@property (readonly, nonatomic) BOOL isValid;
@property (assign, nonatomic) BOOL matchesOnlyOnBestFittingAxis NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSData *TIFFRepresentation;
@property (assign, nonatomic) BOOL cacheDepthMatchesImageDepth;
@property (readonly, nonatomic) NSArray *representations;
@property (assign, nonatomic, getter=isCachedSeparately) BOOL cachedSeparately;
@property (readonly, nonatomic) NSString *name;
@property (assign, nonatomic, getter=isFlipped) BOOL flipped;
@property (assign, nonatomic) BOOL usesEPSOnResolutionMismatch;
@property (assign, nonatomic) id <NSImageDelegate> delegate;

@end


@interface NSPersistentDocument (Properties)

@property (readonly, nonatomic) id managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end


@interface NSDrawer (Properties)

@property (assign, nonatomic) CGFloat leadingOffset;
@property (strong, nonatomic) NSView *contentView;
@property (assign, nonatomic) CGFloat trailingOffset;
@property (readonly, nonatomic) NSInteger state;
@property (readonly, nonatomic) NSRectEdge edge;
@property (assign, nonatomic) id <NSDrawerDelegate> delegate;
@property (assign, nonatomic) NSSize minContentSize;
@property (strong, nonatomic) NSWindow *parentWindow;
@property (assign, nonatomic) NSRectEdge preferredEdge;
@property (assign, nonatomic) NSSize maxContentSize;
@property (assign, nonatomic) NSSize contentSize;

@end


@interface NSCollectionView (Properties)

@property (assign, nonatomic) NSUInteger maxNumberOfColumns;
@property (strong, nonatomic) NSIndexSet *selectionIndexes;
@property (assign, nonatomic) NSSize maxItemSize;
@property (strong, nonatomic) NSArray *backgroundColors;
@property (strong, nonatomic) NSCollectionViewItem *itemPrototype;
@property (readonly, nonatomic) BOOL isFirstResponder;
@property (assign, nonatomic) NSSize minItemSize;
@property (assign, nonatomic) NSUInteger maxNumberOfRows;
@property (strong, nonatomic) NSArray *content;
@property (assign, nonatomic) BOOL allowsMultipleSelection;
@property (assign, nonatomic) id <NSCollectionViewDelegate> delegate;
@property (assign, nonatomic, getter=isSelectable) BOOL selectable;

@end


@interface NSCell (Properties)

@property (copy, nonatomic) NSAttributedString *attributedStringValue;
@property (readonly, nonatomic) NSBackgroundStyle interiorBackgroundStyle NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) BOOL showsFirstResponder;
@property (assign, nonatomic) BOOL truncatesLastVisibleLine NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (strong, nonatomic) NSImage *image;
@property (assign, nonatomic) NSBackgroundStyle backgroundStyle NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) BOOL allowsMixedState;
@property (assign, nonatomic, getter=isBordered) BOOL bordered;
@property (readonly, nonatomic) BOOL isOpaque;
@property (assign, nonatomic) NSInteger tag;
@property (strong, nonatomic) NSFont *font;
@property (readonly, nonatomic) BOOL wantsNotificationForMarkedText;
@property (assign, nonatomic) NSTextAlignment alignment;
@property (assign, nonatomic) BOOL wraps;
@property (readonly, nonatomic) NSInteger mouseDownFlags;
@property (copy, nonatomic) NSString *title;
@property (readonly, nonatomic) BOOL hasValidObjectValue;
@property (assign, nonatomic) NSUserInterfaceLayoutDirection userInterfaceLayoutDirection NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) double doubleValue;
@property (assign, nonatomic, getter=isHighlighted) BOOL highlighted;
@property (assign, nonatomic) NSInteger state;
@property (strong, nonatomic) NSView *controlView;
@property (assign, nonatomic) id formatter;
@property (assign, nonatomic) NSCellType type;
@property (assign, nonatomic) id objectValue;
@property (assign, nonatomic, getter=isContinuous) BOOL continuous;
@property (assign, nonatomic, getter=isBezeled) BOOL bezeled;
@property (assign, nonatomic, getter=isSelectable) BOOL selectable;
@property (assign, nonatomic) BOOL sendsActionOnEndEditing;
@property (assign, nonatomic) float floatValue;
@property (assign, nonatomic, getter=isEditable) BOOL editable;
@property (assign, nonatomic) NSControlTint controlTint;
@property (readonly, nonatomic) NSString *keyEquivalent;
@property (assign, nonatomic) BOOL refusesFirstResponder;
@property (assign, nonatomic) BOOL usesSingleLineMode NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSInteger nextState;
@property (copy, nonatomic) NSString *stringValue;
@property (readonly, nonatomic) NSSize cellSize;
@property (assign, nonatomic) NSControlSize controlSize;
@property (assign, nonatomic, getter=isScrollable) BOOL scrollable;
@property (assign, nonatomic) BOOL allowsUndo;
@property (assign, nonatomic) NSFocusRingType focusRingType;
@property (assign, nonatomic) id target;
@property (assign, nonatomic) NSLineBreakMode lineBreakMode;
@property (assign, nonatomic) NSWritingDirection baseWritingDirection;
@property (assign, nonatomic) int intValue;
@property (assign, nonatomic) BOOL allowsEditingTextAttributes;
@property (assign, nonatomic) id representedObject;
@property (strong, nonatomic) NSMenu *menu;
@property (assign, nonatomic) SEL action;
@property (assign, nonatomic) BOOL importsGraphics;
@property (assign, nonatomic) NSInteger integerValue NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) BOOL acceptsFirstResponder;

@end


@interface NSProgressIndicator (Properties)

@property (assign, nonatomic) NSProgressIndicatorStyle style;
@property (assign, nonatomic, getter=isBezeled) BOOL bezeled;
@property (assign, nonatomic) BOOL usesThreadedAnimation;
@property (assign, nonatomic, getter=isDisplayedWhenStopped) BOOL displayedWhenStopped;
@property (assign, nonatomic, getter=isIndeterminate) BOOL indeterminate;
@property (assign, nonatomic) double doubleValue;
@property (assign, nonatomic) NSControlSize controlSize;
@property (assign, nonatomic) NSControlTint controlTint;
@property (assign, nonatomic) double maxValue;
@property (assign, nonatomic) double minValue;

@end


@interface NSImageCell (Properties)

@property (assign, nonatomic) NSImageScaling imageScaling;
@property (assign, nonatomic) NSImageAlignment imageAlignment;
@property (assign, nonatomic) NSImageFrameStyle imageFrameStyle;

@end


@interface NSTextTab (Properties)

@property (readonly, nonatomic) NSTextTabType tabStopType;
@property (readonly, nonatomic) NSDictionary *options;
@property (readonly, nonatomic) NSTextAlignment alignment;
@property (readonly, nonatomic) CGFloat location;

@end


@interface NSTableHeaderView (Properties)

@property (readonly, nonatomic) CGFloat draggedDistance;
@property (readonly, nonatomic) NSInteger draggedColumn;
@property (strong, nonatomic) NSTableView *tableView;
@property (readonly, nonatomic) NSInteger resizedColumn;

@end


@interface NSTextAttachment (Properties)

@property (strong, nonatomic) NSFileWrapper *fileWrapper;
@property (strong, nonatomic) id <NSTextAttachmentCell>attachmentCell;

@end


@interface NSNib (Properties)


@end


@interface NSParagraphStyle (Properties)

@property (readonly, nonatomic) CGFloat paragraphSpacing;
@property (readonly, nonatomic) CGFloat tailIndent;
@property (readonly, nonatomic) float tighteningFactorForTruncation;
@property (readonly, nonatomic) NSInteger headerLevel;
@property (readonly, nonatomic) CGFloat defaultTabInterval;
@property (readonly, nonatomic) CGFloat lineSpacing;
@property (readonly, nonatomic) NSLineBreakMode lineBreakMode;
@property (readonly, nonatomic) CGFloat maximumLineHeight;
@property (readonly, nonatomic) NSWritingDirection baseWritingDirection;
@property (readonly, nonatomic) CGFloat paragraphSpacingBefore;
@property (readonly, nonatomic) float hyphenationFactor;
@property (readonly, nonatomic) NSArray *textLists;
@property (readonly, nonatomic) NSArray *textBlocks;
@property (readonly, nonatomic) CGFloat headIndent;
@property (readonly, nonatomic) CGFloat lineHeightMultiple;
@property (readonly, nonatomic) CGFloat minimumLineHeight;
@property (readonly, nonatomic) NSArray *tabStops;
@property (readonly, nonatomic) NSTextAlignment alignment;
@property (readonly, nonatomic) CGFloat firstLineHeadIndent;

@end


@interface NSDatePicker (Properties)

@property (assign, nonatomic) NSTimeInterval timeInterval;
@property (assign, nonatomic, getter=isBezeled) BOOL bezeled;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) NSDatePickerElementFlags datePickerElements;
@property (strong, nonatomic) NSLocale *locale;
@property (strong, nonatomic) NSDate *maxDate;
@property (assign, nonatomic) BOOL drawsBackground;
@property (strong, nonatomic) NSTimeZone *timeZone;
@property (assign, nonatomic, getter=isBordered) BOOL bordered;
@property (assign, nonatomic) NSDatePickerStyle datePickerStyle;
@property (assign, nonatomic) id <NSDatePickerCellDelegate> delegate;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic) NSDatePickerMode datePickerMode;
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSColor *textColor;
@property (strong, nonatomic) NSDate *minDate;

@end



@interface NSTextList (Properties)

@property (readonly, nonatomic) NSUInteger listOptions;
@property (assign, nonatomic) NSInteger startingItemNumber NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSString *markerFormat;

@end



@interface NSPICTImageRep (Properties)

@property (readonly, nonatomic) NSRect boundingBox;
@property (readonly, nonatomic) NSData *PICTRepresentation;

@end


@interface NSPrintInfo (Properties)

#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
@property (assign, nonatomic) NSPaperOrientation orientation;
#endif
@property (assign, nonatomic) NSPrintingPaginationMode horizontalPagination;
@property (assign, nonatomic, getter=isSelectionOnly) BOOL selectionOnly NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSMutableDictionary *printSettings NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) CGFloat topMargin;
@property (copy, nonatomic) NSString *jobDisposition;
@property (readonly, nonatomic) NSRect imageablePageBounds;
@property (assign, nonatomic) CGFloat leftMargin;
@property (strong, nonatomic) NSPrinter *printer;
@property (readonly, nonatomic) NSString *localizedPaperName;
@property (readonly, nonatomic) NSMutableDictionary *dictionary;
@property (assign, nonatomic) CGFloat rightMargin;
@property (copy, nonatomic) NSString *paperName;
@property (assign, nonatomic) CGFloat bottomMargin;
@property (assign, nonatomic) NSPrintingPaginationMode verticalPagination;
@property (assign, nonatomic, getter=isHorizontallyCentered) BOOL horizontallyCentered;
@property (assign, nonatomic) NSSize paperSize;
@property (assign, nonatomic, getter=isVerticallyCentered) BOOL verticallyCentered;
@property (assign, nonatomic) CGFloat scalingFactor NS_AVAILABLE_MAC(10_6);

@end


@interface NSTabView (Properties)

@property (readonly, nonatomic) NSInteger numberOfTabViewItems;
@property (assign, nonatomic) NSTabViewType tabViewType;
@property (assign, nonatomic) BOOL drawsBackground;
@property (readonly, nonatomic) NSSize minimumSize;
@property (readonly, nonatomic) NSTabViewItem *selectedTabViewItem;
@property (readonly, nonatomic) NSArray *tabViewItems;
@property (assign, nonatomic) NSControlTint controlTint;
@property (assign, nonatomic) NSControlSize controlSize;
@property (assign, nonatomic) id <NSTabViewDelegate> delegate;
@property (readonly, nonatomic) NSRect contentRect;
@property (assign, nonatomic) BOOL allowsTruncatedLabels;
@property (strong, nonatomic) NSFont *font;

@end


@interface NSSpellChecker (Properties)

@property (readonly, nonatomic) NSPanel *spellingPanel;
@property (copy, nonatomic) NSString *wordFieldStringValue;
- (NSString *)wordFieldStringValue UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSView *accessoryView;
@property (readonly, nonatomic) NSString *language;
@property (readonly, nonatomic) NSArray *userPreferredLanguages NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) BOOL automaticallyIdentifiesLanguages NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSArray *availableLanguages NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSPanel *substitutionsPanel NS_AVAILABLE_MAC(10_6);
@property (strong, nonatomic) NSViewController *substitutionsPanelAccessoryViewController NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSDictionary *userReplacementsDictionary NS_AVAILABLE_MAC(10_6);

@end


@interface NSPredicateEditorRowTemplate (Properties)

@property (strong, nonatomic) NSPredicate *predicate;
- (NSPredicate *)predicate UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSArray *leftExpressions;
@property (readonly, nonatomic) NSAttributeType rightExpressionAttributeType;
@property (readonly, nonatomic) NSArray *operators;
@property (readonly, nonatomic) NSArray *compoundTypes;
@property (readonly, nonatomic) NSArray *templateViews;
@property (readonly, nonatomic) NSArray *rightExpressions;
@property (readonly, nonatomic) NSComparisonPredicateModifier modifier;
@property (readonly, nonatomic) NSUInteger options;

@end


@interface NSSpeechRecognizer (Properties)

@property (strong, nonatomic) NSArray *commands;
@property (copy, nonatomic) NSString *displayedCommandsTitle;
@property (assign, nonatomic) id <NSSpeechRecognizerDelegate> delegate;
@property (assign, nonatomic) BOOL blocksOtherRecognizers;
@property (assign, nonatomic) BOOL listensInForegroundOnly;

@end


@interface NSStatusBar (Properties)

@property (readonly, nonatomic) BOOL isVertical;
@property (readonly, nonatomic) CGFloat thickness;

@end


@interface NSPasteboardItem (Properties)

@property (readonly, nonatomic) NSArray *types;

@end


@interface NSHelpManager (Properties)


@end


@interface NSBrowser (Properties)

@property (assign, nonatomic) BOOL autohidesScroller NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic, getter=isTitled) BOOL titled;
@property (assign, nonatomic) CGFloat rowHeight NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) BOOL isLoaded;
@property (assign, nonatomic) Class cellClass;
- (Class)cellClass UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) id selectedCell;
@property (assign, nonatomic) Class matrixClass;
@property (readonly, nonatomic) NSInteger clickedColumn NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) BOOL sendsActionOnArrowKeys;
@property (readonly, nonatomic) NSInteger selectedColumn;
@property (assign, nonatomic) CGFloat minColumnWidth;
@property (readonly, nonatomic) NSInteger lastVisibleColumn;
@property (assign, nonatomic) BOOL hasHorizontalScroller;
@property (assign, nonatomic) NSBrowserColumnResizingType columnResizingType;
@property (copy, nonatomic) NSString *pathSeparator;
@property (assign, nonatomic) SEL doubleAction;
@property (assign, nonatomic) BOOL allowsTypeSelect NS_AVAILABLE_MAC(10_5);
@property (strong, nonatomic) NSColor *backgroundColor NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) NSInteger maxVisibleColumns;
@property (assign, nonatomic) BOOL reusesColumns;
@property (strong, nonatomic) NSArray *selectionIndexPaths NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) CGFloat defaultColumnWidth NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) BOOL prefersAllColumnUserResizing;
@property (assign, nonatomic) BOOL allowsEmptySelection;
@property (assign, nonatomic) BOOL separatesColumns;
@property (readonly, nonatomic) CGFloat titleHeight;
@property (assign, nonatomic) BOOL allowsMultipleSelection;
@property (readonly, nonatomic) NSString *path;
@property (strong, nonatomic) NSIndexPath *selectionIndexPath NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) BOOL takesTitleFromPreviousColumn;
@property (readonly, nonatomic) NSInteger firstVisibleColumn;
@property (assign, nonatomic) NSInteger lastColumn;
@property (readonly, nonatomic) NSInteger clickedRow NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) id cellPrototype;
@property (assign, nonatomic) BOOL allowsBranchSelection;
@property (readonly, nonatomic) NSArray *selectedCells;
@property (assign, nonatomic) id <NSBrowserDelegate> delegate;
@property (readonly, nonatomic) BOOL sendAction;
@property (copy, nonatomic) NSString *columnsAutosaveName;
@property (readonly, nonatomic) NSInteger numberOfVisibleColumns;

@end


@interface NSToolbarItem (Properties)

@property (copy, nonatomic) NSString *paletteLabel;
@property (readonly, nonatomic) NSString *itemIdentifier;
@property (assign, nonatomic) id target;
@property (readonly, nonatomic) BOOL allowsDuplicatesInToolbar;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (assign, nonatomic) NSInteger visibilityPriority;
@property (copy, nonatomic) NSString *toolTip;
@property (copy, nonatomic) NSString *label;
@property (assign, nonatomic) NSSize minSize;
@property (assign, nonatomic) NSSize maxSize;
@property (assign, nonatomic) NSInteger tag;
@property (readonly, nonatomic) NSToolbar *toolbar;
@property (assign, nonatomic) BOOL autovalidates;
@property (assign, nonatomic) SEL action;
@property (strong, nonatomic) NSImage *image;
@property (strong, nonatomic) NSMenuItem *menuFormRepresentation;
@property (strong, nonatomic) NSView *view;

@end


@interface NSCoder (Properties)


@end


@interface NSSegmentedCell (Properties)

@property (assign, nonatomic) NSInteger selectedSegment;
@property (assign, nonatomic) NSSegmentStyle segmentStyle NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) NSInteger segmentCount;
@property (assign, nonatomic) NSSegmentSwitchTracking trackingMode;

@end


@interface NSColorWell (Properties)

@property (strong, nonatomic) NSColor *color;
@property (assign, nonatomic, getter=isBordered) BOOL bordered;
@property (readonly, nonatomic) BOOL isActive;

@end


@interface NSPopUpButtonCell (Properties)

@property (assign, nonatomic) BOOL autoenablesItems;
@property (readonly, nonatomic) NSInteger indexOfSelectedItem;
@property (readonly, nonatomic) NSString *titleOfSelectedItem;
@property (assign, nonatomic) NSPopUpArrowPosition arrowPosition;
@property (assign, nonatomic) BOOL altersStateOfSelectedItem;
@property (readonly, nonatomic) NSArray *itemArray;
@property (readonly, nonatomic) NSArray *itemTitles;
@property (readonly, nonatomic) NSMenuItem *selectedItem;
@property (readonly, nonatomic) NSInteger numberOfItems;
@property (assign, nonatomic) BOOL pullsDown;
@property (assign, nonatomic) NSRectEdge preferredEdge;
@property (assign, nonatomic) BOOL usesItemFromMenu;
@property (readonly, nonatomic) NSMenuItem *lastItem;

@end


@interface NSBrowserCell (Properties)

@property (assign, nonatomic, getter=isLeaf) BOOL leaf;
@property (strong, nonatomic) NSImage *alternateImage;
@property (assign, nonatomic, getter=isLoaded) BOOL loaded;

@end


@interface NSMenu (Properties)

@property (assign, nonatomic) BOOL autoenablesItems;
@property (strong, nonatomic) NSFont *font NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) CGFloat minimumWidth NS_AVAILABLE_MAC(10_6);
@property (copy, nonatomic) NSString *title;
@property (readonly, nonatomic) BOOL isTornOff;
@property (readonly, nonatomic) NSArray *itemArray;
@property (readonly, nonatomic) NSMenuProperties propertiesToUpdate NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) BOOL menuChangedMessagesEnabled;
@property (readonly, nonatomic) NSMenuItem *highlightedItem NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) BOOL allowsContextMenuPlugIns NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) BOOL showsStateColumn NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSInteger numberOfItems;
@property (readonly, nonatomic) NSSize size NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) CGFloat menuBarHeight;
@property (strong, nonatomic) NSMenu *supermenu;
@property (assign, nonatomic) id <NSMenuDelegate> delegate;

@end


@interface NSImageRep (Properties)

@property (assign, nonatomic) NSInteger pixelsHigh;
@property (readonly, nonatomic) BOOL draw;
@property (assign, nonatomic, getter=isOpaque) BOOL opaque;
@property (assign, nonatomic) NSInteger bitsPerSample;
@property (assign, nonatomic) NSInteger pixelsWide;
@property (copy, nonatomic) NSString *colorSpaceName;
@property (assign, nonatomic, getter=hasAlpha) BOOL alpha;
@property (assign, nonatomic) NSSize size;

@end


@interface NSTreeController (Properties)

@property (copy, nonatomic) NSString *childrenKeyPath;
@property (readonly, nonatomic) BOOL canInsert;
@property (assign, nonatomic) BOOL alwaysUsesMultipleValuesMarker;
@property (copy, nonatomic) NSString *countKeyPath;
@property (assign, nonatomic) BOOL preservesSelection;
@property (readonly, nonatomic) BOOL canAddChild;
@property (readonly, nonatomic) NSArray *selectedObjects;
@property (readonly, nonatomic) NSArray *selectedNodes NS_AVAILABLE_MAC(10_5);
@property (strong, nonatomic) NSArray *sortDescriptors;
@property (copy, nonatomic) NSString *leafKeyPath;
@property (assign, nonatomic) BOOL selectsInsertedObjects;
@property (readonly, nonatomic) NSIndexPath *selectionIndexPath;
@property (readonly, nonatomic) BOOL canInsertChild;
@property (assign, nonatomic) BOOL avoidsEmptySelection;
@property (readonly, nonatomic) NSArray *selectionIndexPaths;
@property (readonly, nonatomic) id arrangedObjects;

@end


@interface NSDocumentController (Properties)

@property (readonly, nonatomic) NSArray *documents;
@property (assign, nonatomic) NSTimeInterval autosavingDelay;
@property (readonly, nonatomic) NSString *currentDirectory;
@property (readonly, nonatomic) NSArray *documentClassNames;
@property (readonly, nonatomic) NSUInteger maximumRecentDocumentCount;
@property (readonly, nonatomic) id currentDocument;
@property (readonly, nonatomic) NSArray *URLsFromRunningOpenPanel;
@property (readonly, nonatomic) NSString *defaultType;
@property (readonly, nonatomic) BOOL hasEditedDocuments;
@property (readonly, nonatomic) NSArray *recentDocumentURLs;

@end


@interface NSBox (Properties)

@property (strong, nonatomic) NSColor *borderColor NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) id contentView;
@property (readonly, nonatomic) NSRect titleRect;
@property (assign, nonatomic) NSTitlePosition titlePosition;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSRect frameFromContentFrame;
- (NSRect)frameFromContentFrame UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) NSBoxType boxType;
@property (readonly, nonatomic) NSRect borderRect;
@property (assign, nonatomic) NSBorderType borderType;
@property (readonly, nonatomic) id titleCell;
@property (strong, nonatomic) NSFont *titleFont;
@property (assign, nonatomic) CGFloat borderWidth NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) NSSize contentViewMargins;
@property (strong, nonatomic) NSColor *fillColor NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic, getter=isTransparent) BOOL transparent NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) CGFloat cornerRadius NS_AVAILABLE_MAC(10_5);

@end


@interface NSAffineTransform (Properties)


@end


@interface NSPasteboard (Properties)

@property (readonly, nonatomic) NSInteger clearContents NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSInteger changeCount;
@property (readonly, nonatomic) NSFileWrapper *readFileWrapper;
@property (readonly, nonatomic) NSArray *pasteboardItems NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) void releaseGlobally;
@property (readonly, nonatomic) NSArray *types;

@end


@interface NSDatePickerCell (Properties)

@property (assign, nonatomic) NSTimeInterval timeInterval;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) NSDatePickerElementFlags datePickerElements;
@property (strong, nonatomic) NSLocale *locale;
@property (strong, nonatomic) NSDate *maxDate;
@property (assign, nonatomic) BOOL drawsBackground;
@property (assign, nonatomic) NSDatePickerStyle datePickerStyle;
@property (assign, nonatomic) id <NSDatePickerCellDelegate> delegate;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (strong, nonatomic) NSTimeZone *timeZone;
@property (assign, nonatomic) NSDatePickerMode datePickerMode;
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSColor *textColor;
@property (strong, nonatomic) NSDate *minDate;

@end


@interface NSPageController (Properties)


@end


@interface NSButton (Properties)

@property (strong, nonatomic) NSSound *sound;
@property (assign, nonatomic) BOOL showsBorderOnlyWhileMouseInside;
@property (assign, nonatomic) NSBezelStyle bezelStyle;
@property (assign, nonatomic) NSButtonType buttonType;
- (NSButtonType)buttonType UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSImage *alternateImage;
@property (strong, nonatomic) NSImage *image;
@property (assign, nonatomic) NSCellImagePosition imagePosition;
@property (assign, nonatomic, getter=isBordered) BOOL bordered;
@property (copy, nonatomic) NSString *alternateTitle;
@property (copy, nonatomic) NSAttributedString *attributedTitle;
@property (assign, nonatomic) NSInteger state;
@property (assign, nonatomic) BOOL allowsMixedState;
@property (copy, nonatomic) NSString *keyEquivalent;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSUInteger keyEquivalentModifierMask;
@property (copy, nonatomic) NSAttributedString *attributedAlternateTitle;
@property (assign, nonatomic, getter=isTransparent) BOOL transparent;

@end


@interface NSAnimationContext (Properties)


@end


@interface NSBundle (Properties)


@end


@interface NSDictionaryController (Properties)

@property (assign, nonatomic) id initialValue;
@property (strong, nonatomic) NSDictionary *localizedKeyDictionary;
@property (copy, nonatomic) NSString *initialKey;
@property (strong, nonatomic) NSArray *excludedKeys;
@property (strong, nonatomic) NSArray *includedKeys;
@property (copy, nonatomic) NSString *localizedKeyTable;
@property (readonly, nonatomic) id newObject;

@end


@interface NSPopUpButton (Properties)

@property (assign, nonatomic) BOOL autoenablesItems;
@property (readonly, nonatomic) NSInteger indexOfSelectedItem;
@property (readonly, nonatomic) NSString *titleOfSelectedItem;
@property (readonly, nonatomic) NSMenuItem *selectedItem;
@property (readonly, nonatomic) NSArray *itemArray;
@property (readonly, nonatomic) NSArray *itemTitles;
@property (readonly, nonatomic) NSInteger numberOfItems;
@property (assign, nonatomic) BOOL pullsDown;
@property (assign, nonatomic) NSRectEdge preferredEdge;
@property (readonly, nonatomic) NSMenuItem *lastItem;

@end


@interface NSTreeNode (Properties)

@property (readonly, nonatomic) NSIndexPath *indexPath;
@property (readonly, nonatomic) NSTreeNode *parentNode;
@property (readonly, nonatomic) id representedObject;
@property (readonly, nonatomic) NSMutableArray *mutableChildNodes;
@property (readonly, nonatomic) NSArray *childNodes;
@property (readonly, nonatomic) BOOL isLeaf;

@end


@interface NSTextBlock (Properties)

@property (strong, nonatomic) NSColor *borderColor;
- (NSColor *)borderColor UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSTextBlockValueType contentWidthValueType;
@property (assign, nonatomic) NSTextBlockVerticalAlignment verticalAlignment;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (readonly, nonatomic) CGFloat contentWidth;

@end


@interface NSObject (Properties)

@property (readonly, nonatomic) NSArray *accessibilityParameterizedAttributeNames;
@property (readonly, nonatomic) BOOL isExplicitlyIncluded;
@property (readonly, nonatomic) NSArray *accessibilityActionNames;
@property (readonly, nonatomic) NSArray *accessibilityAttributeNames;
@property (assign, nonatomic) id value;
@property (readonly, nonatomic) NSArray *exposedBindings;
@property (readonly, nonatomic) BOOL commitEditing;
@property (copy, nonatomic) NSString *localizedKey;
@property (copy, nonatomic) NSString *key;
@property (readonly, nonatomic) BOOL accessibilityIsIgnored;
@property (readonly, nonatomic) BOOL ignoreModifierKeysWhileDragging;
@property (readonly, nonatomic) BOOL accessibilityNotifiesWhenDestroyed NS_AVAILABLE_MAC(10_9);
@property (readonly, nonatomic) id accessibilityFocusedUIElement;

@end


@interface NSResponder (Properties)

@property (readonly, nonatomic) NSUndoManager *undoManager;
@property (readonly, nonatomic) BOOL resignFirstResponder;
@property (strong, nonatomic) NSMenu *menu;
@property (assign, nonatomic) id mark;
- (id)mark UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSResponder *nextResponder;
@property (readonly, nonatomic) BOOL becomeFirstResponder;
@property (readonly, nonatomic) BOOL acceptsFirstResponder;

@end





@interface NSColorPanel (Properties)

@property (strong, nonatomic) NSView *accessoryView;
@property (assign, nonatomic) id target;
- (id)target UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSColor *color;
@property (assign, nonatomic, getter=isContinuous) BOOL continuous;
@property (assign, nonatomic) SEL action;
- (SEL)action UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) BOOL showsAlpha;
@property (readonly, nonatomic) CGFloat alpha;
@property (assign, nonatomic) NSColorPanelMode mode;

@end


@interface NSUserDefaultsController (Properties)

@property (assign, nonatomic) BOOL appliesImmediately;
@property (readonly, nonatomic) id values;
@property (strong, nonatomic) NSDictionary *initialValues;
@property (readonly, nonatomic) BOOL hasUnappliedChanges;
@property (readonly, nonatomic) NSUserDefaults *defaults;

@end


@interface NSScreen (Properties)

@property (readonly, nonatomic) NSDictionary *deviceDescription;
@property (readonly, nonatomic) NSRect frame;
@property (readonly, nonatomic) NSColorSpace *colorSpace NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSWindowDepth depth;
@property (readonly, nonatomic) CGFloat backingScaleFactor NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) const NSWindowDepth *supportedWindowDepths;
@property (readonly, nonatomic) CGFloat userSpaceScaleFactor;
@property (readonly, nonatomic) NSRect visibleFrame;

@end


@interface CIImage (Properties)


@end


@interface CIColor (Properties)


@end


@interface NSSliderCell (Properties)

@property (assign, nonatomic) double altIncrementValue;
@property (assign, nonatomic) NSSliderType sliderType;
@property (assign, nonatomic) double maxValue;
@property (assign, nonatomic) NSInteger numberOfTickMarks;
@property (assign, nonatomic) double minValue;
@property (assign, nonatomic) BOOL allowsTickMarkValuesOnly;
@property (readonly, nonatomic) CGFloat knobThickness;
@property (assign, nonatomic) NSTickMarkPosition tickMarkPosition;
@property (readonly, nonatomic) NSRect trackRect;
@property (readonly, nonatomic) NSInteger isVertical;

@end


@interface NSFontManager (Properties)

@property (readonly, nonatomic) NSFont *selectedFont;
@property (readonly, nonatomic) NSFontAction currentFontAction NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSArray *collectionNames;
@property (assign, nonatomic) id target NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (strong, nonatomic) NSMenu *fontMenu;
- (NSMenu *)fontMenu UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSArray *availableFontFamilies;
@property (assign, nonatomic) id delegate;
@property (readonly, nonatomic) BOOL sendAction;
@property (assign, nonatomic) SEL action;
@property (readonly, nonatomic) NSArray *availableFonts;
@property (readonly, nonatomic) BOOL isMultiple;

@end


@interface NSObjectController (Properties)

@property (readonly, nonatomic) id selection;
@property (readonly, nonatomic) BOOL canAdd;
@property (assign, nonatomic) Class objectClass;
@property (readonly, nonatomic) NSArray *selectedObjects;
@property (assign, nonatomic, getter=isEditable) BOOL editable;
@property (strong, nonatomic) NSPredicate *fetchPredicate;
@property (assign, nonatomic) BOOL automaticallyPreparesContent;
@property (readonly, nonatomic) NSFetchRequest *defaultFetchRequest NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) id content;
@property (readonly, nonatomic) id newObject;
@property (readonly, nonatomic) BOOL canRemove;
@property (copy, nonatomic) NSString *entityName;
@property (assign, nonatomic) BOOL usesLazyFetching NS_AVAILABLE_MAC(10_5);
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end




@interface NSCIImageRep (Properties)

@property (readonly, nonatomic) CIImage *CIImage;

@end


@interface NSColorList (Properties)

@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSArray *allKeys;
@property (readonly, nonatomic) BOOL isEditable;

@end


@interface NSMenuItemCell (Properties)

@property (readonly, nonatomic) CGFloat keyEquivalentWidth;
@property (assign, nonatomic) BOOL needsDisplay;
@property (assign, nonatomic) BOOL needsSizing;
@property (readonly, nonatomic) NSInteger tag;
@property (readonly, nonatomic) CGFloat imageWidth;
@property (strong, nonatomic) NSMenuItem *menuItem;
@property (readonly, nonatomic) CGFloat titleWidth;
@property (readonly, nonatomic) CGFloat stateImageWidth;

@end


@interface NSColorPicker (Properties)

@property (readonly, nonatomic) NSString *buttonToolTip;
@property (readonly, nonatomic) NSImage *provideNewButtonImage;
@property (assign, nonatomic) NSColorPanelMode mode;
- (NSColorPanelMode)mode UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSSize minContentSize;
@property (readonly, nonatomic) NSColorPanel *colorPanel;

@end


@interface NSPathControl (Properties)

@property (strong, nonatomic) NSArray *pathComponentCells;
@property (assign, nonatomic) NSPathStyle pathStyle;
@property (strong, nonatomic) NSURL *URL;
@property (assign, nonatomic) SEL doubleAction;
@property (assign, nonatomic) id <NSPathControlDelegate> delegate;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (readonly, nonatomic) NSPathComponentCell *clickedPathComponentCell;

@end


@interface NSSplitView (Properties)

@property (assign, nonatomic, getter=isVertical) BOOL vertical;
@property (assign, nonatomic) NSSplitViewDividerStyle dividerStyle NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSColor *dividerColor NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) id <NSSplitViewDelegate> delegate;
@property (readonly, nonatomic) CGFloat dividerThickness;
@property (copy, nonatomic) NSString *autosaveName NS_AVAILABLE_MAC(10_5);

@end


@interface NSMutableAttributedString (Properties)


@end


@interface NSAttributedString (Properties)

@property (readonly, nonatomic) BOOL containsAttachments;
@property (readonly, nonatomic) NSSize size;

@end


#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
@interface NSAppearance (Properties)


@end
#endif


@interface NSRulerView (Properties)

@property (strong, nonatomic) NSView *clientView;
@property (assign, nonatomic) NSRulerOrientation orientation;
@property (readonly, nonatomic) BOOL isFlipped;
@property (assign, nonatomic) CGFloat reservedThicknessForAccessoryView;
@property (strong, nonatomic) NSView *accessoryView;
@property (strong, nonatomic) NSScrollView *scrollView;
@property (readonly, nonatomic) CGFloat baselineLocation;
@property (readonly, nonatomic) CGFloat requiredThickness;
@property (strong, nonatomic) NSArray *markers;
@property (assign, nonatomic) CGFloat reservedThicknessForMarkers;
@property (copy, nonatomic) NSString *measurementUnits;
@property (assign, nonatomic) CGFloat originOffset;
@property (assign, nonatomic) CGFloat ruleThickness;

@end


@interface NSPDFImageRep (Properties)

@property (readonly, nonatomic) NSData *PDFRepresentation;
@property (assign, nonatomic) NSInteger currentPage;
@property (readonly, nonatomic) NSRect bounds;
@property (readonly, nonatomic) NSInteger pageCount;

@end


@interface NSActionCell (Properties)

@property (assign, nonatomic) SEL action;
@property (assign, nonatomic) NSInteger tag;

@end


@interface NSSecureTextFieldCell (Properties)

@property (assign, nonatomic) BOOL echosBullets;

@end


@interface NSAppleScript (Properties)

@property (readonly, nonatomic) NSAttributedString *richTextSource;

@end


@interface NSControl (Properties)

@property (readonly, nonatomic) NSText *currentEditor;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (assign, nonatomic) NSInteger tag;
@property (readonly, nonatomic) id selectedCell;
@property (strong, nonatomic) NSFont *font;
@property (assign, nonatomic) NSTextAlignment alignment;
@property (assign, nonatomic) double doubleValue;
@property (assign, nonatomic) id cell;
@property (copy, nonatomic) NSAttributedString *attributedStringValue;
@property (assign, nonatomic) BOOL ignoresMultiClick;
@property (assign, nonatomic) id formatter;
@property (assign, nonatomic) id objectValue;
@property (assign, nonatomic, getter=isContinuous) BOOL continuous;
@property (assign, nonatomic) float floatValue;
@property (assign, nonatomic) int intValue;
@property (copy, nonatomic) NSString *stringValue;
@property (assign, nonatomic) BOOL allowsExpansionToolTips NS_AVAILABLE_MAC(10_8);
@property (assign, nonatomic) id target;
@property (assign, nonatomic) NSWritingDirection baseWritingDirection;
@property (assign, nonatomic) BOOL refusesFirstResponder;
@property (readonly, nonatomic) NSInteger selectedTag;
@property (assign, nonatomic) NSUserInterfaceLayoutDirection userInterfaceLayoutDirection NS_AVAILABLE_MAC(10_8);
@property (assign, nonatomic) SEL action;
@property (readonly, nonatomic) BOOL abortEditing;
@property (assign, nonatomic) NSInteger integerValue NS_AVAILABLE_MAC(10_5);

@end



@interface NSLevelIndicator (Properties)

@property (assign, nonatomic) double criticalValue;
@property (assign, nonatomic) NSInteger numberOfMajorTickMarks;
@property (assign, nonatomic) double maxValue;
@property (assign, nonatomic) NSInteger numberOfTickMarks;
@property (assign, nonatomic) double minValue;
@property (assign, nonatomic) NSTickMarkPosition tickMarkPosition;
@property (assign, nonatomic) double warningValue;

@end


@interface NSFormCell (Properties)

@property (assign, nonatomic) NSWritingDirection titleBaseWritingDirection;
@property (assign, nonatomic) CGFloat preferredTextFieldWidth NS_AVAILABLE_MAC(10_8);
@property (assign, nonatomic) NSTextAlignment titleAlignment;
@property (readonly, nonatomic) BOOL isOpaque;
@property (strong, nonatomic) NSFont *titleFont;
@property (copy, nonatomic) NSString *placeholderString;
@property (copy, nonatomic) NSAttributedString *attributedTitle;
@property (assign, nonatomic) CGFloat titleWidth;
@property (copy, nonatomic) NSAttributedString *placeholderAttributedString;

@end


@interface NSDockTile (Properties)

@property (assign, nonatomic) BOOL showsApplicationBadge;
@property (readonly, nonatomic) id owner;
@property (copy, nonatomic) NSString *badgeLabel;
@property (strong, nonatomic) NSView *contentView;
@property (readonly, nonatomic) NSSize size;

@end


@interface NSWindowController (Properties)

@property (assign, nonatomic) BOOL documentEdited;
- (BOOL)documentEdited UNAVAILABLE_ATTRIBUTE;
@property (copy, nonatomic) NSString *windowFrameAutosaveName;
@property (readonly, nonatomic) NSString *windowNibName;
@property (assign, nonatomic) BOOL shouldCloseDocument;
@property (strong, nonatomic) NSWindow *window;
@property (assign, nonatomic) BOOL shouldCascadeWindows;
@property (readonly, nonatomic) NSString *windowNibPath;
@property (readonly, nonatomic) id owner;
@property (assign, nonatomic) id document;
@property (readonly, nonatomic) BOOL isWindowLoaded;

@end


@interface NSOpenGLPixelBuffer (Properties)


@end


@interface NSAnimation (Properties)

@property (readonly, nonatomic) float currentValue;
@property (assign, nonatomic) NSAnimationCurve animationCurve;
@property (readonly, nonatomic) NSArray *runLoopModesForAnimating;
@property (assign, nonatomic) float frameRate;
@property (strong, nonatomic) NSArray *progressMarks;
@property (readonly, nonatomic) BOOL isAnimating;
@property (assign, nonatomic) id <NSAnimationDelegate> delegate;
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) NSAnimationBlockingMode animationBlockingMode;
@property (assign, nonatomic) NSAnimationProgress currentProgress;

@end


@interface NSPageLayout (Properties)

@property (readonly, nonatomic) NSPrintInfo *printInfo;
@property (readonly, nonatomic) NSInteger runModal;
@property (readonly, nonatomic) NSArray *accessoryControllers NS_AVAILABLE_MAC(10_5);

@end


@interface NSURL (Properties)


@end


@interface NSOpenGLContext (Properties)

@property (readonly, nonatomic) void *CGLContextObj;
@property (assign, nonatomic) GLint currentVirtualScreen;
@property (strong, nonatomic) NSView *view;

@end


@interface NSTextInputContext (Properties)


@end


@interface NSForm (Properties)

@property (readonly, nonatomic) NSInteger indexOfSelectedItem;
@property (assign, nonatomic) NSWritingDirection titleBaseWritingDirection;
- (NSWritingDirection)titleBaseWritingDirection UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) BOOL bezeled;
- (BOOL)bezeled UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat preferredTextFieldWidth NS_AVAILABLE_MAC(10_8);
@property (assign, nonatomic) NSTextAlignment titleAlignment;
- (NSTextAlignment)titleAlignment UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) NSWritingDirection textBaseWritingDirection;
- (NSWritingDirection)textBaseWritingDirection UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat entryWidth;
- (CGFloat)entryWidth UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) BOOL bordered;
- (BOOL)bordered UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat interlineSpacing;
- (CGFloat)interlineSpacing UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSFont *titleFont;
- (NSFont *)titleFont UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSFont *textFont;
- (NSFont *)textFont UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) NSTextAlignment textAlignment;
- (NSTextAlignment)textAlignment UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) NSSize frameSize;
- (NSSize)frameSize UNAVAILABLE_ATTRIBUTE;

@end


@interface NSClipView (Properties)

@property (assign, nonatomic) id documentView;
@property (assign, nonatomic) BOOL drawsBackground;
@property (readonly, nonatomic) NSRect documentRect;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic) BOOL copiesOnScroll;
@property (readonly, nonatomic) NSRect documentVisibleRect;
@property (strong, nonatomic) NSCursor *documentCursor;

@end


@interface NSOpenGLView (Properties)

@property (strong, nonatomic) NSOpenGLPixelFormat *pixelFormat;
@property (strong, nonatomic) NSOpenGLContext *openGLContext;

@end



@interface NSCustomImageRep (Properties)

@property (readonly, nonatomic) SEL drawSelector;
@property (readonly, nonatomic) id delegate;

@end


@interface NSRuleEditor (Properties)

@property (readonly, nonatomic) NSPredicate *predicate;
@property (assign, nonatomic) CGFloat rowHeight;
@property (copy, nonatomic) NSString *displayValuesKeyPath;
@property (assign, nonatomic, getter=isEditable) BOOL editable;
@property (copy, nonatomic) NSString *rowTypeKeyPath;
@property (assign, nonatomic) Class rowClass;
@property (copy, nonatomic) NSString *criteriaKeyPath;
@property (copy, nonatomic) NSString *formattingStringsFilename;
@property (assign, nonatomic) NSRuleEditorNestingMode nestingMode;
@property (strong, nonatomic) NSDictionary *formattingDictionary;
@property (copy, nonatomic) NSString *subrowsKeyPath;
@property (assign, nonatomic) BOOL canRemoveAllRows;
@property (readonly, nonatomic) NSIndexSet *selectedRowIndexes;
@property (readonly, nonatomic) NSInteger numberOfRows;
@property (assign, nonatomic) id <NSRuleEditorDelegate> delegate;

@end


@interface NSOpenGLLayer (Properties)


@end


@interface NSGradient (Properties)

@property (readonly, nonatomic) NSInteger numberOfColorStops;
@property (readonly, nonatomic) NSColorSpace *colorSpace;

@end


@interface NSWorkspace (Properties)

@property (readonly, nonatomic) NSArray *fileLabels NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSArray *runningApplications NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSDictionary *activeApplication;
@property (readonly, nonatomic) NSRunningApplication *menuBarOwningApplication NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSArray *fileLabelColors NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSRunningApplication *frontmostApplication NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSNotificationCenter *notificationCenter;
@property (readonly, nonatomic) NSArray *mountedLocalVolumePaths;
@property (readonly, nonatomic) NSArray *mountedRemovableMedia;

@end


@interface NSTokenField (Properties)

@property (assign, nonatomic) NSTokenStyle tokenStyle;
@property (strong, nonatomic) NSCharacterSet *tokenizingCharacterSet;
@property (assign, nonatomic) NSTimeInterval completionDelay;

@end


@interface NSStepperCell (Properties)

@property (assign, nonatomic) BOOL valueWraps;
@property (assign, nonatomic) BOOL autorepeat;
@property (assign, nonatomic) double maxValue;
@property (assign, nonatomic) double increment;
@property (assign, nonatomic) double minValue;

@end


@interface NSGraphicsContext (Properties)

@property (assign, nonatomic) NSColorRenderingIntent colorRenderingIntent NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) void *graphicsPort;
@property (readonly, nonatomic) BOOL isDrawingToScreen;
@property (assign, nonatomic) id focusStack;
@property (assign, nonatomic) NSPoint patternPhase;
@property (assign, nonatomic) NSImageInterpolation imageInterpolation;
@property (readonly, nonatomic) BOOL isFlipped;
@property (readonly, nonatomic) CIContext *CIContext;
@property (readonly, nonatomic) NSDictionary *attributes;
@property (assign, nonatomic) NSCompositingOperation compositingOperation;
@property (assign, nonatomic) BOOL shouldAntialias;

@end


@interface NSTextFieldCell (Properties)

@property (assign, nonatomic) NSTextFieldBezelStyle bezelStyle;
@property (assign, nonatomic) BOOL drawsBackground;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (strong, nonatomic) NSArray *allowedInputSourceLocales NS_AVAILABLE_MAC(10_5);
@property (copy, nonatomic) NSString *placeholderString;
@property (assign, nonatomic) BOOL wantsNotificationForMarkedText NS_AVAILABLE_MAC(10_5);
- (BOOL)wantsNotificationForMarkedText UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSColor *textColor;
@property (copy, nonatomic) NSAttributedString *placeholderAttributedString;

@end


@interface NSStatusItem (Properties)

@property (assign, nonatomic) id target;
@property (strong, nonatomic) NSString * title;
@property (readonly, nonatomic) NSStatusBar * statusBar;
@property (strong, nonatomic) NSMenu * menu;
@property (strong, nonatomic) NSImage * image;
@property (strong, nonatomic) NSImage *alternateImage;
@property (assign, nonatomic) BOOL highlightMode;
@property (strong, nonatomic) NSString * toolTip;
@property (assign, nonatomic) SEL doubleAction;
@property (assign, nonatomic) CGFloat length;
@property (assign, nonatomic) SEL action;
@property (strong, nonatomic) NSAttributedString * attributedTitle;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (strong, nonatomic) NSView * view;

@end


@interface NSStepper (Properties)

@property (assign, nonatomic) BOOL valueWraps;
@property (assign, nonatomic) BOOL autorepeat;
@property (assign, nonatomic) double maxValue;
@property (assign, nonatomic) double increment;
@property (assign, nonatomic) double minValue;

@end


@interface NSTableColumn (Properties)

@property (assign, nonatomic) NSUInteger resizingMask;
@property (strong, nonatomic) NSTableView *tableView;
@property (assign, nonatomic) CGFloat maxWidth;
@property (assign, nonatomic, getter=isEditable) BOOL editable;
@property (strong, nonatomic) NSSortDescriptor *sortDescriptorPrototype;
@property (copy, nonatomic) NSString *headerToolTip NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) CGFloat minWidth;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic, getter=isHidden) BOOL hidden NS_AVAILABLE_MAC(10_5);
@property (copy, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSTableHeaderCell *headerCell;
@property (strong, nonatomic) NSCell *dataCell;

@end


@interface NSButtonCell (Properties)

@property (strong, nonatomic) NSImage *alternateImage;
@property (readonly, nonatomic) BOOL isOpaque;
@property (assign, nonatomic) BOOL showsBorderOnlyWhileMouseInside;
@property (copy, nonatomic) NSAttributedString *attributedTitle;
@property (assign, nonatomic) NSImageScaling imageScaling NS_AVAILABLE_MAC(10_5);
@property (strong, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic) NSInteger highlightsBy;
@property (assign, nonatomic) NSInteger showsStateBy;
@property (assign, nonatomic) NSCellImagePosition imagePosition;
@property (copy, nonatomic) NSString *alternateTitle;
@property (assign, nonatomic) NSUInteger keyEquivalentModifierMask;
@property (assign, nonatomic, getter=isTransparent) BOOL transparent;
@property (strong, nonatomic) NSSound *sound;
@property (strong, nonatomic) NSFont *keyEquivalentFont;
@property (assign, nonatomic) NSBezelStyle bezelStyle;
@property (assign, nonatomic) NSButtonType buttonType;
- (NSButtonType)buttonType UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) BOOL imageDimsWhenDisabled;
@property (assign, nonatomic) NSGradientType gradientType;
@property (copy, nonatomic) NSString *keyEquivalent;
@property (copy, nonatomic) NSAttributedString *attributedAlternateTitle;

@end


@interface NSSharingService (Properties)


@end


@interface NSPathComponentCell (Properties)

@property (strong, nonatomic) NSURL *URL;

@end




@interface NSColorSpace (Properties)

@property (readonly, nonatomic) NSData *ICCProfileData;
@property (readonly, nonatomic) NSInteger numberOfColorComponents;
@property (readonly, nonatomic) CGColorSpaceRef CGColorSpace NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSString *localizedName;
@property (readonly, nonatomic) NSColorSpaceModel colorSpaceModel;

@end


@interface NSFileWrapper (Properties)

@property (strong, nonatomic) NSImage *icon;

@end


@interface NSMatrix (Properties)

@property (assign, nonatomic) id keyCell;
@property (assign, nonatomic) BOOL autorecalculatesCellSize NS_AVAILABLE_MAC(10_8);
@property (assign, nonatomic) BOOL validateSize;
- (BOOL)validateSize UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) Class cellClass;
@property (readonly, nonatomic) id selectedCell;
@property (readonly, nonatomic) NSArray *selectedCells;
@property (readonly, nonatomic) NSInteger selectedColumn;
@property (readonly, nonatomic) NSInteger mouseDownFlags;
@property (strong, nonatomic) NSColor *cellBackgroundColor;
@property (readonly, nonatomic) NSInteger numberOfColumns;
@property (assign, nonatomic) SEL doubleAction;
@property (assign, nonatomic) BOOL tabKeyTraversesCells;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic, getter=isAutoscroll) BOOL autoscroll;
@property (assign, nonatomic) id prototype;
@property (assign, nonatomic) id <NSMatrixDelegate> delegate;
@property (assign, nonatomic) BOOL allowsEmptySelection;
@property (assign, nonatomic) NSSize cellSize;
@property (assign, nonatomic) NSSize intercellSpacing;
@property (assign, nonatomic) BOOL scrollable;
- (BOOL)scrollable UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) BOOL drawsCellBackground;
@property (assign, nonatomic) BOOL autosizesCells;
@property (readonly, nonatomic) NSInteger selectedRow;
@property (readonly, nonatomic) NSArray *cells;
@property (readonly, nonatomic) NSInteger numberOfRows;
@property (assign, nonatomic) NSMatrixMode mode;
@property (readonly, nonatomic) BOOL sendAction;
@property (assign, nonatomic, getter=isSelectionByRect) BOOL selectionByRect;
@property (assign, nonatomic) BOOL drawsBackground;

@end


@interface NSGlyphInfo (Properties)

@property (readonly, nonatomic) NSCharacterCollection characterCollection;
@property (readonly, nonatomic) NSString *glyphName;
@property (readonly, nonatomic) NSUInteger characterIdentifier;

@end


@interface NSSound (Properties)

@property (readonly, nonatomic) BOOL play;
@property (readonly, nonatomic) BOOL pause;
@property (copy, nonatomic) NSString *playbackDeviceIdentifier NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) BOOL resume;
@property (assign, nonatomic) NSTimeInterval currentTime NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) BOOL stop;
@property (assign, nonatomic) float volume NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) BOOL loops NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) id <NSSoundDelegate> delegate;
@property (readonly, nonatomic) NSTimeInterval duration NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) BOOL isPlaying;

@end


@interface NSArrayController (Properties)

@property (readonly, nonatomic) BOOL canSelectNext;
@property (assign, nonatomic) BOOL preservesSelection;
@property (assign, nonatomic) BOOL alwaysUsesMultipleValuesMarker;
@property (readonly, nonatomic) NSIndexSet *selectionIndexes;
@property (assign, nonatomic) BOOL clearsFilterPredicateOnInsertion;
@property (readonly, nonatomic) NSUInteger selectionIndex;
@property (strong, nonatomic) NSPredicate *filterPredicate;
@property (assign, nonatomic) BOOL selectsInsertedObjects;
@property (readonly, nonatomic) NSArray *selectedObjects;
@property (readonly, nonatomic) NSArray *automaticRearrangementKeyPaths NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) BOOL canInsert;
@property (strong, nonatomic) NSArray *sortDescriptors;
@property (readonly, nonatomic) BOOL canSelectPrevious;
@property (assign, nonatomic) BOOL automaticallyRearrangesObjects NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) BOOL avoidsEmptySelection;
@property (readonly, nonatomic) id arrangedObjects;

@end


@interface NSTextTableBlock (Properties)

@property (readonly, nonatomic) NSInteger rowSpan;
@property (readonly, nonatomic) NSTextTable *table;
@property (readonly, nonatomic) NSInteger startingRow;
@property (readonly, nonatomic) NSInteger startingColumn;
@property (readonly, nonatomic) NSInteger columnSpan;

@end


@interface NSPrintOperation (Properties)

@property (readonly, nonatomic) NSGraphicsContext *createContext;
@property (readonly, nonatomic) NSPrintRenderingQuality preferredRenderingQuality NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) BOOL canSpawnSeparateThread;
@property (assign, nonatomic) NSPrintingPageOrder pageOrder;
@property (strong, nonatomic) NSPrintInfo *printInfo;
@property (assign, nonatomic) BOOL showsProgressPanel;
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
@property (strong, nonatomic) NSPDFPanel *PDFPanel NS_AVAILABLE_MAC(10_9);
#endif
@property (readonly, nonatomic) BOOL runOperation;
@property (readonly, nonatomic) NSRange pageRange NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSGraphicsContext *context;
@property (copy, nonatomic) NSString *jobTitle NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSInteger currentPage;
@property (readonly, nonatomic) BOOL isCopyingOperation;
@property (readonly, nonatomic) NSView *view;
@property (assign, nonatomic) BOOL showsPrintPanel;
@property (readonly, nonatomic) BOOL deliverResult;
@property (strong, nonatomic) NSPrintPanel *printPanel;

@end


@interface NSRulerMarker (Properties)

@property (assign, nonatomic) NSPoint imageOrigin;
@property (readonly, nonatomic) NSRulerView *ruler;
@property (strong, nonatomic) NSImage *image;
@property (assign, nonatomic, getter=isMovable) BOOL movable;
@property (readonly, nonatomic) CGFloat thicknessRequiredInRuler;
@property (readonly, nonatomic) BOOL isDragging;
@property (strong, nonatomic) id <NSCopying>representedObject;
@property (assign, nonatomic, getter=isRemovable) BOOL removable;
@property (readonly, nonatomic) NSRect imageRectInRuler;
@property (assign, nonatomic) CGFloat markerLocation;

@end


@interface NSImageView (Properties)

@property (assign, nonatomic) BOOL allowsCutCopyPaste;
@property (assign, nonatomic) NSImageAlignment imageAlignment;
@property (strong, nonatomic) NSImage *image;
@property (assign, nonatomic) BOOL animates;
@property (assign, nonatomic) NSImageFrameStyle imageFrameStyle;
@property (assign, nonatomic) NSImageScaling imageScaling;
@property (assign, nonatomic, getter=isEditable) BOOL editable;

@end


@interface NSSlider (Properties)

@property (assign, nonatomic) double altIncrementValue;
@property (assign, nonatomic) double maxValue;
@property (assign, nonatomic) NSInteger numberOfTickMarks;
@property (assign, nonatomic) double minValue;
@property (assign, nonatomic) BOOL allowsTickMarkValuesOnly;
@property (readonly, nonatomic) CGFloat knobThickness;
@property (assign, nonatomic) NSTickMarkPosition tickMarkPosition;
@property (readonly, nonatomic) NSInteger isVertical;

@end



@interface NSView (Properties)

@property (assign, nonatomic) CGFloat frameCenterRotation NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) BOOL isRotatedFromBase;
@property (readonly, nonatomic) NSArray *trackingAreas NS_AVAILABLE_MAC(10_5);
@property (strong, nonatomic) NSShadow *shadow NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSWindow *window;
@property (assign, nonatomic, getter=isHidden) BOOL hidden;
@property (assign, nonatomic) BOOL wantsLayer NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) CGFloat frameRotation;
@property (readonly, nonatomic) NSString *printJobTitle;
@property (assign, nonatomic) BOOL autoresizesSubviews;
@property (readonly, nonatomic) NSAttributedString *pageFooter;
@property (assign, nonatomic) NSUInteger autoresizingMask;
@property (readonly, nonatomic) NSRect rectPreservedDuringLiveResize;
@property (readonly, nonatomic) BOOL isFlipped;
@property (readonly, nonatomic) NSArray *constraints NS_AVAILABLE_MAC(10_7);
@property (strong, nonatomic) NSArray *subviews;
@property (readonly, nonatomic) BOOL wantsDefaultClipping;
@property (assign, nonatomic) NSRect frame;
@property (readonly, nonatomic) BOOL isOpaque;
@property (assign, nonatomic) NSSize boundsSize;
- (NSSize)boundsSize UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSMenuItem *enclosingMenuItem NS_AVAILABLE_MAC(10_5);
@property (strong, nonatomic) NSArray *contentFilters NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) BOOL lockFocusIfCanDraw;
@property (assign, nonatomic) BOOL postsBoundsChangedNotifications;
@property (assign, nonatomic) NSRect keyboardFocusRingNeedsDisplayInRect;
- (NSRect)keyboardFocusRingNeedsDisplayInRect UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) BOOL isInFullScreenMode NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) BOOL needsDisplay;
@property (readonly, nonatomic) void releaseGState;
@property (copy, nonatomic) NSString *toolTip;
@property (readonly, nonatomic) BOOL isDrawingFindIndicator NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) BOOL needsLayout NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSInteger gState;
@property (readonly, nonatomic) CGFloat heightAdjustLimit;
@property (assign, nonatomic) BOOL translatesAutoresizingMaskIntoConstraints NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSView *nextValidKeyView;
@property (readonly, nonatomic) BOOL wantsUpdateLayer NS_AVAILABLE_MAC(10_8);
@property (readonly, nonatomic) CALayer *makeBackingLayer NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) CGFloat baselineOffsetFromBottom NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) CGFloat alphaValue NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) NSViewLayerContentsPlacement layerContentsPlacement NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) BOOL canBecomeKeyView;
@property (readonly, nonatomic) BOOL canDraw;
@property (strong, nonatomic) NSArray *backgroundFilters NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) NSPoint frameOrigin;
- (NSPoint)frameOrigin UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) BOOL layerUsesCoreImageFilters NS_AVAILABLE_MAC(10_9);
@property (readonly, nonatomic) CGFloat widthAdjustLimit;
@property (strong, nonatomic) NSView *nextKeyView;
@property (readonly, nonatomic) NSSize fittingSize NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSAttributedString *pageHeader;
@property (assign, nonatomic) BOOL needsUpdateConstraints NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) BOOL wantsRestingTouches NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) BOOL isRotatedOrScaledFromBase;
@property (assign, nonatomic) NSSize frameSize;
- (NSSize)frameSize UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSTextInputContext *inputContext NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) BOOL mouseDownCanMoveWindow;
@property (assign, nonatomic) NSRect bounds;
@property (assign, nonatomic) NSUserInterfaceLayoutDirection userInterfaceLayoutDirection NS_AVAILABLE_MAC(10_8);
@property (readonly, nonatomic) BOOL preservesContentDuringLiveResize;
@property (assign, nonatomic) BOOL acceptsTouchEvents NS_AVAILABLE_MAC(10_6);
@property (strong, nonatomic) CALayer *layer NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSView *superview;
@property (assign, nonatomic) BOOL canDrawConcurrently NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) NSViewLayerContentsRedrawPolicy layerContentsRedrawPolicy NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSView *opaqueAncestor;
@property (readonly, nonatomic) BOOL isHiddenOrHasHiddenAncestor;
@property (readonly, nonatomic) NSInteger tag;
@property (assign, nonatomic) NSRect needsDisplayInRect;
- (NSRect)needsDisplayInRect UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSView *previousKeyView;
@property (readonly, nonatomic) NSEdgeInsets alignmentRectInsets NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSArray *registeredDraggedTypes;
@property (readonly, nonatomic) BOOL needsPanelToBecomeKey;
@property (readonly, nonatomic) NSScrollView *enclosingScrollView;
@property (strong, nonatomic) CIFilter *compositingFilter NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) BOOL postsFrameChangedNotifications;
@property (assign, nonatomic) NSFocusRingType focusRingType;
@property (assign, nonatomic) CGFloat boundsRotation;
@property (readonly, nonatomic) NSRect focusRingMaskBounds NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) NSPoint boundsOrigin;
- (NSPoint)boundsOrigin UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSSize intrinsicContentSize NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) BOOL shouldDrawColor;
@property (readonly, nonatomic) NSView *previousValidKeyView;
@property (readonly, nonatomic) NSRect visibleRect;
@property (readonly, nonatomic) BOOL hasAmbiguousLayout NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) BOOL canDrawSubviewsIntoLayer NS_AVAILABLE_MAC(10_9);
@property (readonly, nonatomic) BOOL inLiveResize;
@property (assign, nonatomic) BOOL wantsBestResolutionOpenGLSurface NS_AVAILABLE_MAC(10_7);

@end


@interface NSPredicateEditor (Properties)

@property (strong, nonatomic) NSArray *rowTemplates;

@end


@interface NSTextField (Properties)

@property (assign, nonatomic) CGFloat preferredMaxLayoutWidth NS_AVAILABLE_MAC(10_8);
@property (assign, nonatomic, getter=isBezeled) BOOL bezeled;
@property (assign, nonatomic) NSTextFieldBezelStyle bezelStyle;
@property (assign, nonatomic) BOOL drawsBackground;
@property (assign, nonatomic, getter=isEditable) BOOL editable;
@property (assign, nonatomic, getter=isBordered) BOOL bordered;
@property (assign, nonatomic) BOOL allowsEditingTextAttributes;
@property (assign, nonatomic) id <NSTextFieldDelegate> delegate;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic) BOOL importsGraphics;
@property (strong, nonatomic) NSColor *textColor;
@property (assign, nonatomic, getter=isSelectable) BOOL selectable;
@property (readonly, nonatomic) BOOL acceptsFirstResponder;

@end


#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
@interface NSMutableFontCollection (Properties)

@property (strong, nonatomic) NSArray *exclusionDescriptors;
- (NSArray *)exclusionDescriptors UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSArray *queryDescriptors;
- (NSArray *)queryDescriptors UNAVAILABLE_ATTRIBUTE;

@end
#endif


@interface NSMutableParagraphStyle (Properties)

@property (assign, nonatomic) CGFloat paragraphSpacing;
- (CGFloat)paragraphSpacing UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat tailIndent;
- (CGFloat)tailIndent UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) float tighteningFactorForTruncation;
- (float)tighteningFactorForTruncation UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) NSInteger headerLevel;
- (NSInteger)headerLevel UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat defaultTabInterval;
- (CGFloat)defaultTabInterval UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat lineSpacing;
- (CGFloat)lineSpacing UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) NSLineBreakMode lineBreakMode;
- (NSLineBreakMode)lineBreakMode UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSArray *tabStops;
- (NSArray *)tabStops UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) NSWritingDirection baseWritingDirection;
- (NSWritingDirection)baseWritingDirection UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat paragraphSpacingBefore;
- (CGFloat)paragraphSpacingBefore UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) float hyphenationFactor;
- (float)hyphenationFactor UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSArray *textLists;
- (NSArray *)textLists UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSArray *textBlocks;
- (NSArray *)textBlocks UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat headIndent;
- (CGFloat)headIndent UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat lineHeightMultiple;
- (CGFloat)lineHeightMultiple UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat minimumLineHeight;
- (CGFloat)minimumLineHeight UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSParagraphStyle *paragraphStyle;
- (NSParagraphStyle *)paragraphStyle UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat maximumLineHeight;
- (CGFloat)maximumLineHeight UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) NSTextAlignment alignment;
- (NSTextAlignment)alignment UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) CGFloat firstLineHeadIndent;
- (CGFloat)firstLineHeadIndent UNAVAILABLE_ATTRIBUTE;

@end


@interface NSPanel (Properties)

@property (assign, nonatomic, getter=isFloatingPanel) BOOL floatingPanel;
@property (assign, nonatomic) BOOL becomesKeyOnlyIfNeeded;
@property (assign, nonatomic) BOOL worksWhenModal;

@end


@interface NSTabViewItem (Properties)

@property (strong, nonatomic) NSColor *color;
@property (readonly, nonatomic) NSTabView *tabView;
@property (assign, nonatomic) id initialFirstResponder;
@property (copy, nonatomic) NSString *toolTip NS_AVAILABLE_MAC(10_6);
@property (copy, nonatomic) NSString *label;
@property (readonly, nonatomic) NSTabState tabState;
@property (assign, nonatomic) id identifier;
@property (assign, nonatomic) id view;

@end


@interface NSGlyphGenerator (Properties)


@end


@interface NSPathCell (Properties)

@property (strong, nonatomic) NSArray *pathComponentCells;
@property (assign, nonatomic) SEL doubleAction;
@property (strong, nonatomic) NSArray *allowedTypes;
@property (strong, nonatomic) NSURL *URL;
@property (assign, nonatomic) NSControlSize controlSize;
- (NSControlSize)controlSize UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) NSPathStyle pathStyle;
@property (assign, nonatomic) id <NSPathCellDelegate> delegate;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (copy, nonatomic) NSString *placeholderString;
@property (readonly, nonatomic) NSPathComponentCell *clickedPathComponentCell;
@property (copy, nonatomic) NSAttributedString *placeholderAttributedString;

@end


@interface NSCursor (Properties)

@property (readonly, nonatomic) BOOL isSetOnMouseExited;
@property (assign, nonatomic) BOOL onMouseEntered;
- (BOOL)onMouseEntered UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) BOOL isSetOnMouseEntered;
@property (assign, nonatomic) BOOL onMouseExited;
- (BOOL)onMouseExited UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSImage *image;
@property (readonly, nonatomic) NSPoint hotSpot;

@end


@interface NSOpenPanel (Properties)

@property (assign, nonatomic) BOOL canChooseFiles;
@property (assign, nonatomic) BOOL resolvesAliases;
@property (assign, nonatomic) BOOL allowsMultipleSelection;
@property (assign, nonatomic) BOOL canChooseDirectories;
@property (readonly, nonatomic) NSArray *URLs;

@end


@interface NSEPSImageRep (Properties)

@property (readonly, nonatomic) NSRect boundingBox;
@property (readonly, nonatomic) NSData *EPSRepresentation;

@end


@interface NSText (Properties)

@property (readonly, nonatomic) BOOL isRulerVisible;
@property (assign, nonatomic) NSSize maxSize;
@property (strong, nonatomic) NSFont *font;
@property (assign, nonatomic) NSTextAlignment alignment;
@property (assign, nonatomic) NSRange selectedRange;
@property (assign, nonatomic) BOOL usesFontPanel;
@property (assign, nonatomic) NSSize minSize;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic, getter=isVerticallyResizable) BOOL verticallyResizable;
@property (strong, nonatomic) NSColor *textColor;
@property (copy, nonatomic) NSString *string;
@property (assign, nonatomic, getter=isFieldEditor) BOOL fieldEditor;
@property (assign, nonatomic, getter=isEditable) BOOL editable;
@property (assign, nonatomic, getter=isRichText) BOOL richText;
@property (assign, nonatomic, getter=isSelectable) BOOL selectable;
@property (assign, nonatomic, getter=isHorizontallyResizable) BOOL horizontallyResizable;
@property (assign, nonatomic) BOOL drawsBackground;
@property (assign, nonatomic) NSWritingDirection baseWritingDirection;
@property (assign, nonatomic) id <NSTextDelegate> delegate;
@property (assign, nonatomic) BOOL importsGraphics;

@end


@interface NSTextTable (Properties)

@property (assign, nonatomic) BOOL collapsesBorders;
@property (assign, nonatomic) NSUInteger numberOfColumns;
@property (assign, nonatomic) BOOL hidesEmptyCells;
@property (assign, nonatomic) NSTextTableLayoutAlgorithm layoutAlgorithm;

@end


@interface NSEvent (Properties)

@property (readonly, nonatomic) id vendorDefined;
@property (readonly, nonatomic) CGEventRef CGEvent NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSUInteger pointingDeviceSerialNumber;
@property (readonly, nonatomic) BOOL hasPreciseScrollingDeltas NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSEventPhase momentumPhase NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) CGFloat scrollingDeltaX NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) CGFloat scrollingDeltaY NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) unsigned long long uniqueID;
@property (readonly, nonatomic) NSPoint tilt;
@property (readonly, nonatomic) NSUInteger capabilityMask;
@property (readonly, nonatomic) NSInteger clickCount;
@property (readonly, nonatomic) CGFloat deltaX;
@property (readonly, nonatomic) CGFloat deltaY;
@property (readonly, nonatomic) CGFloat deltaZ;
@property (readonly, nonatomic) CGFloat magnification NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSWindow *window;
@property (readonly, nonatomic) NSUInteger buttonMask;
@property (readonly, nonatomic) NSEventType type;
@property (readonly, nonatomic) BOOL isARepeat;
@property (readonly, nonatomic) BOOL isEnteringProximity;
@property (readonly, nonatomic) void *userData;
@property (readonly, nonatomic) NSUInteger vendorPointingDeviceType;
@property (readonly, nonatomic) NSUInteger vendorID;
@property (readonly, nonatomic) NSTimeInterval timestamp;
@property (readonly, nonatomic) NSUInteger tabletID;
@property (readonly, nonatomic) float pressure;
@property (readonly, nonatomic) NSInteger windowNumber;
@property (readonly, nonatomic) NSInteger absoluteX;
@property (readonly, nonatomic) NSInteger absoluteY;
@property (readonly, nonatomic) NSString *characters;
@property (readonly, nonatomic) NSEventPhase phase NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) float rotation;
@property (readonly, nonatomic) NSString *charactersIgnoringModifiers;
@property (readonly, nonatomic) NSInteger absoluteZ;
@property (readonly, nonatomic) NSUInteger pointingDeviceID;
@property (readonly, nonatomic) NSUInteger systemTabletID;
@property (readonly, nonatomic) NSInteger eventNumber;
@property (readonly, nonatomic) NSUInteger modifierFlags;
@property (readonly, nonatomic) NSPoint locationInWindow;
@property (readonly, nonatomic) short subtype;
@property (readonly, nonatomic) NSTrackingArea *trackingArea NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSUInteger deviceID;
@property (readonly, nonatomic) NSGraphicsContext *context;
@property (readonly, nonatomic) BOOL isDirectionInvertedFromDevice NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSInteger trackingNumber;
@property (readonly, nonatomic) NSInteger buttonNumber;
@property (readonly, nonatomic) float tangentialPressure;
@property (readonly, nonatomic) unsigned short keyCode;
@property (readonly, nonatomic) NSPointingDeviceType pointingDeviceType;

@end


@interface NSLayoutConstraint (Properties)


@end


@interface NSToolbarItemGroup (Properties)

@property (strong, nonatomic) NSArray *subitems;

@end


@interface NSBezierPath (Properties)

@property (readonly, nonatomic) NSBezierPath *bezierPathByFlatteningPath;
@property (assign, nonatomic) NSWindingRule windingRule;
@property (assign, nonatomic) NSLineCapStyle lineCapStyle;
@property (readonly, nonatomic) NSRect bounds;
@property (assign, nonatomic) CGFloat miterLimit;
@property (readonly, nonatomic) NSInteger elementCount;
@property (assign, nonatomic) NSLineJoinStyle lineJoinStyle;
@property (readonly, nonatomic) NSBezierPath *bezierPathByReversingPath;
@property (readonly, nonatomic) NSPoint currentPoint;
@property (assign, nonatomic) CGFloat flatness;
@property (readonly, nonatomic) BOOL isEmpty;
@property (assign, nonatomic) CGFloat lineWidth;
@property (readonly, nonatomic) NSRect controlPointBounds;

@end


@interface NSTypesetter (Properties)

@property (readonly, nonatomic) NSRange paragraphSeparatorCharacterRange;
@property (assign, nonatomic) NSTypesetterBehavior typesetterBehavior;
@property (readonly, nonatomic) NSDictionary *attributesForExtraLineFragment;
@property (readonly, nonatomic) NSParagraphStyle *currentParagraphStyle;
@property (readonly, nonatomic) NSTextContainer *currentTextContainer;
@property (readonly, nonatomic) NSRange paragraphSeparatorGlyphRange;
@property (assign, nonatomic) float hyphenationFactor;
@property (readonly, nonatomic) NSRange paragraphCharacterRange;
@property (assign, nonatomic) CGFloat lineFragmentPadding;
@property (assign, nonatomic) BOOL usesFontLeading;
@property (assign, nonatomic) BOOL bidiProcessingEnabled;
@property (readonly, nonatomic) NSRange paragraphGlyphRange;
@property (readonly, nonatomic) NSLayoutManager *layoutManager;
@property (readonly, nonatomic) NSArray *textContainers;
@property (copy, nonatomic) NSAttributedString *attributedString;

@end


@interface NSFontPanel (Properties)

@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (strong, nonatomic) NSView *accessoryView;
@property (readonly, nonatomic) BOOL worksWhenModal;

@end


@interface NSComboBoxCell (Properties)

@property (assign, nonatomic) BOOL usesDataSource;
@property (readonly, nonatomic) NSInteger indexOfSelectedItem;
@property (readonly, nonatomic) NSArray *objectValues;
@property (assign, nonatomic) CGFloat itemHeight;
@property (assign, nonatomic) BOOL hasVerticalScroller;
@property (assign, nonatomic) BOOL completes;
@property (assign, nonatomic) NSInteger numberOfVisibleItems;
@property (readonly, nonatomic) NSInteger numberOfItems;
@property (assign, nonatomic, getter=isButtonBordered) BOOL buttonBordered;
@property (readonly, nonatomic) id objectValueOfSelectedItem;
@property (assign, nonatomic) NSSize intercellSpacing;
@property (assign, nonatomic) id <NSComboBoxCellDataSource> dataSource;

@end


@interface NSController (Properties)

@property (readonly, nonatomic) BOOL commitEditing;
@property (readonly, nonatomic) BOOL isEditing;

@end


@interface NSToolbar (Properties)

@property (assign, nonatomic) BOOL allowsUserCustomization;
@property (assign, nonatomic) CGFloat fullScreenAccessoryViewMinHeight NS_AVAILABLE_MAC(10_7);
- (CGFloat)fullScreenAccessoryViewMinHeight UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSArray *visibleItems;
@property (assign, nonatomic) CGFloat fullScreenAccessoryViewMaxHeight NS_AVAILABLE_MAC(10_7);
- (CGFloat)fullScreenAccessoryViewMaxHeight UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSArray *items;
@property (assign, nonatomic) NSToolbarDisplayMode displayMode;
@property (copy, nonatomic) NSString *selectedItemIdentifier;
@property (assign, nonatomic, getter=isVisible) BOOL visible;
@property (assign, nonatomic) NSToolbarSizeMode sizeMode;
@property (assign, nonatomic) id <NSToolbarDelegate> delegate;
@property (assign, nonatomic) BOOL showsBaselineSeparator;
@property (readonly, nonatomic) NSDictionary *configurationDictionary;
@property (readonly, nonatomic) NSString *identifier;
@property (readonly, nonatomic) BOOL customizationPaletteIsRunning;
@property (strong, nonatomic) NSDictionary *configurationFromDictionary;
- (NSDictionary *)configurationFromDictionary UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) BOOL autosavesConfiguration;

@end


@interface NSSavePanel (Properties)

@property (strong, nonatomic) NSURL *directoryURL NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) BOOL isExpanded;
@property (strong, nonatomic) NSView *accessoryView;
@property (readonly, nonatomic) NSURL *URL;
@property (assign, nonatomic) BOOL canSelectHiddenExtension;
@property (assign, nonatomic, getter=isExtensionHidden) BOOL extensionHidden;
@property (readonly, nonatomic) NSInteger runModal;
@property (assign, nonatomic) BOOL canCreateDirectories;
@property (strong, nonatomic) NSArray *tagNames NS_AVAILABLE_MAC(10_9);
@property (assign, nonatomic) BOOL showsHiddenFiles;
@property (copy, nonatomic) NSString *nameFieldLabel;
@property (assign, nonatomic) BOOL showsTagField NS_AVAILABLE_MAC(10_9);
@property (copy, nonatomic) NSString *prompt;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *nameFieldStringValue NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) BOOL treatsFilePackagesAsDirectories;
@property (assign, nonatomic) BOOL allowsOtherFileTypes;
@property (strong, nonatomic) NSArray *allowedFileTypes;

@end


@interface NSDraggingImageComponent (Properties)


@end


@interface NSSharingServicePicker (Properties)


@end


@interface NSPrinter (Properties)

@property (readonly, nonatomic) NSDictionary *deviceDescription;
@property (readonly, nonatomic) NSString *type;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSInteger languageLevel;

@end


@interface NSATSTypesetter (Properties)

@property (assign, nonatomic) NSTypesetterBehavior typesetterBehavior;
@property (readonly, nonatomic) NSTextContainer *currentTextContainer;
@property (readonly, nonatomic) NSRange paragraphSeparatorGlyphRange;
@property (assign, nonatomic) float hyphenationFactor;
@property (assign, nonatomic) CGFloat lineFragmentPadding;
@property (assign, nonatomic) BOOL usesFontLeading;
@property (assign, nonatomic) BOOL bidiProcessingEnabled;
@property (readonly, nonatomic) NSRange paragraphGlyphRange;
@property (readonly, nonatomic) NSLayoutManager *layoutManager;

@end


@interface NSSearchField (Properties)

@property (copy, nonatomic) NSString *recentsAutosaveName;
@property (strong, nonatomic) NSArray *recentSearches;

@end


@interface NSFont (Properties)

@property (readonly, nonatomic) NSString *fontName;
@property (readonly, nonatomic) CGFloat pointSize;
@property (readonly, nonatomic) CGFloat capHeight;
@property (readonly, nonatomic) BOOL isFixedPitch;
@property (readonly, nonatomic) NSSize maximumAdvancement;
@property (readonly, nonatomic) CGFloat underlinePosition;
@property (readonly, nonatomic) CGFloat underlineThickness;
@property (readonly, nonatomic) CGFloat italicAngle;
@property (readonly, nonatomic) NSFont *screenFont;
@property (readonly, nonatomic) const CGFloat *matrix;
@property (readonly, nonatomic) CGFloat leading;
@property (readonly, nonatomic) NSCharacterSet *coveredCharacterSet;
@property (readonly, nonatomic) NSFontDescriptor *fontDescriptor;
@property (strong, nonatomic) NSGraphicsContext *inContext;
- (NSGraphicsContext *)inContext UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) CGFloat ascender;
@property (readonly, nonatomic) NSUInteger numberOfGlyphs;
@property (readonly, nonatomic) NSFont *printerFont;
@property (readonly, nonatomic) NSString *familyName;
@property (readonly, nonatomic) NSStringEncoding mostCompatibleStringEncoding;
@property (readonly, nonatomic) NSFontRenderingMode renderingMode;
@property (readonly, nonatomic) CGFloat descender;
@property (readonly, nonatomic) NSRect boundingRectForFont;
@property (readonly, nonatomic) NSString *displayName;
@property (readonly, nonatomic) NSFont *verticalFont NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) CGFloat xHeight;
@property (readonly, nonatomic) BOOL isVertical NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSAffineTransform *textTransform;

@end


@interface NSOutlineView (Properties)

@property (assign, nonatomic) BOOL autosaveExpandedItems;
@property (assign, nonatomic) CGFloat indentationPerLevel;
@property (assign, nonatomic) NSUserInterfaceLayoutDirection userInterfaceLayoutDirection NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) BOOL indentationMarkerFollowsCell;
@property (assign, nonatomic) BOOL autoresizesOutlineColumn;
@property (strong, nonatomic) NSTableColumn *outlineTableColumn;

@end


@interface NSPrintPanel (Properties)

@property (copy, nonatomic) NSString *jobStyleHint;
@property (copy, nonatomic) NSString *defaultButtonTitle NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSPrintInfo *printInfo NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSArray *accessoryControllers NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSInteger runModal;
@property (copy, nonatomic) NSString *helpAnchor NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) NSPrintPanelOptions options NS_AVAILABLE_MAC(10_5);

@end


@interface NSBitmapImageRep (Properties)

@property (readonly, nonatomic) NSBitmapFormat bitmapFormat;
@property (readonly, nonatomic) CGImageRef CGImage NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) unsigned char *bitmapData;
@property (readonly, nonatomic) BOOL isPlanar;
@property (readonly, nonatomic) NSInteger bytesPerPlane;
@property (readonly, nonatomic) NSInteger bitsPerPixel;
@property (readonly, nonatomic) NSData *TIFFRepresentation;
@property (readonly, nonatomic) NSColorSpace *colorSpace NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSInteger bytesPerRow;
@property (readonly, nonatomic) id initForIncrementalLoad;
@property (readonly, nonatomic) NSInteger samplesPerPixel;
@property (readonly, nonatomic) NSInteger numberOfPlanes;

@end


@interface NSTableView (Properties)

@property (strong, nonatomic) NSTableHeaderView *headerView;
@property (assign, nonatomic) BOOL autosaveTableColumns;
@property (readonly, nonatomic) NSTableViewRowSizeStyle effectiveRowSizeStyle NS_AVAILABLE_MAC(10_7);
@property (strong, nonatomic) NSView *cornerView;
@property (readonly, nonatomic) NSIndexSet *selectedColumnIndexes;
@property (readonly, nonatomic) NSInteger editedRow;
@property (assign, nonatomic) NSTableViewRowSizeStyle rowSizeStyle NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSIndexSet *selectedRowIndexes;
@property (strong, nonatomic) NSArray *sortDescriptors;
@property (readonly, nonatomic) NSInteger clickedColumn;
@property (readonly, nonatomic) NSInteger selectedColumn;
@property (assign, nonatomic) BOOL usesAlternatingRowBackgroundColors;
@property (readonly, nonatomic) NSDictionary *registeredNibsByIdentifier NS_AVAILABLE_MAC(10_8);
@property (assign, nonatomic) SEL doubleAction;
@property (readonly, nonatomic) NSInteger numberOfColumns;
@property (readonly, nonatomic) NSInteger numberOfSelectedColumns;
@property (assign, nonatomic) BOOL allowsColumnReordering;
@property (assign, nonatomic) BOOL verticalMotionCanBeginDrag;
@property (readonly, nonatomic) NSInteger editedColumn;
@property (assign, nonatomic) BOOL allowsTypeSelect NS_AVAILABLE_MAC(10_5);
@property (strong, nonatomic) NSColor *gridColor;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic) BOOL allowsColumnSelection;
@property (assign, nonatomic) NSTableViewSelectionHighlightStyle selectionHighlightStyle NS_AVAILABLE_MAC(10_5);
@property (copy, nonatomic) NSString *autosaveName;
@property (assign, nonatomic) BOOL allowsColumnResizing;
@property (readonly, nonatomic) NSInteger numberOfSelectedRows;
@property (assign, nonatomic) BOOL allowsEmptySelection;
@property (assign, nonatomic) BOOL allowsMultipleSelection;
@property (assign, nonatomic) id <NSTableViewDataSource> dataSource;
@property (assign, nonatomic) BOOL floatsGroupRows NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) NSTableViewColumnAutoresizingStyle columnAutoresizingStyle;
@property (assign, nonatomic) NSSize intercellSpacing;
@property (assign, nonatomic) NSTableViewDraggingDestinationFeedbackStyle draggingDestinationFeedbackStyle NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) CGFloat rowHeight;
@property (readonly, nonatomic) NSInteger selectedRow;
@property (readonly, nonatomic) NSInteger clickedRow;
@property (assign, nonatomic) NSInteger focusedColumn NS_AVAILABLE_MAC(10_5);
@property (strong, nonatomic) NSTableColumn *highlightedTableColumn;
@property (assign, nonatomic) NSTableViewGridLineStyle gridStyleMask;
@property (readonly, nonatomic) NSInteger numberOfRows;
@property (assign, nonatomic) id <NSTableViewDelegate> delegate;
@property (readonly, nonatomic) NSArray *tableColumns;

@end


@interface NSFontDescriptor (Properties)

@property (readonly, nonatomic) NSString *postscriptName;
@property (readonly, nonatomic) NSDictionary *fontAttributes;
@property (readonly, nonatomic) CGFloat pointSize;
@property (readonly, nonatomic) NSAffineTransform *matrix;
@property (readonly, nonatomic) NSFontSymbolicTraits symbolicTraits;

@end


#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
@interface NSFontCollection (Properties)

@property (readonly, nonatomic) NSArray *exclusionDescriptors;
@property (readonly, nonatomic) NSArray *matchingDescriptors;
@property (readonly, nonatomic) NSArray *queryDescriptors;

@end
#endif


#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
@interface NSMediaLibraryBrowserController (Properties)


@end
#endif


@interface NSColor (Properties)

@property (readonly, nonatomic) CGFloat yellowComponent;
@property (readonly, nonatomic) NSColorSpace *colorSpace;
@property (readonly, nonatomic) CGFloat greenComponent;
@property (readonly, nonatomic) CGFloat whiteComponent;
@property (readonly, nonatomic) CGFloat magentaComponent;
@property (readonly, nonatomic) NSImage *patternImage;
@property (readonly, nonatomic) CGFloat hueComponent;
@property (readonly, nonatomic) NSInteger numberOfComponents;
@property (readonly, nonatomic) NSString *localizedCatalogNameComponent;
@property (readonly, nonatomic) CGFloat blackComponent;
@property (readonly, nonatomic) NSString *colorNameComponent;
@property (readonly, nonatomic) CGFloat blueComponent;
@property (readonly, nonatomic) CGFloat brightnessComponent;
@property (readonly, nonatomic) NSString *colorSpaceName;
@property (readonly, nonatomic) NSString *localizedColorNameComponent;
@property (readonly, nonatomic) CGFloat redComponent;
@property (readonly, nonatomic) CGFloat cyanComponent;
@property (readonly, nonatomic) NSString *catalogNameComponent;
@property (readonly, nonatomic) CGFloat saturationComponent;
@property (readonly, nonatomic) CGFloat alphaComponent;

@end


@interface NSViewAnimation (Properties)

@property (strong, nonatomic) NSArray *viewAnimations;

@end


@interface NSOpenGLPixelFormat (Properties)

@property (strong, nonatomic) NSData *attributes;
@property (readonly, nonatomic) GLint numberOfVirtualScreens;
@property (readonly, nonatomic) void *CGLPixelFormatObj;

@end


@interface NSLevelIndicatorCell (Properties)

@property (assign, nonatomic) double criticalValue;
@property (assign, nonatomic) NSInteger numberOfMajorTickMarks;
@property (assign, nonatomic) double maxValue;
@property (assign, nonatomic) NSInteger numberOfTickMarks;
@property (assign, nonatomic) double minValue;
@property (assign, nonatomic) NSTickMarkPosition tickMarkPosition;
@property (assign, nonatomic) double warningValue;
@property (assign, nonatomic) NSLevelIndicatorStyle levelIndicatorStyle;

@end


@interface NSTokenFieldCell (Properties)

@property (assign, nonatomic) NSTokenStyle tokenStyle;
@property (strong, nonatomic) NSCharacterSet *tokenizingCharacterSet;
@property (assign, nonatomic) NSTimeInterval completionDelay;
@property (assign, nonatomic) id <NSTokenFieldCellDelegate> delegate;

@end


@interface NSAlert (Properties)

@property (readonly, nonatomic) NSArray *buttons;
@property (assign, nonatomic) BOOL showsHelp;
@property (assign, nonatomic) NSAlertStyle alertStyle;
@property (strong, nonatomic) NSView *accessoryView NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) BOOL showsSuppressionButton NS_AVAILABLE_MAC(10_5);
@property (copy, nonatomic) NSString *messageText;
@property (readonly, nonatomic) NSButton *suppressionButton NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) id window;
@property (copy, nonatomic) NSString *informativeText;
@property (copy, nonatomic) NSString *helpAnchor;
@property (assign, nonatomic) id <NSAlertDelegate> delegate;
@property (strong, nonatomic) NSImage *icon;

@end


@interface NSInputServer (Properties)


@end


@interface NSApplication (Properties)

@property (readonly, nonatomic) NSDockTile *dockTile NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) BOOL isFullKeyboardAccessEnabled NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSArray *orderedDocuments;
@property (strong, nonatomic) NSMenu *servicesMenu;
@property (readonly, nonatomic) NSEvent *currentEvent;
@property (strong, nonatomic) NSImage *applicationIconImage;
@property (readonly, nonatomic) BOOL isActive;
@property (readonly, nonatomic) NSArray *orderedWindows;
@property (readonly, nonatomic) BOOL isHidden;
@property (assign, nonatomic) BOOL windowsNeedUpdate;
- (BOOL)windowsNeedUpdate UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) id servicesProvider;
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
@property (readonly, nonatomic) NSApplicationOcclusionState occlusionState NS_AVAILABLE_MAC(10_9);
#endif
@property (readonly, nonatomic) NSRemoteNotificationType enabledRemoteNotificationTypes NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSApplicationActivationPolicy activationPolicy NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) NSApplicationPresentationOptions presentationOptions NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSWindow *keyWindow;
@property (readonly, nonatomic) NSApplicationPresentationOptions currentSystemPresentationOptions NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) BOOL isRunning;
@property (readonly, nonatomic) NSWindow *modalWindow;
@property (strong, nonatomic) NSMenu *mainMenu;
@property (readonly, nonatomic) NSWindow *mainWindow;
@property (readonly, nonatomic) NSArray *windows;
@property (readonly, nonatomic) NSUserInterfaceLayoutDirection userInterfaceLayoutDirection NS_AVAILABLE_MAC(10_6);
@property (strong, nonatomic) NSMenu *helpMenu NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) id <NSApplicationDelegate> delegate;
@property (readonly, nonatomic) NSGraphicsContext *context;
@property (strong, nonatomic) NSMenu *windowsMenu;

@end


@interface NSTextStorage (Properties)

@property (readonly, nonatomic) NSInteger changeInLength;
@property (readonly, nonatomic) BOOL fixesAttributesLazily;
@property (strong, nonatomic) NSArray *characters;
@property (strong, nonatomic) NSArray *attributeRuns;
@property (strong, nonatomic) NSColor *foregroundColor;
@property (assign, nonatomic) id <NSTextStorageDelegate> delegate;
@property (strong, nonatomic) NSArray *words;
@property (strong, nonatomic) NSArray *paragraphs;
@property (readonly, nonatomic) NSArray *layoutManagers;
@property (readonly, nonatomic) NSUInteger editedMask;
@property (strong, nonatomic) NSFont *font;
@property (readonly, nonatomic) NSRange editedRange;

@end


@interface NSViewController (Properties)

@property (copy, nonatomic) NSString *title;
@property (readonly, nonatomic) BOOL commitEditing;
@property (assign, nonatomic) id representedObject;
@property (readonly, nonatomic) NSString *nibName;
@property (readonly, nonatomic) NSBundle *nibBundle;
@property (strong, nonatomic) NSView *view;

@end


@interface NSCollectionViewItem (Properties)


@end


@interface NSTouch (Properties)


@end


@interface NSMenuItem (Properties)

@property (strong, nonatomic) NSImage *onStateImage;
@property (strong, nonatomic) NSImage *image;
@property (readonly, nonatomic) NSString *userKeyEquivalent;
@property (readonly, nonatomic) BOOL isHiddenOrHasHiddenAncestor NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) NSInteger tag;
@property (readonly, nonatomic) BOOL isHighlighted NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSMenuItem *parentItem NS_AVAILABLE_MAC(10_6);
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSMenu *menu;
@property (assign, nonatomic, getter=isAlternate) BOOL alternate;
@property (copy, nonatomic) NSAttributedString *attributedTitle;
@property (assign, nonatomic) NSInteger state;
@property (assign, nonatomic, getter=isHidden) BOOL hidden NS_AVAILABLE_MAC(10_5);
@property (copy, nonatomic) NSString *titleWithMnemonic;
- (NSString *)titleWithMnemonic UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSImage *offStateImage;
@property (readonly, nonatomic) BOOL isSeparatorItem;
@property (assign, nonatomic) NSInteger indentationLevel;
@property (copy, nonatomic) NSString *toolTip;
@property (copy, nonatomic) NSString *keyEquivalent;
@property (assign, nonatomic) NSUInteger keyEquivalentModifierMask;
@property (assign, nonatomic) id target;
@property (strong, nonatomic) NSMenu *submenu;
@property (readonly, nonatomic) BOOL hasSubmenu;
@property (strong, nonatomic) NSImage *mixedStateImage;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (assign, nonatomic) id representedObject;
@property (assign, nonatomic) SEL action;
@property (strong, nonatomic) NSView *view NS_AVAILABLE_MAC(10_5);

@end


@interface NSTextView (Properties)

@property (assign, nonatomic) BOOL usesInspectorBar NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) NSTextCheckingTypes enabledTextCheckingTypes NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) BOOL usesFindBar NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSPoint textContainerOrigin;
@property (readonly, nonatomic) NSArray *readablePasteboardTypes;
@property (strong, nonatomic) NSParagraphStyle *defaultParagraphStyle;
@property (readonly, nonatomic) BOOL isCoalescingUndo NS_AVAILABLE_MAC(10_6);
@property (strong, nonatomic) NSColor *insertionPointColor;
@property (assign, nonatomic) NSTextLayoutOrientation layoutOrientation NS_AVAILABLE_MAC(10_7);
- (NSTextLayoutOrientation)layoutOrientation UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSLayoutManager *layoutManager;
@property (readonly, nonatomic) NSRange rangeForUserParagraphAttributeChange;
@property (assign, nonatomic, getter=isSelectable) BOOL selectable;
@property (readonly, nonatomic) NSRange rangeForUserCharacterAttributeChange;
@property (assign, nonatomic) NSSelectionGranularity selectionGranularity;
@property (assign, nonatomic) NSRange selectedRange;
- (NSRange)selectedRange UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) BOOL usesFontPanel;
@property (assign, nonatomic) BOOL allowsImageEditing NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSArray *rangesForUserCharacterAttributeChange;
@property (strong, nonatomic) NSTextContainer *textContainer;
@property (strong, nonatomic) NSDictionary *typingAttributes;
@property (readonly, nonatomic) NSInteger spellCheckerDocumentTag;
@property (assign, nonatomic) BOOL displaysLinkToolTips NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic, getter=isAutomaticDashSubstitutionEnabled) BOOL automaticDashSubstitutionEnabled NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSArray *rangesForUserParagraphAttributeChange;
@property (readonly, nonatomic) NSArray *acceptableDragTypes;
@property (readonly, nonatomic) BOOL shouldDrawInsertionPoint;
@property (readonly, nonatomic) NSArray *writablePasteboardTypes;
@property (assign, nonatomic, getter=isAutomaticTextReplacementEnabled) BOOL automaticTextReplacementEnabled NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) NSRange rangeForUserCompletion;
@property (assign, nonatomic) BOOL acceptsGlyphInfo;
@property (assign, nonatomic) BOOL smartInsertDeleteEnabled;
@property (assign, nonatomic) BOOL usesRuler;
@property (readonly, nonatomic) NSArray *rangesForUserTextChange;
@property (assign, nonatomic) NSSize constrainedFrameSize;
- (NSSize)constrainedFrameSize UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic, getter=isFieldEditor) BOOL fieldEditor;
@property (strong, nonatomic) NSArray *selectedRanges;
@property (assign, nonatomic, getter=isEditable) BOOL editable;
@property (assign, nonatomic, getter=isRichText) BOOL richText;
@property (assign, nonatomic, getter=isContinuousSpellCheckingEnabled) BOOL continuousSpellCheckingEnabled;
@property (strong, nonatomic) NSDictionary *selectedTextAttributes;
@property (assign, nonatomic, getter=isGrammarCheckingEnabled) BOOL grammarCheckingEnabled NS_AVAILABLE_MAC(10_5);
@property (strong, nonatomic) NSArray *allowedInputSourceLocales NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic, getter=isAutomaticLinkDetectionEnabled) BOOL automaticLinkDetectionEnabled NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSRange rangeForUserTextChange;
@property (assign, nonatomic, getter=isAutomaticDataDetectionEnabled) BOOL automaticDataDetectionEnabled NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic, getter=isRulerVisible) BOOL rulerVisible;
@property (assign, nonatomic) BOOL allowsUndo;
@property (assign, nonatomic) NSSize textContainerInset;
@property (assign, nonatomic) BOOL drawsBackground;
@property (assign, nonatomic) BOOL usesFindPanel;
@property (assign, nonatomic) BOOL allowsDocumentBackgroundColorChange;
@property (assign, nonatomic, getter=isAutomaticQuoteSubstitutionEnabled) BOOL automaticQuoteSubstitutionEnabled NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSTextStorage *textStorage;
@property (strong, nonatomic) NSDictionary *markedTextAttributes;
@property (assign, nonatomic, getter=isAutomaticSpellingCorrectionEnabled) BOOL automaticSpellingCorrectionEnabled NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) BOOL importsGraphics;
@property (readonly, nonatomic) NSSelectionAffinity selectionAffinity;
@property (strong, nonatomic) NSDictionary *linkTextAttributes;
@property (assign, nonatomic, getter=isIncrementalSearchingEnabled) BOOL incrementalSearchingEnabled NS_AVAILABLE_MAC(10_7);

@end


@interface NSSearchFieldCell (Properties)

@property (copy, nonatomic) NSString *recentsAutosaveName;
@property (strong, nonatomic) NSButtonCell *searchButtonCell;
@property (strong, nonatomic) NSArray *recentSearches;
@property (assign, nonatomic) BOOL sendsSearchStringImmediately;
@property (strong, nonatomic) NSButtonCell *cancelButtonCell;
@property (assign, nonatomic) NSInteger maximumRecents;
@property (strong, nonatomic) NSMenu *searchMenuTemplate;
@property (assign, nonatomic) BOOL sendsWholeSearchString;

@end


@interface NSSegmentedControl (Properties)

@property (assign, nonatomic) NSInteger selectedSegment;
@property (assign, nonatomic) NSSegmentStyle segmentStyle NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) NSInteger segmentCount;

@end


@interface NSSecureTextField (Properties)


@end


@interface NSWindow (Properties)

@property (assign, nonatomic) BOOL canHide;
@property (readonly, nonatomic) NSInteger resizeFlags;
@property (assign, nonatomic, getter=isExcludedFromWindowsMenu) BOOL excludedFromWindowsMenu;
@property (assign, nonatomic) BOOL showsToolbarButton;
@property (assign, nonatomic) BOOL allowsToolTipsWhenApplicationIsInactive;
@property (assign, nonatomic) BOOL ignoresMouseEvents;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL showsResizeIndicator;
@property (assign, nonatomic) NSBackingStoreType backingType;
@property (readonly, nonatomic) BOOL areCursorRectsEnabled;
@property (readonly, nonatomic) NSString *stringWithSavedFrame;
@property (readonly, nonatomic) BOOL canBecomeKeyWindow;
@property (assign, nonatomic) NSSize contentMinSize;
@property (assign, nonatomic) NSWindowDepth depthLimit;
@property (readonly, nonatomic) BOOL isResizable;
@property (readonly, nonatomic) NSString *frameAutosaveName;
@property (copy, nonatomic) NSString *miniwindowTitle;
@property (assign, nonatomic) NSInteger level;
@property (readonly, nonatomic) NSResponder *firstResponder;
@property (readonly, nonatomic) BOOL canStoreColor;
@property (assign, nonatomic) id <NSWindowDelegate> delegate;
@property (readonly, nonatomic) BOOL isOnActiveSpace NS_AVAILABLE_MAC(10_6);
@property (strong, nonatomic) NSURL *representedURL NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) Class <NSWindowRestoration> restorationClass NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) NSPoint frameOrigin;
- (NSPoint)frameOrigin UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSRect frame;
@property (strong, nonatomic) NSColorSpace *colorSpace NS_AVAILABLE_MAC(10_6);
@property (copy, nonatomic) NSString *frameFromString;
- (NSString *)frameFromString UNAVAILABLE_ATTRIBUTE;
@property (readonly, nonatomic) NSDockTile *dockTile NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) NSSize maxSize;
@property (strong, nonatomic) NSImage *miniwindowImage;
@property (readonly, nonatomic) CGFloat userSpaceScaleFactor;
@property (assign, nonatomic, getter=isOpaque) BOOL opaque;
@property (readonly, nonatomic) NSEvent *currentEvent;
@property (strong, nonatomic) NSColor *backgroundColor;
@property (assign, nonatomic, getter=isReleasedWhenClosed) BOOL releasedWhenClosed;
@property (readonly, nonatomic) NSArray *childWindows;
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
@property (readonly, nonatomic) NSWindowOcclusionState occlusionState NS_AVAILABLE_MAC(10_9);
#endif
@property (assign, nonatomic, getter=isDocumentEdited) BOOL documentEdited;
@property (assign, nonatomic) NSWindowCollectionBehavior collectionBehavior NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSScreen *screen;
@property (assign, nonatomic) CGFloat alphaValue;
@property (strong, nonatomic) NSWindow *parentWindow;
@property (strong, nonatomic) NSToolbar *toolbar;
@property (readonly, nonatomic) BOOL isZoomable;
@property (assign, nonatomic) BOOL displaysWhenScreenProfileChanges;
@property (readonly, nonatomic) NSInteger gState;
@property (assign, nonatomic, getter=hasDynamicDepthLimit) BOOL dynamicDepthLimit;
@property (readonly, nonatomic) NSInteger windowNumber;
@property (assign, nonatomic) NSPoint frameTopLeftPoint;
- (NSPoint)frameTopLeftPoint UNAVAILABLE_ATTRIBUTE;
@property (strong, nonatomic) NSView *initialFirstResponder;
@property (readonly, nonatomic) NSArray *drawers;
@property (readonly, nonatomic) CGFloat backingScaleFactor NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) BOOL worksWhenModal;
@property (readonly, nonatomic) NSWindow *attachedSheet;
@property (assign, nonatomic) NSInteger orderedIndex;
@property (assign, nonatomic) NSSize aspectRatio;
@property (assign, nonatomic) BOOL viewsNeedDisplay;
@property (assign, nonatomic) NSSize contentSize;
- (NSSize)contentSize UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) BOOL hidesOnDeactivate;
@property (readonly, nonatomic) NSArray *sheets NS_AVAILABLE_MAC(10_9);
@property (readonly, nonatomic) BOOL isFloatingPanel;
@property (assign, nonatomic) BOOL preventsApplicationTerminationWhenModal NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) BOOL canBecomeVisibleWithoutLogin NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSSelectionDirection keyViewSelectionDirection;
@property (assign, nonatomic) NSUInteger styleMask;
@property (copy, nonatomic) NSString *titleWithRepresentedFilename;
- (NSString *)titleWithRepresentedFilename UNAVAILABLE_ATTRIBUTE;
@property (assign, nonatomic) BOOL isZoomed;
@property (assign, nonatomic, getter=isRestorable) BOOL restorable NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) NSWindow *sheetParent NS_AVAILABLE_MAC(10_9);
@property (assign, nonatomic) NSSize resizeIncrements;
@property (assign, nonatomic, getter=isMovableByWindowBackground) BOOL movableByWindowBackground;
@property (readonly, nonatomic) BOOL canBecomeMainWindow;
@property (strong, nonatomic) NSButtonCell *defaultButtonCell;
@property (readonly, nonatomic) NSGraphicsContext *graphicsContext;
@property (assign, nonatomic) BOOL hasShadow;
@property (readonly, nonatomic) BOOL isFlushWindowDisabled;
@property (assign, nonatomic) id windowController;
@property (readonly, nonatomic) NSWindowBackingLocation backingLocation NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) NSSize contentMaxSize;
@property (readonly, nonatomic) BOOL isModalPanel;
@property (assign, nonatomic) BOOL preservesContentDuringLiveResize;
@property (assign, nonatomic) BOOL isMiniaturized;
@property (assign, nonatomic) NSWindowAnimationBehavior animationBehavior NS_AVAILABLE_MAC(10_7);
@property (readonly, nonatomic) BOOL isMainWindow;
@property (assign, nonatomic) NSSize contentResizeIncrements;
@property (assign, nonatomic) NSWindowSharingType sharingType NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) NSSize minSize;
@property (readonly, nonatomic) NSScreen *deepestScreen;
@property (readonly, nonatomic) NSPoint mouseLocationOutsideOfEventStream;
@property (assign, nonatomic) NSSize contentAspectRatio;
@property (assign, nonatomic, getter=isOneShot) BOOL oneShot;
@property (assign, nonatomic, getter=isAutodisplay) BOOL autodisplay;
@property (assign, nonatomic) NSWindowBackingLocation preferredBackingLocation NS_AVAILABLE_MAC(10_5);
@property (readonly, nonatomic) NSDictionary *deviceDescription;
@property (readonly, nonatomic) BOOL hasTitleBar;
@property (assign, nonatomic) BOOL isVisible;
@property (assign, nonatomic, getter=isMovable) BOOL movable NS_AVAILABLE_MAC(10_6);
@property (readonly, nonatomic) BOOL isKeyWindow;
@property (readonly, nonatomic) BOOL isMiniaturizable;
@property (assign, nonatomic) id contentView;
@property (assign, nonatomic) BOOL acceptsMouseMovedEvents;
@property (copy, nonatomic) NSString *representedFilename;
@property (readonly, nonatomic) BOOL hasCloseBox;
@property (readonly, nonatomic) BOOL isSheet;
@property (assign, nonatomic) BOOL allowsConcurrentViewDrawing NS_AVAILABLE_MAC(10_6);
@property (assign, nonatomic) BOOL autorecalculatesKeyViewLoop;

@end


@interface NSSpeechSynthesizer (Properties)

@property (readonly, nonatomic) BOOL isSpeaking;
@property (assign, nonatomic) float volume NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) float rate NS_AVAILABLE_MAC(10_5);
@property (assign, nonatomic) id <NSSpeechSynthesizerDelegate> delegate;
@property (readonly, nonatomic) NSString *voice;
@property (assign, nonatomic) BOOL usesFeedbackWindow;

@end


@interface NSScroller (Properties)

@property (readonly, nonatomic) NSUsableScrollerParts usableParts;
@property (readonly, nonatomic) NSScrollerPart hitPart;
@property (assign, nonatomic) NSScrollerStyle scrollerStyle NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) NSScrollArrowPosition arrowsPosition;
@property (assign, nonatomic) NSControlSize controlSize;
@property (assign, nonatomic) NSScrollerKnobStyle knobStyle NS_AVAILABLE_MAC(10_7);
@property (assign, nonatomic) NSControlTint controlTint;
@property (assign, nonatomic) CGFloat knobProportion;

@end


@interface NSTrackingArea (Properties)

@property (readonly, nonatomic) id owner;
@property (readonly, nonatomic) NSTrackingAreaOptions options;
@property (readonly, nonatomic) NSRect rect;
@property (readonly, nonatomic) NSDictionary *userInfo;

@end

#endif
