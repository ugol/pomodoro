//
//  CalendarController.m
//  Pomodoro
//
//  Created by Ugo Landini on 3/17/11.
//  Copyright 2011 iUgol. All rights reserved.
//

#import "CalendarController.h"
#import "CalendarStore/CalendarStore.h"
#import "CalendarHelper.h"
#import "PomoNotifications.h"

@implementation CalendarController

- (id)init
{
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pomodoroFinished:) 
                                                     name:_PMPomoFinished
                                                   object:nil];
    }
    
    return self;
}


- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    
	if ([notification object] == calendarsCombo){
		[[NSUserDefaults standardUserDefaults] setObject:[calendarsCombo objectValueOfSelectedItem] forKey:@"selectedCalendar"];
	}
    
}

- (void)initCalendars {
    
    for (CalCalendar *cal in [[CalCalendarStore defaultCalendarStore] calendars]){
        [calendarsCombo addItemWithObjectValue:[cal title]];
        if ([[cal title] isEqual:_selectedCalendar]){
            [calendarsCombo selectItemWithObjectValue:[cal title]];
        }
    }
    
}

- (void) pomodoroFinished:(NSNotification*) notification {
    
	if ([self checkDefault:@"calendarEnabled"]) {
		[CalendarHelper publishEvent:_selectedCalendar withTitle:[self bindCommonVariables:@"calendarEnd"] duration:_initialTime];
	}

}

- (void)dealloc {
    [super dealloc];
}

@end
