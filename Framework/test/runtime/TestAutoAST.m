#import "TestAutoAST.h"

@implementation TestAutoAST

- (void) init {
  if (self = [super init]) {
    debug = NO;
  }
  return self;
}

- (void) testTokenList {
  NSString * grammar = [[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testTokenListInSingleAltBlock {
  NSString * grammar = [[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : (ID INT) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testSimpleRootAtOuterLevel {
  NSString * grammar = [[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID^ INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"(abc 34)\n" param1:found];
}

- (void) testSimpleRootAtOuterLevelReverse {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : INT ID^ ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"34 abc" param6:debug];
  [self assertEquals:@"(abc 34)\n" param1:found];
}

- (void) testBang {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT! ID! INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34 dag 4532" param6:debug];
  [self assertEquals:@"abc 4532\n" param1:found];
}

- (void) testOptionalThenRoot {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ( ID INT )? ID^ ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a 1 b" param6:debug];
  [self assertEquals:@"(b a 1)\n" param1:found];
}

- (void) testLabeledStringRoot {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : v='void'^ ID ';' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"void foo;" param6:debug];
  [self assertEquals:@"(void foo ;)\n" param1:found];
}

- (void) testWildcard {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : v='void'^ . ';' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"void foo;" param6:debug];
  [self assertEquals:@"(void foo ;)\n" param1:found];
}

- (void) testWildcardRoot {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : v='void' .^ ';' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"void foo;" param6:debug];
  [self assertEquals:@"(foo void ;)\n" param1:found];
}

- (void) testWildcardRootWithLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : v='void' x=.^ ';' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"void foo;" param6:debug];
  [self assertEquals:@"(foo void ;)\n" param1:found];
}

- (void) testWildcardRootWithListLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : v='void' x=.^ ';' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"void foo;" param6:debug];
  [self assertEquals:@"(foo void ;)\n" param1:found];
}

- (void) testWildcardBangWithListLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : v='void' x=.! ';' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"void foo;" param6:debug];
  [self assertEquals:@"void ;\n" param1:found];
}

- (void) testRootRoot {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID^ INT^ ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a 34 c" param6:debug];
  [self assertEquals:@"(34 a c)\n" param1:found];
}

- (void) testRootRoot2 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT^ ID^ ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a 34 c" param6:debug];
  [self assertEquals:@"(c (34 a))\n" param1:found];
}

- (void) testRootThenRootInLoop {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID^ (INT '*'^ ID)+ ;\n"] stringByAppendingString:@"ID  : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a 34 * b 9 * c" param6:debug];
  [self assertEquals:@"(* (* (a 34) b 9) c)\n" param1:found];
}

- (void) testNestedSubrule {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'void' (({;}ID|INT) ID | 'null' ) ';' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"void a b;" param6:debug];
  [self assertEquals:@"void a b ;\n" param1:found];
}

- (void) testInvokeRule {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a  : type ID ;\n"] stringByAppendingString:@"type : {;}'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"int a" param6:debug];
  [self assertEquals:@"int a\n" param1:found];
}

- (void) testInvokeRuleAsRoot {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a  : type^ ID ;\n"] stringByAppendingString:@"type : {;}'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"int a" param6:debug];
  [self assertEquals:@"(int a)\n" param1:found];
}

- (void) testInvokeRuleAsRootWithLabel {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a  : x=type^ ID ;\n"] stringByAppendingString:@"type : {;}'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"int a" param6:debug];
  [self assertEquals:@"(int a)\n" param1:found];
}

- (void) testInvokeRuleAsRootWithListLabel {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a  : x+=type^ ID ;\n"] stringByAppendingString:@"type : {;}'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"int a" param6:debug];
  [self assertEquals:@"(int a)\n" param1:found];
}

- (void) testRuleRootInLoop {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ('+'^ ID)* ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a+b+c+d" param6:debug];
  [self assertEquals:@"(+ (+ (+ a b) c) d)\n" param1:found];
}

- (void) testRuleInvocationRuleRootInLoop {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID (op^ ID)* ;\n"] stringByAppendingString:@"op : {;}'+' | '-' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a+b+c-d" param6:debug];
  [self assertEquals:@"(- (+ (+ a b) c) d)\n" param1:found];
}

- (void) testTailRecursion {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : atom ('exp'^ a)? ;\n"] stringByAppendingString:@"atom : INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"3 exp 4 exp 5" param6:debug];
  [self assertEquals:@"(exp 3 (exp 4 5))\n" param1:found];
}

