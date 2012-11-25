#import "BrowsingNannyController.h"
#import "PomoNotifications.h"
#import "PomodoroController.h"
#import "Scripter.h"

static NSString * const DefaultsKeyEnabled = @"browsingNannyEnabled";
static NSString * const DefaultsKeyUrls = @"browsingNannyUrls";
static NSString * const DefaultsKeySafari = @"browsingNannySafari";
static NSString * const ScriptGetUrlsSafari = @"getActiveUrlsFromSafari";
static NSString * const DefaultsKeyChrome = @"browsingNannyChrome";
static NSString * const ScriptGetUrlsChrome = @"getActiveUrlsFromChrome";

@interface BrowsingNannyController()
- (IBAction)removeUrlClicked:(id)sender;
- (IBAction)addUrlClicked:(id)sender;
- (NSDictionary *)urlPatternObjectWithPattern:(NSString *)pattern;
@end

#pragma mark -

@implementation BrowsingNannyController
@synthesize arrayController, scripter, pomodoroController, blacklistedPredicate;

- (void)awakeFromNib {
    self.blacklistedPredicate = [NSPredicate predicateWithValue:NO];
    [self registerForPomodoro:_PMPomoOncePerSecond method:@selector(oncePerSecond:)];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:DefaultsKeyUrls
                                               options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                                               context:nil];
}

- (void)dealloc {
    self.blacklistedPredicate = nil;
    self.arrayController = nil;
    self.scripter = nil;
    [super dealloc];
}

#pragma mark - Core logic

- (BOOL)enabled {
    return [self checkDefault:DefaultsKeyEnabled];
}

- (BOOL)checkBrowserUrlsWithScript:(NSString *)scriptName {
    NSAppleEventDescriptor *result = [scripter executeScript:scriptName];
    for (NSInteger i = 1; i <= [result numberOfItems]; i++) {
        NSString *urlString = [[result descriptorAtIndex:i] stringValue];
        NSLog(@"You're browsing %@", urlString);
        if ([blacklistedPredicate evaluateWithObject:urlString]) {
            NSLog(@"The url %@ is blacklisted. Marking it an interruption!", urlString);
            [pomodoroController internalInterrupt:self];
            //One interruption is enough, don't need to keep going
            return YES;
        }
    }
    return NO;
}

#pragma mark - Pomodoro notifications

- (void)oncePerSecond:(NSNotification*)notification {
    if (!self.enabled) return;
    NSLog(@"Tick.");
    BOOL done = NO;
    if (!done && [self checkDefault:DefaultsKeySafari]) {
        NSLog(@"Checking your browsing in Safari");
        done = [self checkBrowserUrlsWithScript:ScriptGetUrlsSafari];
    }
    if (!done && [self checkDefault:DefaultsKeyChrome]) {
        NSLog(@"Checking your browsing in Chrome");
        done = [self checkBrowserUrlsWithScript:ScriptGetUrlsChrome];
    }
}

#pragma mark - Compile multiple rules into master predicate

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:DefaultsKeyUrls]) {
        NSArray *patternsArray = [change objectForKey:NSKeyValueChangeNewKey];
        //NSLog(@"change to urls: %@", patternsArray);
        NSPredicate *predicate = nil;
        if (![patternsArray isEqualTo:[NSNull null]] && [patternsArray count] > 0) {
            NSMutableArray *conditions = [NSMutableArray arrayWithCapacity:[patternsArray count]];
            for (NSDictionary *patternObj in patternsArray) {
                NSString *condition = [NSString stringWithFormat:@"(SELF LIKE \"%@\")",
                                       [[patternObj objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
                [conditions addObject:condition];
            }
            NSString *completePredicateString = [conditions componentsJoinedByString:@" OR "];
            @try {
                predicate = [NSPredicate predicateWithFormat:completePredicateString];
            }
            @catch (NSException *exception) {
                NSLog(@"Invalid predicate format! %@", completePredicateString);
            }
        }
        NSLog(@"Predicate: %@", predicate);
        self.blacklistedPredicate = (predicate)? predicate : [NSPredicate predicateWithValue:NO];
    }
}


#pragma mark - Preference Pane Management

- (IBAction)removeUrlClicked:(id)sender {
    if ([arrayController.selectionIndexes count] > 0) {
        [arrayController removeObjectsAtArrangedObjectIndexes:arrayController.selectionIndexes];
    }
}

- (IBAction)addUrlClicked:(id)sender {
    [arrayController addObject:[self urlPatternObjectWithPattern:nil]];
}

- (NSDictionary *)urlPatternObjectWithPattern:(NSString *)pattern {
    if (!pattern) pattern = @"http?://*.blockeddomain.com/*";
    return [NSDictionary dictionaryWithObject:pattern forKey:@"url"];
}

@end
