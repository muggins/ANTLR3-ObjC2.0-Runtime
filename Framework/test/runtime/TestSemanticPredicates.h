#import "Token.h"
#import "DFA.h"
#import "DecisionProbe.h"
#import "CodeGenerator.h"
#import "BitSet.h"
#import "Test.h"
#import "NSMutableArray.h"
#import "NSMutableDictionary.h"
#import "Set.h"

@interface TestSemanticPredicates : BaseTest {
}

- (id) init;
- (void) testPredsButSyntaxResolves;
- (void) testLL_1_Pred;
- (void) testLL_1_Pred_forced_k_1;
- (void) testLL_2_Pred;
- (void) testPredicatedLoop;
- (void) testPredicatedToStayInLoop;
- (void) testAndPredicates;
- (void) testOrPredicates;
- (void) testIgnoresHoistingDepthGreaterThanZero;
- (void) testIgnoresPredsHiddenByActions;
- (void) testIgnoresPredsHiddenByActionsOneAlt;
- (void) testHoist2;
- (void) testHoistCorrectContext;
- (void) testDefaultPredNakedAltIsLast;
- (void) testDefaultPredNakedAltNotLast;
- (void) testLeftRecursivePred;
- (void) testIgnorePredFromLL2AltLastAltIsDefaultTrue;
- (void) testIgnorePredFromLL2AltPredUnionNeeded;
- (void) testPredGets2SymbolSyntacticContext;
- (void) testMatchesLongestThenTestPred;
- (void) testPredsUsedAfterRecursionOverflow;
- (void) testPredsUsedAfterK2FailsNoRecursionOverflow;
- (void) testLexerMatchesLongestThenTestPred;
- (void) testLexerMatchesLongestMinusPred;
- (void) testGatedPred;
- (void) testGatedPredHoistsAndCanBeInStopState;
- (void) testGatedPredInCyclicDFA;
- (void) testGatedPredNotActuallyUsedOnEdges;
- (void) testGatedPredDoesNotForceAllToBeGated;
- (void) testGatedPredDoesNotForceAllToBeGated2;
- (void) testORGatedPred;
- (void) testIncompleteSemanticHoistedContext;
- (void) testIncompleteSemanticHoistedContextk2;
- (void) testIncompleteSemanticHoistedContextInFOLLOW;
- (void) testIncompleteSemanticHoistedContextInFOLLOWk2;
- (void) testIncompleteSemanticHoistedContextInFOLLOWDueToHiddenPred;
- (void) testIncompleteSemanticHoistedContext2;
- (void) testTooFewSemanticPredicates;
- (void) testPredWithK1;
- (void) testPredWithArbitraryLookahead;
- (void) testUniquePredicateOR;
- (void) testSemanticContextPreventsEarlyTerminationOfClosure;
- (void) _template;
- (void) checkDecision:(Grammar *)g decision:(int)decision expecting:(NSString *)expecting expectingUnreachableAlts:(NSArray *)expectingUnreachableAlts expectingNonDetAlts:(NSArray *)expectingNonDetAlts expectingAmbigInput:(NSString *)expectingAmbigInput expectingInsufficientPredAlts:(NSArray *)expectingInsufficientPredAlts expectingDanglingAlts:(NSArray *)expectingDanglingAlts expectingNumWarnings:(int)expectingNumWarnings hasPredHiddenByAction:(BOOL)hasPredHiddenByAction;
- (GrammarNonDeterminismMessage *) getNonDeterminismMessage:(NSMutableArray *)warnings;
- (GrammarInsufficientPredicatesMessage *) getGrammarInsufficientPredicatesMessage:(NSMutableArray *)warnings;
- (NSString *) str:(NSArray *)elements;
@end
