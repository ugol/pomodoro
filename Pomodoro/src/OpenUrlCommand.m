#import "OpenUrlCommand.h"

@implementation OpenUrlCommand

- (id)performDefaultImplementation
{
    NSURL *url = [NSURL URLWithString:[self directParameter]];
    if (!url) return @"A parameter is required, e.g. pomodoro://start";

    //accept any capitalization
    NSString *command = [[url host] capitalizedString];
    
    //Special case for CamelCase commands (if there were more than say, two, we'd consider doing this more intelligently.
    if ([command isEqualToString:@"Externalinterrupt"]) command = @"ExternalInterrupt";
    if ([command isEqualToString:@"Internalinterrupt"]) command = @"InternalInterrupt";
    //Disallow this possible loop.
    if ([command isEqualToString:@"Openurl"]) command = nil;
    
    //TODO pass along arguments from query.
    
    Class CommandClass = NSClassFromString([NSString stringWithFormat:@"%@Command", command]);
    if (CommandClass && [CommandClass isSubclassOfClass:[NSScriptCommand class]])
    {
        return [[[CommandClass alloc] init] performDefaultImplementation];
    }
    
    return [NSString stringWithFormat:@"Didn't understand the command '%@'", [url host]];
}

@end
