//
//  OATokenTest.m
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


#import "OATokenTest.h"
#import "NSString+URLEncoding.h"

@implementation OATokenTest

- (void)setUp {
    key = @"123456";
    secret = @"abcdef";
    appName = @"OAuth Framework Test";
    serviceProviderName = @"OAuth Service Provider";
    token = [[OAToken alloc] initWithKey:key secret:secret];
}

- (void)testInitWithKey {
	STAssertEquals(token.key, @"123456", @"Token key was incorrectly set to: %@", token.key);
	STAssertEquals(token.secret, @"abcdef", @"Token secret was incorrectly set to: %@", token.secret);
}

- (void)testInitWithHTTPResponseBody {
    OAToken *aToken = [[OAToken alloc] initWithHTTPResponseBody:[NSString stringWithFormat:@"oauth_token=%@&oauth_token_secret=%@", key, secret]];
    STAssertEqualObjects(aToken.key, key, @"Token key was incorrectly set to :%@", aToken.key);
    STAssertEqualObjects(aToken.secret, secret, @"Token secret was incorrect set to %@", aToken.secret);
	[aToken release];
	
	NSString *yahooishKey = @"%A=123h%798sdfnF";
	NSString *yahooishSecret = @"%A=234298273985";
	aToken = [[OAToken alloc] initWithHTTPResponseBody:[NSString stringWithFormat:@"oauth_token=%@&oauth_token_secret=%@",
														[yahooishKey URLEncodedString], [yahooishSecret URLEncodedString]]];
	STAssertEqualObjects(aToken.key, yahooishKey, @"Yahoo like  token key was incorrectly set to %@", aToken.key);
	STAssertEqualObjects(aToken.secret, yahooishSecret, @"Yahoo like token secret was incorrectly set to %@", aToken.secret);
	[aToken release];
}

- (void)testStoreInDefaultKeychainWithAppName {
    int status = [token storeInDefaultKeychainWithAppName:appName serviceProviderName:serviceProviderName];
    STAssertEquals(status, 0, @"Keychain insert failed with error status: %d", status);
    [self removeTestKeychainItem];
}

- (void)testInitWithKeychainUsingAppName {
    int status = [token storeInDefaultKeychainWithAppName:appName serviceProviderName:serviceProviderName];
	STAssertEquals(status, 0, @"Keychain insert failed with error status: %d", status);
    OAToken *aToken = [[OAToken alloc] initWithKeychainUsingAppName:appName serviceProviderName:serviceProviderName];
    STAssertEqualObjects(aToken.key, @"123456", @"Token key was incorrectly populated as: %@", aToken.key);
	STAssertEqualObjects(aToken.secret, @"abcdef", @"Token secret was incorrectly populated as: %@", aToken.secret);
    [self removeTestKeychainItem];
}

- (void)removeTestKeychainItem {
	SecKeychainItemRef item;
	NSString *serviceName = [NSString stringWithFormat:@"%@::OAuth::%@", appName, serviceProviderName];
	int status = SecKeychainFindGenericPassword(NULL,
                                                [serviceName length],
                                                [serviceName UTF8String],
                                                [token.key length],
                                                [token.key UTF8String],
                                                NULL,
                                                NULL,
                                                &item);
	STAssertEquals(status, 0, @"Keychain lookup failed with status: %d", status);
	
	if (status == 0) {
		SecKeychainItemDelete(item);
        NSMakeCollectable(item);
	}
    
}

@end
