#import "TestSyntaxErrors.h"

@implementation TestSyntaxErrors

- (void) testLL2 {
  NSString * grammar = [[[[@"grammar T;\n" stringByAppendingString:@"a : 'a' 'b'"] stringByAppendingString:@"  | 'a' 'c'"] stringByAppendingString:@";\n"] stringByAppendingString:@"q : 'e' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"ae" param6:NO];
  NSString * expecting = @"input line 1:1 no viable alternative at input 'e'\n";
  NSString * result = [stderrDuringParse replaceAll:@".*?/input " param1:@"input "];
  [self assertEquals:expecting param1:result];
}

- (void) testLL3 {
  NSString * grammar = [[[[@"grammar T;\n" stringByAppendingString:@"a : 'a' 'b'* 'c'"] stringByAppendingString:@"  | 'a' 'b' 'd'"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"q : 'e' ;\n"];
  [System.out println:grammar];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abe" param6:NO];
  NSString * expecting = @"input line 1:2 no viable alternative at input 'e'\n";
  NSString * result = [stderrDuringParse replaceAll:@".*?/input " param1:@"input "];
  [self assertEquals:expecting param1:result];
}

- (void) testLLStar {
  NSString * grammar = [[[[@"grammar T;\n" stringByAppendingString:@"a : 'a'+ 'b'"] stringByAppendingString:@"  | 'a'+ 'c'"] stringByAppendingString:@";\n"] stringByAppendingString:@"q : 'e' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"aaae" param6:NO];
  NSString * expecting = @"input line 1:3 no viable alternative at input 'e'\n";
  NSString * result = [stderrDuringParse replaceAll:@".*?/input " param1:@"input "];
  [self assertEquals:expecting param1:result];
}

- (void) testSynPred {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"a : (e '.')=> e '.'"] stringByAppendingString:@"  | (e ';')=> e ';'"] stringByAppendingString:@"  | 'z'"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"e : '(' e ')'"] stringByAppendingString:@"  | 'i'"] stringByAppendingString:@"  ;\n"];
  [System.out println:grammar];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"((i))z" param6:NO];
  NSString * expecting = @"input line 1:0 no viable alternative at input '('\n";
  NSString * result = [stderrDuringParse replaceAll:@".*?/input " param1:@"input "];
  [self assertEquals:expecting param1:result];
}

- (void) testLL1ErrorInfo {
  NSString * grammar = [[[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"start : animal (AND acClass)? service EOF;\n"] stringByAppendingString:@"animal : (DOG | CAT );\n"] stringByAppendingString:@"service : (HARDWARE | SOFTWARE) ;\n"] stringByAppendingString:@"AND : 'and';\n"] stringByAppendingString:@"DOG : 'dog';\n"] stringByAppendingString:@"CAT : 'cat';\n"] stringByAppendingString:@"HARDWARE: 'hardware';\n"] stringByAppendingString:@"SOFTWARE: 'software';\n"] stringByAppendingString:@"WS : ' ' {skip();} ;"] stringByAppendingString:@"acClass\n"] stringByAppendingString:@"@init\n"] stringByAppendingString:@"{ System.out.println(computeContextSensitiveRuleFOLLOW().toString(tokenNames)); }\n"] stringByAppendingString:@"  : ;\n"];
  NSString * result = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"start" param5:@"dog and software" param6:NO];
  NSString * expecting = @"{HARDWARE,SOFTWARE}\n";
  [self assertEquals:expecting param1:result];
}

@end
