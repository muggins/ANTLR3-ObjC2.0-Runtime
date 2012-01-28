#import "TestSets.h"

@implementation TestSets


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
    debug = NO;
  }
  return self;
}

- (void) testSeqDoesNotBecomeSet {
  NSString * grammar = [[[[@"grammar P;\n" stringByAppendingString:@"a : C {System.out.println(input);} ;\n"] stringByAppendingString:@"fragment A : '1' | '2';\n"] stringByAppendingString:@"fragment B : '3' '4';\n"] stringByAppendingString:@"C : A | B;\n"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"34" param6:debug];
  [self assertEquals:@"34\n" param1:found];
}

- (void) testParserSet {
  NSString * grammar = [@"grammar T;\n" stringByAppendingString:@"a : t=('x'|'y') {System.out.println($t.text);} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:debug];
  [self assertEquals:@"x\n" param1:found];
}

- (void) testParserNotSet {
  NSString * grammar = [@"grammar T;\n" stringByAppendingString:@"a : t=~('x'|'y') 'z' {System.out.println($t.text);} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"zz" param6:debug];
  [self assertEquals:@"z\n" param1:found];
}

- (void) testParserNotToken {
  NSString * grammar = [@"grammar T;\n" stringByAppendingString:@"a : ~'x' 'z' {System.out.println(input);} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"zz" param6:debug];
  [self assertEquals:@"zz\n" param1:found];
}

- (void) testParserNotTokenWithLabel {
  NSString * grammar = [@"grammar T;\n" stringByAppendingString:@"a : t=~'x' 'z' {System.out.println($t.text);} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"zz" param6:debug];
  [self assertEquals:@"z\n" param1:found];
}

- (void) testRuleAsSet {
  NSString * grammar = [@"grammar T;\n" stringByAppendingString:@"a @after {System.out.println(input);} : 'a' | 'b' |'c' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"b" param6:debug];
  [self assertEquals:@"b\n" param1:found];
}

- (void) testRuleAsSetAST {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : 'a' | 'b' |'c' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"b" param6:debug];
  [self assertEquals:@"b\n" param1:found];
}

- (void) testNotChar {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println($A.text);} ;\n"] stringByAppendingString:@"A : ~'b' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:debug];
  [self assertEquals:@"x\n" param1:found];
}

- (void) testOptionalSingleElement {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"a : A? 'c' {System.out.println(input);} ;\n"] stringByAppendingString:@"A : 'b' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"bc" param6:debug];
  [self assertEquals:@"bc\n" param1:found];
}

- (void) testOptionalLexerSingleElement {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println(input);} ;\n"] stringByAppendingString:@"A : 'b'? 'c' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"bc" param6:debug];
  [self assertEquals:@"bc\n" param1:found];
}

- (void) testStarLexerSingleElement {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println(input);} ;\n"] stringByAppendingString:@"A : 'b'* 'c' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"bbbbc" param6:debug];
  [self assertEquals:@"bbbbc\n" param1:found];
  found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"c" param6:debug];
  [self assertEquals:@"c\n" param1:found];
}

- (void) testPlusLexerSingleElement {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println(input);} ;\n"] stringByAppendingString:@"A : 'b'+ 'c' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"bbbbc" param6:debug];
  [self assertEquals:@"bbbbc\n" param1:found];
}

- (void) testOptionalSet {
  NSString * grammar = [@"grammar T;\n" stringByAppendingString:@"a : ('a'|'b')? 'c' {System.out.println(input);} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"ac" param6:debug];
  [self assertEquals:@"ac\n" param1:found];
}

- (void) testStarSet {
  NSString * grammar = [@"grammar T;\n" stringByAppendingString:@"a : ('a'|'b')* 'c' {System.out.println(input);} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abaac" param6:debug];
  [self assertEquals:@"abaac\n" param1:found];
}

- (void) testPlusSet {
  NSString * grammar = [@"grammar T;\n" stringByAppendingString:@"a : ('a'|'b')+ 'c' {System.out.println(input);} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abaac" param6:debug];
  [self assertEquals:@"abaac\n" param1:found];
}

- (void) testLexerOptionalSet {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println(input);} ;\n"] stringByAppendingString:@"A : ('a'|'b')? 'c' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"ac" param6:debug];
  [self assertEquals:@"ac\n" param1:found];
}

- (void) testLexerStarSet {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println(input);} ;\n"] stringByAppendingString:@"A : ('a'|'b')* 'c' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abaac" param6:debug];
  [self assertEquals:@"abaac\n" param1:found];
}

- (void) testLexerPlusSet {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println(input);} ;\n"] stringByAppendingString:@"A : ('a'|'b')+ 'c' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abaac" param6:debug];
  [self assertEquals:@"abaac\n" param1:found];
}

- (void) testNotCharSet {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println($A.text);} ;\n"] stringByAppendingString:@"A : ~('b'|'c') ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:debug];
  [self assertEquals:@"x\n" param1:found];
}

- (void) testNotCharSetWithLabel {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println($A.text);} ;\n"] stringByAppendingString:@"A : h=~('b'|'c') ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:debug];
  [self assertEquals:@"x\n" param1:found];
}

- (void) testNotCharSetWithRuleRef {
  NSString * grammar = [[[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println($A.text);} ;\n"] stringByAppendingString:@"A : ~('a'|B) ;\n"] stringByAppendingString:@"B : 'b' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:debug];
  [self assertEquals:@"x\n" param1:found];
}

- (void) testNotCharSetWithRuleRef2 {
  NSString * grammar = [[[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println($A.text);} ;\n"] stringByAppendingString:@"A : ~('a'|B) ;\n"] stringByAppendingString:@"B : 'b'|'c' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:debug];
  [self assertEquals:@"x\n" param1:found];
}

- (void) testNotCharSetWithRuleRef3 {
  NSString * grammar = [[[[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println($A.text);} ;\n"] stringByAppendingString:@"A : ('a'|B) ;\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"B : ~('a'|'c') ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:debug];
  [self assertEquals:@"x\n" param1:found];
}

- (void) testNotCharSetWithRuleRef4 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"a : A {System.out.println($A.text);} ;\n"] stringByAppendingString:@"A : ('a'|B) ;\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"B : ~('a'|C) ;\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"C : 'c'|'d' ;\n "];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:debug];
  [self assertEquals:@"x\n" param1:found];
}

@end
