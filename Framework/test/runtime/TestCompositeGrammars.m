#import "TestCompositeGrammars.h"

@implementation TestCompositeGrammars

- (void) init {
  if (self = [super init]) {
    debug = NO;
  }
  return self;
}

- (void) testWildcardStillWorks {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammar = [@"parser grammar S;\n" stringByAppendingString:@"a : B . C ;\n"];
  Grammar * g = [[[Grammar alloc] init:grammar] autorelease];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testDelegatorInvokesDelegateRule {
  NSString * slave = [@"parser grammar S;\n" stringByAppendingString:@"a : B {System.out.println(\"S.a\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"B : 'b' ;"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"M.g" param1:master param2:@"MParser" param3:@"MLexer" param4:@"s" param5:@"b" param6:debug];
  [self assertEquals:@"S.a\n" param1:found];
}

- (void) testDelegatorInvokesDelegateRuleWithArgs {
  NSString * slave = [@"parser grammar S;\n" stringByAppendingString:@"a[int x] returns [int y] : B {System.out.print(\"S.a\"); $y=1000;} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"s : label=a[3] {System.out.println($label.y);} ;\n"] stringByAppendingString:@"B : 'b' ;"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"M.g" param1:master param2:@"MParser" param3:@"MLexer" param4:@"s" param5:@"b" param6:debug];
  [self assertEquals:@"S.a1000\n" param1:found];
}

- (void) testDelegatorInvokesDelegateRuleWithReturnStruct {
  NSString * slave = [@"parser grammar S;\n" stringByAppendingString:@"a : B {System.out.print(\"S.a\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"s : a {System.out.println($a.text);} ;\n"] stringByAppendingString:@"B : 'b' ;"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"M.g" param1:master param2:@"MParser" param3:@"MLexer" param4:@"s" param5:@"b" param6:debug];
  [self assertEquals:@"S.ab\n" param1:found];
}

- (void) testDelegatorAccessesDelegateMembers {
  NSString * slave = [[[[@"parser grammar S;\n" stringByAppendingString:@"@members {\n"] stringByAppendingString:@"  public void foo() {System.out.println(\"foo\");}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : B ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"s : 'b' {gS.foo();} ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"M.g" param1:master param2:@"MParser" param3:@"MLexer" param4:@"s" param5:@"b" param6:debug];
  [self assertEquals:@"foo\n" param1:found];
}

- (void) testDelegatorInvokesFirstVersionOfDelegateRule {
  NSString * slave = [[@"parser grammar S;\n" stringByAppendingString:@"a : b {System.out.println(\"S.a\");} ;\n"] stringByAppendingString:@"b : B ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * slave2 = [@"parser grammar T;\n" stringByAppendingString:@"a : B {System.out.println(\"T.a\");} ;\n"];
  [self writeFile:tmpdir param1:@"T.g" param2:slave2];
  NSString * master = [[[[@"grammar M;\n" stringByAppendingString:@"import S,T;\n"] stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"B : 'b' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"M.g" param1:master param2:@"MParser" param3:@"MLexer" param4:@"s" param5:@"b" param6:debug];
  [self assertEquals:@"S.a\n" param1:found];
}

- (void) testDelegatesSeeSameTokenType {
  NSString * slave = [[@"parser grammar S;\n" stringByAppendingString:@"tokens { A; B; C; }\n"] stringByAppendingString:@"x : A {System.out.println(\"S.x\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * slave2 = [[@"parser grammar T;\n" stringByAppendingString:@"tokens { C; B; A; }\n"] stringByAppendingString:@"y : A {System.out.println(\"T.y\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"T.g" param2:slave2];
  NSString * master = [[[[[[@"grammar M;\n" stringByAppendingString:@"import S,T;\n"] stringByAppendingString:@"s : x y ;\n"] stringByAppendingString:@"B : 'b' ;\n"] stringByAppendingString:@"A : 'a' ;\n"] stringByAppendingString:@"C : 'c' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"M.g" param1:master param2:@"MParser" param3:@"MLexer" param4:@"s" param5:@"aa" param6:debug];
  [self assertEquals:[@"S.x\n" stringByAppendingString:@"T.y\n"] param1:found];
}

- (void) testDelegatesSeeSameTokenType2 {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [[@"parser grammar S;\n" stringByAppendingString:@"tokens { A; B; C; }\n"] stringByAppendingString:@"x : A {System.out.println(\"S.x\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * slave2 = [[@"parser grammar T;\n" stringByAppendingString:@"tokens { C; B; A; }\n"] stringByAppendingString:@"y : A {System.out.println(\"T.y\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"T.g" param2:slave2];
  NSString * master = [[[[[[@"grammar M;\n" stringByAppendingString:@"import S,T;\n"] stringByAppendingString:@"s : x y ;\n"] stringByAppendingString:@"B : 'b' ;\n"] stringByAppendingString:@"A : 'a' ;\n"] stringByAppendingString:@"C : 'c' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  [self writeFile:tmpdir param1:@"M.g" param2:master];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  NSString * expectedTokenIDToTypeMap = @"[A=4, B=5, C=6, WS=7]";
  NSString * expectedStringLiteralToTypeMap = @"{}";
  NSString * expectedTypeToTokenList = @"[A, B, C, WS]";
  [self assertEquals:expectedTokenIDToTypeMap param1:[[self realElements:g.composite.tokenIDToTypeMap] description]];
  [self assertEquals:expectedStringLiteralToTypeMap param1:[g.composite.stringLiteralToTypeMap description]];
  [self assertEquals:expectedTypeToTokenList param1:[[self realElements:g.composite.typeToTokenList] description]];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testCombinedImportsCombined {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [[[[@"grammar S;\n" stringByAppendingString:@"tokens { A; B; C; }\n"] stringByAppendingString:@"x : 'x' INT {System.out.println(\"S.x\");} ;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"s : x INT ;\n"];
  [self writeFile:tmpdir param1:@"M.g" param2:master];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:1 param2:[equeue.errors size]];
  NSString * expectedError = [[@"error(161): " stringByAppendingString:[[tmpdir description] replaceFirst:@"\\-[0-9]+" param1:@""]] stringByAppendingString:@"/M.g:2:8: combined grammar M cannot import combined grammar S"];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:expectedError param2:[[[equeue.errors get:0] description] replaceFirst:@"\\-[0-9]+" param1:@""]];
}

- (void) testSameStringTwoNames {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [[@"parser grammar S;\n" stringByAppendingString:@"tokens { A='a'; }\n"] stringByAppendingString:@"x : A {System.out.println(\"S.x\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * slave2 = [[@"parser grammar T;\n" stringByAppendingString:@"tokens { X='a'; }\n"] stringByAppendingString:@"y : X {System.out.println(\"T.y\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"T.g" param2:slave2];
  NSString * master = [[[@"grammar M;\n" stringByAppendingString:@"import S,T;\n"] stringByAppendingString:@"s : x y ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  [self writeFile:tmpdir param1:@"M.g" param2:master];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  NSString * expectedTokenIDToTypeMap = @"[A=4, WS=6, X=5]";
  NSString * expectedStringLiteralToTypeMap = @"{'a'=4}";
  NSString * expectedTypeToTokenList = @"[A, X, WS]";
  [self assertEquals:expectedTokenIDToTypeMap param1:[[self realElements:g.composite.tokenIDToTypeMap] description]];
  [self assertEquals:expectedStringLiteralToTypeMap param1:[g.composite.stringLiteralToTypeMap description]];
  [self assertEquals:expectedTypeToTokenList param1:[[self realElements:g.composite.typeToTokenList] description]];
  NSObject * expectedArg = @"X='a'";
  NSObject * expectedArg2 = @"A";
  int expectedMsgID = ErrorManager.MSG_TOKEN_ALIAS_CONFLICT;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:1 param2:[equeue.errors size]];
  NSString * expectedError = @"error(158): T.g:2:10: cannot alias X='a'; string already assigned to A";
  [self assertEquals:expectedError param1:[[equeue.errors get:0] description]];
}

- (void) testSameNameTwoStrings {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [[@"parser grammar S;\n" stringByAppendingString:@"tokens { A='a'; }\n"] stringByAppendingString:@"x : A {System.out.println(\"S.x\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * slave2 = [[@"parser grammar T;\n" stringByAppendingString:@"tokens { A='x'; }\n"] stringByAppendingString:@"y : A {System.out.println(\"T.y\");} ;\n"];
  [self writeFile:tmpdir param1:@"T.g" param2:slave2];
  NSString * master = [[[@"grammar M;\n" stringByAppendingString:@"import S,T;\n"] stringByAppendingString:@"s : x y ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  [self writeFile:tmpdir param1:@"M.g" param2:master];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  NSString * expectedTokenIDToTypeMap = @"[A=4, T__6=6, WS=5]";
  NSString * expectedStringLiteralToTypeMap = @"{'a'=4, 'x'=6}";
  NSString * expectedTypeToTokenList = @"[A, WS, T__6]";
  [self assertEquals:expectedTokenIDToTypeMap param1:[[self realElements:g.composite.tokenIDToTypeMap] description]];
  [self assertEquals:expectedStringLiteralToTypeMap param1:[self sortMapToString:g.composite.stringLiteralToTypeMap]];
  [self assertEquals:expectedTypeToTokenList param1:[[self realElements:g.composite.typeToTokenList] description]];
  NSObject * expectedArg = @"A='x'";
  NSObject * expectedArg2 = @"'a'";
  int expectedMsgID = ErrorManager.MSG_TOKEN_ALIAS_REASSIGNMENT;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkGrammarSemanticsError:equeue param1:expectedMessage];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:1 param2:[equeue.errors size]];
  NSString * expectedError = @"error(159): T.g:2:10: cannot alias A='x'; token name already assigned to 'a'";
  [self assertEquals:expectedError param1:[[equeue.errors get:0] description]];
}

- (void) testImportedTokenVocabIgnoredWithWarning {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [[[@"parser grammar S;\n" stringByAppendingString:@"options {tokenVocab=whatever;}\n"] stringByAppendingString:@"tokens { A='a'; }\n"] stringByAppendingString:@"x : A {System.out.println(\"S.x\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"s : x ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  [self writeFile:tmpdir param1:@"M.g" param2:master];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  NSObject * expectedArg = @"S";
  int expectedMsgID = ErrorManager.MSG_TOKEN_VOCAB_IN_DELEGATE;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkGrammarSemanticsWarning:equeue param1:expectedMessage];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:1 param2:[equeue.warnings size]];
  NSString * expectedError = @"warning(160): S.g:2:10: tokenVocab option ignored in imported grammar S";
  [self assertEquals:expectedError param1:[[equeue.warnings get:0] description]];
}

- (void) testImportedTokenVocabWorksInRoot {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [[@"parser grammar S;\n" stringByAppendingString:@"tokens { A='a'; }\n"] stringByAppendingString:@"x : A {System.out.println(\"S.x\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * tokens = @"A=99\n";
  [self writeFile:tmpdir param1:@"Test.tokens" param2:tokens];
  NSString * master = [[[[@"grammar M;\n" stringByAppendingString:@"options {tokenVocab=Test;}\n"] stringByAppendingString:@"import S;\n"] stringByAppendingString:@"s : x ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  [self writeFile:tmpdir param1:@"M.g" param2:master];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  NSString * expectedTokenIDToTypeMap = @"[A=99, WS=101]";
  NSString * expectedStringLiteralToTypeMap = @"{'a'=100}";
  NSString * expectedTypeToTokenList = @"[A, 'a', WS]";
  [self assertEquals:expectedTokenIDToTypeMap param1:[[self realElements:g.composite.tokenIDToTypeMap] description]];
  [self assertEquals:expectedStringLiteralToTypeMap param1:[g.composite.stringLiteralToTypeMap description]];
  [self assertEquals:expectedTypeToTokenList param1:[[self realElements:g.composite.typeToTokenList] description]];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testSyntaxErrorsInImportsNotThrownOut {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [@"parser grammar S;\n" stringByAppendingString:@"options {toke\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"s : x ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  [self writeFile:tmpdir param1:@"M.g" param2:master];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:5 param2:[equeue.errors size]];
}

- (void) testSyntaxErrorsInImportsNotThrownOut2 {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [@"parser grammar S;\n" stringByAppendingString:@": A {System.out.println(\"S.x\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"s : x ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  [self writeFile:tmpdir param1:@"M.g" param2:master];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:3 param2:[equeue.errors size]];
}

- (void) testDelegatorRuleOverridesDelegate {
  NSString * slave = [[@"parser grammar S;\n" stringByAppendingString:@"a : b {System.out.println(\"S.a\");} ;\n"] stringByAppendingString:@"b : B ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"b : 'b'|'c' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"M.g" param1:master param2:@"MParser" param3:@"MLexer" param4:@"a" param5:@"c" param6:debug];
  [self assertEquals:@"S.a\n" param1:found];
}

- (void) testDelegatorRuleOverridesLookaheadInDelegate {
  NSString * slave = [[[[[@"parser grammar JavaDecl;\n" stringByAppendingString:@"type : 'int' ;\n"] stringByAppendingString:@"decl : type ID ';'\n"] stringByAppendingString:@"     | type ID init ';' {System.out.println(\"JavaDecl: \"+$decl.text);}\n"] stringByAppendingString:@"     ;\n"] stringByAppendingString:@"init : '=' INT ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"JavaDecl.g" param2:slave];
  NSString * master = [[[[[[[@"grammar Java;\n" stringByAppendingString:@"import JavaDecl;\n"] stringByAppendingString:@"prog : decl ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"ID  : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"Java.g" param1:master param2:@"JavaParser" param3:@"JavaLexer" param4:@"prog" param5:@"float x = 3;" param6:debug];
  [self assertEquals:@"JavaDecl: floatx=3;\n" param1:found];
}

- (void) testDelegatorRuleOverridesDelegates {
  NSString * slave = [[@"parser grammar S;\n" stringByAppendingString:@"a : b {System.out.println(\"S.a\");} ;\n"] stringByAppendingString:@"b : B ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * slave2 = [[@"parser grammar T;\n" stringByAppendingString:@"tokens { A='x'; }\n"] stringByAppendingString:@"b : B {System.out.println(\"T.b\");} ;\n"];
  [self writeFile:tmpdir param1:@"T.g" param2:slave2];
  NSString * master = [[[@"grammar M;\n" stringByAppendingString:@"import S, T;\n"] stringByAppendingString:@"b : 'b'|'c' {System.out.println(\"M.b\");}|B|A ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"M.g" param1:master param2:@"MParser" param3:@"MLexer" param4:@"a" param5:@"c" param6:debug];
  [self assertEquals:[@"M.b\n" stringByAppendingString:@"S.a\n"] param1:found];
}

- (void) testLexerDelegatorInvokesDelegateRule {
  NSString * slave = [[@"lexer grammar S;\n" stringByAppendingString:@"A : 'a' {System.out.println(\"S.A\");} ;\n"] stringByAppendingString:@"C : 'c' ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[@"lexer grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"B : 'b' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execLexer:@"M.g" param1:master param2:@"M" param3:@"abc" param4:debug];
  [self assertEquals:@"S.A\nabc\n" param1:found];
}

- (void) testLexerDelegatorRuleOverridesDelegate {
  NSString * slave = [[@"lexer grammar S;\n" stringByAppendingString:@"A : 'a' {System.out.println(\"S.A\");} ;\n"] stringByAppendingString:@"B : 'b' {System.out.println(\"S.B\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[@"lexer grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"A : 'a' B {System.out.println(\"M.A\");} ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execLexer:@"M.g" param1:master param2:@"M" param3:@"ab" param4:debug];
  [self assertEquals:[[@"S.B\n" stringByAppendingString:@"M.A\n"] stringByAppendingString:@"ab\n"] param1:found];
}

- (void) testLexerDelegatorRuleOverridesDelegateLeavingNoRules {
  NSString * slave = [@"lexer grammar S;\n" stringByAppendingString:@"A : 'a' {System.out.println(\"S.A\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[@"lexer grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"A : 'a' {System.out.println(\"M.A\");} ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  [self writeFile:tmpdir param1:@"/M.g" param2:master];
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [composite assignTokenTypes];
  [composite defineGrammarSymbols];
  [composite createNFAs];
  [g createLookaheadDFAs:NO];
  NSString * expectingDFA = [[@".s0-'a'->.s1\n" stringByAppendingString:@".s0-{'\\n', ' '}->:s3=>2\n"] stringByAppendingString:@".s1-<EOT>->:s2=>1\n"];
  DFA * dfa = [g getLookaheadDFA:1];
  FASerializer * serializer = [[[FASerializer alloc] init:g] autorelease];
  NSString * result = [serializer serialize:dfa.startState];
  [self assertEquals:expectingDFA param1:result];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testInvalidImportMechanism {
  NSString * slave = [@"lexer grammar S;\n" stringByAppendingString:@"A : 'a' {System.out.println(\"S.A\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[@"tree grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"a : A ;"];
  [self writeFile:tmpdir param1:@"/M.g" param2:master];
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:1 param2:[equeue.errors size]];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.warnings size]];
  NSString * expectedError = [[@"error(161): " stringByAppendingString:[[tmpdir description] replaceFirst:@"\\-[0-9]+" param1:@""]] stringByAppendingString:@"/M.g:2:8: tree grammar M cannot import lexer grammar S"];
  [self assertEquals:expectedError param1:[[[equeue.errors get:0] description] replaceFirst:@"\\-[0-9]+" param1:@""]];
}

- (void) testSyntacticPredicateRulesAreNotInherited {
  NSString * slave = [[[[@"parser grammar S;\n" stringByAppendingString:@"a : 'a' {System.out.println(\"S.a1\");}\n"] stringByAppendingString:@"  | 'a' {System.out.println(\"S.a2\");}\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : 'x' | 'y' {;} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[[[@"grammar M;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"import S;\n"] stringByAppendingString:@"start : a b ;\n"] stringByAppendingString:@"nonsense : 'q' | 'q' {;} ;"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"M.g" param1:master param2:@"MParser" param3:@"MLexer" param4:@"start" param5:@"ax" param6:debug];
  [self assertEquals:@"S.a1\n" param1:found];
}

- (void) testKeywordVSIDGivesNoWarning {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [[@"lexer grammar S;\n" stringByAppendingString:@"A : 'abc' {System.out.println(\"S.A\");} ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"a : A {System.out.println(\"M.a\");} ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"M.g" param1:master param2:@"MParser" param3:@"MLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  [self assertEquals:[@"unexpected warnings: " stringByAppendingString:equeue] param1:0 param2:[equeue.warnings size]];
  [self assertEquals:@"S.A\nM.a\n" param1:found];
}

- (void) testWarningForUndefinedToken {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [@"lexer grammar S;\n" stringByAppendingString:@"A : 'abc' {System.out.println(\"S.A\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"a : ABC A {System.out.println(\"M.a\");} ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  [self rawGenerateAndBuildRecognizer:@"M.g" param1:master param2:@"MParser" param3:@"MLexer" param4:debug];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  [self assertEquals:[@"unexpected warnings: " stringByAppendingString:equeue] param1:1 param2:[equeue.warnings size]];
  NSString * expectedError = [[@"warning(105): " stringByAppendingString:[[tmpdir description] replaceFirst:@"\\-[0-9]+" param1:@""]] stringByAppendingString:@"/M.g:3:5: no lexer rule corresponding to token: ABC"];
  [self assertEquals:expectedError param1:[[[equeue.warnings get:0] description] replaceFirst:@"\\-[0-9]+" param1:@""]];
}


/**
 * Make sure that M can import S that imports T.
 */
- (void) test3LevelImport {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [@"parser grammar T;\n" stringByAppendingString:@"a : T ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"T.g" param2:slave];
  NSString * slave2 = [[@"parser grammar S;\n" stringByAppendingString:@"import T;\n"] stringByAppendingString:@"a : S ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave2];
  NSString * master = [[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"a : M ;\n"];
  [self writeFile:tmpdir param1:@"M.g" param2:master];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  [g.composite defineGrammarSymbols];
  NSString * expectedTokenIDToTypeMap = @"[M=6, S=5, T=4]";
  NSString * expectedStringLiteralToTypeMap = @"{}";
  NSString * expectedTypeToTokenList = @"[T, S, M]";
  [self assertEquals:expectedTokenIDToTypeMap param1:[[self realElements:g.composite.tokenIDToTypeMap] description]];
  [self assertEquals:expectedStringLiteralToTypeMap param1:[g.composite.stringLiteralToTypeMap description]];
  [self assertEquals:expectedTypeToTokenList param1:[[self realElements:g.composite.typeToTokenList] description]];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  BOOL ok = [self rawGenerateAndBuildRecognizer:@"M.g" param1:master param2:@"MParser" param3:nil param4:NO];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:ok];
}

- (void) testBigTreeOfImports {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [@"parser grammar T;\n" stringByAppendingString:@"x : T ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"T.g" param2:slave];
  slave = [[@"parser grammar S;\n" stringByAppendingString:@"import T;\n"] stringByAppendingString:@"y : S ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  slave = [@"parser grammar C;\n" stringByAppendingString:@"i : C ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"C.g" param2:slave];
  slave = [@"parser grammar B;\n" stringByAppendingString:@"j : B ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"B.g" param2:slave];
  slave = [[@"parser grammar A;\n" stringByAppendingString:@"import B,C;\n"] stringByAppendingString:@"k : A ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"A.g" param2:slave];
  NSString * master = [[@"grammar M;\n" stringByAppendingString:@"import S,A;\n"] stringByAppendingString:@"a : M ;\n"];
  [self writeFile:tmpdir param1:@"M.g" param2:master];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  [g.composite defineGrammarSymbols];
  NSString * expectedTokenIDToTypeMap = @"[A=8, B=6, C=7, M=9, S=5, T=4]";
  NSString * expectedStringLiteralToTypeMap = @"{}";
  NSString * expectedTypeToTokenList = @"[T, S, B, C, A, M]";
  [self assertEquals:expectedTokenIDToTypeMap param1:[[self realElements:g.composite.tokenIDToTypeMap] description]];
  [self assertEquals:expectedStringLiteralToTypeMap param1:[g.composite.stringLiteralToTypeMap description]];
  [self assertEquals:expectedTypeToTokenList param1:[[self realElements:g.composite.typeToTokenList] description]];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  BOOL ok = [self rawGenerateAndBuildRecognizer:@"M.g" param1:master param2:@"MParser" param3:nil param4:NO];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:ok];
}

- (void) testRulesVisibleThroughMultilevelImport {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * slave = [@"parser grammar T;\n" stringByAppendingString:@"x : T ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"T.g" param2:slave];
  NSString * slave2 = [[@"parser grammar S;\n" stringByAppendingString:@"import T;\n"] stringByAppendingString:@"a : S ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave2];
  NSString * master = [[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"a : M x ;\n"];
  [self writeFile:tmpdir param1:@"M.g" param2:master];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/M.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  [g.composite defineGrammarSymbols];
  NSString * expectedTokenIDToTypeMap = @"[M=6, S=5, T=4]";
  NSString * expectedStringLiteralToTypeMap = @"{}";
  NSString * expectedTypeToTokenList = @"[T, S, M]";
  [self assertEquals:expectedTokenIDToTypeMap param1:[[self realElements:g.composite.tokenIDToTypeMap] description]];
  [self assertEquals:expectedStringLiteralToTypeMap param1:[g.composite.stringLiteralToTypeMap description]];
  [self assertEquals:expectedTypeToTokenList param1:[[self realElements:g.composite.typeToTokenList] description]];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testNestedComposite {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * gstr = [[[[@"lexer grammar L;\n" stringByAppendingString:@"T1: '1';\n"] stringByAppendingString:@"T2: '2';\n"] stringByAppendingString:@"T3: '3';\n"] stringByAppendingString:@"T4: '4';\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"L.g" param2:gstr];
  gstr = [[[@"parser grammar G1;\n" stringByAppendingString:@"s: a | b;\n"] stringByAppendingString:@"a: T1;\n"] stringByAppendingString:@"b: T2;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"G1.g" param2:gstr];
  gstr = [[@"parser grammar G2;\n" stringByAppendingString:@"import G1;\n"] stringByAppendingString:@"a: T3;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"G2.g" param2:gstr];
  NSString * G3str = [[@"grammar G3;\n" stringByAppendingString:@"import G2;\n"] stringByAppendingString:@"b: T4;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"G3.g" param2:G3str];
  Tool * antlr = [self newTool:[NSArray arrayWithObjects:@"-lib", tmpdir, nil]];
  CompositeGrammar * composite = [[[CompositeGrammar alloc] init] autorelease];
  Grammar * g = [[[Grammar alloc] init:antlr param1:[tmpdir stringByAppendingString:@"/G3.g"] param2:composite] autorelease];
  [composite setDelegationRoot:g];
  [g parseAndBuildAST];
  [g.composite assignTokenTypes];
  [g.composite defineGrammarSymbols];
  NSString * expectedTokenIDToTypeMap = @"[T1=4, T2=5, T3=6, T4=7]";
  NSString * expectedStringLiteralToTypeMap = @"{}";
  NSString * expectedTypeToTokenList = @"[T1, T2, T3, T4]";
  [self assertEquals:expectedTokenIDToTypeMap param1:[[self realElements:g.composite.tokenIDToTypeMap] description]];
  [self assertEquals:expectedStringLiteralToTypeMap param1:[g.composite.stringLiteralToTypeMap description]];
  [self assertEquals:expectedTypeToTokenList param1:[[self realElements:g.composite.typeToTokenList] description]];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  BOOL ok = [self rawGenerateAndBuildRecognizer:@"G3.g" param1:G3str param2:@"G3Parser" param3:nil param4:NO];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:ok];
}

- (void) testHeadersPropogatedCorrectlyToImportedGrammars {
  NSString * slave = [@"parser grammar S;\n" stringByAppendingString:@"a : B {System.out.print(\"S.a\");} ;\n"];
  [self mkdir:tmpdir];
  [self writeFile:tmpdir param1:@"S.g" param2:slave];
  NSString * master = [[[[[[@"grammar M;\n" stringByAppendingString:@"import S;\n"] stringByAppendingString:@"@header{package mypackage;}\n"] stringByAppendingString:@"@lexer::header{package mypackage;}\n"] stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"B : 'b' ;"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  BOOL ok = [self antlr:@"M.g" param1:@"M.g" param2:master param3:debug];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:ok];
}

@end
