#import "Tool.h"
#import "CodeGenerator.h"
#import "Test.h"

@interface TestRewriteTemplates : BaseTest {
  BOOL debug;
}

- (void) init;
- (void) testDelete;
- (void) testAction;
- (void) testEmbeddedLiteralConstructor;
- (void) testInlineTemplate;
- (void) testNamedTemplate;
- (void) testIndirectTemplate;
- (void) testInlineTemplateInvokingLib;
- (void) testPredicatedAlts;
- (void) testTemplateReturn;
- (void) testReturnValueWithTemplate;
- (void) testTemplateRefToDynamicAttributes;
- (void) testSingleNode;
- (void) testSingleNodeRewriteMode;
- (void) testRewriteRuleAndRewriteModeOnSimpleElements;
- (void) testRewriteRuleAndRewriteModeIgnoreActionsPredicates;
- (void) testRewriteRuleAndRewriteModeNotSimple;
- (void) testRewriteRuleAndRewriteModeRefRule;
@end
