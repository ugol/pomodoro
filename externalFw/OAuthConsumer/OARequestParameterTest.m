//
//  OARequestParameterTest.m
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


#import "OARequestParameterTest.h"


@implementation OARequestParameterTest

- (void)setUp {
    param = [[OARequestParameter alloc] initWithName:@"simon" value:@"did not say"];
}

- (void)testInitWithName {
    STAssertEqualObjects(param.name, @"simon", @"The parameter name was incorrectly set to: %@", param.name);
    STAssertEqualObjects(param.value, @"did not say", @"The parameter value was incorrectly set to: %@", param.value);
}

- (void)testURLEncodedName {
    STAssertEqualObjects([param URLEncodedName], @"simon", @"The parameter name was incorrectly encoded as: %@", [param URLEncodedName]);
}

- (void)testURLEncodedValue {
    STAssertEqualObjects([param URLEncodedValue], @"did\%20not\%20say", @"The parameter value was incorrectly encoded as: %@", [param URLEncodedValue]);
}

- (void)testURLEncodedNameValuePair {
    STAssertEqualObjects([param URLEncodedNameValuePair], @"simon=did\%20not\%20say", @"The parameter pair was incorrectly encoded as: %@", [param URLEncodedNameValuePair]);
}

@end
