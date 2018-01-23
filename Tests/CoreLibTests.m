#import <XCTest/XCTest.h>
#import "JMHostInformation.h"


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


@interface TestI : NSDictionary
@property (nonatomic, readonly) NSString *title;
@end
@implementation TestI
@dynamic title;
@end

@interface Test : NSDictionary
@property (nonatomic, readonly) NSString *title;
@end


@interface TestW : NSMutableDictionary
@property (nonatomic, strong) NSString *title;
@end

@interface TestWI : NSMutableDictionary
@property (nonatomic, strong) NSString *title;
@end
@implementation TestWI
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
    {
        TestI *bla = (TestI *)@{@"title" : @"1"};
        NSString *result = bla.title;
        XCTAssert([result isEqualToString:@"1"]);
    }
    {
        Test *bla = (Test *)@{@"title" : @"1"};
        NSString *result = bla.title;
        XCTAssert([result isEqualToString:@"1"]);
    }
//    { // ok this doesn't work - even on the mac ;)
//        TestW *bla = (TestW *)makeMutableDictionary();
//        bla.title = @"1";
//        NSString *result = bla.title;
//        XCTAssert([result isEqualToString:@"1"]);
//    }
//    {
//        TestWI *bla = (TestWI *)makeMutableDictionary();
//        bla.title = @"1";
//        NSString *result = bla.title;
//        XCTAssert([result isEqualToString:@"1"]);
//    }
}


- (void)testHostInformation
{
    NSString *ipv4 = [JMHostInformation ipAddress:NO];
    XCTAssert([ipv4 countOccurencesOfString:@"."] == 3);
    XCTAssert([ipv4 replaced:@"." with:@""].integerValue != 0);
    NSString *ipv6 = [JMHostInformation ipAddress:YES];
    XCTAssert([ipv6 countOccurencesOfString:@":"] >= 5);
    NSString *ipn = [JMHostInformation ipName];
    XCTAssert([ipn hasSuffix:@".local"]);
    NSString *mt = [JMHostInformation machineType];
    XCTAssert([mt countOccurencesOfString:@","] == 1);
    NSString *mac = [JMHostInformation macAddress];
    XCTAssert([mac countOccurencesOfString:@":"] == 5);
    BOOL online = [JMHostInformation isOnline];
    BOOL battery = [JMHostInformation runsOnBattery];
    cc_log(@"%i %i", online, battery);
    
    NSArray *mhdds1 = [JMHostInformation mountedHarddisks:NO];
    NSArray *mhdds2 = [JMHostInformation mountedHarddisks:YES];
    NSArray *hdds = [JMHostInformation allHarddisks];
    XCTAssert(mhdds1.count);
    XCTAssert(mhdds2.count >= mhdds1.count);
    XCTAssert(hdds.count >= mhdds2.count);
    
    for (NSDictionary *dict in hdds)
    {
        NSNumber *num = dict[@"DiskNumber"];
        
        smartStatusEnum status = [JMHostInformation getDiskSMARTStatus:num.intValue];
        NSDictionary *attr = [JMHostInformation getDiskSMARTAttributes:num.intValue];
        NSDictionary *desc = [JMHostInformation descriptionForDevice:num.intValue];
        cc_log(@"%i %@", status, attr);
        
        XCTAssert(desc);
        NSString *name = [JMHostInformation volumeNamesForDevice:num.intValue];
        if (name)
        {
            NSNumber *backnum = [JMHostInformation bsdNumberForVolume:name];
            
            XCTAssert(backnum.intValue == num.intValue);
        }
    }
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
