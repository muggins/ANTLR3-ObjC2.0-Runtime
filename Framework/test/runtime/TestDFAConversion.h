#import "Tool.h"
#import "DFA.h"
#import "DecisionProbe.h"
#import "CodeGenerator.h"
#import "BitSet.h"
#import "Test.h"

@interface TestDFAConversion_Anon1 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion_Anon2 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion_Anon3 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion_Anon4 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion_Anon5 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion_Anon6 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion_Anon7 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion_Anon8 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion_Anon9 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion_Anon10 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion_Anon11 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion_Anon12 : NSObject <HashSet> {
}

- (void) init;
@end

@interface TestDFAConversion : BaseTest {
}

- (void) testA;
- (void) testAB_or_AC;
- (void) testAB_or_AC_k2;
- (void) testAB_or_AC_k1;
- (void) testselfRecurseNonDet;
- (void) testRecursionOverflow;
- (void) testRecursionOverflow2;
- (void) testRecursionOverflowWithPredOk;
- (void) testRecursionOverflowWithPredOk2;
- (void) testCannotSeePastRecursion;
- (void) testSynPredResolvesRecursion;
- (void) testSynPredMissingInMiddle;
- (void) testAutoBacktrackAndPredMissingInMiddle;
- (void) testSemPredResolvesRecursion;
- (void) testSemPredResolvesRecursion2;
- (void) testSemPredResolvesRecursion3;
- (void) testSynPredResolvesRecursion2;
- (void) testSynPredResolvesRecursion3;
- (void) testSynPredResolvesRecursion4;
- (void) testSynPredResolvesRecursionInLexer;
- (void) testAutoBacktrackResolvesRecursionInLexer;
- (void) testAutoBacktrackResolvesRecursion;
- (void) testselfRecurseNonDet2;
- (void) testIndirectRecursionLoop;
- (void) testIndirectRecursionLoop2;
- (void) testIndirectRecursionLoop3;
- (void) testifThenElse;
- (void) testifThenElseChecksStackSuffixConflict;
- (void) testInvokeRule;
- (void) testDoubleInvokeRuleLeftEdge;
- (void) testimmediateTailRecursion;
- (void) testAStar_immediateTailRecursion;
- (void) testNoStartRule;
- (void) testAStar_immediateTailRecursion2;
- (void) testimmediateLeftRecursion;
- (void) testIndirectLeftRecursion;
- (void) testLeftRecursionInMultipleCycles;
- (void) testCycleInsideRuleDoesNotForceInfiniteRecursion;
- (void) testAStar;
- (void) testAorBorCStar;
- (void) testAPlus;
- (void) testAPlusNonGreedyWhenDeterministic;
- (void) testAPlusNonGreedyWhenNonDeterministic;
- (void) testAPlusGreedyWhenNonDeterministic;
- (void) testAorBorCPlus;
- (void) testAOptional;
- (void) testAorBorCOptional;
- (void) testAStarBOrAStarC;
- (void) testAStarBOrAPlusC;
- (void) testAOrBPlusOrAPlus;
- (void) testLoopbackAndExit;
- (void) testOptionalAltAndBypass;
- (void) testResolveLL1ByChoosingFirst;
- (void) testResolveLL2ByChoosingFirst;
- (void) testResolveLL2MixAlt;
- (void) testIndirectIFThenElseStyleAmbig;
- (void) testComplement;
- (void) testComplementToken;
- (void) testComplementChar;
- (void) testComplementCharSet;
- (void) testNoSetCollapseWithActions;
- (void) testRuleAltsSetCollapse;
- (void) testTokensRuleAltsDoNotCollapse;
- (void) testMultipleSequenceCollision;
- (void) testMultipleAltsSameSequenceCollision;
- (void) testFollowReturnsToLoopReenteringSameRule;
- (void) testTokenCallsAnotherOnLeftEdge;
- (void) testSelfRecursionAmbigAlts;
- (void) testIndirectRecursionAmbigAlts;
- (void) testTailRecursionInvokedFromArbitraryLookaheadDecision;
- (void) testWildcardStarK1AndNonGreedyByDefaultInParser;
- (void) testWildcardPlusK1AndNonGreedyByDefaultInParser;
- (void) testGatedSynPred;
- (void) testHoistedGatedSynPred;
- (void) testHoistedGatedSynPred2;
- (void) testGreedyGetsNoErrorForAmbig;
- (void) testGreedyNonLLStarStillGetsError;
- (void) testGreedyRecOverflowStillGetsError;
- (void) testCyclicTableCreation;
- (void) _template;
- (void) assertNonLLStar:(Grammar *)g expectedBadAlts:(NSMutableArray *)expectedBadAlts;
- (void) assertRecursionOverflow:(Grammar *)g expectedTargetRules:(NSMutableArray *)expectedTargetRules expectedAlt:(int)expectedAlt;
- (void) testWildcardInTreeGrammar;
- (void) testWildcardInTreeGrammar2;
- (void) checkDecision:(Grammar *)g decision:(int)decision expecting:(NSString *)expecting expectingUnreachableAlts:(NSArray *)expectingUnreachableAlts expectingNonDetAlts:(NSArray *)expectingNonDetAlts expectingAmbigInput:(NSString *)expectingAmbigInput expectingDanglingAlts:(NSArray *)expectingDanglingAlts expectingNumWarnings:(int)expectingNumWarnings;
- (GrammarNonDeterminismMessage *) getNonDeterminismMessage:(NSMutableArray *)warnings;
- (NonRegularDecisionMessage *) getNonRegularDecisionMessage:(NSMutableArray *)errors;
- (RecursionOverflowMessage *) getRecursionOverflowMessage:(NSMutableArray *)warnings;
- (LeftRecursionCyclesMessage *) getLeftRecursionCyclesMessage:(NSMutableArray *)warnings;
- (GrammarDanglingStateMessage *) getDanglingStateMessage:(NSMutableArray *)warnings;
- (NSString *) str:(NSArray *)elements;
- (Set *) ruleNames:(Set *)rules;
- (Set *) ruleNames2:(NSMutableArray *)rules;
@end
