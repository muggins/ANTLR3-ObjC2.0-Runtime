#import "TestTrees.h"

@implementation V

- (id) initWithT:(Token *)t
{
    if (self = [super init]) {
        token = t;
    }
    return self;
}

- (id) init:(int)ttype x:(int)x
{
    if (self = [super init]) {
        x = x;
        token = [[[CommonToken alloc] init:ttype] autorelease];
    }
    return self;
}

- (id) init:(int)ttype t:(Token *)t x:(int)x
{
    if (self = [super init]) {
        token = t;
        x = x;
    }
    return self;
}

- (NSString *) description
{
    return [(token != nil ? [token text] : @"") stringByAppendingString:@"<V>"];
}

@end

@implementation TestTrees

- (void) init
{
    if (self = [super init]) {
        adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
        debug = NO;
    }
    return self;
}

- (void) testSingleNode
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
    [self assertNull:t.parent];
    [self assertEquals:-1 param1:t.childIndex];
}

- (void) testTwoChildrenOfNilRoot
{
    CommonTree * root_0 = (CommonTree *)[adaptor nil];
    CommonTree * t = [[[V alloc] init:101 param1:2] autorelease];
    CommonTree * u = [[[V alloc] init:[[[CommonToken alloc] init:102 param1:@"102"] autorelease]] autorelease];
    [adaptor addChild:root_0 param1:t];
    [adaptor addChild:root_0 param1:u];
    [self assertNull:root_0.parent];
    [self assertEquals:-1 param1:root_0.childIndex];
    [self assertEquals:0 param1:t.childIndex];
    [self assertEquals:1 param1:u.childIndex];
}

- (void) test4Nodes
{
    CommonTree * r0 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
    [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
    [[r0 getChild:0] addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
    [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:104] autorelease]] autorelease]];
    [self assertNull:r0.parent];
    [self assertEquals:-1 param1:r0.childIndex];
}

- (void) testList
{
    CommonTree * r0 = [[[CommonTree alloc] init:(Token *)nil] autorelease];
    CommonTree * c0, c1, c2;
    [r0 addChild:c0 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease]];
    [r0 addChild:c1 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
    [r0 addChild:c2 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
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
    CommonTree * root = [[[CommonTree alloc] init:[[[CommonToken alloc] init:5] autorelease]] autorelease];
    CommonTree * r0 = [[[CommonTree alloc] init:(Token *)nil] autorelease];
    CommonTree * c0, c1, c2;
    [r0 addChild:c0 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease]];
    [r0 addChild:c1 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
    [r0 addChild:c2 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
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
    CommonTree * root = [[[CommonTree alloc] init:[[[CommonToken alloc] init:5] autorelease]] autorelease];
    [root addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:6] autorelease]] autorelease]];
    CommonTree * r0 = [[[CommonTree alloc] init:(Token *)nil] autorelease];
    CommonTree * c0, c1, c2;
    [r0 addChild:c0 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease]];
    [r0 addChild:c1 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
    [r0 addChild:c2 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
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
    CommonTree * r0 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
    CommonTree * r1 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease];
    [r0 addChild:r1];
    [r1 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
    Tree * r2 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:106] autorelease]] autorelease];
    [r2 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:107] autorelease]] autorelease]];
    [r1 addChild:r2];
    [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:104] autorelease]] autorelease]];
    [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:105] autorelease]] autorelease]];
    CommonTree * dup = (CommonTree *)[([[[CommonTreeAdaptor alloc] init] autorelease]) dupTree:r0];
    [self assertNull:dup.parent];
    [self assertEquals:-1 param1:dup.childIndex];
    [dup sanityCheckParentAndChildIndexes];
}

