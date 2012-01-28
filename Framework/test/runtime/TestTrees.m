#import "TestTrees.h"

@implementation V

- (id) initWithT:(ANTLRCommonToken *)t
{
  self = [super init];
  if ( self  != nil ) {
    token = t;
  }
  return self;
}

- (id) init:(int)ttype x:(int)x
{
  self = [super init];
  if ( self  != nil ) {
    x = x;
    token = [ANTLRCommonToken newToken:ttype];
  }
  return self;
}

- (id) init:(int)ttype t:(ANTLRCommonToken *)t x:(int)x
{
  self = [super init];
  if ( self  != nil ) {
    token = t;
    x = x;
  }
  return self;
}

- (NSString *) description {
  return [(token != nil ? [token text] : @"") stringByAppendingString:@"<V>"];
}

@end

@implementation TestTrees

- (void) init
{
  self = [super init];
  if ( self != nil ) {
    adaptor = [ANTLRCommonTreeAdaptor alloc] init];
    debug = NO;
  }
  return self;
}

- (void) testSingleNode
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:101];
  [self assertNull:t.parent];
  [self assertEquals:-1 param1:t.childIndex];
}

- (void) testTwoChildrenOfNilRoot
{
  ANTLRCommonTree *root_0 = (ANTLRCommonTree *)[adaptor nil];
  ANTLRCommonTree *t = [V newToken:101 param1:2];
  ANTLRCommonTree *u = [V alloc] init:[[[ANTLRCommonToken newToken:102 text:@"102"];
  [adaptor addChild:root_0 param1:t];
  [adaptor addChild:root_0 param1:u];
  [self assertNull:root_0.parent];
  [self assertEquals:-1 param1:root_0.childIndex];
  [self assertEquals:0 param1:t.childIndex];
  [self assertEquals:1 param1:u.childIndex];
}

- (void) test4Nodes
{
  ANTLRCommonTree *r0 = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:101]];
  [r0 addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:102]]];
  [[r0 getChild:0] addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:103]]];
  [r0 addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:104]]];
  [self assertNull:r0.parent];
  [self assertEquals:-1 param1:r0.childIndex];
}

- (void) testList
{
  ANTLRCommonTree *r0 = [ANTLRCommonTree newTree:(ANTLRCommonToken *)nil];
  ANTLRCommonTree *c0, c1, c2;
  [r0 addChild:c0 = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:101]]];
  [r0 addChild:c1 = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:102]]];
  [r0 addChild:c2 = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:103]]];
  [self assertNull:r0.parent];
  [self assertEquals:-1 param1:r0.childIndex];
  [self assertEquals:r0 param1:c0.parent];
  [self assertEquals:0 param1:c0.childIndex];
  [self assertEquals:r0 param1:c1.parent];
  [self assertEquals:1 param1:c1.childIndex];
  [self assertEquals:r0 param1:c2.parent];
  [self assertEquals:2 param1:c2.childIndex];
}

- (void) testList2
{
  ANTLRCommonTree *root = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:5]];
  ANTLRCommonTree *r0 = [[ANTLRCommonTree newTree:(ANTLRCommonToken *)nil];
  ANTLRCommonTree *c0, c1, c2;
  [r0 addChild:c0 = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:101]]];
  [r0 addChild:c1 = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:102]]];
  [r0 addChild:c2 = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:103]]];
  [root addChild:r0];
  [self assertNull:root.parent];
  [self assertEquals:-1 param1:root.childIndex];
  [self assertEquals:root param1:c0.parent];
  [self assertEquals:0 param1:c0.childIndex];
  [self assertEquals:root param1:c0.parent];
  [self assertEquals:1 param1:c1.childIndex];
  [self assertEquals:root param1:c0.parent];
  [self assertEquals:2 param1:c2.childIndex];
}

- (void) testAddListToExistChildren
{
  ANTLRCommonTree *root = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:5]];
  [root addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:6]];
  ANTLRCommonTree *r0 = [ANTLRCommonTree newTree:(ANTLRCommonToken *)nil];
  ANTLRCommonTree *c0, c1, c2;
  [r0 addChild:c0 = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:101]];
  [r0 addChild:c1 = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:102]];
  [r0 addChild:c2 = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:103]];
  [root addChild:r0];
  [self assertNull:root.parent];
  [self assertEquals:-1 param1:root.childIndex];
  [self assertEquals:root param1:c0.parent];
  [self assertEquals:1 param1:c0.childIndex];
  [self assertEquals:root param1:c0.parent];
  [self assertEquals:2 param1:c1.childIndex];
  [self assertEquals:root param1:c0.parent];
  [self assertEquals:3 param1:c2.childIndex];
}

