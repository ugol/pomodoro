//
//  NSMutableURLRequest+ParametersTest.m
//  OAuthConsumer
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "NSMutableURLRequest+ParametersTest.h"

@interface NSMutableURLRequest_ParametersTest (Utility)
- (void)verifyDefaultParametersForRequest:(NSMutableURLRequest *)request;
- (void)verifyModifiedParametersForRequest:(NSMutableURLRequest *)request;
- (void)verifyEmptyParametersForRequest:(NSMutableURLRequest *)request;
@end

@implementation NSMutableURLRequest_ParametersTest

- (void)setUp {
    requestWithoutParams = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://kaboomerang.com/index.html"]];
    requestWithQueryParams = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://kaboomerang.com/test.rb?first_name=fake&last_name=steve"]];
    
    NSString *encodedParameterPairs = @"first_name=fake&last_name=steve";
    NSData *requestData = [encodedParameterPairs dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    requestWithBodyParams = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://kaboomerang.com/test.rb"]];
    [requestWithBodyParams setHTTPBody:requestData];
    [requestWithBodyParams setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [requestWithBodyParams setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    OARequestParameter *firstName = [[OARequestParameter alloc] initWithName:@"address" value:@"123 Main Street"];
    OARequestParameter *lastName = [[OARequestParameter alloc] initWithName:@"city" value:@"Hometown"];
    parameters = [NSArray arrayWithObjects:firstName, lastName, nil];
}

- (void)testParametersForGETWithoutParameters {
    [self verifyEmptyParametersForRequest:requestWithoutParams];
}

- (void)testParametersForGETWithParameters {
    [self verifyDefaultParametersForRequest:requestWithQueryParams];
}

- (void)testParametersForPOSTWithoutParameters {
    [requestWithoutParams setHTTPMethod:@"POST"];
    [self verifyEmptyParametersForRequest:requestWithoutParams];
}

- (void)testParametersForPOSTWithParameters {
    [requestWithBodyParams setHTTPMethod:@"POST"];
    [self verifyDefaultParametersForRequest:requestWithBodyParams];
}

- (void)testParametersForPUTWithoutParameters {
    [requestWithoutParams setHTTPMethod:@"PUT"];
    [self verifyEmptyParametersForRequest:requestWithoutParams];
}

- (void)testParametersForPUTWithParameters {
    [requestWithBodyParams setHTTPMethod:@"PUT"];
    [self verifyDefaultParametersForRequest:requestWithBodyParams];
}

- (void)testParametersForDELETEWithoutParameters {
    [requestWithoutParams setHTTPMethod:@"DELETE"];
    [self verifyEmptyParametersForRequest:requestWithoutParams];
}

- (void)testParametersForDELETEWithParameters {
    [requestWithQueryParams setHTTPMethod:@"DELETE"];
    [self verifyDefaultParametersForRequest:requestWithQueryParams];
}

- (void)testSetParametersForGETWithoutParameters {
    [requestWithoutParams setParameters:parameters];
    [self verifyModifiedParametersForRequest:requestWithoutParams];
}

- (void)testSetParametersForGETWithParameters {
    [requestWithQueryParams setParameters:parameters];
    [self verifyModifiedParametersForRequest:requestWithQueryParams];
}

- (void)testSetParametersForPOSTWithoutParameters {
    [requestWithoutParams setHTTPMethod:@"POST"];
    [requestWithoutParams setParameters:parameters];
    [self verifyModifiedParametersForRequest:requestWithoutParams];
}

- (void)testSetParametersForPOSTWithParameters {
    [requestWithBodyParams setHTTPMethod:@"POST"];
    [requestWithBodyParams setParameters:parameters];
    [self verifyModifiedParametersForRequest:requestWithBodyParams];
}

- (void)testSetParametersForPUTWithoutParameters {
    [requestWithoutParams setHTTPMethod:@"PUT"];
    [requestWithoutParams setParameters:parameters];
    [self verifyModifiedParametersForRequest:requestWithoutParams];
}

- (void)testSetParametersForPUTWithParameters {
    [requestWithBodyParams setHTTPMethod:@"PUT"];
    [requestWithBodyParams setParameters:parameters];
    [self verifyModifiedParametersForRequest:requestWithBodyParams];
}

- (void)testSetParametersForDELETEWithoutParameters {
    [requestWithoutParams setHTTPMethod:@"DELETE"];
    [requestWithoutParams setParameters:parameters];
    [self verifyModifiedParametersForRequest:requestWithoutParams];
}

- (void)testSetParametersForDELETEWithParameters {
    [requestWithQueryParams setHTTPMethod:@"DELETE"];
    [requestWithQueryParams setParameters:parameters];
    [self verifyModifiedParametersForRequest:requestWithQueryParams];
}

- (void)verifyDefaultParametersForRequest:(NSMutableURLRequest *)request {
    STAssertNotNil([request parameters],
                   @"A request with parameters should not return nil.");
    STAssertEqualObjects([[[request parameters] objectAtIndex:0] name],
                         @"first_name",
                         @"first_name param returned: %@. Expected: first_name.",
                         [[[request parameters] objectAtIndex:0] name]);
    STAssertEqualObjects([[[request parameters] objectAtIndex:0] value],
                         @"fake",
                         @"first_name param value returned: %@. Expected: fake.",
                         [[[request parameters] objectAtIndex:0] value]);
    STAssertEqualObjects([[[request parameters] objectAtIndex:1] name],
                         @"last_name",
                         @"last_name param returned: %@. Expected: last_name.",
                         [[[request parameters] objectAtIndex:1] name]);
    STAssertEqualObjects([[[request parameters] objectAtIndex:1] value],
                         @"steve",
                         @"last_name param value returned: %@. Expected: steve.",
                         [[[request parameters] objectAtIndex:1] value]);
}

- (void)verifyModifiedParametersForRequest:(NSMutableURLRequest *)request {
    STAssertNotNil([request parameters],
                   @"A request with parameters should not return nil.");
    STAssertEqualObjects([[[request parameters] objectAtIndex:0] name],
                         @"address",
                         @"address param returned: %@. Expected: address.",
                         [[[request parameters] objectAtIndex:0] name]);
    STAssertEqualObjects([[[request parameters] objectAtIndex:0] value],
                         @"123 Main Street",
                         @"address param value returned: %@. Expected: 123 Main Street.",
                         [[[request parameters] objectAtIndex:0] value]);
    STAssertEqualObjects([[[request parameters] objectAtIndex:1] name],
                         @"city",
                         @"city param returned: %@. Expected: city.",
                         [[[request parameters] objectAtIndex:1] name]);
    STAssertEqualObjects([[[request parameters] objectAtIndex:1] value],
                         @"Hometown",
                         @"city param value returned: %@. Expected: Hometown.",
                         [[[request parameters] objectAtIndex:1] value]);
}

- (void)verifyEmptyParametersForRequest:(NSMutableURLRequest *)request {
    STAssertNil([request parameters],
                @"A request with no parameters returned: %@",
                [request parameters]);
}

@end
