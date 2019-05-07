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

#import "StatsController.h"

@implementation StatsController

@synthesize pomos;

#pragma mark ---- Helper methods ----

- (void) saveState {
	NSError *error;
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext commitEditing]) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                NSLog(@"Save failed.");
            }
        }
    }

}	

#pragma mark ---- Window delegate methods ----


- (void)windowDidResignKey:(NSNotification *)notification {
    
    // Commit Editing still in place when closing a panel or losing focus
    
    [self saveState];
    [notification.object makeFirstResponder:nil];
    
}

#pragma mark ---- Core Data support methods ----


- (NSString *)applicationSupportFolder {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"Pomodoro"];
}

- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.  This 
 implementation will create and return a coordinator, having added the 
 store for the application to it.  (The folder for the store is created, 
 if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSFileManager *fileManager;
    NSString *applicationSupportFolder = nil;
    NSURL *url;
    NSError *error = nil;
    
    fileManager = [NSFileManager defaultManager];
    applicationSupportFolder = [self applicationSupportFolder];

    if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
		
		if (! [fileManager createDirectoryAtPath:applicationSupportFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
			[[NSApplication sharedApplication] presentError:error];
		}
		
    }
	
	//[fileManager createFileAtPath:[applicationSupportFolder stringByAppendingPathComponent:@"Pomodoros.txt"] contents:nil attributes:nil];
    url = [NSURL fileURLWithPath: [applicationSupportFolder stringByAppendingPathComponent: @"Pomodoro.sql"]];
   
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error]){
        [[NSApplication sharedApplication] presentError:error];
    }   
	
    return persistentStoreCoordinator;
}


/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.) 
 */

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

/*
#pragma mark ---- Voice combo box delegate/datasource methods ----

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    //return [pomodoros count];
	return 0;
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
			row:(int)row
{
    //return [pomodoros objectAtIndex:row];
	return nil;
}
*/

#pragma mark ---- Business methods ----

- (IBAction) resetGlobalStatistics:(id)sender {
	
	[[NSUserDefaults standardUserDefaults] setObject: [NSDate date] forKey:@"globalStartDate"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"globalPomodoroStarted"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"globalInternalInterruptions"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"globalExternalInterruptions"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"globalPomodoroResumed"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"globalPomodoroReset"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"globalPomodoroDone"];
	
}

- (IBAction) resetDailyStatistics:(id)sender {
	
	[[NSUserDefaults standardUserDefaults] setObject: [NSDate date] forKey:@"dailyStartDate"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"dailyPomodoroStarted"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"dailyInternalInterruptions"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"dailyExternalInterruptions"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"dailyPomodoroResumed"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"dailyPomodoroReset"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:0] forKey:@"dailyPomodoroDone"];
	
}

- (void) writeFullExport: (NSFileHandle *) output results: (NSArray *) results  {
    
    NSString* header = [NSString stringWithFormat:NSLocalizedString(@"Export data created by Pomodoro on %@\n",@"Export Header"), [NSDate date]];
    [output writeData:[header dataUsingEncoding:NSUTF8StringEncoding]];
    [output writeData:[NSLocalizedString(@"\nDescription, When, Duration, externalInterruptions, internalInterruptions\n\n",@"Export Table Header") dataUsingEncoding:NSUTF8StringEncoding]];
    for (NSManagedObject* pomo in results) {
        NSString* line = [NSString stringWithFormat:@"%@, %@, %@, %@, %@\n", [pomo valueForKey:@"name"], [pomo valueForKey:@"when"], [pomo valueForKey:@"durationMinutes"], [pomo valueForKey:@"externalInterruptions"], [pomo valueForKey:@"internalInterruptions"]];
        [output writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];							  
    }

}

- (void) writeLightExport: (NSFileHandle *) output results: (NSArray *) results  {
    
}


- (IBAction) exportToText:(id)sender {
	
	NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:@"Timers.txt"];
    
	//[sp setAllowedFileTypes:[NSArray arrayWithObjects:@"txt", nil]];
    
    NSInteger result = [panel runModal];
    
    if(result == NSFileHandlingPanelOKButton){
        NSURL*  theFile = [panel URL];
        [[NSFileManager defaultManager] createFileAtPath:[theFile path] contents:nil attributes:nil];
        NSFileHandle* output = [NSFileHandle fileHandleForWritingAtPath:[theFile path]];
        [output seekToEndOfFile];
            
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Pomodoros" inManagedObjectContext:managedObjectContext]];
        NSError* error;
        NSArray* results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Error %@", [error localizedDescription]);
        } else {
            [self writeFullExport: output results: results];
        }
        [output synchronizeFile];
        [output closeFile];
            
    }
}

#pragma mark ---- Daily check methods ----

- (void) updateGlobalDateIfNil {
	
	NSDate* savedGlobalDate = _globalStartDate;
	if (savedGlobalDate == nil) {
		[[NSUserDefaults standardUserDefaults] setObject: [NSDate date] forKey:@"globalStartDate"];
	}
	
}

- (void) updateDateIfChanged {
	
	
	NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDate* today = [NSDate date];
	if (_dailyStartDate == nil) {
		[[NSUserDefaults standardUserDefaults] setObject: today forKey:@"dailyStartDate"];
	} else {
		
		NSDateComponents* nowDay = [cal components:NSCalendarUnitDay fromDate:today];
		NSDateComponents* savedDay = [cal components:NSCalendarUnitDay fromDate:_dailyStartDate];
		
		if ( ([nowDay day] != [savedDay day]) || ([nowDay month] != [savedDay month]) || ([nowDay year] != [savedDay year]) ) {
			[self resetDailyStatistics:nil];
		}
		
	}
	
}


-(void) checkDate:(NSTimer *)aTimer  {
	[self updateDateIfChanged];
}

#pragma mark ---- Lifecycle methods ----

- (id) init {
	
	if (![super initWithWindowNibName:@"Stats"]) return nil;
	return self;
}

- (void)awakeFromNib {
	
	NSTimer* dailyChecker = [NSTimer timerWithTimeInterval:10
												target:self
											  selector:@selector(checkDate:)													 
											  userInfo:nil
											   repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:dailyChecker forMode:NSRunLoopCommonModes];
	
	[self updateGlobalDateIfNil];
	[self updateDateIfChanged];

	NSSortDescriptor* sort = [[NSSortDescriptor alloc] 
							  initWithKey:@"when" ascending:NO];
	[pomos setSortDescriptors:
	 [NSArray arrayWithObject: sort]];
		
}

@end
