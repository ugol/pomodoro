//
//  OAHMAC_SHA1SignatureProviderTest.m
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


#import "OAHMAC_SHA1SignatureProviderTest.h"


@implementation OAHMAC_SHA1SignatureProviderTest

- (void)testSignClearText {
    OAHMAC_SHA1SignatureProvider *provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    STAssertEqualObjects([provider signClearText:@"simon says" withSecret:@"abcedfg123456789"],
                         @"vyeIZc3+tF6F3i95IEV+AJCWBYQ=",
                         NULL);
    STAssertEqualObjects([provider signClearText:@"GET&http%3A%2F%2Fphotos.example.net%2Fphotos&file%3Dvacation.jpg%26oauth_consumer_key%3Ddpf43f3p2l4k3l03%26oauth_nonce%3Dkllo9940pd9333jh%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1191242096%26oauth_token%3Dnnch734d00sl2jdk%26oauth_version%3D1.0%26size%3Doriginal&kd94hf93k423kf44&pfkkdhi9sl3r4s00"
                                      withSecret:@"kd94hf93k423kf44&pfkkdhi9sl3r4s00"],
                         @"Gcg/323lvAsQ707p+y41y14qWfY=",
                         NULL);
}

@end
