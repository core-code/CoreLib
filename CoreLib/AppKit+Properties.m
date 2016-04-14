//
//  AppKit+Properties.m
//  CoreLib
//
//  Created by CoreCode on 09.02.14.
/*	Copyright (c) 2016 CoreCode
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#if ((defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED < 101000) || (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED < 90000)))
#import "AppKit+Properties.h"

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE


@implementation NSDocument (Properties)

@dynamic undoManager;
@dynamic windowForSheet;
@dynamic keepBackupFile;
@dynamic hasUndoManager;
@dynamic autosavingFileType;
@dynamic autosavedContentsFileURL;
@dynamic fileNameExtensionWasHiddenInLastRunSavePanel;
@dynamic fileModificationDate;
@dynamic isDocumentEdited;
@dynamic autosavingIsImplicitlyCancellable;
@dynamic windowNibName;
@dynamic isInViewingMode;
@dynamic hasUnautosavedChanges;
@dynamic fileType;
@dynamic isLocked;
@dynamic window;
@dynamic draft;
@dynamic shouldRunSavePanelWithAccessoryView;
@dynamic fileURL;
@dynamic fileTypeFromLastRunSavePanel;
@dynamic windowControllers;
@dynamic PDFPrintOperation;
@dynamic objectSpecifier;
@dynamic displayName;
@dynamic defaultDraftName;
@dynamic isEntireFileLoaded;
@dynamic backupFileURL;
@dynamic lastComponentOfFileName;
@dynamic printInfo;

@end


@implementation NSScrollView (Properties)

@dynamic  documentView;
@dynamic scrollerKnobStyle;
@dynamic rulersVisible;
@dynamic borderType;
@dynamic verticalLineScroll;
@dynamic verticalPageScroll;
@dynamic hasHorizontalScroller;
@dynamic hasVerticalScroller;
@dynamic scrollsDynamically;
@dynamic backgroundColor;
@dynamic horizontalScrollElasticity;
@dynamic horizontalRulerView;
@dynamic documentVisibleRect;
@dynamic contentSize;
@dynamic verticalScroller;
@dynamic hasHorizontalRuler;
@dynamic lineScroll;
@dynamic horizontalScroller;
@dynamic findBarPosition;
@dynamic verticalScrollElasticity;
@dynamic autohidesScrollers;
@dynamic hasVerticalRuler;
@dynamic horizontalPageScroll;
@dynamic contentView;
@dynamic horizontalLineScroll;
@dynamic scrollerStyle;
@dynamic drawsBackground;
@dynamic pageScroll;
@dynamic usesPredominantAxisScrolling;
@dynamic verticalRulerView;
@dynamic documentCursor;

@end


@implementation NSRunningApplication (Properties)

@dynamic  terminate;
@dynamic hide;
@dynamic forceTerminate;
@dynamic unhide;

@end


@implementation NSTextContainer (Properties)

@dynamic  isSimpleRectangularTextContainer;
@dynamic widthTracksTextView;
@dynamic containerSize;
@dynamic lineFragmentPadding;
@dynamic heightTracksTextView;
@dynamic layoutManager;
@dynamic textView;

@end


@implementation NSLayoutManager (Properties)

@dynamic  textViewForBeginningOfSelection;
@dynamic hasNonContiguousLayout;
@dynamic extraLineFragmentRect;
@dynamic glyphGenerator;
@dynamic showsInvisibleCharacters;
@dynamic usesFontLeading;
@dynamic layoutOptions;
@dynamic extraLineFragmentUsedRect;
@dynamic firstUnlaidCharacterIndex;
@dynamic typesetterBehavior;
@dynamic extraLineFragmentTextContainer;
@dynamic defaultAttachmentScaling;
@dynamic allowsNonContiguousLayout;
@dynamic firstUnlaidGlyphIndex;
@dynamic typesetter;
@dynamic numberOfGlyphs;
@dynamic usesScreenFonts;
@dynamic hyphenationFactor;
@dynamic showsControlCharacters;
@dynamic textContainers;
@dynamic backgroundLayoutEnabled;
@dynamic firstTextView;
@dynamic textStorage;
@dynamic delegate;
@dynamic attributedString;

@end


@implementation NSShadow (Properties)

@dynamic  shadowOffset;
@dynamic shadowColor;
@dynamic shadowBlurRadius;

@end



@implementation NSComboBox (Properties)

@dynamic  usesDataSource;
@dynamic indexOfSelectedItem;
@dynamic objectValues;
@dynamic itemHeight;
@dynamic hasVerticalScroller;
@dynamic dataSource;
@dynamic completes;
@dynamic numberOfVisibleItems;
@dynamic numberOfItems;
@dynamic buttonBordered;
@dynamic objectValueOfSelectedItem;
@dynamic intercellSpacing;

@end


@implementation NSImage (Properties)

@dynamic  scalesWhenResized;
@dynamic matchesOnMultipleResolution;
@dynamic size;
@dynamic alignmentRect;
@dynamic prefersColorMatch;
//@dynamic template;
@dynamic accessibilityDescription;
@dynamic backgroundColor;
@dynamic dataRetained;
@dynamic isValid;
@dynamic matchesOnlyOnBestFittingAxis;
@dynamic TIFFRepresentation;
@dynamic cacheDepthMatchesImageDepth;
@dynamic representations;
@dynamic cachedSeparately;
@dynamic name;
@dynamic flipped;
@dynamic usesEPSOnResolutionMismatch;
@dynamic delegate;

@end


@implementation NSPersistentDocument (Properties)

@dynamic  managedObjectModel;
@dynamic managedObjectContext;

@end


@implementation NSDrawer (Properties)

@dynamic  leadingOffset;
@dynamic contentView;
@dynamic trailingOffset;
@dynamic state;
@dynamic edge;
@dynamic delegate;
@dynamic minContentSize;
@dynamic parentWindow;
@dynamic preferredEdge;
@dynamic maxContentSize;
@dynamic contentSize;

@end


@implementation NSCollectionView (Properties)

@dynamic  maxNumberOfColumns;
@dynamic selectionIndexes;
@dynamic maxItemSize;
@dynamic backgroundColors;
@dynamic itemPrototype;
@dynamic isFirstResponder;
@dynamic minItemSize;
@dynamic maxNumberOfRows;
@dynamic content;
@dynamic allowsMultipleSelection;
@dynamic delegate;
@dynamic selectable;

@end


@implementation NSCell (Properties)

@dynamic  attributedStringValue;
@dynamic interiorBackgroundStyle;
@dynamic showsFirstResponder;
@dynamic truncatesLastVisibleLine;
@dynamic enabled;
@dynamic image;
@dynamic backgroundStyle;
@dynamic allowsMixedState;
@dynamic bordered;
@dynamic isOpaque;
@dynamic tag;
@dynamic font;
@dynamic wantsNotificationForMarkedText;
@dynamic alignment;
@dynamic wraps;
@dynamic mouseDownFlags;
@dynamic title;
@dynamic hasValidObjectValue;
@dynamic userInterfaceLayoutDirection;
@dynamic doubleValue;
@dynamic highlighted;
@dynamic state;
@dynamic controlView;
@dynamic formatter;
@dynamic type;
@dynamic objectValue;
@dynamic continuous;
@dynamic bezeled;
@dynamic selectable;
@dynamic sendsActionOnEndEditing;
@dynamic floatValue;
@dynamic editable;
@dynamic controlTint;
@dynamic keyEquivalent;
@dynamic refusesFirstResponder;
@dynamic usesSingleLineMode;
@dynamic nextState;
@dynamic stringValue;
@dynamic cellSize;
@dynamic controlSize;
@dynamic scrollable;
@dynamic allowsUndo;
@dynamic focusRingType;
@dynamic target;
@dynamic lineBreakMode;
@dynamic baseWritingDirection;
@dynamic intValue;
@dynamic allowsEditingTextAttributes;
@dynamic representedObject;
@dynamic menu;
@dynamic action;
@dynamic importsGraphics;
@dynamic integerValue;
@dynamic acceptsFirstResponder;

@end




@implementation NSProgressIndicator (Properties)

@dynamic  style;
@dynamic bezeled;
@dynamic usesThreadedAnimation;
@dynamic displayedWhenStopped;
@dynamic indeterminate;
@dynamic doubleValue;
@dynamic controlSize;
@dynamic controlTint;
@dynamic maxValue;
@dynamic minValue;

@end


@implementation NSImageCell (Properties)

@dynamic  imageScaling;
@dynamic imageAlignment;
@dynamic imageFrameStyle;

@end


@implementation NSTextTab (Properties)

@dynamic  tabStopType;
@dynamic options;
@dynamic alignment;
@dynamic location;

@end


@implementation NSTableHeaderView (Properties)

@dynamic  draggedDistance;
@dynamic draggedColumn;
@dynamic tableView;
@dynamic resizedColumn;

@end


@implementation NSTextAttachment (Properties)

@dynamic  fileWrapper;
@dynamic attachmentCell;

@end


@implementation NSParagraphStyle (Properties)

@dynamic  paragraphSpacing;
@dynamic tailIndent;
@dynamic tighteningFactorForTruncation;
@dynamic headerLevel;
@dynamic defaultTabInterval;
@dynamic lineSpacing;
@dynamic lineBreakMode;
@dynamic maximumLineHeight;
@dynamic baseWritingDirection;
@dynamic paragraphSpacingBefore;
@dynamic hyphenationFactor;
@dynamic textLists;
@dynamic textBlocks;
@dynamic headIndent;
@dynamic lineHeightMultiple;
@dynamic minimumLineHeight;
@dynamic tabStops;
@dynamic alignment;
@dynamic firstLineHeadIndent;

@end


@implementation NSDatePicker (Properties)

@dynamic  timeInterval;
@dynamic bezeled;
@dynamic dateValue;
@dynamic datePickerElements;
@dynamic locale;
@dynamic maxDate;
@dynamic drawsBackground;
@dynamic timeZone;
@dynamic bordered;
@dynamic datePickerStyle;
@dynamic delegate;
@dynamic backgroundColor;
@dynamic datePickerMode;
@dynamic calendar;
@dynamic textColor;
@dynamic minDate;

@end




@implementation NSTextList (Properties)

@dynamic  listOptions;
@dynamic startingItemNumber;
@dynamic markerFormat;

@end


@implementation NSPICTImageRep (Properties)

@dynamic  boundingBox;
@dynamic PICTRepresentation;

@end


@implementation NSPrintInfo (Properties)

#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
@dynamic orientation;
#endif
@dynamic horizontalPagination;
@dynamic selectionOnly;
@dynamic printSettings;
@dynamic topMargin;
@dynamic jobDisposition;
@dynamic imageablePageBounds;
@dynamic leftMargin;
@dynamic printer;
@dynamic localizedPaperName;
@dynamic dictionary;
@dynamic rightMargin;
@dynamic paperName;
@dynamic bottomMargin;
@dynamic verticalPagination;
@dynamic horizontallyCentered;
@dynamic paperSize;
@dynamic verticallyCentered;
@dynamic scalingFactor;

@end


@implementation NSTabView (Properties)

@dynamic  numberOfTabViewItems;
@dynamic tabViewType;
@dynamic drawsBackground;
@dynamic minimumSize;
@dynamic selectedTabViewItem;
@dynamic tabViewItems;
@dynamic controlTint;
@dynamic controlSize;
@dynamic delegate;
@dynamic contentRect;
@dynamic allowsTruncatedLabels;
@dynamic font;

@end


@implementation NSSpellChecker (Properties)

@dynamic  spellingPanel;
@dynamic wordFieldStringValue;
@dynamic accessoryView;
@dynamic language;
@dynamic userPreferredLanguages;
@dynamic automaticallyIdentifiesLanguages;
@dynamic availableLanguages;
@dynamic substitutionsPanel;
@dynamic substitutionsPanelAccessoryViewController;
@dynamic userReplacementsDictionary;

@end


@implementation NSPredicateEditorRowTemplate (Properties)

@dynamic  predicate;
@dynamic leftExpressions;
@dynamic rightExpressionAttributeType;
@dynamic operators;
@dynamic compoundTypes;
@dynamic templateViews;
@dynamic rightExpressions;
@dynamic modifier;
@dynamic options;

@end


@implementation NSSpeechRecognizer (Properties)

@dynamic  commands;
@dynamic displayedCommandsTitle;
@dynamic delegate;
@dynamic blocksOtherRecognizers;
@dynamic listensInForegroundOnly;

@end


@implementation NSStatusBar (Properties)

@dynamic  isVertical;
@dynamic thickness;

@end


@implementation NSPasteboardItem (Properties)

@dynamic  types;

@end


@implementation NSBrowser (Properties)

@dynamic  autohidesScroller;
@dynamic titled;
@dynamic rowHeight;
@dynamic isLoaded;
@dynamic cellClass;
@dynamic selectedCell;
@dynamic matrixClass;
@dynamic clickedColumn;
@dynamic sendsActionOnArrowKeys;
@dynamic selectedColumn;
@dynamic minColumnWidth;
@dynamic lastVisibleColumn;
@dynamic hasHorizontalScroller;
@dynamic columnResizingType;
@dynamic pathSeparator;
@dynamic doubleAction;
@dynamic allowsTypeSelect;
@dynamic backgroundColor;
@dynamic maxVisibleColumns;
@dynamic reusesColumns;
@dynamic selectionIndexPaths;
@dynamic defaultColumnWidth;
@dynamic prefersAllColumnUserResizing;
@dynamic allowsEmptySelection;
@dynamic separatesColumns;
@dynamic titleHeight;
@dynamic allowsMultipleSelection;
@dynamic path;
@dynamic selectionIndexPath;
@dynamic takesTitleFromPreviousColumn;
@dynamic firstVisibleColumn;
@dynamic lastColumn;
@dynamic clickedRow;
@dynamic cellPrototype;
@dynamic allowsBranchSelection;
@dynamic selectedCells;
@dynamic delegate;
@dynamic sendAction;
@dynamic columnsAutosaveName;
@dynamic numberOfVisibleColumns;

@end


@implementation NSToolbarItem (Properties)

@dynamic  paletteLabel;
@dynamic itemIdentifier;
@dynamic target;
@dynamic allowsDuplicatesInToolbar;
@dynamic enabled;
@dynamic visibilityPriority;
@dynamic toolTip;
@dynamic label;
@dynamic minSize;
@dynamic maxSize;
@dynamic tag;
@dynamic toolbar;
@dynamic autovalidates;
@dynamic action;
@dynamic image;
@dynamic menuFormRepresentation;
@dynamic view;

@end


@implementation NSSegmentedCell (Properties)

@dynamic  selectedSegment;
@dynamic segmentStyle;
@dynamic segmentCount;
@dynamic trackingMode;

@end


@implementation NSColorWell (Properties)

@dynamic  color;
@dynamic bordered;
@dynamic isActive;

@end


@implementation NSPopUpButtonCell (Properties)

@dynamic  autoenablesItems;
@dynamic indexOfSelectedItem;
@dynamic titleOfSelectedItem;
@dynamic arrowPosition;
@dynamic altersStateOfSelectedItem;
@dynamic itemArray;
@dynamic itemTitles;
@dynamic selectedItem;
@dynamic numberOfItems;
@dynamic pullsDown;
@dynamic preferredEdge;
@dynamic usesItemFromMenu;
@dynamic lastItem;

@end


@implementation NSBrowserCell (Properties)

@dynamic  leaf;
@dynamic alternateImage;
@dynamic loaded;

@end


@implementation NSMenu (Properties)

@dynamic  autoenablesItems;
@dynamic font;
@dynamic minimumWidth;
@dynamic title;
@dynamic isTornOff;
@dynamic itemArray;
@dynamic propertiesToUpdate;
@dynamic menuChangedMessagesEnabled;
@dynamic highlightedItem;
@dynamic allowsContextMenuPlugIns;
@dynamic showsStateColumn;
@dynamic numberOfItems;
@dynamic size;
@dynamic menuBarHeight;
@dynamic supermenu;
@dynamic delegate;

@end


@implementation NSImageRep (Properties)

@dynamic  pixelsHigh;
@dynamic draw;
@dynamic opaque;
@dynamic bitsPerSample;
@dynamic pixelsWide;
@dynamic colorSpaceName;
@dynamic alpha;
@dynamic size;

@end


@implementation NSTreeController (Properties)

@dynamic  childrenKeyPath;
@dynamic canInsert;
@dynamic alwaysUsesMultipleValuesMarker;
@dynamic countKeyPath;
@dynamic preservesSelection;
@dynamic canAddChild;
@dynamic selectedObjects;
@dynamic selectedNodes;
@dynamic sortDescriptors;
@dynamic leafKeyPath;
@dynamic selectsInsertedObjects;
@dynamic selectionIndexPath;
@dynamic canInsertChild;
@dynamic avoidsEmptySelection;
@dynamic selectionIndexPaths;
@dynamic arrangedObjects;

@end


@implementation NSDocumentController (Properties)

@dynamic  documents;
@dynamic autosavingDelay;
@dynamic currentDirectory;
@dynamic documentClassNames;
@dynamic maximumRecentDocumentCount;
@dynamic currentDocument;
@dynamic URLsFromRunningOpenPanel;
@dynamic defaultType;
@dynamic hasEditedDocuments;
@dynamic recentDocumentURLs;

@end


@implementation NSBox (Properties)

@dynamic  borderColor;
@dynamic contentView;
@dynamic titleRect;
@dynamic titlePosition;
@dynamic title;
@dynamic frameFromContentFrame;
@dynamic boxType;
@dynamic borderRect;
@dynamic borderType;
@dynamic titleCell;
@dynamic titleFont;
@dynamic borderWidth;
@dynamic contentViewMargins;
@dynamic fillColor;
@dynamic transparent;
@dynamic cornerRadius;

@end



@implementation NSPasteboard (Properties)

@dynamic  clearContents;
@dynamic changeCount;
@dynamic readFileWrapper;


@end


@implementation NSDatePickerCell (Properties)

@dynamic  timeInterval;
@dynamic dateValue;
@dynamic datePickerElements;
@dynamic locale;
@dynamic maxDate;
@dynamic drawsBackground;
@dynamic datePickerStyle;
@dynamic delegate;
@dynamic backgroundColor;
@dynamic timeZone;
@dynamic datePickerMode;
@dynamic calendar;
@dynamic textColor;
@dynamic minDate;

@end



@implementation NSButton (Properties)

@dynamic  sound;
@dynamic showsBorderOnlyWhileMouseInside;
@dynamic bezelStyle;
@dynamic buttonType;
@dynamic alternateImage;
@dynamic image;
@dynamic imagePosition;
@dynamic bordered;
@dynamic alternateTitle;
@dynamic attributedTitle;
@dynamic state;
@dynamic allowsMixedState;
@dynamic keyEquivalent;
@dynamic title;
@dynamic keyEquivalentModifierMask;
@dynamic attributedAlternateTitle;
@dynamic transparent;

@end



@implementation NSDictionaryController (Properties)

@dynamic  initialValue;
@dynamic localizedKeyDictionary;
@dynamic initialKey;
@dynamic excludedKeys;
@dynamic includedKeys;
@dynamic localizedKeyTable;
@dynamic newObject;

@end


@implementation NSPopUpButton (Properties)

@dynamic  autoenablesItems;
@dynamic indexOfSelectedItem;
@dynamic titleOfSelectedItem;
@dynamic selectedItem;
@dynamic itemArray;
@dynamic itemTitles;
@dynamic numberOfItems;
@dynamic pullsDown;
@dynamic preferredEdge;
@dynamic lastItem;

@end


@implementation NSTreeNode (Properties)

@dynamic  indexPath;
@dynamic parentNode;
@dynamic representedObject;
@dynamic mutableChildNodes;
@dynamic childNodes;
@dynamic isLeaf;

@end


@implementation NSTextBlock (Properties)

@dynamic  borderColor;
@dynamic contentWidthValueType;
@dynamic verticalAlignment;
@dynamic backgroundColor;
@dynamic contentWidth;

@end


@implementation NSObject (Properties)

@dynamic accessibilityParameterizedAttributeNames;
@dynamic isExplicitlyIncluded;
@dynamic accessibilityActionNames;
@dynamic accessibilityAttributeNames;
@dynamic value;
@dynamic exposedBindings;
@dynamic commitEditing;
@dynamic localizedKey;
@dynamic key;
@dynamic accessibilityIsIgnored;
@dynamic ignoreModifierKeysWhileDragging;
@dynamic accessibilityNotifiesWhenDestroyed;
@dynamic accessibilityFocusedUIElement;

@end


@implementation NSResponder (Properties)

@dynamic  undoManager;
@dynamic resignFirstResponder;
@dynamic menu;
@dynamic mark;
@dynamic nextResponder;
@dynamic becomeFirstResponder;
@dynamic acceptsFirstResponder;

@end



@implementation NSColorPanel (Properties)

@dynamic  accessoryView;
@dynamic target;
@dynamic color;
@dynamic continuous;
@dynamic action;
@dynamic showsAlpha;
@dynamic alpha;
@dynamic mode;

@end


@implementation NSUserDefaultsController (Properties)

@dynamic  appliesImmediately;
@dynamic values;
@dynamic initialValues;
@dynamic hasUnappliedChanges;
@dynamic defaults;

@end


@implementation NSScreen (Properties)

@dynamic  deviceDescription;
@dynamic frame;
@dynamic colorSpace;
@dynamic depth;
@dynamic backingScaleFactor;
@dynamic supportedWindowDepths;
@dynamic userSpaceScaleFactor;
@dynamic visibleFrame;

@end



@implementation NSSliderCell (Properties)

@dynamic  altIncrementValue;
@dynamic sliderType;
@dynamic maxValue;
@dynamic numberOfTickMarks;
@dynamic minValue;
@dynamic allowsTickMarkValuesOnly;
@dynamic knobThickness;
@dynamic tickMarkPosition;
@dynamic trackRect;
@dynamic isVertical;

@end


@implementation NSFontManager (Properties)

@dynamic  selectedFont;
@dynamic currentFontAction;
@dynamic collectionNames;
@dynamic target;
@dynamic enabled;
@dynamic fontMenu;
@dynamic availableFontFamilies;
@dynamic delegate;
@dynamic sendAction;
@dynamic action;
@dynamic availableFonts;
@dynamic isMultiple;

@end


@implementation NSObjectController (Properties)

@dynamic  selection;
@dynamic canAdd;
@dynamic objectClass;
@dynamic selectedObjects;
@dynamic editable;
@dynamic fetchPredicate;
@dynamic automaticallyPreparesContent;
@dynamic defaultFetchRequest;
@dynamic content;
@dynamic newObject;
@dynamic canRemove;
@dynamic entityName;
@dynamic usesLazyFetching;
@dynamic managedObjectContext;

@end



@implementation NSCIImageRep (Properties)

@dynamic  CIImage;

@end


@implementation NSColorList (Properties)

@dynamic  name;
@dynamic allKeys;
@dynamic isEditable;

@end


@implementation NSMenuItemCell (Properties)

@dynamic  keyEquivalentWidth;
@dynamic needsDisplay;
@dynamic needsSizing;
@dynamic tag;
@dynamic imageWidth;
@dynamic menuItem;
@dynamic titleWidth;
@dynamic stateImageWidth;

@end


@implementation NSColorPicker (Properties)

@dynamic  buttonToolTip;
@dynamic provideNewButtonImage;
@dynamic mode;
@dynamic minContentSize;
@dynamic colorPanel;

@end


@implementation NSPathControl (Properties)

@dynamic  pathComponentCells;
@dynamic pathStyle;
@dynamic URL;
@dynamic doubleAction;
@dynamic delegate;
@dynamic backgroundColor;
@dynamic clickedPathComponentCell;

@end


@implementation NSSplitView (Properties)

@dynamic  vertical;
@dynamic dividerStyle;
@dynamic dividerColor;
@dynamic delegate;
@dynamic dividerThickness;
@dynamic autosaveName;

@end



@implementation NSAttributedString (Properties)

@dynamic  containsAttachments;
@dynamic size;

@end



@implementation NSRulerView (Properties)

@dynamic  clientView;
@dynamic orientation;
@dynamic isFlipped;
@dynamic reservedThicknessForAccessoryView;
@dynamic accessoryView;
@dynamic scrollView;
@dynamic baselineLocation;
@dynamic requiredThickness;
@dynamic markers;
@dynamic reservedThicknessForMarkers;
@dynamic measurementUnits;
@dynamic originOffset;
@dynamic ruleThickness;

@end


@implementation NSPDFImageRep (Properties)

@dynamic  PDFRepresentation;
@dynamic currentPage;
@dynamic bounds;
@dynamic pageCount;

@end


@implementation NSActionCell (Properties)

@dynamic  action;
@dynamic tag;

@end


@implementation NSSecureTextFieldCell (Properties)

@dynamic  echosBullets;

@end


@implementation NSAppleScript (Properties)

@dynamic  richTextSource;

@end


@implementation NSControl (Properties)

@dynamic  currentEditor;
@dynamic enabled;
@dynamic tag;
@dynamic selectedCell;
@dynamic font;
@dynamic alignment;
@dynamic doubleValue;
@dynamic cell;
@dynamic attributedStringValue;
@dynamic ignoresMultiClick;
@dynamic formatter;
@dynamic objectValue;
@dynamic continuous;
@dynamic floatValue;
@dynamic intValue;
@dynamic stringValue;
@dynamic allowsExpansionToolTips;
@dynamic target;
@dynamic baseWritingDirection;
@dynamic refusesFirstResponder;
@dynamic selectedTag;
@dynamic userInterfaceLayoutDirection;
@dynamic action;
@dynamic abortEditing;
@dynamic integerValue;

@end




@implementation NSLevelIndicator (Properties)

@dynamic criticalValue;
@dynamic numberOfMajorTickMarks;
@dynamic maxValue;
@dynamic numberOfTickMarks;
@dynamic minValue;
@dynamic tickMarkPosition;
@dynamic warningValue;

@end


@implementation NSFormCell (Properties)

@dynamic  titleBaseWritingDirection;
@dynamic preferredTextFieldWidth;
@dynamic titleAlignment;
@dynamic isOpaque;
@dynamic titleFont;
@dynamic placeholderString;
@dynamic attributedTitle;
@dynamic titleWidth;
@dynamic placeholderAttributedString;

@end


@implementation NSDockTile (Properties)

@dynamic  showsApplicationBadge;
@dynamic owner;
@dynamic badgeLabel;
@dynamic contentView;
@dynamic size;

@end


@implementation NSWindowController (Properties)

@dynamic  documentEdited;
@dynamic windowFrameAutosaveName;
@dynamic windowNibName;
@dynamic shouldCloseDocument;
@dynamic window;
@dynamic shouldCascadeWindows;
@dynamic windowNibPath;
@dynamic owner;
@dynamic document;
@dynamic isWindowLoaded;

@end



@implementation NSAnimation (Properties)

@dynamic  currentValue;
@dynamic animationCurve;
@dynamic runLoopModesForAnimating;
@dynamic frameRate;
@dynamic progressMarks;
@dynamic isAnimating;
@dynamic delegate;
@dynamic duration;
@dynamic animationBlockingMode;
@dynamic currentProgress;

@end


@implementation NSPageLayout (Properties)

@dynamic  printInfo;
@dynamic runModal;
@dynamic accessoryControllers;

@end





@implementation NSOpenGLContext (Properties)

@dynamic  CGLContextObj;
@dynamic currentVirtualScreen;
@dynamic view;

@end





@implementation NSForm (Properties)

@dynamic  indexOfSelectedItem;
@dynamic titleBaseWritingDirection;
@dynamic bezeled;
@dynamic preferredTextFieldWidth;
@dynamic titleAlignment;
@dynamic textBaseWritingDirection;
@dynamic entryWidth;
@dynamic bordered;
@dynamic interlineSpacing;
@dynamic titleFont;
@dynamic textFont;
@dynamic textAlignment;
@dynamic frameSize;

@end


@implementation NSClipView (Properties)

@dynamic  documentView;
@dynamic drawsBackground;
@dynamic documentRect;
@dynamic backgroundColor;
@dynamic copiesOnScroll;
@dynamic documentVisibleRect;
@dynamic documentCursor;

@end


@implementation NSOpenGLView (Properties)

@dynamic  pixelFormat;
@dynamic openGLContext;

@end





@implementation NSCustomImageRep (Properties)

@dynamic  drawSelector;
@dynamic delegate;

@end


@implementation NSRuleEditor (Properties)

@dynamic  predicate;
@dynamic rowHeight;
@dynamic displayValuesKeyPath;
@dynamic editable;
@dynamic rowTypeKeyPath;
@dynamic rowClass;
@dynamic criteriaKeyPath;
@dynamic formattingStringsFilename;
@dynamic nestingMode;
@dynamic formattingDictionary;
@dynamic subrowsKeyPath;
@dynamic canRemoveAllRows;
@dynamic selectedRowIndexes;
@dynamic numberOfRows;
@dynamic delegate;

@end





@implementation NSGradient (Properties)

@dynamic  numberOfColorStops;
@dynamic colorSpace;

@end


@implementation NSWorkspace (Properties)

@dynamic  fileLabels;
@dynamic runningApplications;
@dynamic activeApplication;
@dynamic menuBarOwningApplication;
@dynamic fileLabelColors;
@dynamic frontmostApplication;
@dynamic notificationCenter;
@dynamic mountedLocalVolumePaths;
@dynamic mountedRemovableMedia;

@end


@implementation NSTokenField (Properties)

@dynamic  tokenStyle;
@dynamic tokenizingCharacterSet;
@dynamic completionDelay;

@end


@implementation NSStepperCell (Properties)

@dynamic  valueWraps;
@dynamic autorepeat;
@dynamic maxValue;
@dynamic increment;
@dynamic minValue;

@end


@implementation NSGraphicsContext (Properties)

@dynamic  colorRenderingIntent;
@dynamic graphicsPort;
@dynamic isDrawingToScreen;
@dynamic focusStack;
@dynamic patternPhase;
@dynamic imageInterpolation;
@dynamic isFlipped;
@dynamic CIContext;
@dynamic attributes;
@dynamic compositingOperation;
@dynamic shouldAntialias;

@end


@implementation NSTextFieldCell (Properties)

@dynamic  bezelStyle;
@dynamic drawsBackground;
@dynamic backgroundColor;
@dynamic allowedInputSourceLocales;
@dynamic placeholderString;
@dynamic wantsNotificationForMarkedText;
@dynamic textColor;
@dynamic placeholderAttributedString;

@end


@implementation NSStatusItem (Properties)

@dynamic  target;
@dynamic title;
@dynamic statusBar;
@dynamic menu;
@dynamic image;
@dynamic alternateImage;
@dynamic highlightMode;
@dynamic toolTip;
@dynamic doubleAction;
@dynamic length;
@dynamic action;
@dynamic attributedTitle;
@dynamic enabled;
@dynamic view;

@end


@implementation NSStepper (Properties)

@dynamic  valueWraps;
@dynamic autorepeat;
@dynamic maxValue;
@dynamic increment;
@dynamic minValue;

@end


@implementation NSTableColumn (Properties)

@dynamic  resizingMask;
@dynamic dataCell;
@dynamic tableView;
@dynamic maxWidth;
@dynamic editable;
@dynamic sortDescriptorPrototype;
@dynamic headerToolTip;
@dynamic minWidth;
@dynamic width;
@dynamic hidden;
@dynamic identifier;
@dynamic headerCell;

@end


@implementation NSButtonCell (Properties)

@dynamic  alternateImage;
@dynamic isOpaque;
@dynamic showsBorderOnlyWhileMouseInside;
@dynamic attributedTitle;
@dynamic imageScaling;
@dynamic backgroundColor;
@dynamic highlightsBy;
@dynamic showsStateBy;
@dynamic imagePosition;
@dynamic alternateTitle;
@dynamic keyEquivalentModifierMask;
@dynamic transparent;
@dynamic sound;
@dynamic keyEquivalentFont;
@dynamic bezelStyle;
@dynamic buttonType;
@dynamic imageDimsWhenDisabled;
@dynamic gradientType;
@dynamic keyEquivalent;
@dynamic attributedAlternateTitle;

@end





@implementation NSPathComponentCell (Properties)

@dynamic  URL;

@end





@implementation NSColorSpace (Properties)

@dynamic  ICCProfileData;
@dynamic numberOfColorComponents;
@dynamic CGColorSpace;
@dynamic localizedName;
@dynamic colorSpaceModel;

@end


@implementation NSFileWrapper (Properties)

@dynamic  icon;

@end


@implementation NSMatrix (Properties)

@dynamic  keyCell;
@dynamic autorecalculatesCellSize;
@dynamic validateSize;
@dynamic cellClass;
@dynamic selectedCell;
@dynamic selectedCells;
@dynamic selectedColumn;
@dynamic mouseDownFlags;
@dynamic cellBackgroundColor;
@dynamic numberOfColumns;
@dynamic doubleAction;
@dynamic tabKeyTraversesCells;
@dynamic backgroundColor;
@dynamic autoscroll;
@dynamic prototype;
@dynamic delegate;
@dynamic allowsEmptySelection;
@dynamic cellSize;
@dynamic intercellSpacing;
@dynamic scrollable;
@dynamic drawsCellBackground;
@dynamic autosizesCells;
@dynamic selectedRow;
@dynamic cells;
@dynamic numberOfRows;
@dynamic mode;
@dynamic sendAction;
@dynamic selectionByRect;
@dynamic drawsBackground;

@end


@implementation NSGlyphInfo (Properties)

@dynamic  characterCollection;
@dynamic glyphName;
@dynamic characterIdentifier;

@end


@implementation NSSound (Properties)

@dynamic  play;
@dynamic pause;
@dynamic playbackDeviceIdentifier;
@dynamic name;
@dynamic resume;
@dynamic currentTime;
@dynamic stop;
@dynamic volume;
@dynamic loops;
@dynamic delegate;
@dynamic duration;
@dynamic isPlaying;

@end


@implementation NSArrayController (Properties)

@dynamic  canSelectNext;
@dynamic preservesSelection;
@dynamic alwaysUsesMultipleValuesMarker;
@dynamic selectionIndexes;
@dynamic clearsFilterPredicateOnInsertion;
@dynamic selectionIndex;
@dynamic filterPredicate;
@dynamic selectsInsertedObjects;
@dynamic selectedObjects;
@dynamic automaticRearrangementKeyPaths;
@dynamic canInsert;
@dynamic sortDescriptors;
@dynamic canSelectPrevious;
@dynamic automaticallyRearrangesObjects;
@dynamic avoidsEmptySelection;
@dynamic arrangedObjects;

@end


@implementation NSTextTableBlock (Properties)

@dynamic  rowSpan;
@dynamic table;
@dynamic startingRow;
@dynamic startingColumn;
@dynamic columnSpan;

@end


@implementation NSPrintOperation (Properties)

@dynamic  createContext;
@dynamic preferredRenderingQuality;
@dynamic canSpawnSeparateThread;
@dynamic pageOrder;
@dynamic printInfo;
@dynamic showsProgressPanel;
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
@dynamic PDFPanel;
#endif
@dynamic runOperation;
@dynamic pageRange;
@dynamic context;
@dynamic jobTitle;
@dynamic currentPage;
@dynamic isCopyingOperation;
@dynamic view;
@dynamic showsPrintPanel;
@dynamic deliverResult;
@dynamic printPanel;

@end


@implementation NSRulerMarker (Properties)

@dynamic  imageOrigin;
@dynamic ruler;
@dynamic image;
@dynamic movable;
@dynamic thicknessRequiredInRuler;
@dynamic isDragging;
@dynamic representedObject;
@dynamic removable;
@dynamic imageRectInRuler;
@dynamic markerLocation;

@end


@implementation NSImageView (Properties)

@dynamic  allowsCutCopyPaste;
@dynamic imageAlignment;
@dynamic image;
@dynamic animates;
@dynamic imageFrameStyle;
@dynamic imageScaling;
@dynamic editable;

@end


@implementation NSSlider (Properties)

@dynamic  altIncrementValue;
@dynamic maxValue;
@dynamic numberOfTickMarks;
@dynamic minValue;
@dynamic allowsTickMarkValuesOnly;
@dynamic knobThickness;
@dynamic tickMarkPosition;
@dynamic isVertical;

@end





@implementation NSView (Properties)

@dynamic  frameCenterRotation;
@dynamic isRotatedFromBase;
@dynamic trackingAreas;
@dynamic shadow;
@dynamic window;
@dynamic hidden;
@dynamic wantsLayer;
@dynamic frameRotation;
@dynamic printJobTitle;
@dynamic autoresizesSubviews;
@dynamic pageFooter;
@dynamic autoresizingMask;
@dynamic rectPreservedDuringLiveResize;
@dynamic isFlipped;
@dynamic constraints;
@dynamic subviews;
@dynamic wantsDefaultClipping;
@dynamic frame;
@dynamic isOpaque;
@dynamic boundsSize;
@dynamic enclosingMenuItem;
@dynamic contentFilters;
@dynamic lockFocusIfCanDraw;
@dynamic postsBoundsChangedNotifications;
@dynamic keyboardFocusRingNeedsDisplayInRect;
@dynamic isInFullScreenMode;
@dynamic needsDisplay;
@dynamic releaseGState;
@dynamic toolTip;
@dynamic isDrawingFindIndicator;
@dynamic needsLayout;
@dynamic gState;
@dynamic heightAdjustLimit;
@dynamic translatesAutoresizingMaskIntoConstraints;
@dynamic nextValidKeyView;
@dynamic wantsUpdateLayer;
@dynamic makeBackingLayer;
@dynamic baselineOffsetFromBottom;
@dynamic alphaValue;
@dynamic layerContentsPlacement;
@dynamic canBecomeKeyView;
@dynamic canDraw;
@dynamic backgroundFilters;
@dynamic frameOrigin;
@dynamic layerUsesCoreImageFilters;
@dynamic widthAdjustLimit;
@dynamic nextKeyView;
@dynamic fittingSize;
@dynamic pageHeader;
@dynamic needsUpdateConstraints;
@dynamic wantsRestingTouches;
@dynamic isRotatedOrScaledFromBase;
@dynamic frameSize;
@dynamic inputContext;
@dynamic mouseDownCanMoveWindow;
@dynamic bounds;
@dynamic userInterfaceLayoutDirection;
@dynamic preservesContentDuringLiveResize;
@dynamic acceptsTouchEvents;
@dynamic layer;
@dynamic superview;
@dynamic canDrawConcurrently;
@dynamic layerContentsRedrawPolicy;
@dynamic opaqueAncestor;
@dynamic isHiddenOrHasHiddenAncestor;
@dynamic tag;
@dynamic needsDisplayInRect;
@dynamic previousKeyView;
@dynamic alignmentRectInsets;
@dynamic registeredDraggedTypes;
@dynamic needsPanelToBecomeKey;
@dynamic enclosingScrollView;
@dynamic compositingFilter;
@dynamic postsFrameChangedNotifications;
@dynamic focusRingType;
@dynamic boundsRotation;
@dynamic focusRingMaskBounds;
@dynamic boundsOrigin;
@dynamic intrinsicContentSize;
@dynamic shouldDrawColor;
@dynamic previousValidKeyView;
@dynamic visibleRect;
@dynamic hasAmbiguousLayout;
@dynamic canDrawSubviewsIntoLayer;
@dynamic inLiveResize;
@dynamic wantsBestResolutionOpenGLSurface;

@end


@implementation NSPredicateEditor (Properties)

@dynamic  rowTemplates;

@end


@implementation NSTextField (Properties)

@dynamic  preferredMaxLayoutWidth;
@dynamic bezeled;
@dynamic bezelStyle;
@dynamic drawsBackground;
@dynamic editable;
@dynamic bordered;
@dynamic allowsEditingTextAttributes;
@dynamic delegate;
@dynamic backgroundColor;
@dynamic importsGraphics;
@dynamic textColor;
@dynamic selectable;
@dynamic acceptsFirstResponder;

@end


#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
@implementation NSMutableFontCollection (Properties)

@dynamic  exclusionDescriptors;
@dynamic queryDescriptors;

@end
#endif

@implementation NSMutableParagraphStyle (Properties)

@dynamic  paragraphSpacing;
@dynamic tailIndent;
@dynamic tighteningFactorForTruncation;
@dynamic headerLevel;
@dynamic defaultTabInterval;
@dynamic lineSpacing;
@dynamic lineBreakMode;
@dynamic tabStops;
@dynamic baseWritingDirection;
@dynamic paragraphSpacingBefore;
@dynamic hyphenationFactor;
@dynamic textLists;
@dynamic textBlocks;
@dynamic headIndent;
@dynamic lineHeightMultiple;
@dynamic minimumLineHeight;
@dynamic paragraphStyle;
@dynamic maximumLineHeight;
@dynamic alignment;
@dynamic firstLineHeadIndent;

@end


@implementation NSPanel (Properties)

@dynamic  floatingPanel;
@dynamic becomesKeyOnlyIfNeeded;
@dynamic worksWhenModal;

@end


@implementation NSTabViewItem (Properties)

@dynamic  color;
@dynamic tabView;
@dynamic initialFirstResponder;
@dynamic toolTip;
@dynamic label;
@dynamic tabState;
@dynamic identifier;
@dynamic view;

@end





@implementation NSPathCell (Properties)

@dynamic pathComponentCells;
@dynamic doubleAction;
@dynamic allowedTypes;
@dynamic URL;
@dynamic controlSize;
@dynamic pathStyle;
@dynamic delegate;
@dynamic backgroundColor;
@dynamic placeholderString;
@dynamic clickedPathComponentCell;
@dynamic placeholderAttributedString;

@end


@implementation NSCursor (Properties)

@dynamic  isSetOnMouseExited;
@dynamic onMouseEntered;
@dynamic isSetOnMouseEntered;
@dynamic onMouseExited;
@dynamic image;
@dynamic hotSpot;

@end


@implementation NSOpenPanel (Properties)

@dynamic  canChooseFiles;
@dynamic resolvesAliases;
@dynamic allowsMultipleSelection;
@dynamic canChooseDirectories;
@dynamic URLs;

@end


@implementation NSEPSImageRep (Properties)

@dynamic  boundingBox;
@dynamic EPSRepresentation;

@end


@implementation NSText (Properties)

@dynamic  isRulerVisible;
@dynamic maxSize;
@dynamic font;
@dynamic alignment;
@dynamic selectedRange;
@dynamic usesFontPanel;
@dynamic minSize;
@dynamic backgroundColor;
@dynamic verticallyResizable;
@dynamic textColor;
@dynamic string;
@dynamic fieldEditor;
@dynamic editable;
@dynamic richText;
@dynamic selectable;
@dynamic horizontallyResizable;
@dynamic drawsBackground;
@dynamic baseWritingDirection;
@dynamic delegate;
@dynamic importsGraphics;

@end


@implementation NSTextTable (Properties)

@dynamic  collapsesBorders;
@dynamic numberOfColumns;
@dynamic hidesEmptyCells;
@dynamic layoutAlgorithm;

@end


@implementation NSEvent (Properties)

@dynamic  vendorDefined;
@dynamic CGEvent;
@dynamic pointingDeviceSerialNumber;
@dynamic hasPreciseScrollingDeltas;
@dynamic momentumPhase;
@dynamic scrollingDeltaX;
@dynamic scrollingDeltaY;
@dynamic uniqueID;
@dynamic tilt;
@dynamic capabilityMask;
@dynamic clickCount;
@dynamic deltaX;
@dynamic deltaY;
@dynamic deltaZ;
@dynamic magnification;
@dynamic window;
@dynamic buttonMask;
@dynamic type;
@dynamic isARepeat;
@dynamic isEnteringProximity;
@dynamic userData;
@dynamic vendorPointingDeviceType;
@dynamic vendorID;
@dynamic timestamp;
@dynamic tabletID;
@dynamic pressure;
@dynamic windowNumber;
@dynamic absoluteX;
@dynamic absoluteY;
@dynamic characters;
@dynamic phase;
@dynamic rotation;
@dynamic charactersIgnoringModifiers;
@dynamic absoluteZ;
@dynamic pointingDeviceID;
@dynamic systemTabletID;
@dynamic eventNumber;
@dynamic modifierFlags;
@dynamic locationInWindow;
@dynamic subtype;
@dynamic trackingArea;
@dynamic deviceID;
@dynamic context;
@dynamic isDirectionInvertedFromDevice;
@dynamic trackingNumber;
@dynamic buttonNumber;
@dynamic tangentialPressure;
@dynamic keyCode;
@dynamic pointingDeviceType;

@end



@implementation NSToolbarItemGroup (Properties)

@dynamic  subitems;

@end


@implementation NSBezierPath (Properties)

@dynamic  bezierPathByFlatteningPath;
@dynamic windingRule;
@dynamic lineCapStyle;
@dynamic bounds;
@dynamic miterLimit;
@dynamic elementCount;
@dynamic lineJoinStyle;
@dynamic bezierPathByReversingPath;
@dynamic currentPoint;
@dynamic flatness;
@dynamic isEmpty;
@dynamic lineWidth;
@dynamic controlPointBounds;

@end




@implementation NSTypesetter (Properties)

@dynamic  paragraphSeparatorCharacterRange;
@dynamic typesetterBehavior;
@dynamic attributesForExtraLineFragment;
@dynamic currentParagraphStyle;
@dynamic currentTextContainer;
@dynamic paragraphSeparatorGlyphRange;
@dynamic hyphenationFactor;
@dynamic paragraphCharacterRange;
@dynamic lineFragmentPadding;
@dynamic usesFontLeading;
@dynamic bidiProcessingEnabled;
@dynamic paragraphGlyphRange;
@dynamic layoutManager;
@dynamic textContainers;
@dynamic attributedString;

@end


@implementation NSFontPanel (Properties)

@dynamic  enabled;
@dynamic accessoryView;
@dynamic worksWhenModal;

@end


@implementation NSComboBoxCell (Properties)

@dynamic  usesDataSource;
@dynamic indexOfSelectedItem;
@dynamic objectValues;
@dynamic itemHeight;
@dynamic hasVerticalScroller;
@dynamic completes;
@dynamic numberOfVisibleItems;
@dynamic numberOfItems;
@dynamic buttonBordered;
@dynamic objectValueOfSelectedItem;
@dynamic intercellSpacing;
@dynamic dataSource;

@end


@implementation NSController (Properties)

@dynamic  commitEditing;
@dynamic isEditing;

@end


@implementation NSToolbar (Properties)

@dynamic  allowsUserCustomization;
@dynamic fullScreenAccessoryViewMinHeight;
@dynamic visibleItems;
@dynamic fullScreenAccessoryViewMaxHeight;
@dynamic items;
@dynamic displayMode;
@dynamic selectedItemIdentifier;
@dynamic visible;
@dynamic sizeMode;
@dynamic delegate;
@dynamic showsBaselineSeparator;
@dynamic configurationDictionary;
@dynamic identifier;
@dynamic customizationPaletteIsRunning;
@dynamic configurationFromDictionary;
@dynamic autosavesConfiguration;

@end


@implementation NSSavePanel (Properties)

@dynamic  directoryURL;
@dynamic isExpanded;
@dynamic accessoryView;
@dynamic URL;
@dynamic canSelectHiddenExtension;
@dynamic extensionHidden;
@dynamic runModal;
@dynamic canCreateDirectories;
@dynamic tagNames;
@dynamic showsHiddenFiles;
@dynamic nameFieldLabel;
@dynamic showsTagField;
@dynamic prompt;
@dynamic message;
@dynamic nameFieldStringValue;
@dynamic treatsFilePackagesAsDirectories;
@dynamic allowsOtherFileTypes;
@dynamic allowedFileTypes;

@end








@implementation NSPrinter (Properties)

@dynamic  deviceDescription;
@dynamic type;
@dynamic name;
@dynamic languageLevel;

@end


@implementation NSATSTypesetter (Properties)

@dynamic  typesetterBehavior;
@dynamic currentTextContainer;
@dynamic paragraphSeparatorGlyphRange;
@dynamic hyphenationFactor;
@dynamic lineFragmentPadding;
@dynamic usesFontLeading;
@dynamic bidiProcessingEnabled;
@dynamic paragraphGlyphRange;
@dynamic layoutManager;

@end


@implementation NSSearchField (Properties)

@dynamic  recentsAutosaveName;
@dynamic recentSearches;

@end


@implementation NSFont (Properties)

@dynamic  fontName;
@dynamic pointSize;
@dynamic capHeight;
@dynamic isFixedPitch;
@dynamic maximumAdvancement;
@dynamic underlinePosition;
@dynamic underlineThickness;
@dynamic italicAngle;
@dynamic screenFont;
@dynamic matrix;
@dynamic leading;
@dynamic coveredCharacterSet;
@dynamic fontDescriptor;
@dynamic inContext;
@dynamic ascender;
@dynamic numberOfGlyphs;
@dynamic printerFont;
@dynamic familyName;
@dynamic mostCompatibleStringEncoding;
@dynamic renderingMode;
@dynamic descender;
@dynamic boundingRectForFont;
@dynamic displayName;
@dynamic verticalFont;
@dynamic xHeight;
@dynamic isVertical;
@dynamic textTransform;

@end


@implementation NSOutlineView (Properties)

@dynamic  autosaveExpandedItems;
@dynamic indentationPerLevel;
@dynamic userInterfaceLayoutDirection;
@dynamic indentationMarkerFollowsCell;
@dynamic autoresizesOutlineColumn;
@dynamic outlineTableColumn;

@end


@implementation NSPrintPanel (Properties)

@dynamic  jobStyleHint;
@dynamic defaultButtonTitle;
@dynamic printInfo;
@dynamic accessoryControllers;
@dynamic runModal;
@dynamic helpAnchor;
@dynamic options;

@end


@implementation NSBitmapImageRep (Properties)

@dynamic  bitmapFormat;
@dynamic CGImage;
@dynamic bitmapData;
@dynamic isPlanar;
@dynamic bytesPerPlane;
@dynamic bitsPerPixel;
@dynamic TIFFRepresentation;
@dynamic colorSpace;
@dynamic bytesPerRow;
@dynamic initForIncrementalLoad;
@dynamic samplesPerPixel;
@dynamic numberOfPlanes;

@end


@implementation NSTableView (Properties)

@dynamic  headerView;
@dynamic autosaveTableColumns;
@dynamic effectiveRowSizeStyle;
@dynamic cornerView;
@dynamic selectedColumnIndexes;
@dynamic editedRow;
@dynamic rowSizeStyle;
@dynamic selectedRowIndexes;
@dynamic sortDescriptors;
@dynamic clickedColumn;
@dynamic selectedColumn;
@dynamic usesAlternatingRowBackgroundColors;
@dynamic registeredNibsByIdentifier;
@dynamic doubleAction;
@dynamic numberOfColumns;
@dynamic numberOfSelectedColumns;
@dynamic allowsColumnReordering;
@dynamic verticalMotionCanBeginDrag;
@dynamic editedColumn;
@dynamic allowsTypeSelect;
@dynamic gridColor;
@dynamic backgroundColor;
@dynamic allowsColumnSelection;
@dynamic selectionHighlightStyle;
@dynamic autosaveName;
@dynamic allowsColumnResizing;
@dynamic numberOfSelectedRows;
@dynamic allowsEmptySelection;
@dynamic allowsMultipleSelection;
@dynamic dataSource;
@dynamic floatsGroupRows;
@dynamic columnAutoresizingStyle;
@dynamic intercellSpacing;
@dynamic draggingDestinationFeedbackStyle;
@dynamic rowHeight;
@dynamic selectedRow;
@dynamic clickedRow;
@dynamic focusedColumn;
@dynamic highlightedTableColumn;
@dynamic gridStyleMask;
@dynamic numberOfRows;
@dynamic delegate;
@dynamic tableColumns;

@end


@implementation NSFontDescriptor (Properties)

@dynamic  postscriptName;
@dynamic fontAttributes;
@dynamic pointSize;
@dynamic matrix;
@dynamic symbolicTraits;

@end








#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
@implementation NSFontCollection (Properties)

@dynamic  exclusionDescriptors;
@dynamic matchingDescriptors;
@dynamic queryDescriptors;

@end
#endif




@implementation NSColor (Properties)

@dynamic  yellowComponent;
@dynamic colorSpace;
@dynamic greenComponent;
@dynamic whiteComponent;
@dynamic magentaComponent;
@dynamic patternImage;
@dynamic hueComponent;
@dynamic numberOfComponents;
@dynamic localizedCatalogNameComponent;
@dynamic blackComponent;
@dynamic colorNameComponent;
@dynamic blueComponent;
@dynamic brightnessComponent;
@dynamic colorSpaceName;
@dynamic localizedColorNameComponent;
@dynamic redComponent;
@dynamic cyanComponent;
@dynamic catalogNameComponent;
@dynamic saturationComponent;
@dynamic alphaComponent;

@end


@implementation NSViewAnimation (Properties)

@dynamic  viewAnimations;

@end


@implementation NSOpenGLPixelFormat (Properties)

@dynamic  attributes;
@dynamic numberOfVirtualScreens;
@dynamic CGLPixelFormatObj;

@end


@implementation NSLevelIndicatorCell (Properties)

@dynamic  criticalValue;
@dynamic numberOfMajorTickMarks;
@dynamic maxValue;
@dynamic numberOfTickMarks;
@dynamic minValue;
@dynamic tickMarkPosition;
@dynamic warningValue;
@dynamic levelIndicatorStyle;

@end


@implementation NSTokenFieldCell (Properties)

@dynamic  tokenStyle;
@dynamic tokenizingCharacterSet;
@dynamic completionDelay;
@dynamic delegate;

@end


@implementation NSAlert (Properties)

@dynamic  buttons;
@dynamic showsHelp;
@dynamic alertStyle;
@dynamic accessoryView;
@dynamic showsSuppressionButton;
@dynamic messageText;
@dynamic suppressionButton;
@dynamic window;
@dynamic informativeText;
@dynamic helpAnchor;
@dynamic delegate;
@dynamic icon;

@end


@implementation NSApplication (Properties)

@dynamic  dockTile;
@dynamic isFullKeyboardAccessEnabled;
@dynamic orderedDocuments;
@dynamic servicesMenu;
@dynamic currentEvent;
@dynamic applicationIconImage;
@dynamic isActive;
@dynamic orderedWindows;
@dynamic isHidden;
@dynamic windowsNeedUpdate;
@dynamic servicesProvider;
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
@dynamic occlusionState;
#endif
@dynamic enabledRemoteNotificationTypes;
@dynamic activationPolicy;
@dynamic presentationOptions;
@dynamic keyWindow;
@dynamic currentSystemPresentationOptions;
@dynamic isRunning;
@dynamic modalWindow;
@dynamic mainMenu;
@dynamic mainWindow;
@dynamic windows;
@dynamic userInterfaceLayoutDirection;
@dynamic helpMenu;
@dynamic delegate;
@dynamic context;
@dynamic windowsMenu;

@end


@implementation NSTextStorage (Properties)

@dynamic  changeInLength;
@dynamic fixesAttributesLazily;
@dynamic characters;
@dynamic attributeRuns;
@dynamic foregroundColor;
@dynamic delegate;
@dynamic words;
@dynamic paragraphs;
@dynamic layoutManagers;
@dynamic editedMask;
@dynamic font;
@dynamic editedRange;

@end


@implementation NSViewController (Properties)

@dynamic  title;
@dynamic commitEditing;
@dynamic representedObject;
@dynamic nibName;
@dynamic nibBundle;
@dynamic view;

@end








@implementation NSMenuItem (Properties)

@dynamic  onStateImage;
@dynamic image;
@dynamic userKeyEquivalent;
@dynamic isHiddenOrHasHiddenAncestor;
@dynamic tag;
@dynamic isHighlighted;
@dynamic parentItem;
@dynamic title;
@dynamic menu;
@dynamic alternate;
@dynamic attributedTitle;
@dynamic state;
@dynamic hidden;
@dynamic titleWithMnemonic;
@dynamic isSeparatorItem;
@dynamic indentationLevel;
@dynamic toolTip;
@dynamic keyEquivalent;
@dynamic keyEquivalentModifierMask;
@dynamic target;
@dynamic submenu;
@dynamic hasSubmenu;
@dynamic mixedStateImage;
@dynamic enabled;
@dynamic representedObject;
@dynamic action;
@dynamic view;

@end


@implementation NSTextView (Properties)

@dynamic  usesInspectorBar;
@dynamic enabledTextCheckingTypes;
@dynamic usesFindBar;
@dynamic textContainerOrigin;
@dynamic readablePasteboardTypes;
@dynamic defaultParagraphStyle;
@dynamic isCoalescingUndo;
@dynamic insertionPointColor;
@dynamic layoutOrientation;
@dynamic layoutManager;
@dynamic rangeForUserParagraphAttributeChange;
@dynamic selectable;
@dynamic rangeForUserCharacterAttributeChange;
@dynamic selectionGranularity;
@dynamic selectedRange;
@dynamic usesFontPanel;
@dynamic allowsImageEditing;
@dynamic rangesForUserCharacterAttributeChange;
@dynamic textContainer;
@dynamic typingAttributes;
@dynamic spellCheckerDocumentTag;
@dynamic displaysLinkToolTips;
@dynamic shouldDrawInsertionPoint;
@dynamic writablePasteboardTypes;
@dynamic automaticTextReplacementEnabled;
@dynamic rangeForUserCompletion;
@dynamic acceptsGlyphInfo;
@dynamic smartInsertDeleteEnabled;
@dynamic usesRuler;
@dynamic rangesForUserTextChange;
@dynamic constrainedFrameSize;
@dynamic fieldEditor;
@dynamic selectedRanges;
@dynamic editable;
@dynamic richText;
@dynamic continuousSpellCheckingEnabled;
@dynamic selectedTextAttributes;
@dynamic grammarCheckingEnabled;
@dynamic allowedInputSourceLocales;
@dynamic automaticLinkDetectionEnabled;
@dynamic rangeForUserTextChange;
@dynamic automaticDataDetectionEnabled;
@dynamic rulerVisible;
@dynamic allowsUndo;
@dynamic textContainerInset;
@dynamic drawsBackground;
@dynamic usesFindPanel;
@dynamic allowsDocumentBackgroundColorChange;
@dynamic automaticQuoteSubstitutionEnabled;
@dynamic textStorage;
@dynamic markedTextAttributes;
@dynamic automaticSpellingCorrectionEnabled;
@dynamic importsGraphics;
@dynamic selectionAffinity;
@dynamic linkTextAttributes;
@dynamic incrementalSearchingEnabled;

@end


@implementation NSSearchFieldCell (Properties)

@dynamic  recentsAutosaveName;
@dynamic searchButtonCell;
@dynamic recentSearches;
@dynamic sendsSearchStringImmediately;
@dynamic cancelButtonCell;
@dynamic maximumRecents;
@dynamic searchMenuTemplate;
@dynamic sendsWholeSearchString;

@end


@implementation NSSegmentedControl (Properties)

@dynamic  selectedSegment;
@dynamic segmentStyle;
@dynamic segmentCount;

@end





@implementation NSWindow (Properties)

@dynamic  canHide;
@dynamic resizeFlags;
@dynamic excludedFromWindowsMenu;
@dynamic showsToolbarButton;
@dynamic allowsToolTipsWhenApplicationIsInactive;
@dynamic ignoresMouseEvents;
@dynamic title;
@dynamic showsResizeIndicator;
@dynamic backingType;
@dynamic areCursorRectsEnabled;
@dynamic stringWithSavedFrame;
@dynamic canBecomeKeyWindow;
@dynamic contentMinSize;
@dynamic depthLimit;
@dynamic isResizable;
@dynamic frameAutosaveName;
@dynamic miniwindowTitle;
@dynamic level;
@dynamic firstResponder;
@dynamic canStoreColor;
@dynamic delegate;
@dynamic isOnActiveSpace;
@dynamic representedURL;
@dynamic restorationClass;
@dynamic frameOrigin;
@dynamic frame;
@dynamic colorSpace;
@dynamic frameFromString;
@dynamic dockTile;
@dynamic maxSize;
@dynamic miniwindowImage;
@dynamic userSpaceScaleFactor;
@dynamic opaque;
@dynamic currentEvent;
@dynamic backgroundColor;
@dynamic releasedWhenClosed;
@dynamic childWindows;
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
@dynamic occlusionState;
#endif
@dynamic documentEdited;
@dynamic collectionBehavior;
@dynamic screen;
@dynamic alphaValue;
@dynamic parentWindow;
@dynamic toolbar;
@dynamic isZoomable;
@dynamic displaysWhenScreenProfileChanges;
@dynamic gState;
@dynamic dynamicDepthLimit;
@dynamic windowNumber;
@dynamic frameTopLeftPoint;
@dynamic initialFirstResponder;
@dynamic drawers;
@dynamic backingScaleFactor;
@dynamic worksWhenModal;
@dynamic attachedSheet;
@dynamic orderedIndex;
@dynamic aspectRatio;
@dynamic viewsNeedDisplay;
@dynamic contentSize;
@dynamic hidesOnDeactivate;
@dynamic sheets;
@dynamic isFloatingPanel;
@dynamic preventsApplicationTerminationWhenModal;
@dynamic canBecomeVisibleWithoutLogin;
@dynamic keyViewSelectionDirection;
@dynamic styleMask;
@dynamic titleWithRepresentedFilename;
@dynamic isZoomed;
@dynamic restorable;
@dynamic sheetParent;
@dynamic resizeIncrements;
@dynamic movableByWindowBackground;
@dynamic canBecomeMainWindow;
@dynamic defaultButtonCell;
@dynamic graphicsContext;
@dynamic hasShadow;
@dynamic isFlushWindowDisabled;
@dynamic windowController;
@dynamic backingLocation;
@dynamic contentMaxSize;
@dynamic isModalPanel;
@dynamic preservesContentDuringLiveResize;
@dynamic isMiniaturized;
@dynamic animationBehavior;
@dynamic isMainWindow;
@dynamic contentResizeIncrements;
@dynamic sharingType;
@dynamic minSize;
@dynamic deepestScreen;
@dynamic mouseLocationOutsideOfEventStream;
@dynamic contentAspectRatio;
@dynamic oneShot;
@dynamic autodisplay;
@dynamic preferredBackingLocation;
@dynamic deviceDescription;
@dynamic hasTitleBar;
@dynamic isVisible;
@dynamic movable;
@dynamic isKeyWindow;
@dynamic isMiniaturizable;
@dynamic contentView;
@dynamic acceptsMouseMovedEvents;
@dynamic representedFilename;
@dynamic hasCloseBox;
@dynamic isSheet;
@dynamic allowsConcurrentViewDrawing;
@dynamic autorecalculatesKeyViewLoop;

@end


@implementation NSSpeechSynthesizer (Properties)

@dynamic  isSpeaking;
@dynamic volume;
@dynamic rate;
@dynamic delegate;
@dynamic voice;
@dynamic usesFeedbackWindow;

@end


@implementation NSScroller (Properties)

@dynamic  usableParts;
@dynamic hitPart;
@dynamic scrollerStyle;
@dynamic arrowsPosition;
@dynamic controlSize;
@dynamic knobStyle;
@dynamic controlTint;
@dynamic knobProportion;

@end


@implementation NSTrackingArea (Properties)

@dynamic  owner;
@dynamic options;
@dynamic rect;
@dynamic userInfo;

@end

#endif
#endif