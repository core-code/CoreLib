//
//  CoreLibTests.m
//  CoreLibTests
//
//  Created by Julian Mayer on 21/12/13.
//  Copyright (c) 2013 CoreCode. All rights reserved.
//

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
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTAssertNotNil(fileManager);
}

@end