- (void) testDupTree
{
  ANTLRCommonTree *r0 = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:101]];
  ANTLRCommonTree *r1 = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:102]];
  [r0 addChild:r1];
  [r1 addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:103]]];
  Tree *r2 = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:106]];
  [r2 addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:107]]];
  [r1 addChild:r2];
  [r0 addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:104]]];
  [r0 addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:105]]];
  ANTLRCommonTree *dup = (ANTLRCommonTree *)[([[[CommonTreeAdaptor alloc] init]) dupTree:r0];
  [self assertNull:dup.parent];
  [self assertEquals:-1 param1:dup.childIndex];
  [dup sanityCheckParentAndChildIndexes];
}

- (void) testBecomeRoot
{
  ANTLRCommonTree *newRoot = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:5];
  ANTLRCommonTree *oldRoot = [[ANTLRCommonTree newTree:(ANTLRCommonToken *)nil];
  [oldRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:101]]];
  [oldRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:102]]];
  [oldRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:103]]];
  TreeAdaptor *adaptor = [[[CommonTreeAdaptor alloc] init];
  [adaptor becomeRoot:newRoot param1:oldRoot];
  [newRoot sanityCheckParentAndChildIndexes];
}

- (void) testBecomeRoot2
{
  ANTLRCommonTree *newRoot = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:5]];
  ANTLRCommonTree *oldRoot = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:101]];
  [oldRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:102]]];
  [oldRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:103]]];
  TreeAdaptor *adaptor = [[[CommonTreeAdaptor alloc] init];
  [adaptor becomeRoot:newRoot param1:oldRoot];
  [newRoot sanityCheckParentAndChildIndexes];
}

- (void) testBecomeRoot3
{
  ANTLRCommonTree *newRoot = [ANTLRCommonTree newTree:(ANTLRCommonToken *)nil];
  [newRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:5]]];
  ANTLRCommonTree *oldRoot = [[ANTLRCommonTree newTree:(ANTLRCommonToken *)nil];
  [oldRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:101]]];
  [oldRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:102]]];
  [oldRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:103]]];
  TreeAdaptor *adaptor = [[[CommonTreeAdaptor alloc] init];
  [adaptor becomeRoot:newRoot param1:oldRoot];
  [newRoot sanityCheckParentAndChildIndexes];
}

- (void) testBecomeRoot5
{
  ANTLRCommonTree *newRoot = [[ANTLRCommonTree newTree:(ANTLRCommonToken *)nil];
  [newRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:5]];
  ANTLRCommonTree *oldRoot = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:101];
  [oldRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:102]];
  [oldRoot addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:103]];
  TreeAdaptor *adaptor = [[[CommonTreeAdaptor alloc] init];
  [adaptor becomeRoot:newRoot param1:oldRoot];
  [newRoot sanityCheckParentAndChildIndexes];
}

- (void) testBecomeRoot6
{
  ANTLRCommonTree *root_0 = (ANTLRCommonTree *)[adaptor nil];
  ANTLRCommonTree *root_1 = (ANTLRCommonTree *)[adaptor nil];
  root_1 = (ANTLRCommonTree *)[adaptor becomeRoot:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:5] param1:root_1];
  [adaptor addChild:root_1 param1:[ANTLRCommonTree newTree:[ANTLRCommonToken alloc] init:6]];
  [adaptor addChild:root_0 param1:root_1];
  [root_0 sanityCheckParentAndChildIndexes];
}

- (void) testReplaceWithNoChildren
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:101];
  ANTLRCommonTree *newChild = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:5];
  BOOL error = NO;

  @try {
    [t replaceChildren:0 param1:0 param2:newChild];
  }
  @catch (IllegalArgumentException *iae) {
    error = YES;
  }
  [self assertTrue:error];
}

