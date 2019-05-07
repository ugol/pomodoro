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

#import "Scripter.h"


@implementation Scripter

- (id) init { 
    return [self initWithCapacity:10];
}

- (id) initWithCapacity:(int)capacity { 
    if ( (self = [super init]) ) {
        scripts = [NSMutableDictionary dictionaryWithCapacity:capacity];
    }
    return self;
}

- (NSAppleEventDescriptor*)executeScript:(NSString*) scriptId {

	NSAppleScript* applescript = [scripts objectForKey:scriptId];
	/*if (nil == applescript) {
		NSString* scriptFileName = [[NSBundle mainBundle] pathForResource: scriptId ofType: @"applescript"];
		applescript = [[NSAppleScript alloc] initWithContentsOfURL: [NSURL fileURLWithPath: scriptFileName] error: nil];
		[applescript compileAndReturnError:nil];
		[scripts setObject:applescript forKey:scriptId];
	} 
	return [applescript executeAndReturnError:nil];*/
    return nil;
}

- (NSAppleEventDescriptor*)executeScript:(NSString *)scriptId withParameter:(NSString*)parameter {
	NSString* scriptText = [scripts objectForKey:scriptId];
	if (nil == scriptText) {
		NSString* scriptFileName = [[NSBundle mainBundle] pathForResource: scriptId ofType: @"applescript"];
        NSError *error = nil;
        NSStringEncoding encoding;
        
        scriptText = [[NSString alloc] initWithContentsOfURL:[NSURL fileURLWithPath: scriptFileName]
                                                         usedEncoding:&encoding
                               
                                                                error:&error];
		[scripts setObject:scriptText forKey:scriptId];
	}
	NSAppleScript* applescript = [[NSAppleScript alloc] initWithSource:[NSString stringWithFormat:scriptText, parameter]];
	return [applescript executeAndReturnError:nil];
}

@end
