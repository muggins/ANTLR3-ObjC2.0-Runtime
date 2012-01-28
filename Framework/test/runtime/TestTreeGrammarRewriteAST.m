#import "TestTreeGrammarRewriteAST.h"

@implementation TestTreeGrammarRewriteAST

- (void) init {
  if (self = [super init]) {
    debug = NO;
  }
  return self;
}

- (void) testFlatList {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ID INT -> INT ID\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"34 abc\n" param1:found];
}

- (void) testSimpleTree {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(ID INT) -> ^(INT ID)\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"(34 abc)\n" param1:found];
}

- (void) testNonImaginaryWithCtor {
  NSString * grammar = [[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : INT ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : INT -> INT[\"99\"]\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"34"];
  [self assertEquals:@"99\n" param1:found];
}

- (void) testCombinedRewriteAndAuto {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT) | INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(ID INT) -> ^(INT ID) | INT\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"(34 abc)\n" param1:found];
  found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"34"];
  [self assertEquals:@"34\n" param1:found];
}

- (void) testAvoidDup {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ID -> ^(ID ID)\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc"];
  [self assertEquals:@"(abc abc)\n" param1:found];
}

- (void) testLoop {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID+ INT+ -> (^(ID INT))+ ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : (^(ID INT))+ -> INT+ ID+\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a b c 3 4 5"];
  [self assertEquals:@"3 4 5 a b c\n" param1:found];
}

- (void) testAutoDup {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ID \n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc"];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testAutoDupRule {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : b c ;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"c : INT ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 1"];
  [self assertEquals:@"a 1\n" param1:found];
}

- (void) testAutoWildcard {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ID . \n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testNoWildcardAsRootError {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ^(. INT) \n"] stringByAppendingString:@"  ;\n"];
  Grammar * g = [[[Grammar alloc] init:treeGrammar] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:1 param2:[equeue.errors size]];
  int expectedMsgID = ErrorManager.MSG_WILDCARD_AS_ROOT;
  NSObject * expectedArg = nil;
  RecognitionException * expectedExc = nil;
  GrammarSyntaxMessage * expectedMessage = [[[GrammarSyntaxMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedExc] autorelease];
  [self checkError:equeue param1:expectedMessage];
}

- (void) testAutoWildcard2 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(ID .) \n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"(abc 34)\n" param1:found];
}

- (void) testAutoWildcardWithLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ID c=. \n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testAutoWildcardWithListLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ID c+=. \n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testAutoDupMultiple {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ID INT;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ID ID INT\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a b 3"];
  [self assertEquals:@"a b 3\n" param1:found];
}

- (void) testAutoDupTree {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(ID INT)\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 3"];
  [self assertEquals:@"(a 3)\n" param1:found];
}

- (void) testAutoDupTree2 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT INT -> ^(ID INT INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(ID b b)\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : INT ;"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 3 4"];
  [self assertEquals:@"(a 3 4)\n" param1:found];
}

- (void) testAutoDupTreeWithLabels {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(x=ID y=INT)\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 3"];
  [self assertEquals:@"(a 3)\n" param1:found];
}

- (void) testAutoDupTreeWithListLabels {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(x+=ID y+=INT)\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 3"];
  [self assertEquals:@"(a 3)\n" param1:found];
}

- (void) testAutoDupTreeWithRuleRoot {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(b INT) ;\n"] stringByAppendingString:@"b : ID ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 3"];
  [self assertEquals:@"(a 3)\n" param1:found];
}

- (void) testAutoDupTreeWithRuleRootAndLabels {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(x=b INT) ;\n"] stringByAppendingString:@"b : ID ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 3"];
  [self assertEquals:@"(a 3)\n" param1:found];
}

- (void) testAutoDupTreeWithRuleRootAndListLabels {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(x+=b y+=c) ;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"c : INT ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 3"];
  [self assertEquals:@"(a 3)\n" param1:found];
}

- (void) testAutoDupNestedTree {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x=ID y=ID INT -> ^($x ^($y INT));\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(ID ^(ID INT))\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a b 3"];
  [self assertEquals:@"(a (b 3))\n" param1:found];
}

- (void) testAutoDupTreeWithSubruleInside {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {OP;}\n"] stringByAppendingString:@"a : (x=ID|x=INT) -> ^(OP $x) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(OP (b|c)) ;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"c : INT ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a"];
  [self assertEquals:@"(OP a)\n" param1:found];
}

- (void) testDelete {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ID -> \n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc"];
  [self assertEquals:@"" param1:found];
}

- (void) testSetMatchNoRewrite {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : b INT\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : ID | INT ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testSetOptionalMatchNoRewrite {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : (ID|INT)? INT ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testSetMatchNoRewriteLevel2 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x=ID INT -> ^($x INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(ID (ID | INT) ) ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"(abc 34)\n" param1:found];
}

- (void) testSetMatchNoRewriteLevel2Root {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x=ID INT -> ^($x INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^((ID | INT) INT) ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"(abc 34)\n" param1:found];
}

- (void) testRewriteModeCombinedRewriteAndAuto {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT) | INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"a : ^(ID INT) -> ^(ID[\"ick\"] INT)\n"] stringByAppendingString:@"  | INT\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"(ick 34)\n" param1:found];
  found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"34"];
  [self assertEquals:@"34\n" param1:found];
}

- (void) testRewriteModeFlatTree {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ID INT | INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : ID a ;\n"] stringByAppendingString:@"a : INT -> INT[\"1\"]\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:@"abc 1\n" param1:found];
}

- (void) testRewriteModeChainRuleFlatTree {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ID INT | INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : b ;\n"] stringByAppendingString:@"b : ID INT -> INT ID\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:@"34 abc\n" param1:found];
}

