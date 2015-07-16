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
@end
