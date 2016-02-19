//
//  ResourceCenterTests.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 1/25/16.
//  Copyright (c) 2016 Bill. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ResourceCenter.h"

@interface ResourceCenterTests : XCTestCase

@property (nonatomic) ResourceCenter *rcToTest;
@end

@implementation ResourceCenterTests

- (void)setUp {
    [super setUp];
    self.rcToTest = [[ResourceCenter alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void)testDecyperToReadable {
    NSString *category1 = @"gettingonoff";
    NSString *category2 = @"ridingthebus";

    NSString *expected1 = @"getting on and off the bus";
    NSString *expected2 = @"riding the bus";

    NSString *readable1 = [[self rcToTest] decyperToReadable:category1];
    NSString *readable2 = [[self rcToTest] decyperToReadable:category2];


    XCTAssertEqualObjects(expected1, readable1);
    XCTAssertEqualObjects(expected2, readable2);
}


-(void) testColorFromHexString {

    UIColor *color1 = [ResourceCenter colorFromHexString:@"#662865"];
    UIColor *expectColor1 = [UIColor colorWithRed:0.4 green:0.157 blue:0.396 alpha:1]; /*#662865*/

    UIColor *color2 = [ResourceCenter colorFromHexString:@"#006400"];
    UIColor *expectColor2 = [UIColor colorWithRed:0 green:0.392 blue:0 alpha:1]; /*#006400*/

    UIColor *color3 = [ResourceCenter colorFromHexString:@"#ffc0cb"];
    UIColor *expectColor3 = [UIColor colorWithRed:1 green:0.753 blue:0.796 alpha:1]; /*#ffc0cb*/

    
//    XCTAssertEqualObjects(color1, expectColor1);
//    XCTAssertEqualObjects(color2, expectColor2);
//    XCTAssertEqualObjects(color3, expectColor3);

}

-(void)testPerformanceSpeakOut {
    NSString *speakText = @"hello welcome to test project eric speak out";
    [self measureBlock:^{
        [[self rcToTest] SpeakOut:speakText];
    }];

}

-(void)testPerformanceSpeakContinue {
    NSString *speakText = @"hello welcome to test project eric speak continue";
    [self measureBlock:^{
        [[self rcToTest] SpeakContinue:speakText];
    }];

}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



@end
