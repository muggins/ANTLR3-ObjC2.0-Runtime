#import "CommonToken.h"
#import "Token.h"
#import "Test.h"

/**
 * Test the tree node stream.
 */

@interface TestTreeNodeStream : BaseTest {
}

- (TreeNodeStream *) newStream:(NSObject *)t;
- (NSString *) toTokenTypeString:(TreeNodeStream *)stream;
- (void) testSingleNode;
- (void) test4Nodes;
- (void) testList;
- (void) testFlatList;
- (void) testListWithOneNode;
- (void) testAoverB;
- (void) testLT;
- (void) testMarkRewindEntire;
- (void) testMarkRewindInMiddle;
- (void) testMarkRewindNested;
- (void) testSeekFromStart;
- (void) testReset;
- (NSString *) toNodesOnlyString:(TreeNodeStream *)nodes;
@end