- (void) testRewriteModeChainRuleTree {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : b ;\n"] stringByAppendingString:@"b : ^(ID INT) -> INT\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:@"34\n" param1:found];
}

- (void) testRewriteModeChainRuleTree2 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"tokens { X; }\n"] stringByAppendingString:@"s : a* b ;\n"] stringByAppendingString:@"a : X ;\n"] stringByAppendingString:@"b : ^(ID INT) -> INT\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:@"34\n" param1:found];
}

- (void) testRewriteModeChainRuleTree3 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'boo' ID INT -> 'boo' ^(ID INT) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"tokens { X; }\n"] stringByAppendingString:@"s : 'boo' a* b ;\n"] stringByAppendingString:@"a : X ;\n"] stringByAppendingString:@"b : ^(ID INT) -> INT\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"boo abc 34"];
  [self assertEquals:@"boo 34\n" param1:found];
}

- (void) testRewriteModeChainRuleTree4 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'boo' ID INT -> ^('boo' ^(ID INT)) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"tokens { X; }\n"] stringByAppendingString:@"s : ^('boo' a* b) ;\n"] stringByAppendingString:@"a : X ;\n"] stringByAppendingString:@"b : ^(ID INT) -> INT\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"boo abc 34"];
  [self assertEquals:@"(boo 34)\n" param1:found];
}

- (void) testRewriteModeChainRuleTree5 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'boo' ID INT -> ^('boo' ^(ID INT)) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"tokens { X; }\n"] stringByAppendingString:@"s : ^(a b) ;\n"] stringByAppendingString:@"a : 'boo' ;\n"] stringByAppendingString:@"b : ^(ID INT) -> INT\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"boo abc 34"];
  [self assertEquals:@"(boo 34)\n" param1:found];
}

- (void) testRewriteOfRuleRef {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ID INT | INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : a -> a ;\n"] stringByAppendingString:@"a : ID INT -> ID INT ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testRewriteOfRuleRefRoot {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT INT -> ^(INT ^(ID INT));\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : ^(a ^(ID INT)) -> a ;\n"] stringByAppendingString:@"a : INT ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 12 34"];
  [self assertEquals:@"(12 (abc 34))\n" param1:found];
}

- (void) testRewriteOfRuleRefRootLabeled {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT INT -> ^(INT ^(ID INT));\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : ^(label=a ^(ID INT)) -> a ;\n"] stringByAppendingString:@"a : INT ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 12 34"];
  [self assertEquals:@"(12 (abc 34))\n" param1:found];
}

- (void) testRewriteOfRuleRefRootListLabeled {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT INT -> ^(INT ^(ID INT));\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : ^(label+=a ^(ID INT)) -> a ;\n"] stringByAppendingString:@"a : INT ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 12 34"];
  [self assertEquals:@"(12 (abc 34))\n" param1:found];
}

- (void) testRewriteOfRuleRefChild {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID ^(INT INT));\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : ^(ID a) -> a ;\n"] stringByAppendingString:@"a : ^(INT INT) ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:@"(34 34)\n" param1:found];
}

- (void) testRewriteOfRuleRefLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID ^(INT INT));\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : ^(ID label=a) -> a ;\n"] stringByAppendingString:@"a : ^(INT INT) ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:@"(34 34)\n" param1:found];
}

- (void) testRewriteOfRuleRefListLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID ^(INT INT));\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : ^(ID label+=a) -> a ;\n"] stringByAppendingString:@"a : ^(INT INT) ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:@"(34 34)\n" param1:found];
}

- (void) testRewriteModeWithPredicatedRewrites {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID[\"root\"] ^(ID INT)) | INT -> ^(ID[\"root\"] INT) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : ^(ID a) {System.out.println(\"altered tree=\"+$s.start.toStringTree());};\n"] stringByAppendingString:@"a : ^(ID INT) -> {true}? ^(ID[\"ick\"] INT)\n"] stringByAppendingString:@"              -> INT\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:[@"altered tree=(root (ick 34))\n" stringByAppendingString:@"(root (ick 34))\n"] param1:found];
}

- (void) testWildcardSingleNode {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID[\"root\"] INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"s : ^(ID c=.) -> $c\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:@"34\n" param1:found];
}

- (void) testWildcardUnlabeledSingleNode {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"s : ^(ID .) -> ID\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testWildcardGrabsSubtree {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID x=INT y=INT z=INT -> ^(ID[\"root\"] ^($x $y $z));\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"s : ^(ID c=.) -> $c\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 1 2 3"];
  [self assertEquals:@"(1 2 3)\n" param1:found];
}

- (void) testWildcardGrabsSubtree2 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID x=INT y=INT z=INT -> ID ^($x $y $z);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"s : ID c=. -> $c\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 1 2 3"];
  [self assertEquals:@"(1 2 3)\n" param1:found];
}

- (void) testWildcardListLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : INT INT INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"s : (c+=.)+ -> $c+\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"1 2 3"];
  [self assertEquals:@"1 2 3\n" param1:found];
}

- (void) testWildcardListLabel2 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree;}\n"] stringByAppendingString:@"a  : x=INT y=INT z=INT -> ^($x ^($y $z) ^($y $z));\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T; rewrite=true;}\n"] stringByAppendingString:@"s : ^(INT (c+=.)+) -> $c+\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"1 2 3"];
  [self assertEquals:@"(2 3) (2 3)\n" param1:found];
}

- (void) testRuleResultAsRoot {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID '=' INT -> ^('=' ID INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"COLON : ':' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; rewrite=true; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ^(eq e1=ID e2=.) -> ^(eq $e2 $e1) ;\n"] stringByAppendingString:@"eq : '=' | ':' {;} ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc = 34"];
  [self assertEquals:@"(= 34 abc)\n" param1:found];
}

@end
