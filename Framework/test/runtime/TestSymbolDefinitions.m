#import "TestSymbolDefinitions.h"

@implementation TestSymbolDefinitions


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) testParserSimpleTokens {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a : A | B;\n"] stringByAppendingString:@"b : C ;"]] autorelease];
  NSString * rules = @"a, b";
  NSString * tokenNames = @"A, B, C";
  [self checkSymbols:g rulesStr:rules tokensStr:tokenNames];
}

- (void) testParserTokensSection {
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"tokens {\n"] stringByAppendingString:@"  C;\n"] stringByAppendingString:@"  D;"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : A | B;\n"] stringByAppendingString:@"b : C ;"]] autorelease];
  NSString * rules = @"a, b";
  NSString * tokenNames = @"A, B, C, D";
  [self checkSymbols:g rulesStr:rules tokensStr:tokenNames];
}

- (void) testLexerTokensSection {
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"tokens {\n"] stringByAppendingString:@"  C;\n"] stringByAppendingString:@"  D;"] stringByAppendingString:@"}\n"] stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"C : 'c' ;"]] autorelease];
  NSString * rules = @"A, C, Tokens";
  NSString * tokenNames = @"A, C, D";
  [self checkSymbols:g rulesStr:rules tokensStr:tokenNames];
}

- (void) testTokensSectionWithAssignmentSection {
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"tokens {\n"] stringByAppendingString:@"  C='c';\n"] stringByAppendingString:@"  D;"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : A | B;\n"] stringByAppendingString:@"b : C ;"]] autorelease];
  NSString * rules = @"a, b";
  NSString * tokenNames = @"A, B, C, D, 'c'";
  [self checkSymbols:g rulesStr:rules tokensStr:tokenNames];
}

- (void) testCombinedGrammarLiterals {
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar t;\n" stringByAppendingString:@"a : 'begin' b 'end';\n"] stringByAppendingString:@"b : C ';' ;\n"] stringByAppendingString:@"ID : 'a' ;\n"] stringByAppendingString:@"FOO : 'foo' ;\n"] stringByAppendingString:@"C : 'c' ;\n"]] autorelease];
  NSString * rules = @"a, b";
  NSString * tokenNames = @"C, FOO, ID, 'begin', 'end', ';'";
  [self checkSymbols:g rulesStr:rules tokensStr:tokenNames];
}

- (void) testLiteralInParserAndLexer {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"a : 'x' E ; \n"] stringByAppendingString:@"E: 'x' '0' ;\n"]] autorelease];
  NSString * literals = @"['x']";
  NSString * foundLiterals = [[g stringLiterals] description];
  [self assertEquals:literals param1:foundLiterals];
  NSString * implicitLexer = [[[[[@"lexer grammar t;\n" stringByAppendingString:@"\n"] stringByAppendingString:@"T__5 : 'x' ;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"// $ANTLR src \"<string>\" 3\n"] stringByAppendingString:@"E: 'x' '0' ;\n"];
  [self assertEquals:implicitLexer param1:[g lexerGrammar]];
}

- (void) testCombinedGrammarWithRefToLiteralButNoTokenIDRef {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"a : 'a' ;\n"] stringByAppendingString:@"A : 'a' ;\n"]] autorelease];
  NSString * rules = @"a";
  NSString * tokenNames = @"A, 'a'";
  [self checkSymbols:g rulesStr:rules tokensStr:tokenNames];
}

- (void) testSetDoesNotMissTokenAliases {
  Grammar * g = [[[Grammar alloc] init:[[[@"grammar t;\n" stringByAppendingString:@"a : 'a'|'b' ;\n"] stringByAppendingString:@"A : 'a' ;\n"] stringByAppendingString:@"B : 'b' ;\n"]] autorelease];
  NSString * rules = @"a";
  NSString * tokenNames = @"A, 'a', B, 'b'";
  [self checkSymbols:g rulesStr:rules tokensStr:tokenNames];
}

- (void) testSimplePlusEqualLabel {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : ids+=ID ( COMMA ids+=ID )* ;\n"]] autorelease];
  NSString * rule = @"a";
  NSString * tokenLabels = @"ids";
  NSString * ruleLabels = nil;
  [self checkPlusEqualsLabels:g ruleName:rule tokenLabelsStr:tokenLabels ruleLabelsStr:ruleLabels];
}

