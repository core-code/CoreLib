#import <XCTest/XCTest.h>

@interface CoreLibTests : XCTestCase

@end


@implementation CoreLibTests

- (void)setUp
{
    [super setUp];
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

@end