- (void) testBecomeRoot
{
    CommonTree * newRoot = [[[CommonTree alloc] init:[[[CommonToken alloc] init:5] autorelease]] autorelease];
    CommonTree * oldRoot = [[[CommonTree alloc] init:(Token *)nil] autorelease];
    [oldRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease]];
    [oldRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
    [oldRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
    TreeAdaptor * adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
    [adaptor becomeRoot:newRoot param1:oldRoot];
    [newRoot sanityCheckParentAndChildIndexes];
}

- (void) testBecomeRoot2
{
    CommonTree * newRoot = [[[CommonTree alloc] init:[[[CommonToken alloc] init:5] autorelease]] autorelease];
    CommonTree * oldRoot = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
    [oldRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
    [oldRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
    TreeAdaptor * adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
    [adaptor becomeRoot:newRoot param1:oldRoot];
    [newRoot sanityCheckParentAndChildIndexes];
}

- (void) testBecomeRoot3
{
    CommonTree * newRoot = [[[CommonTree alloc] init:(Token *)nil] autorelease];
    [newRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:5] autorelease]] autorelease]];
    CommonTree * oldRoot = [[[CommonTree alloc] init:(Token *)nil] autorelease];
    [oldRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease]];
    [oldRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
    [oldRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
    TreeAdaptor * adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
    [adaptor becomeRoot:newRoot param1:oldRoot];
    [newRoot sanityCheckParentAndChildIndexes];
}

- (void) testBecomeRoot5
{
    CommonTree * newRoot = [[[CommonTree alloc] init:(Token *)nil] autorelease];
    [newRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:5] autorelease]] autorelease]];
    CommonTree * oldRoot = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
    [oldRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
    [oldRoot addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
    TreeAdaptor * adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];
    [adaptor becomeRoot:newRoot param1:oldRoot];
    [newRoot sanityCheckParentAndChildIndexes];
}

- (void) testBecomeRoot6
{
    CommonTree * root_0 = (CommonTree *)[adaptor nil];
    CommonTree * root_1 = (CommonTree *)[adaptor nil];
    root_1 = (CommonTree *)[adaptor becomeRoot:[[[CommonTree alloc] init:[[[CommonToken alloc] init:5] autorelease]] autorelease] param1:root_1];
    [adaptor addChild:root_1 param1:[[[CommonTree alloc] init:[[[CommonToken alloc] init:6] autorelease]] autorelease]];
    [adaptor addChild:root_0 param1:root_1];
    [root_0 sanityCheckParentAndChildIndexes];
}

- (void) testReplaceWithNoChildren
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
    CommonTree * newChild = [[[CommonTree alloc] init:[[[CommonToken alloc] init:5] autorelease]] autorelease];
    BOOL error = NO;
    
    @try {
        [t replaceChildren:0 param1:0 param2:newChild];
    }
    @catch (IllegalArgumentException * iae) {
        error = YES;
    }
    [self assertTrue:error];
}

