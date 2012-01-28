#import "TestSemanticPredicateEvaluation.h"

@implementation TestSemanticPredicateEvaluation

- (void) testSimpleCyclicDFAWithPredicate {
  NSString * grammar = [[[@"grammar foo;\n" stringByAppendingString:@"a : {false}? 'x'* 'y' {System.out.println(\"alt1\");}\n"] stringByAppendingString:@"  | {true}?  'x'* 'y' {System.out.println(\"alt2\");}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"xxxy" param6:NO];
  [self assertEquals:@"alt2\n" param1:found];
}

- (void) testSimpleCyclicDFAWithInstanceVarPredicate {
  NSString * grammar = [[[[@"grammar foo;\n" stringByAppendingString:@"@members {boolean v=true;}\n"] stringByAppendingString:@"a : {false}? 'x'* 'y' {System.out.println(\"alt1\");}\n"] stringByAppendingString:@"  | {v}?     'x'* 'y' {System.out.println(\"alt2\");}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"xxxy" param6:NO];
  [self assertEquals:@"alt2\n" param1:found];
}

- (void) testPredicateValidation {
  NSString * grammar = [[[[[[[[@"grammar foo;\n" stringByAppendingString:@"@members {\n"] stringByAppendingString:@"public void reportError(RecognitionException e) {\n"] stringByAppendingString:@"    System.out.println(\"error: \"+e.toString());\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"a : {false}? 'x'\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"x" param6:NO];
  [self assertEquals:@"error: FailedPredicateException(a,{false}?)\n" param1:found];
}

- (void) testLexerPreds {
  NSString * grammar = [[[[@"grammar foo;" stringByAppendingString:@"@lexer::members {boolean p=false;}\n"] stringByAppendingString:@"a : (A|B)+ ;\n"] stringByAppendingString:@"A : {p}? 'a'  {System.out.println(\"token 1\");} ;\n"] stringByAppendingString:@"B : {!p}? 'a' {System.out.println(\"token 2\");} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"a" param6:NO];
  [self assertEquals:@"token 2\n" param1:found];
}

- (void) testLexerPreds2 {
  NSString * grammar = [[[[@"grammar foo;" stringByAppendingString:@"@lexer::members {boolean p=true;}\n"] stringByAppendingString:@"a : (A|B)+ ;\n"] stringByAppendingString:@"A : {p}? 'a' {System.out.println(\"token 1\");} ;\n"] stringByAppendingString:@"B : ('a'|'b')+ {System.out.println(\"token 2\");} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"a" param6:NO];
  [self assertEquals:@"token 1\n" param1:found];
}

- (void) testLexerPredInExitBranch {
  NSString * grammar = [[[[[@"grammar foo;" stringByAppendingString:@"@lexer::members {boolean p=true;}\n"] stringByAppendingString:@"a : (A|B)+ ;\n"] stringByAppendingString:@"A : ('a' {System.out.print(\"1\");})*\n"] stringByAppendingString:@"    {p}?\n"] stringByAppendingString:@"    ('a' {System.out.print(\"2\");})* ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"aaa" param6:NO];
  [self assertEquals:@"222\n" param1:found];
}

- (void) testLexerPredInExitBranch2 {
  NSString * grammar = [[[[@"grammar foo;" stringByAppendingString:@"@lexer::members {boolean p=true;}\n"] stringByAppendingString:@"a : (A|B)+ ;\n"] stringByAppendingString:@"A : ({p}? 'a' {System.out.print(\"1\");})*\n"] stringByAppendingString:@"    ('a' {System.out.print(\"2\");})* ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"aaa" param6:NO];
  [self assertEquals:@"111\n" param1:found];
}

- (void) testLexerPredInExitBranch3 {
  NSString * grammar = [[[[@"grammar foo;" stringByAppendingString:@"@lexer::members {boolean p=true;}\n"] stringByAppendingString:@"a : (A|B)+ ;\n"] stringByAppendingString:@"A : ({p}? 'a' {System.out.print(\"1\");} | )\n"] stringByAppendingString:@"    ('a' {System.out.print(\"2\");})* ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"aaa" param6:NO];
  [self assertEquals:@"122\n" param1:found];
}

- (void) testLexerPredInExitBranch4 {
  NSString * grammar = [[[@"grammar foo;" stringByAppendingString:@"a : (A|B)+ ;\n"] stringByAppendingString:@"A @init {int n=0;} : ({n<2}? 'a' {System.out.print(n++);})+\n"] stringByAppendingString:@"    ('a' {System.out.print(\"x\");})* ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"aaaaa" param6:NO];
  [self assertEquals:@"01xxx\n" param1:found];
}

- (void) testLexerPredsInCyclicDFA {
  NSString * grammar = [[[[@"grammar foo;" stringByAppendingString:@"@lexer::members {boolean p=false;}\n"] stringByAppendingString:@"a : (A|B)+ ;\n"] stringByAppendingString:@"A : {p}? ('a')+ 'x'  {System.out.println(\"token 1\");} ;\n"] stringByAppendingString:@"B :      ('a')+ 'x' {System.out.println(\"token 2\");} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"aax" param6:NO];
  [self assertEquals:@"token 2\n" param1:found];
}

- (void) testLexerPredsInCyclicDFA2 {
  NSString * grammar = [[[[@"grammar foo;" stringByAppendingString:@"@lexer::members {boolean p=false;}\n"] stringByAppendingString:@"a : (A|B)+ ;\n"] stringByAppendingString:@"A : {p}? ('a')+ 'x' ('y')? {System.out.println(\"token 1\");} ;\n"] stringByAppendingString:@"B :      ('a')+ 'x' {System.out.println(\"token 2\");} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"aax" param6:NO];
  [self assertEquals:@"token 2\n" param1:found];
}

- (void) testGatedPred {
  NSString * grammar = [[[@"grammar foo;" stringByAppendingString:@"a : (A|B)+ ;\n"] stringByAppendingString:@"A : {true}?=> 'a' {System.out.println(\"token 1\");} ;\n"] stringByAppendingString:@"B : {false}?=>('a'|'b')+ {System.out.println(\"token 2\");} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"aa" param6:NO];
  [self assertEquals:@"token 1\ntoken 1\n" param1:found];
}

- (void) testGatedPred2 {
  NSString * grammar = [[[[[@"grammar foo;\n" stringByAppendingString:@"@lexer::members {boolean sig=false;}\n"] stringByAppendingString:@"a : (A|B)+ ;\n"] stringByAppendingString:@"A : 'a' {System.out.print(\"A\"); sig=true;} ;\n"] stringByAppendingString:@"B : 'b' ;\n"] stringByAppendingString:@"C : {sig}?=> ('a'|'b') {System.out.print(\"C\");} ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"aa" param6:NO];
  [self assertEquals:@"AC\n" param1:found];
}

- (void) testPredWithActionTranslation {
  NSString * grammar = [[[[[@"grammar foo;\n" stringByAppendingString:@"a : b[2] ;\n"] stringByAppendingString:@"b[int i]\n"] stringByAppendingString:@"  : {$i==1}?   'a' {System.out.println(\"alt 1\");}\n"] stringByAppendingString:@"  | {$b.i==2}? 'a' {System.out.println(\"alt 2\");}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"aa" param6:NO];
  [self assertEquals:@"alt 2\n" param1:found];
}

- (void) testPredicatesOnEOTTarget {
  NSString * grammar = [[[[[[@"grammar foo; \n" stringByAppendingString:@"@lexer::members {boolean p=true, q=false;}"] stringByAppendingString:@"a : B ;\n"] stringByAppendingString:@"A: '</'; \n"] stringByAppendingString:@"B: {p}? '<!' {System.out.println(\"B\");};\n"] stringByAppendingString:@"C: {q}? '<' {System.out.println(\"C\");}; \n"] stringByAppendingString:@"D: '<';\n"];
  NSString * found = [self execParser:@"foo.g" param1:grammar param2:@"fooParser" param3:@"fooLexer" param4:@"a" param5:@"<!" param6:NO];
  [self assertEquals:@"B\n" param1:found];
}

- (void) _test {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a :  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {channel=99;} ;\n"];
  NSString * found = [self execParser:@"t.g" param1:grammar param2:@"T" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:NO];
  [self assertEquals:@"\n" param1:found];
}

@end
