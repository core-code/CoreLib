#import <XCTest/XCTest.h>



NSString *randomString(int maxLength)
{
    NSMutableString *str = [NSMutableString string];
    int len = generateRandomIntBetween(0,maxLength);

    for (int i = 0; i < len; i++)
    {
        unsigned char r = (unsigned char) generateRandomIntBetween(1,255);

        NSString *c = [[NSString alloc] initWithBytes:&r length:1 encoding:NSASCIIStringEncoding];

        [str appendString:c];
    }
    return str;
}


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

- (void)testDirectoryListing
{
    for (NSString *dir in @[@"/Library/"])
    {
        NSArray <NSURL *>*dirContents = dir.fileURL.directoryContentsRecursive;
        
        XCTAssert(dirContents.count > 10000);
    }
}

- (void)testDirectorySize
{
    for (NSString *dir in @[@"/Library/"])
    {
        unsigned long long size = dir.fileURL.directorySize;
        
        XCTAssert(BYTES_TO_MB(size) > 1000);
    }
}


#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
- (void)testDictionaryMisuse // we know this fails on iOS for a while now. no more fun with bad tricks
{
	Test *bla = (Test *)@{@"title" : @"1"};
	NSString *result = bla.title;
	XCTAssert([result isEqualToString:@"1"]);
}
#endif

- (void)testStringHexRoundtrip
{
	NSData *data = @"/System/Library/PreferencePanes/Dock.prefPane/Contents/Resources/Dock.png".contents;

	NSString *bla = data.hexString;

	NSData *data2 = bla.dataFromHexString;

	XCTAssert([data isEqualToData:data2]);
}
- (void)testTimeout
{
    BOOL res1 = dispatch_sync_back_timeout(^{ cc_log_debug(@"testTimeout");}, 1);
    XCTAssert(res1 == 0);


    BOOL res2 = dispatch_sync_back_timeout(^{ sleep(5);}, 1);
    XCTAssert(res2 == 1);

    __block BOOL shit1 = FALSE;
    BOOL res3 = dispatch_sync_back_timeout(^{ shit1 = TRUE; cc_log_debug(@"testTimeout");}, 1);
    XCTAssert(res3 == 0);
    XCTAssert(shit1 == 1);

    __block BOOL shit2 = FALSE;
    BOOL res4 = dispatch_sync_back_timeout(^{ shit2 = TRUE; sleep(5);}, 1);
    XCTAssert(res4 == 1);
    XCTAssert(shit2 == 1);
}


- (void)testLogging
{
//  for (int i = 0; i < 100; i++)
    {
        NSString *str = randomString(100);
        
        cc_log_debug(@"%@", str);
        cc_log(@"%@", str);
        cc_log_error(@"%@", str);
        cc_log_emerg(@"%@", str);
        cc_log_level(2, @"%@", str);
    }
}


@end