- (void) testMixedPlusEqualLabel {
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : id+=ID ( ',' e+=expr )* ;\n"] stringByAppendingString:@"expr : 'e';\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  NSString * rule = @"a";
  NSString * tokenLabels = @"id";
  NSString * ruleLabels = @"e";
  [self checkPlusEqualsLabels:g ruleName:rule tokenLabelsStr:tokenLabels ruleLabelsStr:ruleLabels];
}

- (void) testParserCharLiteralWithEscape {
  Grammar * g = [[[Grammar alloc] init:[@"grammar t;\n" stringByAppendingString:@"a : '\\n';\n"]] autorelease];
  Set * literals = [g stringLiterals];
  [self assertEquals:@"'\\n'" param1:[literals toArray][0]];
}

- (void) testTokenInTokensSectionAndTokenRuleDef {
  NSString * grammar = [[[[[@"grammar P;\n" stringByAppendingString:@"tokens { B='}'; }\n"] stringByAppendingString:@"a : A B {System.out.println(input);} ;\n"] stringByAppendingString:@"A : 'a' ;\n"] stringByAppendingString:@"B : '}' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"a}" param6:NO];
  [self assertEquals:@"a}\n" param1:found];
}

- (void) testTokenInTokensSectionAndTokenRuleDef2 {
  NSString * grammar = [[[[[@"grammar P;\n" stringByAppendingString:@"tokens { B='}'; }\n"] stringByAppendingString:@"a : A '}' {System.out.println(input);} ;\n"] stringByAppendingString:@"A : 'a' ;\n"] stringByAppendingString:@"B : '}' {/* */} ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"a}" param6:NO];
  [self assertEquals:@"a}\n" param1:found];
}

- (void) testRefToRuleWithNoReturnValue {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammarStr = [[[@"grammar P;\n" stringByAppendingString:@"a : x=b ;\n"] stringByAppendingString:@"b : B ;\n"] stringByAppendingString:@"B : 'b' ;\n"];
  Grammar * g = [[[Grammar alloc] init:grammarStr] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  StringTemplate * recogST = [generator genRecognizer];
  NSString * code = [recogST description];
  [self assertTrue:@"not expecting label" param1:[code rangeOfString:@"x=b();"] < 0];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testParserStringLiterals {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a : 'begin' b ;\n"] stringByAppendingString:@"b : C ;"]] autorelease];
  NSObject * expectedArg = @"'begin'";
  int expectedMsgID = ErrorManager.MSG_LITERAL_NOT_ASSOCIATED_WITH_LEXER_RULE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testParserCharLiterals {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a : '(' b ;\n"] stringByAppendingString:@"b : C ;"]] autorelease];
  NSObject * expectedArg = @"'('";
  int expectedMsgID = ErrorManager.MSG_LITERAL_NOT_ASSOCIATED_WITH_LEXER_RULE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testEmptyNotChar {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"grammar foo;\n" stringByAppendingString:@"a : (~'x')+ ;\n"]] autorelease];
  [g buildNFA];
  NSObject * expectedArg = @"'x'";
  int expectedMsgID = ErrorManager.MSG_EMPTY_COMPLEMENT;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testEmptyNotToken {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"grammar foo;\n" stringByAppendingString:@"a : (~A)+ ;\n"]] autorelease];
  [g buildNFA];
  NSObject * expectedArg = @"A";
  int expectedMsgID = ErrorManager.MSG_EMPTY_COMPLEMENT;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testEmptyNotSet {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"grammar foo;\n" stringByAppendingString:@"a : (~(A|B))+ ;\n"]] autorelease];
  [g buildNFA];
  NSObject * expectedArg = nil;
  int expectedMsgID = ErrorManager.MSG_EMPTY_COMPLEMENT;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testStringLiteralInParserTokensSection {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"tokens {\n"] stringByAppendingString:@"  B='begin';\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : A B;\n"] stringByAppendingString:@"b : C ;"]] autorelease];
  NSObject * expectedArg = @"'begin'";
  int expectedMsgID = ErrorManager.MSG_LITERAL_NOT_ASSOCIATED_WITH_LEXER_RULE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testCharLiteralInParserTokensSection {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"tokens {\n"] stringByAppendingString:@"  B='(';\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : A B;\n"] stringByAppendingString:@"b : C ;"]] autorelease];
  NSObject * expectedArg = @"'('";
  int expectedMsgID = ErrorManager.MSG_LITERAL_NOT_ASSOCIATED_WITH_LEXER_RULE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testCharLiteralInLexerTokensSection {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"lexer grammar t;\n" stringByAppendingString:@"tokens {\n"] stringByAppendingString:@"  B='(';\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  NSObject * expectedArg = @"'('";
  int expectedMsgID = ErrorManager.MSG_CANNOT_ALIAS_TOKENS_IN_LEXER;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testRuleRedefinition {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a : A | B;\n"] stringByAppendingString:@"a : C ;"]] autorelease];
  NSObject * expectedArg = @"a";
  int expectedMsgID = ErrorManager.MSG_RULE_REDEFINITION;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testLexerRuleRedefinition {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"ID : 'a' ;\n"] stringByAppendingString:@"ID : 'd' ;"]] autorelease];
  NSObject * expectedArg = @"ID";
  int expectedMsgID = ErrorManager.MSG_RULE_REDEFINITION;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testCombinedRuleRedefinition {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[@"grammar t;\n" stringByAppendingString:@"x : ID ;\n"] stringByAppendingString:@"ID : 'a' ;\n"] stringByAppendingString:@"x : ID ID ;"]] autorelease];
  NSObject * expectedArg = @"x";
  int expectedMsgID = ErrorManager.MSG_RULE_REDEFINITION;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testUndefinedToken {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"grammar t;\n" stringByAppendingString:@"x : ID ;"]] autorelease];
  NSObject * expectedArg = @"ID";
  int expectedMsgID = ErrorManager.MSG_NO_TOKEN_DEFINITION;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsWarning:equeue param1:expectedMessage];
}

