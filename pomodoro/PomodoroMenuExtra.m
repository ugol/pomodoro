//
//  PomodoroMenuExtra.m
//  pomodoro
//
//  Created by Ugo Landini on 06/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PomodoroMenuExtra.h"
#import "PomodoroMenuExtraView.h"

@implementation PomodoroMenuExtra

- (id)initWithBundle:(NSBundle *)bundle {
    self = [super initWithBundle:bundle];
    if( self == nil )
        return nil;
	
    // we will create and set the MenuExtraView
    theView = [[PomodoroMenuExtraView alloc] initWithFrame:
			   [[self view] frame] menuExtra:self];
    [self setView:theView];
    
    // prepare "dummy" menu, without any actions
    theMenu = [[NSMenu alloc] initWithTitle: @"Ciao"];
    [theMenu setAutoenablesItems: NO];
    [theMenu addItemWithTitle: @"1" action: nil keyEquivalent: @""];
    [theMenu addItemWithTitle: @"2" action: nil keyEquivalent: @""];
    [theMenu addItemWithTitle: @"3" action: nil keyEquivalent: @""];
	
    return self;
}

- (void)dealloc {
    [theMenu release];
    [theView release];
    [super dealloc];
}

- (NSMenu *)menu {
    return theMenu;
}

@end
