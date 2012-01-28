#import "TestRewriteAST.h"

@implementation TestRewriteAST

- (void) init {
  if (self = [super init]) {
    debug = NO;
  }
  return self;
}

- (void) testDelete {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"" param1:found];
}

- (void) testSingleToken {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID -> ID;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testSingleTokenToNewNode {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID -> ID[\"x\"];\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"x\n" param1:found];
}

- (void) testSingleTokenToNewNodeRoot {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID -> ^(ID[\"x\"] INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"(x INT)\n" param1:found];
}

- (void) testSingleTokenToNewNode2 {
  NSString * grammar = [[[[[@"grammar TT;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID -> ID[ ];\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"TT.g" param1:grammar param2:@"TTParser" param3:@"TTLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"ID\n" param1:found];
}

- (void) testSingleCharLiteral {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'c' -> 'c';\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"c" param6:debug];
  [self assertEquals:@"c\n" param1:found];
}

- (void) testSingleStringLiteral {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'ick' -> 'ick';\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"ick" param6:debug];
  [self assertEquals:@"ick\n" param1:found];
}

- (void) testSingleRule {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b -> b;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testReorderTokens {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> INT ID;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"34 abc\n" param1:found];
}

- (void) testReorderTokenAndRule {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b INT -> INT b;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"34 abc\n" param1:found];
}

- (void) testTokenTree {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(INT ID);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"(34 abc)\n" param1:found];
}

- (void) testTokenTreeAfterOtherStuff {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'void' ID INT -> 'void' ^(INT ID);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"void abc 34" param6:debug];
  [self assertEquals:@"void (34 abc)\n" param1:found];
}

- (void) testNestedTokenTreeWithOuterLoop {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {DUH;}\n"] stringByAppendingString:@"a : ID INT ID INT -> ^( DUH ID ^( DUH INT) )+ ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a 1 b 2" param6:debug];
  [self assertEquals:@"(DUH a (DUH 1)) (DUH b (DUH 2))\n" param1:found];
}

- (void) testOptionalSingleToken {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID -> ID? ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testClosureSingleToken {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ID -> ID* ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"a b\n" param1:found];
}

- (void) testPositiveClosureSingleToken {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ID -> ID+ ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"a b\n" param1:found];
}

- (void) testOptionalSingleRule {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b -> b?;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testClosureSingleRule {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b b -> b*;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"a b\n" param1:found];
}

- (void) testClosureOfLabel {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x+=b x+=b -> $x*;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"a b\n" param1:found];
}

- (void) testOptionalLabelNoListLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : (x=ID)? -> $x?;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a\n" param1:found];
}

- (void) testPositiveClosureSingleRule {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b b -> b+;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"a b\n" param1:found];
}

- (void) testSinglePredicateT {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID -> {true}? ID -> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testSinglePredicateF {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID -> {false}? ID -> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"" param1:found];
}

