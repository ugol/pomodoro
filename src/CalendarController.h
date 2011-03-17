//
//  CalendarController.h
//  Pomodoro
//
//  Created by Ugo Landini on 3/17/11.
//  Copyright 2011 iUgol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonController.h"

#define _selectedCalendar [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedCalendar"]
#define _initialTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"initialTime"] intValue]

@interface CalendarController : CommonController {

    IBOutlet NSComboBox* calendarsCombo;
    
}

- (void)initCalendars;

@end
