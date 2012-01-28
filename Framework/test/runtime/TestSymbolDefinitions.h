#import "Tool.h"
#import "Label.h"
#import "CodeGenerator.h"
#import "StringTemplate.h"
#import "Test.h"

@interface TestSymbolDefinitions : BaseTest {
}

- (id) init;
- (void) testParserSimpleTokens;
- (void) testParserTokensSection;
- (void) testLexerTokensSection;
- (void) testTokensSectionWithAssignmentSection;
- (void) testCombinedGrammarLiterals;
- (void) testLiteralInParserAndLexer;
- (void) testCombinedGrammarWithRefToLiteralButNoTokenIDRef;
- (void) testSetDoesNotMissTokenAliases;
- (void) testSimplePlusEqualLabel;
- (void) testMixedPlusEqualLabel;
- (void) testParserCharLiteralWithEscape;
- (void) testTokenInTokensSectionAndTokenRuleDef;
- (void) testTokenInTokensSectionAndTokenRuleDef2;
- (void) testRefToRuleWithNoReturnValue;
- (void) testParserStringLiterals;
- (void) testParserCharLiterals;
- (void) testEmptyNotChar;
- (void) testEmptyNotToken;
- (void) testEmptyNotSet;
- (void) testStringLiteralInParserTokensSection;
- (void) testCharLiteralInParserTokensSection;
- (void) testCharLiteralInLexerTokensSection;
- (void) testRuleRedefinition;
- (void) testLexerRuleRedefinition;
- (void) testCombinedRuleRedefinition;
- (void) testUndefinedToken;
- (void) testUndefinedTokenOkInParser;
- (void) testUndefinedRule;
- (void) testLexerRuleInParser;
- (void) testParserRuleInLexer;
- (void) testRuleScopeConflict;
- (void) testTokenRuleScopeConflict;
- (void) testTokenScopeConflict;
- (void) testTokenRuleScopeConflictInLexerGrammar;
- (void) testTokenLabelScopeConflict;
- (void) testRuleLabelScopeConflict;
- (void) testLabelAndRuleNameConflict;
- (void) testLabelAndTokenNameConflict;
- (void) testLabelAndArgConflict;
- (void) testLabelAndParameterConflict;
- (void) testLabelRuleScopeConflict;
- (void) testRuleScopeArgConflict;
- (void) testRuleScopeReturnValueConflict;
- (void) testRuleScopeRuleNameConflict;
- (void) testBadGrammarOption;
- (void) testBadRuleOption;
- (void) testBadSubRuleOption;
- (void) testTokenVocabStringUsedInLexer;
- (void) testTokenVocabStringUsedInCombined;
- (void) checkPlusEqualsLabels:(Grammar *)g ruleName:(NSString *)ruleName tokenLabelsStr:(NSString *)tokenLabelsStr ruleLabelsStr:(NSString *)ruleLabelsStr;
- (void) checkSymbols:(Grammar *)g rulesStr:(NSString *)rulesStr tokensStr:(NSString *)tokensStr;
@end