- (void) testMultiplePredicate {
  NSString * grammar = [[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> {false}? ID\n"] stringByAppendingString:@"           -> {true}? INT\n"] stringByAppendingString:@"           -> \n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a 2" param6:debug];
  [self assertEquals:@"2\n" param1:found];
}

- (void) testMultiplePredicateTrees {
  NSString * grammar = [[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> {false}? ^(ID INT)\n"] stringByAppendingString:@"           -> {true}? ^(INT ID)\n"] stringByAppendingString:@"           -> ID\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a 2" param6:debug];
  [self assertEquals:@"(2 a)\n" param1:found];
}

- (void) testSimpleTree {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : op INT -> ^(op INT);\n"] stringByAppendingString:@"op : '+'|'-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"-34" param6:debug];
  [self assertEquals:@"(- 34)\n" param1:found];
}

- (void) testSimpleTree2 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : op INT -> ^(INT op);\n"] stringByAppendingString:@"op : '+'|'-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"+ 34" param6:debug];
  [self assertEquals:@"(34 +)\n" param1:found];
}

- (void) testNestedTrees {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'var' (ID ':' type ';')+ -> ^('var' ^(':' ID type)+) ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"var a:int; b:float;" param6:debug];
  [self assertEquals:@"(var (: a int) (: b float))\n" param1:found];
}

- (void) testImaginaryTokenCopy {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {VAR;}\n"] stringByAppendingString:@"a : ID (',' ID)*-> ^(VAR ID)+ ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a,b,c" param6:debug];
  [self assertEquals:@"(VAR a) (VAR b) (VAR c)\n" param1:found];
}

- (void) testTokenUnreferencedOnLeftButDefined {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {VAR;}\n"] stringByAppendingString:@"a : b -> ID ;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"ID\n" param1:found];
}

- (void) testImaginaryTokenCopySetText {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {VAR;}\n"] stringByAppendingString:@"a : ID (',' ID)*-> ^(VAR[\"var\"] ID)+ ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a,b,c" param6:debug];
  [self assertEquals:@"(var a) (var b) (var c)\n" param1:found];
}

- (void) testImaginaryTokenNoCopyFromToken {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : lc='{' ID+ '}' -> ^(BLOCK[$lc] ID+) ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"{a b c}" param6:debug];
  [self assertEquals:@"({ a b c)\n" param1:found];
}

- (void) testImaginaryTokenNoCopyFromTokenSetText {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : lc='{' ID+ '}' -> ^(BLOCK[$lc,\"block\"] ID+) ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"{a b c}" param6:debug];
  [self assertEquals:@"(block a b c)\n" param1:found];
}

- (void) testMixedRewriteAndAutoAST {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : b b^ ;\n"] stringByAppendingString:@"b : ID INT -> INT ID\n"] stringByAppendingString:@"  | INT\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a 1 2" param6:debug];
  [self assertEquals:@"(2 1 a)\n" param1:found];
}

- (void) testSubruleWithRewrite {
  NSString * grammar = [[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : b b ;\n"] stringByAppendingString:@"b : (ID INT -> INT ID | INT INT -> INT+ )\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a 1 2 3" param6:debug];
  [self assertEquals:@"1 a 2 3\n" param1:found];
}

- (void) testSubruleWithRewrite2 {
  NSString * grammar = [[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {TYPE;}\n"] stringByAppendingString:@"a : b b ;\n"] stringByAppendingString:@"b : 'int'\n"] stringByAppendingString:@"    ( ID -> ^(TYPE 'int' ID)\n"] stringByAppendingString:@"    | ID '=' INT -> ^(TYPE 'int' ID INT)\n"] stringByAppendingString:@"    )\n"] stringByAppendingString:@"    ';'\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"int a; int b=3;" param6:debug];
  [self assertEquals:@"(TYPE int a) (TYPE int b 3)\n" param1:found];
}

- (void) testNestedRewriteShutsOffAutoAST {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : b b ;\n"] stringByAppendingString:@"b : ID ( ID (last=ID -> $last)+ ) ';'\n"] stringByAppendingString:@"  | INT\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b c d; 42" param6:debug];
  [self assertEquals:@"d 42\n" param1:found];
}

- (void) testRewriteActions {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : atom -> ^({adaptor.create(INT,\"9\")} atom) ;\n"] stringByAppendingString:@"atom : INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"3" param6:debug];
  [self assertEquals:@"(9 3)\n" param1:found];
}

- (void) testRewriteActions2 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : atom -> {adaptor.create(INT,\"9\")} atom ;\n"] stringByAppendingString:@"atom : INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"3" param6:debug];
  [self assertEquals:@"9 3\n" param1:found];
}

- (void) testRefToOldValue {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : (atom -> atom) (op='+' r=atom -> ^($op $a $r) )* ;\n"] stringByAppendingString:@"atom : INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"3+4+5" param6:debug];
  [self assertEquals:@"(+ (+ 3 4) 5)\n" param1:found];
}

- (void) testCopySemanticsForRules {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : atom -> ^(atom atom) ;\n"] stringByAppendingString:@"atom : INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"3" param6:debug];
  [self assertEquals:@"(3 3)\n" param1:found];
}

- (void) testCopySemanticsForRules2 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : type ID (',' ID)* ';' -> ^(type ID)+ ;\n"] stringByAppendingString:@"type : 'int' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"int a,b,c;" param6:debug];
  [self assertEquals:@"(int a) (int b) (int c)\n" param1:found];
}

- (void) testCopySemanticsForRules3 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : modifier? type ID (',' ID)* ';' -> ^(type modifier? ID)+ ;\n"] stringByAppendingString:@"type : 'int' ;\n"] stringByAppendingString:@"modifier : 'public' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"public int a,b,c;" param6:debug];
  [self assertEquals:@"(int public a) (int public b) (int public c)\n" param1:found];
}

- (void) testCopySemanticsForRules3Double {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : modifier? type ID (',' ID)* ';' -> ^(type modifier? ID)+ ^(type modifier? ID)+ ;\n"] stringByAppendingString:@"type : 'int' ;\n"] stringByAppendingString:@"modifier : 'public' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"public int a,b,c;" param6:debug];
  [self assertEquals:@"(int public a) (int public b) (int public c) (int public a) (int public b) (int public c)\n" param1:found];
}

- (void) testCopySemanticsForRules4 {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {MOD;}\n"] stringByAppendingString:@"a : modifier? type ID (',' ID)* ';' -> ^(type ^(MOD modifier)? ID)+ ;\n"] stringByAppendingString:@"type : 'int' ;\n"] stringByAppendingString:@"modifier : 'public' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"public int a,b,c;" param6:debug];
  [self assertEquals:@"(int (MOD public) a) (int (MOD public) b) (int (MOD public) c)\n" param1:found];
}

