#import "Test.h"

@interface TestSyntacticPredicateEvaluation : BaseTest {
}

- (void) testTwoPredsWithNakedAlt;
- (void) testTwoPredsWithNakedAltNotLast;
- (void) testLexerPred;
- (void) testLexerWithPredLongerThanAlt;
- (void) testLexerPredCyclicPrediction;
- (void) testLexerPredCyclicPrediction2;
- (void) testSimpleNestedPred;
- (void) testTripleNestedPredInLexer;
- (void) testTreeParserWithSynPred;
- (void) testTreeParserWithNestedSynPred;
- (void) testSynPredWithOutputTemplate;
- (void) testSynPredWithOutputAST;
- (void) testOptionalBlockWithSynPred;
- (void) testSynPredK2;
- (void) testSynPredKStar;
@end
