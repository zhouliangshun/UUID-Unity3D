//
//  UUIDTests.m
//  UUIDTests
//
//  Created by liangshun zhou on 11/19/13.
//  Copyright (c) 2013 MT. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UUID.h"

@interface UUIDTests : XCTestCase

@end

@implementation UUIDTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    
    if(HasUUID(CSTR(@"com.mdnt.uuid.test.1"))==0)
    {
        SaveUUID(CSTR(@"com.mdnt.uuid.test.1"),CSTR(@"1121-2121-4433-4335"));
    }else
    {
        GetUUID(CSTR(@"com.mdnt.uuid.test.1"));
    }
    
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    

}

@end
