#import "TestFastQueue.h"

@implementation TestFastQueue

- (void) testQueueNoRemove {
  FastQueue * q = [[[FastQueue alloc] init] autorelease];
  [q add:@"a"];
  [q add:@"b"];
  [q add:@"c"];
  [q add:@"d"];
  [q add:@"e"];
  NSString * expecting = @"a b c d e";
  NSString * found = [q description];
  [self assertEquals:expecting param1:found];
}

- (void) testQueueThenRemoveAll {
  FastQueue * q = [[[FastQueue alloc] init] autorelease];
  [q add:@"a"];
  [q add:@"b"];
  [q add:@"c"];
  [q add:@"d"];
  [q add:@"e"];
  StringBuffer * buf = [[[StringBuffer alloc] init] autorelease];

  while ([q size] > 0) {
    NSString * o = [q remove];
    [buf append:o];
    if ([q size] > 0)
      [buf append:@" "];
  }

  [self assertEquals:@"queue should be empty" param1:0 param2:[q size]];
  NSString * expecting = @"a b c d e";
  NSString * found = [buf description];
  [self assertEquals:expecting param1:found];
}

- (void) testQueueThenRemoveOneByOne {
  StringBuffer * buf = [[[StringBuffer alloc] init] autorelease];
  FastQueue * q = [[[FastQueue alloc] init] autorelease];
  [q add:@"a"];
  [buf append:[q remove]];
  [q add:@"b"];
  [buf append:[q remove]];
  [q add:@"c"];
  [buf append:[q remove]];
  [q add:@"d"];
  [buf append:[q remove]];
  [q add:@"e"];
  [buf append:[q remove]];
  [self assertEquals:@"queue should be empty" param1:0 param2:[q size]];
  NSString * expecting = @"abcde";
  NSString * found = [buf description];
  [self assertEquals:expecting param1:found];
}

- (void) testGetFromEmptyQueue {
  FastQueue * q = [[[FastQueue alloc] init] autorelease];
  NSString * msg = nil;

  @try {
    [q remove];
  }
  @catch (NoSuchElementException * nsee) {
    msg = [nsee message];
  }
  NSString * expecting = @"queue index 0 > last index -1";
  NSString * found = msg;
  [self assertEquals:expecting param1:found];
}

- (void) testGetFromEmptyQueueAfterSomeAdds {
  FastQueue * q = [[[FastQueue alloc] init] autorelease];
  [q add:@"a"];
  [q add:@"b"];
  [q remove];
  [q remove];
  NSString * msg = nil;

  @try {
    [q remove];
  }
  @catch (NoSuchElementException * nsee) {
    msg = [nsee message];
  }
  NSString * expecting = @"queue index 0 > last index -1";
  NSString * found = msg;
  [self assertEquals:expecting param1:found];
}

- (void) testGetFromEmptyQueueAfterClear {
  FastQueue * q = [[[FastQueue alloc] init] autorelease];
  [q add:@"a"];
  [q add:@"b"];
  [q clear];
  NSString * msg = nil;

  @try {
    [q remove];
  }
  @catch (NoSuchElementException * nsee) {
    msg = [nsee message];
  }
  NSString * expecting = @"queue index 0 > last index -1";
  NSString * found = msg;
  [self assertEquals:expecting param1:found];
}

@end