- (void) testCopySemanticsLists {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {MOD;}\n"] stringByAppendingString:@"a : ID (',' ID)* ';' -> ID+ ID+ ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a,b,c;" param6:debug];
  [self assertEquals:@"a b c a b c\n" param1:found];
}

- (void) testCopyRuleLabel {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : x=b -> $x $x;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a a\n" param1:found];
}

- (void) testCopyRuleLabel2 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : x=b -> ^($x $x);\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"(a a)\n" param1:found];
}

- (void) testQueueingOfTokens {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'int' ID (',' ID)* ';' -> ^('int' ID+) ;\n"] stringByAppendingString:@"op : '+'|'-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"int a,b,c;" param6:debug];
  [self assertEquals:@"(int a b c)\n" param1:found];
}

- (void) testCopyOfTokens {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'int' ID ';' -> 'int' ID 'int' ID ;\n"] stringByAppendingString:@"op : '+'|'-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"int a;" param6:debug];
  [self assertEquals:@"int a int a\n" param1:found];
}

- (void) testTokenCopyInLoop {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'int' ID (',' ID)* ';' -> ^('int' ID)+ ;\n"] stringByAppendingString:@"op : '+'|'-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"int a,b,c;" param6:debug];
  [self assertEquals:@"(int a) (int b) (int c)\n" param1:found];
}

- (void) testTokenCopyInLoopAgainstTwoOthers {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'int' ID ':' INT (',' ID ':' INT)* ';' -> ^('int' ID INT)+ ;\n"] stringByAppendingString:@"op : '+'|'-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"int a:1,b:2,c:3;" param6:debug];
  [self assertEquals:@"(int a 1) (int b 2) (int c 3)\n" param1:found];
}

- (void) testListRefdOneAtATime {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID+ -> ID ID ID ;\n"] stringByAppendingString:@"op : '+'|'-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b c" param6:debug];
  [self assertEquals:@"a b c\n" param1:found];
}

- (void) testSplitListWithLabels {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {VAR;}\n"] stringByAppendingString:@"a : first=ID others+=ID* -> $first VAR $others+ ;\n"] stringByAppendingString:@"op : '+'|'-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b c" param6:debug];
  [self assertEquals:@"a VAR b c\n" param1:found];
}

- (void) testComplicatedMelange {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : A A b=B B b=B c+=C C c+=C D {String s=$D.text;} -> A+ B+ C+ D ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"A : 'a' ;\n"] stringByAppendingString:@"B : 'b' ;\n"] stringByAppendingString:@"C : 'c' ;\n"] stringByAppendingString:@"D : 'd' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a a b b b c c c d" param6:debug];
  [self assertEquals:@"a a b b b c c c d\n" param1:found];
}

- (void) testRuleLabel {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : x=b -> $x;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a\n" param1:found];
}

- (void) testAmbiguousRule {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID a -> a | INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT: '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"34\n" param1:found];
}

- (void) testWeirdRuleRef {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID a -> $a | INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT: '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  Grammar * g = [[[Grammar alloc] init:grammar] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:1 param2:[equeue.errors size]];
}

- (void) testRuleListLabel {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : x+=b x+=b -> $x+;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"a b\n" param1:found];
}

- (void) testRuleListLabel2 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : x+=b x+=b -> $x $x*;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"a b\n" param1:found];
}

- (void) testOptional {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : x=b (y=b)? -> $x $y?;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a\n" param1:found];
}

- (void) testOptional2 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : x=ID (y=b)? -> $x $y?;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"a b\n" param1:found];
}

- (void) testOptional3 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : x=ID (y=b)? -> ($x $y)?;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"a b\n" param1:found];
}

- (void) testOptional4 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : x+=ID (y=b)? -> ($x $y)?;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"a b\n" param1:found];
}

- (void) testOptional5 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : ID -> ID? ;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a\n" param1:found];
}

- (void) testArbitraryExprType {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : x+=b x+=b -> {new CommonTree()};\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"" param1:found];
}

