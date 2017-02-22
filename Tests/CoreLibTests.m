#import <XCTest/XCTest.h>




@interface Test : NSDictionary
@property (nonatomic, readonly) NSString *title;
@end
@implementation Test
@dynamic title;
@end


@interface CoreLibTests : XCTestCase

@end


@implementation CoreLibTests

- (void)setUp
{
	[super setUp];

	if (!cc)
		cc = [CoreLib new];
}

- (void)tearDown
{
	[super tearDown];
}

- (void)testExample
{
	XCTAssertNotNil(fileManager);
}

- (void)testDictionaryMisuse
{
	Test *bla = (Test *)@{@"title" : @"1"};
	NSString *result = bla.title;
	XCTAssert([result isEqualToString:@"1"]);
}

- (void)testStringHexRoundtrip
{
	NSData *data = @"/System/Library/PreferencePanes/Dock.prefPane/Contents/Resources/Dock.png".contents;

	NSString *bla = data.hexString;

	NSData *data2 = bla.dataFromHexString;

	XCTAssert([data isEqualToData:data2]);
}
#if ((MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_10) || (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000))
- (void)testTimeout
{
    BOOL res1 = dispatch_sync_back_timeout(^{ asl_NSLog_debug(@"testTimeout");}, 1);
    XCTAssert(res1 == 0);


    BOOL res2 = dispatch_sync_back_timeout(^{ sleep(5);}, 1);
    XCTAssert(res2 == 1);

    __block BOOL shit1 = FALSE;
    BOOL res3 = dispatch_sync_back_timeout(^{ shit1 = TRUE; asl_NSLog_debug(@"testTimeout");}, 1);
    XCTAssert(res3 == 0);
    XCTAssert(shit1 == 1);

    __block BOOL shit2 = FALSE;
    BOOL res4 = dispatch_sync_back_timeout(^{ shit2 = TRUE; sleep(5);}, 1);
    XCTAssert(res4 == 1);
    XCTAssert(shit2 == 1);
}
#endif
@end