- (void) testSet {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID|INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testSetRoot {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ('+' | '-')^ ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"+abc" param6:debug];
  [self assertEquals:@"(+ abc)\n" param1:found];
}

- (void) testSetRootWithLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x=('+' | '-')^ ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"+abc" param6:debug];
  [self assertEquals:@"(+ abc)\n" param1:found];
}

- (void) testSetAsRuleRootInLoop {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID (('+'|'-')^ ID)* ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a+b-c" param6:debug];
  [self assertEquals:@"(- (+ a b) c)\n" param1:found];
}

- (void) testNotSet {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ~ID '+' INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"34+2" param6:debug];
  [self assertEquals:@"34 + 2\n" param1:found];
}

- (void) testNotSetWithLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x=~ID '+' INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"34+2" param6:debug];
  [self assertEquals:@"34 + 2\n" param1:found];
}

- (void) testNotSetWithListLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x=~ID '+' INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"34+2" param6:debug];
  [self assertEquals:@"34 + 2\n" param1:found];
}

- (void) testNotSetRoot {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ~'+'^ INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"34 55" param6:debug];
  [self assertEquals:@"(34 55)\n" param1:found];
}

- (void) testNotSetRootWithLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ~'+'^ INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"34 55" param6:debug];
  [self assertEquals:@"(34 55)\n" param1:found];
}

- (void) testNotSetRootWithListLabel {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ~'+'^ INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"34 55" param6:debug];
  [self assertEquals:@"(34 55)\n" param1:found];
}

- (void) testNotSetRuleRootInLoop {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : INT (~INT^ INT)* ;\n"] stringByAppendingString:@"blort : '+' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"3+4+5" param6:debug];
  [self assertEquals:@"(+ (+ 3 4) 5)\n" param1:found];
}

