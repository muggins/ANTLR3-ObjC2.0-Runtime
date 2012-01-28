#import "TestJavaCodeGeneration.h"

@implementation TestJavaCodeGeneration

- (void) testDupVarDefForPinchedState {
  NSString * grammar = [[[@"grammar T;\n" stringByAppendingString:@"a : (| A | B) X Y\n"] stringByAppendingString:@"  | (| A | B) X Z\n"] stringByAppendingString:@"  ;\n"];
  BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:@"TParser" param3:nil param4:NO];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:found];
}

- (void) testLabeledNotSetsInLexer {
  NSString * grammar = [[@"lexer grammar T;\n" stringByAppendingString:@"A : d=~('x'|'y') e='0'..'9'\n"] stringByAppendingString:@"  ; \n"];
  BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:nil param3:@"T" param4:NO];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:found];
}

- (void) testLabeledSetsInLexer {
  NSString * grammar = [[[@"grammar T;\n" stringByAppendingString:@"a : A ;\n"] stringByAppendingString:@"A : d=('x'|'y') {System.out.println((char)$d);}\n"] stringByAppendingString:@"  ; \n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:NO];
  [self assertEquals:@"x\n" param1:found];
}

- (void) testLabeledRangeInLexer {
  NSString * grammar = [[[@"grammar T;\n" stringByAppendingString:@"a : A;\n"] stringByAppendingString:@"A : d='a'..'z' {System.out.println((char)$d);} \n"] stringByAppendingString:@"  ; \n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:NO];
  [self assertEquals:@"x\n" param1:found];
}

- (void) testLabeledWildcardInLexer {
  NSString * grammar = [[[@"grammar T;\n" stringByAppendingString:@"a : A;\n"] stringByAppendingString:@"A : d=. {System.out.println((char)$d);}\n"] stringByAppendingString:@"  ; \n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:NO];
  [self assertEquals:@"x\n" param1:found];
}

- (void) testSynpredWithPlusLoop {
  NSString * grammar = [@"grammar T; \n" stringByAppendingString:@"a : (('x'+)=> 'x'+)?;\n"];
  BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:NO];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:found];
}

- (void) testDoubleQuoteEscape {
  NSString * grammar = [[[[@"lexer grammar T; \n" stringByAppendingString:@"A : '\\\\\"';\n"] stringByAppendingString:@"B : '\\\"';\n"] stringByAppendingString:@"C : '\\'\\'';\n"] stringByAppendingString:@"D : '\\k';\n"];
  BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:nil param3:@"T" param4:NO];
  BOOL expecting = YES;
  [self assertEquals:expecting param1:found];
}

@end
