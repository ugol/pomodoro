//
//  OADataFetcherTest.m
//  OAuthConsumer
//
//  Created by Jon Crosby on 11/6/07.
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


#import "OADataFetcherTest.h"


@implementation OADataFetcherTest

- (void)setUp {
    NSString *currentDir = [[NSFileManager defaultManager] currentDirectoryPath];
    NSString *serverPath = [currentDir stringByAppendingPathComponent:@"OATestServer.rb"];
    
    server = [[NSTask alloc] init];
    [server setArguments:[NSArray arrayWithObject:serverPath]];
    [server setLaunchPath:@"/usr/bin/ruby"];
    [server launch];
    sleep(2); // let the server get ready to respond
}

- (void)tearDown {
    [server terminate];
}

- (void)testFetchDataWithRequest {
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"dpf43f3p2l4k3l03"
                                                    secret:@"kd94hf93k423kf44"];
    NSURL *url = [NSURL URLWithString:@"http://localhost:4567/request_token"];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:NULL
                                                                      realm:NULL
                                                          signatureProvider:[[OAPlaintextSignatureProvider alloc] init]];
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request 
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:finishedWithData:)
                  didFailSelector:@selector(requestTokenTicket:failedWithError:)];
}
     
- (void)requestTokenTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data {
    STAssertTrue(ticket.didSucceed, NULL);
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    STAssertEqualObjects(token.key, @"nnch734d00sl2jdk", NULL);
    STAssertEqualObjects(token.secret, @"pfkkdhi9sl3r4s00", NULL);
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket failedWithError:(NSError *)error {
    STAssertFalse(ticket.didSucceed, NULL);
}

@end
