//
//  OAMutableURLRequestTest.m
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


#import "OAMutableURLRequestTest.h"

// supress warnings for private methods
@interface OAMutableURLRequest (Private)
- (NSString *)_signatureBaseString;
- (void)_generateNonce;
@end

@implementation OAMutableURLRequestTest

- (void)setUp {
    consumer = [[OAConsumer alloc] initWithKey:@"dpf43f3p2l4k3l03"
                                        secret:@"kd94hf93k423kf44"];
    token = [[OAToken alloc] initWithKey:@"nnch734d00sl2jdk"
                                  secret:@"pfkkdhi9sl3r4s00"];
    plaintextProvider = [[OAPlaintextSignatureProvider alloc] init];
    hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    
    // From OAuth Spec, Appendix A.2 "Obtaining a Request Token
    plaintextRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://photos.example.net/request_token"]
                                                                            consumer:consumer
                                                                               token:NULL
                                                                               realm:NULL
                                                                   signatureProvider:plaintextProvider
                                                                               nonce:@"hsu94j3884jdopsl"
                                                                           timestamp:@"1191242090"];
    [plaintextRequest setHTTPMethod:@"POST"];    
                        
    // From OAuth Spec, Appendix A.5.3 "Requesting Protected Resource"
    hmacSha1Request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://photos.example.net/photos"]
                                                      consumer:consumer
                                                         token:token
                                                         realm:NULL
                                             signatureProvider:hmacSha1Provider
                                                         nonce:@"kllo9940pd9333jh"
                                                     timestamp:@"1191242096"];
    [hmacSha1Request setParameters:[NSArray arrayWithObjects:[[OARequestParameter alloc] initWithName:@"file" value:@"vacation.jpg"],
                                   [[OARequestParameter alloc] initWithName:@"size" value:@"original"], nil]];
    
}

- (void)testGenerateNonce {
    // Check for duplicates over 100,000 requests
    NSUInteger nonceTolerance = 100000;
    NSMutableDictionary *hash = [[NSMutableDictionary alloc] initWithCapacity:nonceTolerance];
    int i;
    for (i = 0; i < nonceTolerance; i++) {
        [plaintextRequest _generateNonce];
        NSString *nonce = [plaintextRequest nonce];
        [hash setObject:@"" forKey:nonce];
    }
    
    STAssertEquals(nonceTolerance, [hash count], @"Nonce collision with %d requests", nonceTolerance);
}

- (void)testSignatureBaseString {
    // From OAuth Spec, Appendix A.5.1
    STAssertEqualObjects([hmacSha1Request _signatureBaseString],
                         @"GET&http%3A%2F%2Fphotos.example.net%2Fphotos&file%3Dvacation.jpg%26oauth_consumer_key%3Ddpf43f3p2l4k3l03%26oauth_nonce%3Dkllo9940pd9333jh%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1191242096%26oauth_token%3Dnnch734d00sl2jdk%26oauth_version%3D1.0%26size%3Doriginal",
                         @"Signature Base String does not match OAuth Spec, Appendix A.5.1");
}

- (void)testSignature {
    // From OAuth Spec, Appendix A.2 "Obtaining a Request Token"
    [plaintextRequest prepare];
    STAssertEqualObjects(plaintextRequest.signature, @"kd94hf93k423kf44&", @"Plaintext request signature does not match OAuth Spec, Appendix A.2");
    
    // From OAuth Spec, Appendix A.5.3 "Requesting Protected Resource"
    [hmacSha1Request prepare];
    STAssertEqualObjects(hmacSha1Request.signature, @"tR3+Ty81lMeYAr/Fid0kMTYa/WM=", @"HMAC-SHA1 request signature does not match OAuth Spec, Appendix A.5.3");
}

- (void)testOptionalOAuthParameters {
	// Optional OAuth parameters that should appear in the HTTP Authorization header.
	[plaintextRequest setOAuthParameterName:@"oauth_callback" withValue:@"myurlhandler:oauth"];
	[plaintextRequest setOAuthParameterName:@"oauth_verifier" withValue:@"abc123"];
	
	[plaintextRequest prepare];
	
	STAssertEqualObjects([plaintextRequest valueForHTTPHeaderField:@"Authorization"],
						 @"OAuth realm=\"\", oauth_consumer_key=\"dpf43f3p2l4k3l03\", oauth_signature_method=\"PLAINTEXT\", oauth_signature=\"kd94hf93k423kf44%26\", oauth_timestamp=\"1191242090\", oauth_nonce=\"hsu94j3884jdopsl\", oauth_version=\"1.0\", oauth_callback=\"myurlhandler%3Aoauth\", oauth_verifier=\"abc123\"",
						 @"Authorization header doesn't match expected value.");
}

@end
