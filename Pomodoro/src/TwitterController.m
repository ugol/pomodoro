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

#import "TwitterController.h"
#import "TwitterSecrets.h"
#import "MGTwitterEngine.h"
#import "PomoNotifications.h"

@implementation TwitterController

@synthesize prefs, twitterStatus, twitterProgress;

#pragma mark ---- MGTwitterEngineDelegate methods ----

- (void) accessTokenReceived:(OAToken *)token forRequest:(NSString *)connectionIdentifier {
	NSLog(@"Token received %@ at (%@)", token, connectionIdentifier);	
	[twitterEngine setAccessToken:token];
	[twitterStatus setImage:greenButtonImage];
	[twitterProgress stopAnimation:self];
}

- (void)requestSucceeded:(NSString *)requestIdentifier {
    NSLog(@"Request succeeded (%@)", requestIdentifier);	
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error {
    NSLog(@"Twitter request failed! (%@) Error: %@ (%@)", 
          requestIdentifier, 
          [error localizedDescription], 
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
	[twitterStatus setImage:redButtonImage];
	[twitterProgress stopAnimation:self];
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier {}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier {}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier {}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)identifier {}

- (void)imageReceived:(NSImage *)image forRequest:(NSString *)identifier {}

- (void) tryConnectionToTwitter {
	if ([self checkDefault:@"enableTwitter"]) {
		NSLog(@"Setting twitter account");
		[twitterEngine getXAuthAccessTokenForUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUser"] 
											 password:[[NSUserDefaults standardUserDefaults] objectForKey:@"twitterPwd"]];
	}
}

-(IBAction) connectToTwitter: (id) sender {
	
	if (![prefs makeFirstResponder:prefs]) {
		[prefs endEditingFor:nil];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[self tryConnectionToTwitter];	
	[twitterEngine testService];
	[twitterStatus setImage:nil];
	[twitterProgress startAnimation:self];
}

#pragma mark ---- Pomodoro notifications methods ----


-(void) pomodoroStarted:(NSNotification*) notification {	
    if ([self checkDefault:@"enableTwitter"] && [self checkDefault:@"twitterAtStartEnabled"]) {
		[twitterEngine sendUpdate:[self bindCommonVariables:@"twitterStart"]];
	}
}

-(void) pomodoroFinished:(NSNotification*) notification {
    if ([self checkDefault:@"enableTwitter"] && [self checkDefault:@"twitterAtEndEnabled"]) {
		[twitterEngine sendUpdate:[self bindCommonVariables:@"twitterEnd"]];
	}
}

-(void) pomodoroReset:(NSNotification*) notification {
    if ([self checkDefault:@"enableTwitter"] && [self checkDefault:@"twitterAtResetEnabled"]) {
		[twitterEngine sendUpdate:[self bindCommonVariables:@"twitterReset"]];
	}
}

-(void) breakFinished:(NSNotification*) notification {
    if ([self checkDefault:@"enableTwitter"] && [self checkDefault:@"twitterAtBreakFinishedEnabled"]) {
		[twitterEngine sendUpdate:[self bindCommonVariables:@"twitterBreakFinished"]];
	}
}

#pragma mark ---- Lifecycle methods ----

- (void)awakeFromNib {
    
    redButtonImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red" ofType:@"png"]];
    greenButtonImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green" ofType:@"png"]];
    yellowButtonImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yellow" ofType:@"png"]];
    
    [self registerForPomodoro:_PMPomoStarted method:@selector(pomodoroStarted:)];
    [self registerForPomodoro:_PMPomoFinished method:@selector(pomodoroFinished:)];
    [self registerForPomodoro:_PMPomoReset method:@selector(pomodoroReset:)];
    [self registerForPomodoro:_PMPomoBreakFinished method:@selector(breakFinished:)];
    
    twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
    [twitterEngine setConsumerKey:_consumerkey secret:_secretkey];	
    [self tryConnectionToTwitter];
    
}



@end
