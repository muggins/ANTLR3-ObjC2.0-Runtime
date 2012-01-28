#import "Tool.h"
#import "CodeGenerator.h"
#import "StringTemplate.h"
#import "Grammar.h"
#import "Test.h"

@interface TestLexer : BaseTest {
  BOOL debug;
}

- (id) init;
- (void) testSetText;
- (void) testRefToRuleDoesNotSetTokenNorEmitAnother;
- (void) testRefToRuleDoesNotSetChannel;
- (void) testWeCanSetType;
- (void) testRefToFragment;
- (void) testMultipleRefToFragment;
- (void) testLabelInSubrule;
- (void) testRefToTokenInLexer;
- (void) testListLabelInLexer;
- (void) testDupListRefInLexer;
- (void) testCharLabelInLexer;
- (void) testRepeatedLabelInLexer;
- (void) testRepeatedRuleLabelInLexer;
- (void) testIsolatedEOTEdge;
- (void) testEscapedLiterals;
- (void) testNewlineLiterals;
@end
