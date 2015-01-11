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

#import "CalendarHelper.h"
static EKEventStore *eventStore = nil;

@implementation CalendarHelper

+ (void) publishEvent: (NSString*)selectedCalendar withTitle:(NSString*)title duration:(int)duration {
    EKEventStore *eventStore = nil;
    if ([EKEventStore respondsToSelector:@selector(authorizationStatusForEntityType:)]) {
        // 10.9 style
        eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             // your completion
             NSLog(@"----");
         }];
    } else {
        // 10.8 style
        eventStore = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskEvent ];
    }
    
    //if (eventStore == nil) {
    //    eventStore = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityTypeEvent];
    //}
    
    
    NSArray* cals = [eventStore calendarsForEntityType:EKEntityTypeEvent            ];
    NSLog(@"1st time calendars %@", cals);
        
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        
    switch (status){
        // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized:{
            NSLog(@"permission was already granted before");
            cals = [eventStore calendarsForEntityType:EKEntityTypeEvent];
            break;
        }
        case EKAuthorizationStatusNotDetermined:{
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
             {
                if (granted){
                    NSLog(@"granted after user confirmation");
                         dispatch_sync(dispatch_get_main_queue(), ^{
                             [eventStore reset];
                             // refetch calendars
                             NSArray* cals = [eventStore calendarsForEntityType:EKEntityTypeEvent];
                             NSLog(@"calendars %@", cals);
                         });
                } else {
                    //show alert
                    /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                    [alert show];*/
                }
            }];
        }
            break;
        case EKAuthorizationStatusDenied:
            case EKAuthorizationStatusRestricted:{
                //show alert
                /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];*/
            }
                break;
        default:
            break;
        }
        
        
    //find choosen calendar
	EKCalendar *calendar;
	for (calendar in cals){
		if ([[calendar title] isEqual:selectedCalendar])
            break;
		calendar = NULL;
	}
    //if the calendar is not found
    //create a new calendar with selected name
	if (calendar == NULL){
		calendar = [EKCalendar calendarForEntityType:EKEntityMaskEvent eventStore:eventStore];
		[calendar setTitle:selectedCalendar];
	}
        
        NSLog(@"new created calendar %@", calendar);
    //create event with title and duration
	EKEvent *evt = [EKEvent eventWithEventStore:eventStore];
    [evt setCalendar:calendar];
	evt.title = title;
	evt.startDate = [[NSDate date] dateByAddingTimeInterval:(-60 * duration)];
	evt.endDate = [NSDate date];
	
    NSError *calError;
	//add the calendar to the calendars store and catch error if occur
	if ([eventStore saveCalendar:calendar commit:YES error:&calError] == NO) {
		//[[NSAlert alertWithError:calError] runModal];
		NSLog(@"Calendar error: %@", calError);
	}
    //add the event to the calendar and catch and show error if occur
	if ([eventStore saveEvent:evt span:EKSpanThisEvent commit:YES error:&calError] == NO) {
		//[[NSAlert alertWithError:calError] runModal];
		NSLog(@"Calendar event error: %@", calError);

    }
    
}
@end

