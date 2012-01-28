#import "Test.h"

@interface TestTreeParsing : BaseTest {
}

- (void) testFlatList;
- (void) testSimpleTree;
- (void) testFlatVsTreeDecision;
- (void) testFlatVsTreeDecision2;
- (void) testCyclicDFALookahead;
- (void) testTemplateOutput;
- (void) testNullableChildList;
- (void) testNullableChildList2;
- (void) testNullableChildList3;
- (void) testActionsAfterRoot;
- (void) testWildcardLookahead;
- (void) testWildcardLookahead2;
- (void) testWildcardLookahead3;
- (void) testWildcardPlusLookahead;
@end