- (void) testTokenLabelReuse {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : id=ID id=ID {System.out.print(\"2nd id=\"+$id.text+';');} ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"2nd id=b;a b\n" param1:found];
}

- (void) testTokenLabelReuse2 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : id=ID id=ID^ {System.out.print(\"2nd id=\"+$id.text+';');} ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"2nd id=b;(b a)\n" param1:found];
}

- (void) testTokenListLabelReuse {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ids+=ID ids+=ID {System.out.print(\"id list=\"+$ids+';');} ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  NSString * expecting = @"id list=[[@0,0:0='a',<4>,1:0], [@2,2:2='b',<4>,1:2]];a b\n";
  [self assertEquals:expecting param1:found];
}

- (void) testTokenListLabelReuse2 {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ids+=ID^ ids+=ID {System.out.print(\"id list=\"+$ids+';');} ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  NSString * expecting = @"id list=[[@0,0:0='a',<4>,1:0], [@2,2:2='b',<4>,1:2]];(a b)\n";
  [self assertEquals:expecting param1:found];
}

- (void) testTokenListLabelRuleRoot {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : id+=ID^ ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a\n" param1:found];
}

- (void) testTokenListLabelBang {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : id+=ID! ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"" param1:found];
}

- (void) testRuleListLabel {
  NSString * grammar = [[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x+=b x+=b {"] stringByAppendingString:@"Tree t=(Tree)$x.get(1);"] stringByAppendingString:@"System.out.print(\"2nd x=\"+t.toStringTree()+';');} ;\n"] stringByAppendingString:@"b : ID;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"2nd x=b;a b\n" param1:found];
}

- (void) testRuleListLabelRuleRoot {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ( x+=b^ )+ {"] stringByAppendingString:@"System.out.print(\"x=\"+((CommonTree)$x.get(1)).toStringTree()+';');} ;\n"] stringByAppendingString:@"b : ID;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"x=(b a);(b a)\n" param1:found];
}

- (void) testRuleListLabelBang {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x+=b! x+=b {"] stringByAppendingString:@"System.out.print(\"1st x=\"+((CommonTree)$x.get(0)).toStringTree()+';');} ;\n"] stringByAppendingString:@"b : ID;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b" param6:debug];
  [self assertEquals:@"1st x=a;b\n" param1:found];
}

- (void) testComplicatedMelange {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : A b=B b=B c+=C c+=C D {String s = $D.text;} ;\n"] stringByAppendingString:@"A : 'a' ;\n"] stringByAppendingString:@"B : 'b' ;\n"] stringByAppendingString:@"C : 'c' ;\n"] stringByAppendingString:@"D : 'd' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a b b c c d" param6:debug];
  [self assertEquals:@"a b b c c d\n" param1:found];
}

- (void) testReturnValueWithAST {
  NSString * grammar = [[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID b {System.out.println($b.i);} ;\n"] stringByAppendingString:@"b returns [int i] : INT {$i=Integer.parseInt($INT.text);} ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"34\nabc 34\n" param1:found];
}

- (void) testSetLoop {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options { output=AST; }\n"] stringByAppendingString:@"r : (INT|ID)+ ; \n"] stringByAppendingString:@"ID : 'a'..'z' + ;\n"] stringByAppendingString:@"INT : '0'..'9' +;\n"] stringByAppendingString:@"WS: (' ' | '\\n' | '\\t')+ {$channel = HIDDEN;};\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"r" param5:@"abc 34 d" param6:debug];
  [self assertEquals:@"abc 34 d\n" param1:found];
}

- (void) testExtraTokenInSimpleDecl {
  NSString * grammar = [[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"decl : type^ ID '='! INT ';'! ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"decl" param5:@"int 34 x=1;" param6:debug];
  [self assertEquals:@"line 1:4 extraneous input '34' expecting ID\n" param1:stderrDuringParse];
  [self assertEquals:@"(int x 1)\n" param1:found];
}

- (void) testMissingIDInSimpleDecl {
  NSString * grammar = [[[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {EXPR;}\n"] stringByAppendingString:@"decl : type^ ID '='! INT ';'! ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"decl" param5:@"int =1;" param6:debug];
  [self assertEquals:@"line 1:4 missing ID at '='\n" param1:stderrDuringParse];
  [self assertEquals:@"(int <missing ID> 1)\n" param1:found];
}

- (void) testMissingSetInSimpleDecl {
  NSString * grammar = [[[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {EXPR;}\n"] stringByAppendingString:@"decl : type^ ID '='! INT ';'! ;\n"] stringByAppendingString:@"type : 'int' | 'float' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"decl" param5:@"x=1;" param6:debug];
  [self assertEquals:@"line 1:0 mismatched input 'x' expecting set null\n" param1:stderrDuringParse];
  [self assertEquals:@"(<error: x> x 1)\n" param1:found];
}

- (void) testMissingTokenGivesErrorNode {
  NSString * grammar = [[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"line 1:3 missing INT at '<EOF>'\n" param1:stderrDuringParse];
  [self assertEquals:@"abc <missing INT>\n" param1:found];
}

- (void) testMissingTokenGivesErrorNodeInInvokedRule {
  NSString * grammar = [[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b ;\n"] stringByAppendingString:@"b : ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"abc" param6:debug];
  [self assertEquals:@"line 1:3 mismatched input '<EOF>' expecting INT\n" param1:stderrDuringParse];
  [self assertEquals:@"<mismatched token: [@1,3:3='<EOF>',<-1>,1:3], resync=abc>\n" param1:found];
}

- (void) testExtraTokenGivesErrorNode {
  NSString * grammar = [[[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b c ;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"c : INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"abc ick 34" param6:debug];
  [self assertEquals:@"line 1:4 extraneous input 'ick' expecting INT\n" param1:stderrDuringParse];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testMissingFirstTokenGivesErrorNode {
  NSString * grammar = [[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"34" param6:debug];
  [self assertEquals:@"line 1:0 missing ID at '34'\n" param1:stderrDuringParse];
  [self assertEquals:@"<missing ID> 34\n" param1:found];
}

- (void) testMissingFirstTokenGivesErrorNode2 {
  NSString * grammar = [[[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b c ;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"c : INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"34" param6:debug];
  [self assertEquals:@"line 1:0 missing ID at '34'\n" param1:stderrDuringParse];
  [self assertEquals:@"<missing ID> 34\n" param1:found];
}

- (void) testNoViableAltGivesErrorNode {
  NSString * grammar = [[[[[[[[@"grammar foo;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b | c ;\n"] stringByAppendingString:@"b : ID ;\n"] stringByAppendingString:@"c : INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"S : '*' ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"*" param6:debug];
  [self assertEquals:@"line 1:0 no viable alternative at input '*'\n" param1:stderrDuringParse];
  [self assertEquals:@"<unexpected: [@0,0:0='*',<6>,1:0], resync=*>\n" param1:found];
}

- (void) _test {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a :  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"\n" param1:found];
}

@end
