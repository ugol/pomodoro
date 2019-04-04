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

#import "AboutController.h"


@implementation AboutController

@synthesize aboutText, appversion;

- (id) init {
		
	if (![super initWithWindowNibName:@"About"]) return nil;
	return self;
}

-(id)infoValueForKey:(NSString*)key
{ 
    if ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key])
        return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}


- (void)awakeFromNib {
    
	NSBundle *bundle = [NSBundle mainBundle];

    NSError *error = nil;
    NSString *aboutString = [[NSString alloc] initWithContentsOfFile:[bundle pathForResource:@"about" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    
	NSAttributedString* aboutHtml = [[NSAttributedString alloc] initWithHTML:[aboutString dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
	[aboutText setLinkTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
									  [NSColor whiteColor], NSForegroundColorAttributeName,nil]];
	[aboutText insertText:aboutHtml];
	[aboutText setEditable:NO];
    
	[self switchBetweenReleaseAndBuild:nil];
}

-(IBAction) switchBetweenReleaseAndBuild: (id) sender {
    
    showRelease = !showRelease;
    NSString* text;
    if (showRelease) {
        text = [NSString stringWithFormat:NSLocalizedString(@"Release", @"Release Number"), [self infoValueForKey:@"CFBundleVersion"]];
    } else {
        text = [NSString stringWithFormat:NSLocalizedString(@"Build", @"Build Number"), [[self infoValueForKey:@"CFBuildNumber"] intValue]];
    }
    [appversion setStringValue:text];

}



@end
