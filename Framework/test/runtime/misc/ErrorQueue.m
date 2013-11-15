#import "ErrorQueue.h"

@implementation ErrorQueue

@synthesize infos;
@synthesize errors;
@synthesize warnings;

- (id) init
{
    self = [super init];
    if ( self != nil ) {
        infos = [AMutableArray arrayWithCapacity:5];
        errors = [AMutableArray arrayWithCapacity:5];
        warnings = [AMutableArray arrayWithCapacity:5];
    }
    return self;
}

- (void) info:(NSString *)msg
{
  [infos addObject:msg];
}

- (void) error:(id)msg
{
  [errors addObject:msg];
}

- (void) warning:(id)msg
{
  [warnings addObject:msg];
}

- (NSInteger) size
{
  return ([infos count] + [errors count] + [warnings count]);
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"infos: %@\nerrors: %@\nwarnings: %@", infos, errors, warnings];
}

- (void) dealloc
{
    infos = nil;
    errors = nil;
    warnings = nil;
    // [super dealloc];
}

@end
