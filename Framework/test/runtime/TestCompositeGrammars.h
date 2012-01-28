#import "Tool.h"
#import "Test.h"

@interface TestCompositeGrammars : BaseTest {
  BOOL debug;
}

- (void) init;
- (void) testWildcardStillWorks;
- (void) testDelegatorInvokesDelegateRule;
- (void) testDelegatorInvokesDelegateRuleWithArgs;
- (void) testDelegatorInvokesDelegateRuleWithReturnStruct;
- (void) testDelegatorAccessesDelegateMembers;
- (void) testDelegatorInvokesFirstVersionOfDelegateRule;
- (void) testDelegatesSeeSameTokenType;
- (void) testDelegatesSeeSameTokenType2;
- (void) testCombinedImportsCombined;
- (void) testSameStringTwoNames;
- (void) testSameNameTwoStrings;
- (void) testImportedTokenVocabIgnoredWithWarning;
- (void) testImportedTokenVocabWorksInRoot;
- (void) testSyntaxErrorsInImportsNotThrownOut;
- (void) testSyntaxErrorsInImportsNotThrownOut2;
- (void) testDelegatorRuleOverridesDelegate;
- (void) testDelegatorRuleOverridesLookaheadInDelegate;
- (void) testDelegatorRuleOverridesDelegates;
- (void) testLexerDelegatorInvokesDelegateRule;
- (void) testLexerDelegatorRuleOverridesDelegate;
- (void) testLexerDelegatorRuleOverridesDelegateLeavingNoRules;
- (void) testInvalidImportMechanism;
- (void) testSyntacticPredicateRulesAreNotInherited;
- (void) testKeywordVSIDGivesNoWarning;
- (void) testWarningForUndefinedToken;
- (void) test3LevelImport;
- (void) testBigTreeOfImports;
- (void) testRulesVisibleThroughMultilevelImport;
- (void) testNestedComposite;
- (void) testHeadersPropogatedCorrectlyToImportedGrammars;
@end
