#import "TestTreeIterator.h"

NSArray *tokens = [NSArray arrayWithObjects:@"<invalid>", @"<EOR>", @"<DOWN>", @"<UP>", @"A", @"B", @"C", @"D", @"E", @"F", @"G", nil];

@implementation TestTreeIterator

- (void) testNode
{
  TreeAdaptor * adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"A"];
  TreeIterator * it = [[[TreeIterator alloc] init:t] autorelease];
  StringBuffer * buf = [self description:it];
  NSString * expecting = @"A EOF";
  NSString * found = [buf description];
  [self assertEquals:expecting param1:found];
}

- (void) testFlatAB
{
  TreeAdaptor * adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(nil A B)"];
  TreeIterator * it = [[[TreeIterator alloc] init:t] autorelease];
  StringBuffer * buf = [self description:it];
  NSString * expecting = @"nil DOWN A B UP EOF";
  NSString * found = [buf description];
  [self assertEquals:expecting param1:found];
}

- (void) testAB
{
  TreeAdaptor * adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B)"];
  TreeIterator * it = [[[TreeIterator alloc] init:t] autorelease];
  StringBuffer * buf = [self description:it];
  NSString * expecting = @"A DOWN B UP EOF";
  NSString * found = [buf description];
  [self assertEquals:expecting param1:found];
}

- (void) testABC
{
  TreeAdaptor * adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C)"];
  TreeIterator * it = [[[TreeIterator alloc] init:t] autorelease];
  StringBuffer * buf = [self description:it];
  NSString * expecting = @"A DOWN B C UP EOF";
  NSString * found = [buf description];
  [self assertEquals:expecting param1:found];
}

- (void) testVerticalList
{
  TreeAdaptor * adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A (B C))"];
  TreeIterator * it = [[[TreeIterator alloc] init:t] autorelease];
  StringBuffer * buf = [self description:it];
  NSString * expecting = @"A DOWN B DOWN C UP UP EOF";
  NSString * found = [buf description];
  [self assertEquals:expecting param1:found];
}

- (void) testComplex
{
  TreeAdaptor * adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A (B (C D E) F) G)"];
  TreeIterator * it = [[[TreeIterator alloc] init:t] autorelease];
  StringBuffer * buf = [self description:it];
  NSString * expecting = @"A DOWN B DOWN C DOWN D E UP F UP G UP EOF";
  NSString * found = [buf description];
  [self assertEquals:expecting param1:found];
}

- (void) testReset
{
  TreeAdaptor * adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A (B (C D E) F) G)"];
  TreeIterator * it = [[[TreeIterator alloc] init:t] autorelease];
  StringBuffer * buf = [self description:it];
  NSString * expecting = @"A DOWN B DOWN C DOWN D E UP F UP G UP EOF";
  NSString * found = [buf description];
  [self assertEquals:expecting param1:found];
  [it reset];
  buf = [self description:it];
  expecting = @"A DOWN B DOWN C DOWN D E UP F UP G UP EOF";
  found = [buf description];
  [self assertEquals:expecting param1:found];
}

+ (StringBuffer *) description:(TreeIterator *)it
{
  StringBuffer * buf = [[[StringBuffer alloc] init] autorelease];

  while ([it hasNext]) {
    CommonTree * n = (CommonTree *)[it next];
    [buf append:n];
    if ([it hasNext])
      [buf append:@" "];
  }

  return buf;
}

@end
