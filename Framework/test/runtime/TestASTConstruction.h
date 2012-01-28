#import "Grammar.h"
#import "Test.h"

@interface TestASTConstruction : BaseTest {
}

- (id) init;
- (void) testA;
- (void) testNakeRulePlusInLexer;
- (void) testRulePlus;
- (void) testNakedRulePlus;
- (void) testRuleOptional;
- (void) testNakedRuleOptional;
- (void) testRuleStar;
- (void) testNakedRuleStar;
- (void) testCharStar;
- (void) testCharStarInLexer;
- (void) testStringStar;
- (void) testStringStarInLexer;
- (void) testCharPlus;
- (void) testCharPlusInLexer;
- (void) testCharOptional;
- (void) testCharOptionalInLexer;
- (void) testCharRangePlus;
- (void) testLabel;
- (void) testLabelOfOptional;
- (void) testLabelOfClosure;
- (void) testRuleLabel;
- (void) testSetLabel;
- (void) testNotSetLabel;
- (void) testNotSetListLabel;
- (void) testNotSetListLabelInLoop;
- (void) testRuleLabelOfPositiveClosure;
- (void) testListLabelOfClosure;
- (void) testListLabelOfClosure2;
- (void) testRuleListLabelOfPositiveClosure;
- (void) testRootTokenInStarLoop;
- (void) testActionInStarLoop;
@end
