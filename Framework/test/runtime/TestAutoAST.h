#import "Ignore.h"
#import "Test.h"

@interface TestAutoAST : BaseTest {
  BOOL debug;
}

- (void) init;
- (void) testTokenList;
- (void) testTokenListInSingleAltBlock;
- (void) testSimpleRootAtOuterLevel;
- (void) testSimpleRootAtOuterLevelReverse;
- (void) testBang;
- (void) testOptionalThenRoot;
- (void) testLabeledStringRoot;
- (void) testWildcard;
- (void) testWildcardRoot;
- (void) testWildcardRootWithLabel;
- (void) testWildcardRootWithListLabel;
- (void) testWildcardBangWithListLabel;
- (void) testRootRoot;
- (void) testRootRoot2;
- (void) testRootThenRootInLoop;
- (void) testNestedSubrule;
- (void) testInvokeRule;
- (void) testInvokeRuleAsRoot;
- (void) testInvokeRuleAsRootWithLabel;
- (void) testInvokeRuleAsRootWithListLabel;
- (void) testRuleRootInLoop;
- (void) testRuleInvocationRuleRootInLoop;
- (void) testTailRecursion;
- (void) testSet;
- (void) testSetRoot;
- (void) testSetRootWithLabel;
- (void) testSetAsRuleRootInLoop;
- (void) testNotSet;
- (void) testNotSetWithLabel;
- (void) testNotSetWithListLabel;
- (void) testNotSetRoot;
- (void) testNotSetRootWithLabel;
- (void) testNotSetRootWithListLabel;
- (void) testNotSetRuleRootInLoop;
- (void) testTokenLabelReuse;
- (void) testTokenLabelReuse2;
- (void) testTokenListLabelReuse;
- (void) testTokenListLabelReuse2;
- (void) testTokenListLabelRuleRoot;
- (void) testTokenListLabelBang;
- (void) testRuleListLabel;
- (void) testRuleListLabelRuleRoot;
- (void) testRuleListLabelBang;
- (void) testComplicatedMelange;
- (void) testReturnValueWithAST;
- (void) testSetLoop;
- (void) testExtraTokenInSimpleDecl;
- (void) testMissingIDInSimpleDecl;
- (void) testMissingSetInSimpleDecl;
- (void) testMissingTokenGivesErrorNode;
- (void) testMissingTokenGivesErrorNodeInInvokedRule;
- (void) testExtraTokenGivesErrorNode;
- (void) testMissingFirstTokenGivesErrorNode;
- (void) testMissingFirstTokenGivesErrorNode2;
- (void) testNoViableAltGivesErrorNode;
- (void) _test;
@end