- (void) testSet {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options { output = AST; } \n"] stringByAppendingString:@"a: (INT|ID)+ -> INT+ ID+ ;\n"] stringByAppendingString:@"INT: '0'..'9'+;\n"] stringByAppendingString:@"ID : 'a'..'z'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"2 a 34 de" param6:debug];
  [self assertEquals:@"2 34 a de\n" param1:found];
}

- (void) testSet2 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options { output = AST; } \n"] stringByAppendingString:@"a: (INT|ID) -> INT? ID? ;\n"] stringByAppendingString:@"INT: '0'..'9'+;\n"] stringByAppendingString:@"ID : 'a'..'z'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"2" param6:debug];
  [self assertEquals:@"2\n" param1:found];
}

- (void) testSetWithLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options { output = AST; } \n"] stringByAppendingString:@"a : x=(INT|ID) -> $x ;\n"] stringByAppendingString:@"INT: '0'..'9'+;\n"] stringByAppendingString:@"ID : 'a'..'z'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"2" param6:debug];
  [self assertEquals:@"2\n" param1:found];
}

- (void) testRewriteAction {
  NSString * grammar = [[[[[[[@"grammar T; \n" stringByAppendingString:@"options { output = AST; }\n"] stringByAppendingString:@"tokens { FLOAT; }\n"] stringByAppendingString:@"r\n"] stringByAppendingString:@"    : INT -> {new CommonTree(new CommonToken(FLOAT,$INT.text+\".0\"))} \n"] stringByAppendingString:@"    ; \n"] stringByAppendingString:@"INT : '0'..'9'+; \n"] stringByAppendingString:@"WS: (' ' | '\\n' | '\\t')+ {$channel = HIDDEN;}; \n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"r" param5:@"25" param6:debug];
  [self assertEquals:@"25.0\n" param1:found];
}

- (void) testOptionalSubruleWithoutRealElements {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;} \n"] stringByAppendingString:@"tokens {PARMS;} \n"] stringByAppendingString:@"\n"] stringByAppendingString:@"modulo \n"] stringByAppendingString:@" : 'modulo' ID ('(' parms+ ')')? -> ^('modulo' ID ^(PARMS parms+)?) \n"] stringByAppendingString:@" ; \n"] stringByAppendingString:@"parms : '#'|ID; \n"] stringByAppendingString:@"ID : ('a'..'z' | 'A'..'Z')+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"modulo" param5:@"modulo abc (x y #)" param6:debug];
  [self assertEquals:@"(modulo abc (PARMS x y #))\n" param1:found];
}

- (void) testCardinality {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {BLOCK;}\n"] stringByAppendingString:@"a : ID ID INT INT INT -> (ID INT)+;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+; \n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b 3 4 5" param6:debug];
  NSString * expecting = @"org.antlr.runtime.tree.RewriteCardinalityException: token ID";
  NSString * found = [self firstLineOfException];
  [self assertEquals:expecting param1:found];
}

- (void) testCardinality2 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID+ -> ID ID ID ;\n"] stringByAppendingString:@"op : '+'|'-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  NSString * expecting = @"org.antlr.runtime.tree.RewriteCardinalityException: token ID";
  NSString * found = [self firstLineOfException];
  [self assertEquals:expecting param1:found];
}

- (void) testCardinality3 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID? INT -> ID INT ;\n"] stringByAppendingString:@"op : '+'|'-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"3" param6:debug];
  NSString * expecting = @"org.antlr.runtime.tree.RewriteEmptyStreamException: token ID";
  NSString * found = [self firstLineOfException];
  [self assertEquals:expecting param1:found];
}

- (void) testLoopCardinality {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID? INT -> ID+ INT ;\n"] stringByAppendingString:@"op : '+'|'-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"3" param6:debug];
  NSString * expecting = @"org.antlr.runtime.tree.RewriteEarlyExitException";
  NSString * found = [self firstLineOfException];
  [self assertEquals:expecting param1:found];
}

- (void) testWildcard {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID c=. -> $c;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"34\n" param1:found];
}

- (void) testUnknownRule {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : INT -> ugh ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  Grammar * g = [[[Grammar alloc] init:grammar] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_UNDEFINED_RULE_REF;
  NSObject * expectedArg = @"ugh";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue param1:expectedMessage];
}

- (void) testKnownRuleButNotInLHS {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : INT -> b ;\n"] stringByAppendingString:@"b : 'b' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  Grammar * g = [[[Grammar alloc] init:grammar] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_REWRITE_ELEMENT_NOT_PRESENT_ON_LHS;
  NSObject * expectedArg = @"b";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue param1:expectedMessage];
}

