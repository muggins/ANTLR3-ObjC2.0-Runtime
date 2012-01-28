#import "CommonToken.h"
#import "Token.h"
#import "CommonTree.h"
#import "CommonTreeAdaptor.h"
#import "Tree.h"
#import "TreeAdaptor.h"
#import "Test.h"

@interface V : CommonTree {
  int x;
}

- (id) initWithT:(Token *)t;
- (id) init:(int)ttype x:(int)x;
- (id) init:(int)ttype t:(Token *)t x:(int)x;
- (NSString *) description;
@end

@interface TestTrees : BaseTest {
  TreeAdaptor * adaptor;
  BOOL debug;
}

- (void) init;
- (void) testSingleNode;
- (void) testTwoChildrenOfNilRoot;
- (void) test4Nodes;
- (void) testList;
- (void) testList2;
- (void) testAddListToExistChildren;
- (void) testDupTree;
- (void) testBecomeRoot;
- (void) testBecomeRoot2;
- (void) testBecomeRoot3;
- (void) testBecomeRoot5;
- (void) testBecomeRoot6;
- (void) testReplaceWithNoChildren;
- (void) testReplaceWithOneChildren;
- (void) testReplaceInMiddle;
- (void) testReplaceAtLeft;
- (void) testReplaceAtRight;
- (void) testReplaceOneWithTwoAtLeft;
- (void) testReplaceOneWithTwoAtRight;
- (void) testReplaceOneWithTwoInMiddle;
- (void) testReplaceTwoWithOneAtLeft;
- (void) testReplaceTwoWithOneAtRight;
- (void) testReplaceAllWithOne;
- (void) testReplaceAllWithTwo;
@end
