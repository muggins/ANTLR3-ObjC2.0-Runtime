#import "TestLexer.h"

@implementation TestLexer


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
    debug = NO;
  }
  return self;
}

- (void) testSetText {
  NSString * grammar = [[[@"grammar P;\n" stringByAppendingString:@"a : A {System.out.println(input);} ;\n"] stringByAppendingString:@"A : '\\\\' 't' {setText(\"\t\");} ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"\\t" param6:debug];
  [self assertEquals:@"\t\n" param1:found];
}

- (void) testRefToRuleDoesNotSetTokenNorEmitAnother {
  NSString * grammar = [[[[@"grammar P;\n" stringByAppendingString:@"a : A EOF {System.out.println(input);} ;\n"] stringByAppendingString:@"A : '-' I ;\n"] stringByAppendingString:@"I : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"-34" param6:debug];
  [self assertEquals:@"-34\n" param1:found];
}

- (void) testRefToRuleDoesNotSetChannel {
  NSString * grammar = [[[[@"grammar P;\n" stringByAppendingString:@"a : A EOF {System.out.println($A.text+\", channel=\"+$A.channel);} ;\n"] stringByAppendingString:@"A : '-' WS I ;\n"] stringByAppendingString:@"I : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"- 34" param6:debug];
  [self assertEquals:@"- 34, channel=0\n" param1:found];
}

- (void) testWeCanSetType {
  NSString * grammar = [[[[[@"grammar P;\n" stringByAppendingString:@"tokens {X;}\n"] stringByAppendingString:@"a : X EOF {System.out.println(input);} ;\n"] stringByAppendingString:@"A : '-' I {$type = X;} ;\n"] stringByAppendingString:@"I : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"-34" param6:debug];
  [self assertEquals:@"-34\n" param1:found];
}

- (void) testRefToFragment {
  NSString * grammar = [[[[@"grammar P;\n" stringByAppendingString:@"a : A {System.out.println(input);} ;\n"] stringByAppendingString:@"A : '-' I ;\n"] stringByAppendingString:@"fragment I : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"-34" param6:debug];
  [self assertEquals:@"-34\n" param1:found];
}

- (void) testMultipleRefToFragment {
  NSString * grammar = [[[[@"grammar P;\n" stringByAppendingString:@"a : A EOF {System.out.println(input);} ;\n"] stringByAppendingString:@"A : I '.' I ;\n"] stringByAppendingString:@"fragment I : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"3.14159" param6:debug];
  [self assertEquals:@"3.14159\n" param1:found];
}

- (void) testLabelInSubrule {
  NSString * grammar = [[[[@"grammar P;\n" stringByAppendingString:@"a : A EOF ;\n"] stringByAppendingString:@"A : 'hi' WS (v=I)? {$channel=0; System.out.println($v.text);} ;\n"] stringByAppendingString:@"fragment I : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"hi 342" param6:debug];
  [self assertEquals:@"342\n" param1:found];
}

- (void) testRefToTokenInLexer {
  NSString * grammar = [[[[@"grammar P;\n" stringByAppendingString:@"a : A EOF ;\n"] stringByAppendingString:@"A : I {System.out.println($I.text);} ;\n"] stringByAppendingString:@"fragment I : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"342" param6:debug];
  [self assertEquals:@"342\n" param1:found];
}

- (void) testListLabelInLexer {
  NSString * grammar = [[[[@"grammar P;\n" stringByAppendingString:@"a : A ;\n"] stringByAppendingString:@"A : i+=I+ {for (Object t : $i) System.out.print(\" \"+((Token)t).getText());} ;\n"] stringByAppendingString:@"fragment I : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"33 297" param6:debug];
  [self assertEquals:@" 33 297\n" param1:found];
}

- (void) testDupListRefInLexer {
  NSString * grammar = [[[[@"grammar P;\n" stringByAppendingString:@"a : A ;\n"] stringByAppendingString:@"A : i+=I WS i+=I {$channel=0; for (Object t : $i) System.out.print(\" \"+((Token)t).getText());} ;\n"] stringByAppendingString:@"fragment I : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;"];
  NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"33 297" param6:debug];
  [self assertEquals:@" 33 297\n" param1:found];
}

- (void) testCharLabelInLexer {
  NSString * grammar = [[@"grammar T;\n" stringByAppendingString:@"a : B ;\n"] stringByAppendingString:@"B : x='a' {System.out.println((char)$x);} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a\n" param1:found];
}

- (void) testRepeatedLabelInLexer {
  NSString * grammar = [@"lexer grammar T;\n" stringByAppendingString:@"B : x='a' x='b' ;\n"];
  BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:nil param3:@"T" param4:NO];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:found];
}

- (void) testRepeatedRuleLabelInLexer {
  NSString * grammar = [[@"lexer grammar T;\n" stringByAppendingString:@"B : x=A x=A ;\n"] stringByAppendingString:@"fragment A : 'a' ;\n"];
  BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:nil param3:@"T" param4:NO];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:found];
}

- (void) testIsolatedEOTEdge {
  NSString * grammar = [[@"lexer grammar T;\n" stringByAppendingString:@"QUOTED_CONTENT \n"] stringByAppendingString:@"        : 'q' (~'q')* (('x' 'q') )* 'q' ; \n"];
  BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:nil param3:@"T" param4:NO];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:found];
}

- (void) testEscapedLiterals {
  NSString * grammar = [[@"lexer grammar T;\n" stringByAppendingString:@"A : '\\\"' ;\n"] stringByAppendingString:@"B : '\\\\\\\"' ;\n"];
  BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:nil param3:@"T" param4:NO];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:found];
}

- (void) testNewlineLiterals {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar T;\n" stringByAppendingString:@"A : '\\n\\n' ;\n"]] autorelease];
  NSString * expecting = @"match(\"\\n\\n\")";
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  int m = [code rangeOfString:@"match(\""];
  NSString * found = [code substringFromIndex:m param1:m + [expecting length]];
  [self assertEquals:expecting param1:found];
}

@end