- (void) testUndefinedTokenOkInParser {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"x : ID ;"]] autorelease];
  [self assertEquals:@"should not be an error" param1:0 param2:[equeue.errors size]];
}

- (void) testUndefinedRule {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"grammar t;\n" stringByAppendingString:@"x : r ;"]] autorelease];
  NSObject * expectedArg = @"r";
  int expectedMsgID = ErrorManager.MSG_UNDEFINED_RULE_REF;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testLexerRuleInParser {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"X : ;"]] autorelease];
  NSObject * expectedArg = @"X";
  int expectedMsgID = ErrorManager.MSG_LEXER_RULES_NOT_ALLOWED;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testParserRuleInLexer {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"a : ;"]] autorelease];
  NSObject * expectedArg = @"a";
  int expectedMsgID = ErrorManager.MSG_PARSER_RULES_NOT_ALLOWED;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testRuleScopeConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar t;\n" stringByAppendingString:@"scope a {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : \n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"a";
  int expectedMsgID = ErrorManager.MSG_SYMBOL_CONFLICTS_WITH_GLOBAL_SCOPE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testTokenRuleScopeConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar t;\n" stringByAppendingString:@"scope ID {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"ID : 'a'\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"ID";
  int expectedMsgID = ErrorManager.MSG_SYMBOL_CONFLICTS_WITH_GLOBAL_SCOPE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testTokenScopeConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"tokens { ID; }\n"] stringByAppendingString:@"scope ID {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : \n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"ID";
  int expectedMsgID = ErrorManager.MSG_SYMBOL_CONFLICTS_WITH_GLOBAL_SCOPE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testTokenRuleScopeConflictInLexerGrammar {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"lexer grammar t;\n" stringByAppendingString:@"scope ID {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"ID : 'a'\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"ID";
  int expectedMsgID = ErrorManager.MSG_SYMBOL_CONFLICTS_WITH_GLOBAL_SCOPE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testTokenLabelScopeConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"scope s {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : s=ID \n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"s";
  int expectedMsgID = ErrorManager.MSG_SYMBOL_CONFLICTS_WITH_GLOBAL_SCOPE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testRuleLabelScopeConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"scope s {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : s=b \n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : ;\n"]] autorelease];
  NSObject * expectedArg = @"s";
  int expectedMsgID = ErrorManager.MSG_SYMBOL_CONFLICTS_WITH_GLOBAL_SCOPE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testLabelAndRuleNameConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"parser grammar t;\n" stringByAppendingString:@"a : c=b \n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : ;\n"] stringByAppendingString:@"c : ;\n"]] autorelease];
  NSObject * expectedArg = @"c";
  int expectedMsgID = ErrorManager.MSG_LABEL_CONFLICTS_WITH_RULE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testLabelAndTokenNameConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"parser grammar t;\n" stringByAppendingString:@"a : ID=b \n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"c : ;\n"]] autorelease];
  NSObject * expectedArg = @"ID";
  int expectedMsgID = ErrorManager.MSG_LABEL_CONFLICTS_WITH_TOKEN;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testLabelAndArgConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a[int i] returns [int x]: i=ID \n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"i";
  int expectedMsgID = ErrorManager.MSG_LABEL_CONFLICTS_WITH_RULE_ARG_RETVAL;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testLabelAndParameterConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a[int i] returns [int x]: x=ID \n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"x";
  int expectedMsgID = ErrorManager.MSG_LABEL_CONFLICTS_WITH_RULE_ARG_RETVAL;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testLabelRuleScopeConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a\n"] stringByAppendingString:@"scope {"] stringByAppendingString:@"  int n;"] stringByAppendingString:@"}\n"] stringByAppendingString:@"  : n=ID\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"n";
  NSObject * expectedArg2 = @"a";
  int expectedMsgID = ErrorManager.MSG_LABEL_CONFLICTS_WITH_RULE_SCOPE_ATTRIBUTE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testRuleScopeArgConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a[int n]\n"] stringByAppendingString:@"scope {"] stringByAppendingString:@"  int n;"] stringByAppendingString:@"}\n"] stringByAppendingString:@"  : \n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"n";
  NSObject * expectedArg2 = @"a";
  int expectedMsgID = ErrorManager.MSG_ATTRIBUTE_CONFLICTS_WITH_RULE_ARG_RETVAL;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testRuleScopeReturnValueConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a returns [int n]\n"] stringByAppendingString:@"scope {"] stringByAppendingString:@"  int n;"] stringByAppendingString:@"}\n"] stringByAppendingString:@"  : \n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"n";
  NSObject * expectedArg2 = @"a";
  int expectedMsgID = ErrorManager.MSG_ATTRIBUTE_CONFLICTS_WITH_RULE_ARG_RETVAL;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testRuleScopeRuleNameConflict {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a\n"] stringByAppendingString:@"scope {"] stringByAppendingString:@"  int a;"] stringByAppendingString:@"}\n"] stringByAppendingString:@"  : \n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"a";
  NSObject * expectedArg2 = nil;
  int expectedMsgID = ErrorManager.MSG_ATTRIBUTE_CONFLICTS_WITH_RULE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testBadGrammarOption {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Tool * antlr = [self newTool];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[[@"grammar t;\n" stringByAppendingString:@"options {foo=3; language=Java;}\n"] stringByAppendingString:@"a : 'a';\n"]] autorelease];
  NSObject * expectedArg = @"foo";
  int expectedMsgID = ErrorManager.MSG_ILLEGAL_OPTION;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testBadRuleOption {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[@"grammar t;\n" stringByAppendingString:@"a\n"] stringByAppendingString:@"options {k=3; tokenVocab=blort;}\n"] stringByAppendingString:@"  : 'a';\n"]] autorelease];
  NSObject * expectedArg = @"tokenVocab";
  int expectedMsgID = ErrorManager.MSG_ILLEGAL_OPTION;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testBadSubRuleOption {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar t;\n" stringByAppendingString:@"a : ( options {k=3; language=Java;}\n"] stringByAppendingString:@"    : 'a'\n"] stringByAppendingString:@"    | 'b'\n"] stringByAppendingString:@"    )\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSObject * expectedArg = @"language";
  int expectedMsgID = ErrorManager.MSG_ILLEGAL_OPTION;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
}

