//
//  SocializeFacebookInterfaceTests.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 10/31/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeFacebookInterfaceTests.h"
#import "SocializeFacebookInterface.h"
#import <Facebook-iOS-SDK/FacebookSDK/Facebook.h>
#import "Socialize.h"
#import "SocializeThirdPartyFacebook.h"
#import "SocializeTestCase.h"
#import "Facebook+Socialize.h"

@interface SocializeFacebookInterface () <FBRequestDelegate>
@end

@implementation SocializeFacebookInterfaceTests
@synthesize facebookInterface = facebookInterface_;

- (void)setUp {
    self.facebookInterface = [[[SocializeFacebookInterface alloc] init] autorelease];
}

- (void)tearDown {
    self.facebookInterface = nil;
}

- (void)testSuccessfulRequest {
    __block BOOL completed = NO;
    
    id mockFacebook = [OCMockObject mockForClass:[Facebook class]];
    [[[mockFacebook stub] andReturnBool:YES] isForCurrentSocializeSession];
    id mockRequest = [OCMockObject mockForClass:[FBRequest class]];
    [[[mockFacebook expect] andReturn:mockRequest] requestWithGraphPath:@"some/path" andParams:[NSMutableDictionary dictionary] andHttpMethod:@"METHOD" andDelegate:self.facebookInterface];
    self.facebookInterface.facebook = mockFacebook;
    
    [self.facebookInterface requestWithGraphPath:@"some/path" params:nil httpMethod:@"METHOD" completion:^(id result, NSError *error) {
        GHAssertNil(error, @"error was not nil");
        completed = YES;
    }];
    [self.facebookInterface request:mockRequest didLoad:nil];
    
    GHAssertTrue(completed, @"block not completed");
    [mockFacebook verify];
}

- (void)testFailedRequest {
    __block BOOL completed = NO;
    
    id mockFacebook = [OCMockObject mockForClass:[Facebook class]];
    [[[mockFacebook stub] andReturnBool:YES] isForCurrentSocializeSession];
    id mockRequest = [OCMockObject mockForClass:[FBRequest class]];
    [[[mockFacebook expect] andReturn:mockRequest] requestWithGraphPath:@"some/path" andParams:[NSMutableDictionary dictionary] andHttpMethod:@"METHOD" andDelegate:self.facebookInterface];
    self.facebookInterface.facebook = mockFacebook;
    
    [self.facebookInterface requestWithGraphPath:@"some/path" params:nil httpMethod:@"METHOD" completion:^(id result, NSError *error) {
        GHAssertNil(result, @"result was not nil");
        completed = YES;
    }];
    [self.facebookInterface request:mockRequest didFailWithError:nil];
    
    GHAssertTrue(completed, @"block not completed");
}

@end