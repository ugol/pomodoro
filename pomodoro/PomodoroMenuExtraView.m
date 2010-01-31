//
//  PomodoroMenuExtraView.m
//  pomodoro
//
//  Created by Ugo Landini on 06/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PomodoroMenuExtraView.h"


@implementation PomodoroMenuExtraView

- (void)drawRect:(NSRect)rect {
    [[NSColor purpleColor] set];
    NSRect smallerRect = NSInsetRect( rect, 4.0, 4.0 );
    [[NSBezierPath bezierPathWithOvalInRect: smallerRect] fill];
}

@end