- (void) testTokenVocabStringUsedInLexer {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * tokens = @"';'=4\n";
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"T.tokens" param2:tokens];
  NSString * importer = [[@"lexer grammar B; \n" stringByAppendingString:@"options\t{tokenVocab=T;} \n"] stringByAppendingString:@"SEMI:';' ; \n"];
  [self writeFile:tmpdir param1:@"B.g" param2:importer];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/B.g"] param2:composite] autorelease];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  NSString * expectedTokenIDToTypeMap = @"[SEMI=4]";
  NSString * expectedStringLiteralToTypeMap = @"{';'=4}";
  NSString * expectedTypeToTokenList = @"[SEMI]";
  [self assertEquals:expectedTokenIDToTypeMap param1:[[self realElements:g.composite.tokenIDToTypeMap] description]];
  [self assertEquals:expectedStringLiteralToTypeMap param1:[g.composite.stringLiteralToTypeMap description]];
  [self assertEquals:expectedTypeToTokenList param1:[[self realElements:g.composite.typeToTokenList] description]];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testTokenVocabStringUsedInCombined {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * tokens = @"';'=4\n";
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"T.tokens" param2:tokens];
  NSString * importer = [[@"grammar B; \n" stringByAppendingString:@"options\t{tokenVocab=T;} \n"] stringByAppendingString:@"SEMI:';' ; \n"];
  [self writeFile:tmpdir param1:@"B.g" param2:importer];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/B.g"] param2:composite] autorelease];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  NSString * expectedTokenIDToTypeMap = @"[SEMI=4]";
  NSString * expectedStringLiteralToTypeMap = @"{';'=4}";
  NSString * expectedTypeToTokenList = @"[SEMI]";
  [self assertEquals:expectedTokenIDToTypeMap param1:[[self realElements:g.composite.tokenIDToTypeMap] description]];
  [self assertEquals:expectedStringLiteralToTypeMap param1:[g.composite.stringLiteralToTypeMap description]];
  [self assertEquals:expectedTypeToTokenList param1:[[self realElements:g.composite.typeToTokenList] description]];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) checkPlusEqualsLabels:(Grammar *)g ruleName:(NSString *)ruleName tokenLabelsStr:(NSString *)tokenLabelsStr ruleLabelsStr:(NSString *)ruleLabelsStr {
  Rule * r = [g getRule:ruleName];
  StringTokenizer * st = [[[StringTokenizer alloc] init:tokenLabelsStr param1:@", "] autorelease];
  Set * tokenLabels = nil;

  while ([st hasMoreTokens]) {
    if (tokenLabels == nil) {
      tokenLabels = [[[HashSet alloc] init] autorelease];
    }
    NSString * labelName = [st nextToken];
    [tokenLabels add:labelName];
  }

  Set * ruleLabels = nil;
  if (ruleLabelsStr != nil) {
    st = [[[StringTokenizer alloc] init:ruleLabelsStr param1:@", "] autorelease];
    ruleLabels = [[[HashSet alloc] init] autorelease];

    while ([st hasMoreTokens]) {
      NSString * labelName = [st nextToken];
      [ruleLabels add:labelName];
    }

  }
  [self assertTrue:[[@"token += labels mismatch; " stringByAppendingString:tokenLabels] stringByAppendingString:@"!="] + r.tokenListLabels param1:(tokenLabels != nil && r.tokenListLabels != nil) || (tokenLabels == nil && r.tokenListLabels == nil)];
  [self assertTrue:[[@"rule += labels mismatch; " stringByAppendingString:ruleLabels] stringByAppendingString:@"!="] + r.ruleListLabels param1:(ruleLabels != nil && r.ruleListLabels != nil) || (ruleLabels == nil && r.ruleListLabels == nil)];
  if (tokenLabels != nil) {
    [self assertEquals:tokenLabels param1:[r.tokenListLabels keySet]];
  }
  if (ruleLabels != nil) {
    [self assertEquals:ruleLabels param1:[r.ruleListLabels keySet]];
  }
}

