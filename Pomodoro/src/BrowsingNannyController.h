#import "CommonController.h"
@class PomodoroController;
@class Scripter;

@interface BrowsingNannyController : CommonController {
    IBOutlet NSArrayController *__unsafe_unretained arrayController;
    IBOutlet Scripter *__unsafe_unretained scripter;
    IBOutlet PomodoroController *__unsafe_unretained pomodoroController;
    NSPredicate *blacklistedPredicate;
    NSUInteger tickCount;
}

@property (readonly) BOOL enabled;
@property (strong) NSPredicate *blacklistedPredicate;
@property (unsafe_unretained) IBOutlet PomodoroController *pomodoroController;
@property (unsafe_unretained) IBOutlet NSArrayController *arrayController;
@property (unsafe_unretained) IBOutlet Scripter *scripter;

@end
