#import "CommonController.h"
@class PomodoroController;
@class Scripter;

@interface BrowsingNannyController : CommonController {
    IBOutlet NSArrayController *arrayController;
    IBOutlet Scripter *scripter;
    IBOutlet PomodoroController *pomodoroController;
    NSPredicate *blacklistedPredicate;
    NSUInteger tickCount;
}

@property (readonly) BOOL enabled;
@property (retain) NSPredicate *blacklistedPredicate;
@property (assign) IBOutlet PomodoroController *pomodoroController;
@property (assign) IBOutlet NSArrayController *arrayController;
@property (assign) IBOutlet Scripter *scripter;

@end
