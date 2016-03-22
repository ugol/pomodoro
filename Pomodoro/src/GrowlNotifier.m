// Pomodoro Desktop - Copyright (c) 2009-2011, Ugo Landini (ugol@computer.org)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
// * Neither the name of the <organization> nor the
// names of its contributors may be used to endorse or promote products
// derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY COPYRIGHT HOLDERS ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <copyright holder> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "GrowlNotifier.h"

@implementation GrowlNotifier

- (id) init { 
    if ( (self = [super init]) ) {
        [GrowlApplicationBridge setGrowlDelegate:self];
    }
    return self;
}



- (NSDictionary *) registrationDictionaryForGrowl {
    NSArray *array = [NSArray arrayWithObjects:@"pomodoro", nil]; 
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:1],
                          @"TicketVersion",
                          array, 
                          @"AllNotifications",
                          array,
                          @"DefaultNotifications",
                          nil];
    return dict;
}


-(void) growlAlert:(NSString *)message title:(NSString *)title{
    [self growlAlert:message title:title sticky:NO]; 
}

-(void) growlAlert:(NSString *)message title:(NSString *)title sticky:(BOOL)st{
    [GrowlApplicationBridge notifyWithTitle:title 
								description:message 
						   notificationName:@"pomodoro"
								   iconData:nil
								   priority:0 
								   isSticky:st 
							   clickContext:nil]; 
}

-(BOOL) isGrowlInstalled {
    return [GrowlApplicationBridge isGrowlInstalled];
}

-(BOOL) isGrowlRunning {
    return [GrowlApplicationBridge isGrowlRunning];
}

@end
