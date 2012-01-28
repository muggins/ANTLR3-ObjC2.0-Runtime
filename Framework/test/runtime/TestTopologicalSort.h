#import "Graph.h"
#import "Test.h"
#import "NSMutableArray.h"

/**
 * Test topo sort in GraphNode.
 */

@interface TestTopologicalSort : BaseTest {
}

- (void) testFairlyLargeGraph;
- (void) testCyclicGraph;
- (void) testRepeatedEdges;
- (void) testSimpleTokenDependence;
- (void) testParserLexerCombo;
@end