- (void) testReplaceWithOneChildren
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"a"];
  ANTLRCommonTree *c0 = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"b"];
  [t addChild:c0];
  ANTLRCommonTree *newChild = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"c"];
  [t replaceChildren:0 param1:0 param2:newChild];
  NSString *expecting = @"(a c)";
  [self assertEquals:expecting param1:[t toStringTree]];
  [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceInMiddle
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"a"];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"b"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"c"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"d"]];
  ANTLRCommonTree *newChild = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"x"];
  [t replaceChildren:1 param1:1 param2:newChild];
  NSString *expecting = @"(a b x d)";
  [self assertEquals:expecting param1:[t toStringTree]];
  [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceAtLeft
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"a"];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"b"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"c"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 param1:@"d"]];
  ANTLRCommonTree *newChild = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"x"];
  [t replaceChildren:0 param1:0 param2:newChild];
  NSString *expecting = @"(a x c d)";
  [self assertEquals:expecting param1:[t toStringTree]];
  [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceAtRight
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"a"];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"b"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"c"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"d"]];
  ANTLRCommonTree *newChild = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"x"];
  [t replaceChildren:2 param1:2 param2:newChild];
  NSString *expecting = @"(a b c x)";
  [self assertEquals:expecting param1:[t toStringTree]];
  [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceOneWithTwoAtLeft
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"a"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"b"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"c"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"d"]];
  ANTLRCommonTree *newChildren = (ANTLRCommonTree *)[adaptor nil];
  [newChildren addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"x"]];
  [newChildren addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"y"]];
  [t replaceChildren:0 param1:0 param2:newChildren];
  NSString *expecting = @"(a x y c d)";
  [self assertEquals:expecting param1:[t toStringTree]];
  [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceOneWithTwoAtRight
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"a"];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"b"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"c"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"d"]];
  ANTLRCommonTree *newChildren = (ANTLRCommonTree *)[adaptor nil];
  [newChildren addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"x"]];
  [newChildren addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"y"]];
  [t replaceChildren:2 param1:2 param2:newChildren];
  NSString *expecting = @"(a b c x y)";
  [self assertEquals:expecting param1:[t toStringTree]];
  [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceOneWithTwoInMiddle
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"a"];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"b"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"c"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"d"]];
  ANTLRCommonTree *newChildren = (ANTLRCommonTree *)[adaptor nil];
  [newChildren addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"x"]];
  [newChildren addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"y"]];
  [t replaceChildren:1 param1:1 param2:newChildren];
  NSString *expecting = @"(a b x y d)";
  [self assertEquals:expecting param1:[t toStringTree]];
  [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceTwoWithOneAtLeft
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"a"];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"b"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"c"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"d"]];
  ANTLRCommonTree *newChild = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"x"];
  [t replaceChildren:0 param1:1 param2:newChild];
  NSString *expecting = @"(a x d)";
  [self assertEquals:expecting param1:[t toStringTree]];
  [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceTwoWithOneAtRight
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"a"];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"b"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"c"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"d"]];
  ANTLRCommonTree *newChild = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"x"];
  [t replaceChildren:1 param1:2 param2:newChild];
  NSString *expecting = @"(a b x)";
  [self assertEquals:expecting param1:[t toStringTree]];
  [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceAllWithOne
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"a"];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"b"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"c"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"d"]];
  ANTLRCommonTree *newChild = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"x"];
  [t replaceChildren:0 param1:2 param2:newChild];
  NSString *expecting = @"(a x)";
  [self assertEquals:expecting param1:[t toStringTree]];
  [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceAllWithTwo
{
  ANTLRCommonTree *t = [ANTLRCommonTree newTree:ANTLRCommonToken newToken:99 text:@"a"];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"b"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"c"]];
  [t addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"d"]];
  ANTLRCommonTree *newChildren = (ANTLRCommonTree *)[adaptor nil];
  [newChildren addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"x"]];
  [newChildren addChild:[ANTLRCommonTree newTree:[ANTLRCommonToken newToken:99 text:@"y"]];
  [t replaceChildren:0 param1:2 param2:newChildren];
  NSString *expecting = @"(a x y)";
  [self assertEquals:expecting param1:[t toStringTree]];
  [t sanityCheckParentAndChildIndexes];
}

- (void) dealloc
{
  [adaptor release];
  [super dealloc];
}

@end