- (void) testReplaceWithOneChildren
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"a"] autorelease]] autorelease];
    CommonTree * c0 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"b"] autorelease]] autorelease];
    [t addChild:c0];
    CommonTree * newChild = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"c"] autorelease]] autorelease];
    [t replaceChildren:0 param1:0 param2:newChild];
    NSString * expecting = @"(a c)";
    [self assertEquals:expecting param1:[t toStringTree]];
    [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceInMiddle
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"a"] autorelease]] autorelease];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"b"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"c"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"d"] autorelease]] autorelease]];
    CommonTree * newChild = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"x"] autorelease]] autorelease];
    [t replaceChildren:1 param1:1 param2:newChild];
    NSString * expecting = @"(a b x d)";
    [self assertEquals:expecting param1:[t toStringTree]];
    [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceAtLeft
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"a"] autorelease]] autorelease];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"b"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"c"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"d"] autorelease]] autorelease]];
    CommonTree * newChild = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"x"] autorelease]] autorelease];
    [t replaceChildren:0 param1:0 param2:newChild];
    NSString * expecting = @"(a x c d)";
    [self assertEquals:expecting param1:[t toStringTree]];
    [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceAtRight
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"a"] autorelease]] autorelease];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"b"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"c"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"d"] autorelease]] autorelease]];
    CommonTree * newChild = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"x"] autorelease]] autorelease];
    [t replaceChildren:2 param1:2 param2:newChild];
    NSString * expecting = @"(a b c x)";
    [self assertEquals:expecting param1:[t toStringTree]];
    [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceOneWithTwoAtLeft
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"a"] autorelease]] autorelease];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"b"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"c"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"d"] autorelease]] autorelease]];
    CommonTree * newChildren = (CommonTree *)[adaptor nil];
    [newChildren addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"x"] autorelease]] autorelease]];
    [newChildren addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"y"] autorelease]] autorelease]];
    [t replaceChildren:0 param1:0 param2:newChildren];
    NSString * expecting = @"(a x y c d)";
    [self assertEquals:expecting param1:[t toStringTree]];
    [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceOneWithTwoAtRight
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"a"] autorelease]] autorelease];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"b"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"c"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"d"] autorelease]] autorelease]];
    CommonTree * newChildren = (CommonTree *)[adaptor nil];
    [newChildren addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"x"] autorelease]] autorelease]];
    [newChildren addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"y"] autorelease]] autorelease]];
    [t replaceChildren:2 param1:2 param2:newChildren];
    NSString * expecting = @"(a b c x y)";
    [self assertEquals:expecting param1:[t toStringTree]];
    [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceOneWithTwoInMiddle
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"a"] autorelease]] autorelease];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"b"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"c"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"d"] autorelease]] autorelease]];
    CommonTree * newChildren = (CommonTree *)[adaptor nil];
    [newChildren addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"x"] autorelease]] autorelease]];
    [newChildren addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"y"] autorelease]] autorelease]];
    [t replaceChildren:1 param1:1 param2:newChildren];
    NSString * expecting = @"(a b x y d)";
    [self assertEquals:expecting param1:[t toStringTree]];
    [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceTwoWithOneAtLeft
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"a"] autorelease]] autorelease];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"b"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"c"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"d"] autorelease]] autorelease]];
    CommonTree * newChild = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"x"] autorelease]] autorelease];
    [t replaceChildren:0 param1:1 param2:newChild];
    NSString * expecting = @"(a x d)";
    [self assertEquals:expecting param1:[t toStringTree]];
    [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceTwoWithOneAtRight
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"a"] autorelease]] autorelease];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"b"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"c"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"d"] autorelease]] autorelease]];
    CommonTree * newChild = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"x"] autorelease]] autorelease];
    [t replaceChildren:1 param1:2 param2:newChild];
    NSString * expecting = @"(a b x)";
    [self assertEquals:expecting param1:[t toStringTree]];
    [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceAllWithOne
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"a"] autorelease]] autorelease];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"b"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"c"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"d"] autorelease]] autorelease]];
    CommonTree * newChild = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"x"] autorelease]] autorelease];
    [t replaceChildren:0 param1:2 param2:newChild];
    NSString * expecting = @"(a x)";
    [self assertEquals:expecting param1:[t toStringTree]];
    [t sanityCheckParentAndChildIndexes];
}

- (void) testReplaceAllWithTwo
{
    CommonTree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"a"] autorelease]] autorelease];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"b"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"c"] autorelease]] autorelease]];
    [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"d"] autorelease]] autorelease]];
    CommonTree * newChildren = (CommonTree *)[adaptor nil];
    [newChildren addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"x"] autorelease]] autorelease]];
    [newChildren addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:99 param1:@"y"] autorelease]] autorelease]];
    [t replaceChildren:0 param1:2 param2:newChildren];
    NSString * expecting = @"(a x y)";
    [self assertEquals:expecting param1:[t toStringTree]];
    [t sanityCheckParentAndChildIndexes];
}

- (void) dealloc
{
    [adaptor release];
    [super dealloc];
}

@end
