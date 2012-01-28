#import "Tool.h"
#import "CodeGenerator.h"
#import "ANTLRParser.h"
#import "ActionTranslator.h"
#import "StringTemplate.h"
#import "StringTemplateGroup.h"
#import "AngleBracketTemplateLexer.h"
#import "Test.h"
#import "StringReader.h"
#import "NSMutableArray.h"

@interface TestAttributes_Anon1 : NSObject <NSMutableArray> {
}

- (void) init;
@end

/**
 * Check the $x, $x.y attributes.  For checking the actual
 * translation, assume the Java target.  This is still a great test
 * for the semantics of the $x.y stuff regardless of the target.
 */

@interface TestAttributes : BaseTest {
}

- (id) init;
- (void) testEscapedLessThanInAction;
- (void) testEscaped$InAction;
- (void) testArguments;
- (void) testComplicatedArgParsing;
- (void) testBracketArgParsing;
- (void) testStringArgParsing;
- (void) testComplicatedSingleArgParsing;
- (void) testArgWithLT;
- (void) testGenericsAsArgumentDefinition;
- (void) testGenericsAsArgumentDefinition2;
- (void) testGenericsAsReturnValue;
- (void) testComplicatedArgParsingWithTranslation;
- (void) testRefToReturnValueBeforeRefToPredefinedAttr;
- (void) testRuleLabelBeforeRefToPredefinedAttr;
- (void) testInvalidArguments;
- (void) testReturnValue;
- (void) testReturnValueWithNumber;
- (void) testReturnValues;
- (void) testReturnWithMultipleRuleRefs;
- (void) testInvalidReturnValues;
- (void) testTokenLabels;
- (void) testRuleLabels;
- (void) testAmbiguRuleRef;
- (void) testRuleLabelsWithSpecialToken;
- (void) testForwardRefRuleLabels;
- (void) testInvalidRuleLabelAccessesParameter;
- (void) testInvalidRuleLabelAccessesScopeAttribute;
- (void) testInvalidRuleAttribute;
- (void) testMissingRuleAttribute;
- (void) testMissingUnlabeledRuleAttribute;
- (void) testNonDynamicAttributeOutsideRule;
- (void) testNonDynamicAttributeOutsideRule2;
- (void) testBasicGlobalScope;
- (void) testUnknownGlobalScope;
- (void) testIndexedGlobalScope;
- (void) test0IndexedGlobalScope;
- (void) testAbsoluteIndexedGlobalScope;
- (void) testScopeAndAttributeWithUnderscore;
- (void) testSharedGlobalScope;
- (void) testGlobalScopeOutsideRule;
- (void) testRuleScopeOutsideRule;
- (void) testBasicRuleScope;
- (void) testUnqualifiedRuleScopeAccessInsideRule;
- (void) testIsolatedDynamicRuleScopeRef;
- (void) testDynamicRuleScopeRefInSubrule;
- (void) testIsolatedGlobalScopeRef;
- (void) testRuleScopeFromAnotherRule;
- (void) testFullyQualifiedRefToCurrentRuleParameter;
- (void) testFullyQualifiedRefToCurrentRuleRetVal;
- (void) testSetFullyQualifiedRefToCurrentRuleRetVal;
- (void) testIsolatedRefToCurrentRule;
- (void) testIsolatedRefToRule;
- (void) testFullyQualifiedRefToTemplateAttributeInCurrentRule;
- (void) testRuleRefWhenRuleHasScope;
- (void) testDynamicScopeRefOkEvenThoughRuleRefExists;
- (void) testRefToTemplateAttributeForCurrentRule;
- (void) testRefToTextAttributeForCurrentRule;
- (void) testRefToStartAttributeForCurrentRule;
- (void) testTokenLabelFromMultipleAlts;
- (void) testRuleLabelFromMultipleAlts;
- (void) testUnknownDynamicAttribute;
- (void) testUnknownGlobalDynamicAttribute;
- (void) testUnqualifiedRuleScopeAttribute;
- (void) testRuleAndTokenLabelTypeMismatch;
- (void) testListAndTokenLabelTypeMismatch;
- (void) testListAndRuleLabelTypeMismatch;
- (void) testArgReturnValueMismatch;
- (void) testSimplePlusEqualLabel;
- (void) testPlusEqualStringLabel;
- (void) testPlusEqualSetLabel;
- (void) testPlusEqualWildcardLabel;
- (void) testImplicitTokenLabel;
- (void) testImplicitRuleLabel;
- (void) testReuseExistingLabelWithImplicitRuleLabel;
- (void) testReuseExistingListLabelWithImplicitRuleLabel;
- (void) testReuseExistingLabelWithImplicitTokenLabel;
- (void) testReuseExistingListLabelWithImplicitTokenLabel;
- (void) testRuleLabelWithoutOutputOption;
- (void) testRuleLabelOnTwoDifferentRulesAST;
- (void) testRuleLabelOnTwoDifferentRulesTemplate;
- (void) testMissingArgs;
- (void) testArgsWhenNoneDefined;
- (void) testReturnInitValue;
- (void) testMultipleReturnInitValue;
- (void) testCStyleReturnInitValue;
- (void) testArgsWithInitValues;
- (void) testArgsOnToken;
- (void) testArgsOnTokenInLexer;
- (void) testLabelOnRuleRefInLexer;
- (void) testRefToRuleRefInLexer;
- (void) testRefToRuleRefInLexerNoAttribute;
- (void) testCharLabelInLexer;
- (void) testCharListLabelInLexer;
- (void) testWildcardCharLabelInLexer;
- (void) testWildcardCharListLabelInLexer;
- (void) testMissingArgsInLexer;
- (void) testLexerRulePropertyRefs;
- (void) testLexerLabelRefs;
- (void) testSettingLexerRulePropertyRefs;
- (void) testArgsOnTokenInLexerRuleOfCombined;
- (void) testMissingArgsOnTokenInLexerRuleOfCombined;
- (void) testTokenLabelTreeProperty;
- (void) testTokenRefTreeProperty;
- (void) testAmbiguousTokenRef;
- (void) testAmbiguousTokenRefWithProp;
- (void) testRuleRefWithDynamicScope;
- (void) testAssignToOwnRulenameAttr;
- (void) testAssignToOwnParamAttr;
- (void) testIllegalAssignToOwnRulenameAttr;
- (void) testIllegalAssignToLocalAttr;
- (void) testIllegalAssignRuleRefAttr;
- (void) testIllegalAssignTokenRefAttr;
- (void) testAssignToTreeNodeAttribute;
- (void) testDoNotTranslateAttributeCompare;
- (void) testDoNotTranslateScopeAttributeCompare;
- (void) testTreeRuleStopAttributeIsInvalid;
- (void) testRefToTextAttributeForCurrentTreeRule;
- (void) testTypeOfGuardedAttributeRefIsCorrect;
- (void) checkError:(ErrorQueue *)equeue expectedMessage:(GrammarSemanticsMessage *)expectedMessage;
- (void) checkErrors:(ErrorQueue *)equeue expectedMessages:(NSMutableArray *)expectedMessages;
@end
