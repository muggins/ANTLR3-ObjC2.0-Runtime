#import "Test.h"

@interface TestSemanticPredicateEvaluation : BaseTest {
}

- (void) testSimpleCyclicDFAWithPredicate;
- (void) testSimpleCyclicDFAWithInstanceVarPredicate;
- (void) testPredicateValidation;
- (void) testLexerPreds;
- (void) testLexerPreds2;
- (void) testLexerPredInExitBranch;
- (void) testLexerPredInExitBranch2;
- (void) testLexerPredInExitBranch3;
- (void) testLexerPredInExitBranch4;
- (void) testLexerPredsInCyclicDFA;
- (void) testLexerPredsInCyclicDFA2;
- (void) testGatedPred;
- (void) testGatedPred2;
- (void) testPredWithActionTranslation;
- (void) testPredicatesOnEOTTarget;
- (void) _test;
@end
