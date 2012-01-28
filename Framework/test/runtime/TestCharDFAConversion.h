#import "DFA.h"
#import "DFAOptimizer.h"
#import "CodeGenerator.h"
#import "Test.h"
#import "NSMutableArray.h"

@interface TestCharDFAConversion : BaseTest {
}

- (id) init;
- (void) testSimpleRangeVersusChar;
- (void) testRangeWithDisjointSet;
- (void) testDisjointSetCollidingWithTwoRanges;
- (void) testDisjointSetCollidingWithTwoRangesCharsFirst;
- (void) testDisjointSetCollidingWithTwoRangesAsSeparateAlts;
- (void) testKeywordVersusID;
- (void) testIdenticalRules;
- (void) testAdjacentNotCharLoops;
- (void) testNonAdjacentNotCharLoops;
- (void) testLoopsWithOptimizedOutExitBranches;
- (void) testNonGreedy;
- (void) testNonGreedyWildcardStar;
- (void) testNonGreedyByDefaultWildcardStar;
- (void) testNonGreedyWildcardPlus;
- (void) testNonGreedyByDefaultWildcardPlus;
- (void) testNonGreedyByDefaultWildcardPlusWithParens;
- (void) testNonWildcardNonGreedy;
- (void) testNonWildcardEOTMakesItWorkWithoutNonGreedyOption;
- (void) testAltConflictsWithLoopThenExit;
- (void) testNonGreedyLoopThatNeverLoops;
- (void) testRecursive;
- (void) testRecursive2;
- (void) testNotFragmentInLexer;
- (void) testNotSetFragmentInLexer;
- (void) testNotTokenInLexer;
- (void) testNotComplicatedSetRuleInLexer;
- (void) testNotSetWithRuleInLexer;
- (void) testSetCallsRuleWithNot;
- (void) testSynPredInLexer;
- (void) _template;
- (void) checkDecision:(Grammar *)g decision:(int)decision expecting:(NSString *)expecting expectingUnreachableAlts:(NSArray *)expectingUnreachableAlts;
@end
