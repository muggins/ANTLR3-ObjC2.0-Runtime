#import "ErrorQueue.h"

@implementation ErrorQueue

- (void) init {
  if (self = [super init]) {
    infos = [[[NSMutableArray alloc] init] autorelease];
    errors = [[[NSMutableArray alloc] init] autorelease];
    warnings = [[[NSMutableArray alloc] init] autorelease];
  }
  return self;
}

- (void) info:(NSString *)msg {
  [infos addObject:msg];
}

- (void) error:(Message *)msg {
  [errors addObject:msg];
}

- (void) warning:(Message *)msg {
  [warnings addObject:msg];
}

- (void) error:(ToolMessage *)msg {
  [errors addObject:msg];
}

- (int) size {
  return [infos count] + [errors count] + [warnings count];
}

- (NSString *) description {
  return [[[@"infos: " stringByAppendingString:infos] stringByAppendingString:@"errors: "] + errors stringByAppendingString:@"warnings: "] + warnings;
}

- (void) dealloc {
  [infos release];
  [errors release];
  [warnings release];
  [super dealloc];
}

@end