- (void) checkSymbols:(Grammar *)g rulesStr:(NSString *)rulesStr tokensStr:(NSString *)tokensStr {
  Set * tokens = [g tokenDisplayNames];
  StringTokenizer * st = [[[StringTokenizer alloc] init:tokensStr param1:@", "] autorelease];

  while ([st hasMoreTokens]) {
    NSString * tokenName = [st nextToken];
    [self assertTrue:[[@"token " stringByAppendingString:tokenName] stringByAppendingString:@" expected"] param1:[g getTokenType:tokenName] != Label.INVALID];
    [tokens remove:tokenName];
  }


  for (NSEnumerator * iter = [tokens iterator]; [iter hasNext]; ) {
    NSString * tokenName = (NSString *)[iter nextObject];
    [self assertTrue:[@"unexpected token name " stringByAppendingString:tokenName] param1:[g getTokenType:tokenName] < Label.MIN_TOKEN_TYPE];
  }

  st = [[[StringTokenizer alloc] init:rulesStr param1:@", "] autorelease];
  int n = 0;

  while ([st hasMoreTokens]) {
    NSString * ruleName = [st nextToken];
    [self assertNotNull:[[@"rule " stringByAppendingString:ruleName] stringByAppendingString:@" expected"] param1:[g getRule:ruleName]];
    n++;
  }

  NSMutableArray * rules = [g rules];
  [self assertEquals:[[@"number of rules mismatch; expecting " stringByAppendingString:n] stringByAppendingString:@"; found "] + [rules count] param1:n param2:[rules count]];
}

@end