- (void) testUnknownToken {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : INT -> ICK ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  Grammar * g = [[[Grammar alloc] init:grammar] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_UNDEFINED_TOKEN_REF_IN_REWRITE;
  NSObject * expectedArg = @"ICK";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue param1:expectedMessage];
}

- (void) testUnknownLabel {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : INT -> $foo ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  Grammar * g = [[[Grammar alloc] init:grammar] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_UNDEFINED_LABEL_REF_IN_REWRITE;
  NSObject * expectedArg = @"foo";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue param1:expectedMessage];
}

- (void) testUnknownCharLiteralToken {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : INT -> 'a' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  Grammar * g = [[[Grammar alloc] init:grammar] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_UNDEFINED_TOKEN_REF_IN_REWRITE;
  NSObject * expectedArg = @"'a'";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue param1:expectedMessage];
}

- (void) testUnknownStringLiteralToken {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : INT -> 'foo' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  Grammar * g = [[[Grammar alloc] init:grammar] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_UNDEFINED_TOKEN_REF_IN_REWRITE;
  NSObject * expectedArg = @"'foo'";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue param1:expectedMessage];
}

- (void) testExtraTokenInSimpleDecl {
  NSString * grammar = [[[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {EXPR;}\n"] stringByAppendingString:@"decl : type ID '=' INT ';' -> ^(EXPR type ID INT) ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"decl" param5:@"int 34 x=1;" param6:debug];
  [self assertEquals:@"line 1:4 extraneous input '34' expecting ID\n" param1:stderrDuringParse];
  [self assertEquals:@"(EXPR int x 1)\n" param1:found];
}

- (void) testMissingIDInSimpleDecl {
  NSString * grammar = [[[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {EXPR;}\n"] stringByAppendingString:@"decl : type ID '=' INT ';' -> ^(EXPR type ID INT) ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"decl" param5:@"int =1;" param6:debug];
  [self assertEquals:@"line 1:4 missing ID at '='\n" param1:stderrDuringParse];
  [self assertEquals:@"(EXPR int <missing ID> 1)\n" param1:found];
}

- (void) testMissingSetInSimpleDecl {
  NSString * grammar = [[[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {EXPR;}\n"] stringByAppendingString:@"decl : type ID '=' INT ';' -> ^(EXPR type ID INT) ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"decl" param5:@"x=1;" param6:debug];
  [self assertEquals:@"line 1:0 mismatched input 'x' expecting set null\n" param1:stderrDuringParse];
  [self assertEquals:@"(EXPR <error: x> x 1)\n" param1:found];
}

- (void) testMissingTokenGivesErrorNode {
  NSString * grammar = [[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"line 1:3 missing INT at '<EOF>'\n" param1:stderrDuringParse];
  [self assertEquals:@"abc <missing INT>\n" param1:found];
}

- (void) testExtraTokenGivesErrorNode {
  NSString * grammar = [[[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b c -> b c;\n"] stringByAppendingString:@"b : ID -> ID ;\n"] stringByAppendingString:@"c : INT -> INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"abc ick 34" param6:debug];
  [self assertEquals:@"line 1:4 extraneous input 'ick' expecting INT\n" param1:stderrDuringParse];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testMissingFirstTokenGivesErrorNode {
  NSString * grammar = [[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"34" param6:debug];
  [self assertEquals:@"line 1:0 missing ID at '34'\n" param1:stderrDuringParse];
  [self assertEquals:@"<missing ID> 34\n" param1:found];
}

- (void) testMissingFirstTokenGivesErrorNode2 {
  NSString * grammar = [[[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b c -> b c;\n"] stringByAppendingString:@"b : ID -> ID ;\n"] stringByAppendingString:@"c : INT -> INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"34" param6:debug];
  [self assertEquals:@"line 1:0 missing ID at '34'\n" param1:stderrDuringParse];
  [self assertEquals:@"<missing ID> 34\n" param1:found];
}

- (void) testNoViableAltGivesErrorNode {
  NSString * grammar = [[[[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b -> b | c -> c;\n"] stringByAppendingString:@"b : ID -> ID ;\n"] stringByAppendingString:@"c : INT -> INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"S : '*' ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"*" param6:debug];
  [self assertEquals:@"line 1:0 no viable alternative at input '*'\n" param1:stderrDuringParse];
  [self assertEquals:@"<unexpected: [@0,0:0='*',<6>,1:0], resync=*>\n" param1:found];
}

@end
