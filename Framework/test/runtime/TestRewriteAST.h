#import "Tool.h"
#import "CodeGenerator.h"
#import "ErrorManager.h"
#import "Grammar.h"
#import "GrammarSemanticsMessage.h"
#import "Ignore.h"
#import "Test.h"

@interface TestRewriteAST : BaseTest {
  BOOL debug;
}

- (void) init;
- (void) testDelete;
- (void) testSingleToken;
- (void) testSingleTokenToNewNode;
- (void) testSingleTokenToNewNodeRoot;
- (void) testSingleTokenToNewNode2;
- (void) testSingleCharLiteral;
- (void) testSingleStringLiteral;
- (void) testSingleRule;
- (void) testReorderTokens;
- (void) testReorderTokenAndRule;
- (void) testTokenTree;
- (void) testTokenTreeAfterOtherStuff;
- (void) testNestedTokenTreeWithOuterLoop;
- (void) testOptionalSingleToken;
- (void) testClosureSingleToken;
- (void) testPositiveClosureSingleToken;
- (void) testOptionalSingleRule;
- (void) testClosureSingleRule;
- (void) testClosureOfLabel;
- (void) testOptionalLabelNoListLabel;
- (void) testPositiveClosureSingleRule;
- (void) testSinglePredicateT;
- (void) testSinglePredicateF;
- (void) testMultiplePredicate;
- (void) testMultiplePredicateTrees;
- (void) testSimpleTree;
- (void) testSimpleTree2;
- (void) testNestedTrees;
- (void) testImaginaryTokenCopy;
- (void) testTokenUnreferencedOnLeftButDefined;
- (void) testImaginaryTokenCopySetText;
- (void) testImaginaryTokenNoCopyFromToken;
- (void) testImaginaryTokenNoCopyFromTokenSetText;
- (void) testMixedRewriteAndAutoAST;
- (void) testSubruleWithRewrite;
- (void) testSubruleWithRewrite2;
- (void) testNestedRewriteShutsOffAutoAST;
- (void) testRewriteActions;
- (void) testRewriteActions2;
- (void) testRefToOldValue;
- (void) testCopySemanticsForRules;
- (void) testCopySemanticsForRules2;
- (void) testCopySemanticsForRules3;
- (void) testCopySemanticsForRules3Double;
- (void) testCopySemanticsForRules4;
- (void) testCopySemanticsLists;
- (void) testCopyRuleLabel;
- (void) testCopyRuleLabel2;
- (void) testQueueingOfTokens;
- (void) testCopyOfTokens;
- (void) testTokenCopyInLoop;
- (void) testTokenCopyInLoopAgainstTwoOthers;
- (void) testListRefdOneAtATime;
- (void) testSplitListWithLabels;
- (void) testComplicatedMelange;
- (void) testRuleLabel;
- (void) testAmbiguousRule;
- (void) testWeirdRuleRef;
- (void) testRuleListLabel;
- (void) testRuleListLabel2;
- (void) testOptional;
- (void) testOptional2;
- (void) testOptional3;
- (void) testOptional4;
- (void) testOptional5;
- (void) testArbitraryExprType;
- (void) testSet;
- (void) testSet2;
- (void) testSetWithLabel;
- (void) testRewriteAction;
- (void) testOptionalSubruleWithoutRealElements;
- (void) testCardinality;
- (void) testCardinality2;
- (void) testCardinality3;
- (void) testLoopCardinality;
- (void) testWildcard;
- (void) testUnknownRule;
- (void) testKnownRuleButNotInLHS;
- (void) testUnknownToken;
- (void) testUnknownLabel;
- (void) testUnknownCharLiteralToken;
- (void) testUnknownStringLiteralToken;
- (void) testExtraTokenInSimpleDecl;
- (void) testMissingIDInSimpleDecl;
- (void) testMissingSetInSimpleDecl;
- (void) testMissingTokenGivesErrorNode;
- (void) testExtraTokenGivesErrorNode;
- (void) testMissingFirstTokenGivesErrorNode;
- (void) testMissingFirstTokenGivesErrorNode2;
- (void) testNoViableAltGivesErrorNode;
@end
