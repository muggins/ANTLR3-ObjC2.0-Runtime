#import "Tool.h"
#import "CodeGenerator.h"
#import "ErrorManager.h"
#import "Grammar.h"
#import "GrammarSyntaxMessage.h"
#import "Ignore.h"
#import "Test.h"

/**
 * Tree rewrites in tree parsers are basically identical to rewrites
 * in a normal grammar except that the atomic element is a node not
 * a Token.  Tests here ensure duplication of nodes occurs properly
 * and basic functionality.
 */

@interface TestTreeGrammarRewriteAST : BaseTest {
  BOOL debug;
}

- (void) init;
- (void) testFlatList;
- (void) testSimpleTree;
- (void) testNonImaginaryWithCtor;
- (void) testCombinedRewriteAndAuto;
- (void) testAvoidDup;
- (void) testLoop;
- (void) testAutoDup;
- (void) testAutoDupRule;
- (void) testAutoWildcard;
- (void) testNoWildcardAsRootError;
- (void) testAutoWildcard2;
- (void) testAutoWildcardWithLabel;
- (void) testAutoWildcardWithListLabel;
- (void) testAutoDupMultiple;
- (void) testAutoDupTree;
- (void) testAutoDupTree2;
- (void) testAutoDupTreeWithLabels;
- (void) testAutoDupTreeWithListLabels;
- (void) testAutoDupTreeWithRuleRoot;
- (void) testAutoDupTreeWithRuleRootAndLabels;
- (void) testAutoDupTreeWithRuleRootAndListLabels;
- (void) testAutoDupNestedTree;
- (void) testAutoDupTreeWithSubruleInside;
- (void) testDelete;
- (void) testSetMatchNoRewrite;
- (void) testSetOptionalMatchNoRewrite;
- (void) testSetMatchNoRewriteLevel2;
- (void) testSetMatchNoRewriteLevel2Root;
- (void) testRewriteModeCombinedRewriteAndAuto;
- (void) testRewriteModeFlatTree;
- (void) testRewriteModeChainRuleFlatTree;
- (void) testRewriteModeChainRuleTree;
- (void) testRewriteModeChainRuleTree2;
- (void) testRewriteModeChainRuleTree3;
- (void) testRewriteModeChainRuleTree4;
- (void) testRewriteModeChainRuleTree5;
- (void) testRewriteOfRuleRef;
- (void) testRewriteOfRuleRefRoot;
- (void) testRewriteOfRuleRefRootLabeled;
- (void) testRewriteOfRuleRefRootListLabeled;
- (void) testRewriteOfRuleRefChild;
- (void) testRewriteOfRuleRefLabel;
- (void) testRewriteOfRuleRefListLabel;
- (void) testRewriteModeWithPredicatedRewrites;
- (void) testWildcardSingleNode;
- (void) testWildcardUnlabeledSingleNode;
- (void) testWildcardGrabsSubtree;
- (void) testWildcardGrabsSubtree2;
- (void) testWildcardListLabel;
- (void) testWildcardListLabel2;
- (void) testRuleResultAsRoot;
@end
