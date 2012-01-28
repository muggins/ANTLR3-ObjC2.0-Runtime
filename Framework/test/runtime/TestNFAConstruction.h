#import "State.h"
#import "FASerializer.h"
#import "Grammar.h"
#import "Test.h"

@interface TestNFAConstruction : BaseTest {
}

- (id) init;
- (void) testA;
- (void) testAB;
- (void) testAorB;
- (void) testRangeOrRange;
- (void) testRange;
- (void) testCharSetInParser;
- (void) testABorCD;
- (void) testbA;
- (void) testbA_bC;
- (void) testAorEpsilon;
- (void) testAOptional;
- (void) testNakedAoptional;
- (void) testAorBthenC;
- (void) testAplus;
- (void) testNakedAplus;
- (void) testAplusNonGreedy;
- (void) testAorBplus;
- (void) testAorBorEmptyPlus;
- (void) testAStar;
- (void) testNestedAstar;
- (void) testPlusNestedInStar;
- (void) testStarNestedInPlus;
- (void) testNakedAstar;
- (void) testAorBstar;
- (void) testAorBOptionalSubrule;
- (void) testPredicatedAorB;
- (void) testMultiplePredicates;
- (void) testSets;
- (void) testNotSet;
- (void) testNotSingletonBlockSet;
- (void) testNotCharSet;
- (void) testNotBlockSet;
- (void) testNotSetLoop;
- (void) testNotBlockSetLoop;
- (void) testSetsInCombinedGrammarSentToLexer;
- (void) testLabeledNotSet;
- (void) testLabeledNotCharSet;
- (void) testLabeledNotBlockSet;
- (void) testEscapedCharLiteral;
- (void) testEscapedStringLiteral;
- (void) testAutoBacktracking_RuleBlock;
- (void) testAutoBacktracking_RuleSetBlock;
- (void) testAutoBacktracking_SimpleBlock;
- (void) testAutoBacktracking_SetBlock;
- (void) testAutoBacktracking_StarBlock;
- (void) testAutoBacktracking_StarSetBlock_IgnoresPreds;
- (void) testAutoBacktracking_StarSetBlock;
- (void) testAutoBacktracking_StarBlock1Alt;
- (void) testAutoBacktracking_PlusBlock;
- (void) testAutoBacktracking_PlusSetBlock;
- (void) testAutoBacktracking_PlusBlock1Alt;
- (void) testAutoBacktracking_OptionalBlock2Alts;
- (void) testAutoBacktracking_OptionalBlock1Alt;
- (void) testAutoBacktracking_ExistingPred;
@end
