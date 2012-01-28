#import "TestInterpretedLexing.h"

@implementation TestInterpretedLexing


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) testSimpleAltCharTest {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a' | 'b' | 'c';"]] autorelease];
  int Atype = [g getTokenType:@"A"];
  Interpreter * engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"a"] autorelease]] autorelease];
  engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"b"] autorelease]] autorelease];
  Token * result = [engine scan:@"A"];
  [self assertEquals:[result type] param1:Atype];
  engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"c"] autorelease]] autorelease];
  result = [engine scan:@"A"];
  [self assertEquals:[result type] param1:Atype];
}

- (void) testSingleRuleRef {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a' B 'c' ;\n"] stringByAppendingString:@"B : 'b' ;\n"]] autorelease];
  int Atype = [g getTokenType:@"A"];
  Interpreter * engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"abc"] autorelease]] autorelease];
  Token * result = [engine scan:@"A"];
  [self assertEquals:[result type] param1:Atype];
}

- (void) testSimpleLoop {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"INT : (DIGIT)+ ;\n"] stringByAppendingString:@"fragment DIGIT : '0'..'9';\n"]] autorelease];
  int INTtype = [g getTokenType:@"INT"];
  Interpreter * engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"12x"] autorelease]] autorelease];
  Token * result = [engine scan:@"INT"];
  [self assertEquals:[result type] param1:INTtype];
  engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"1234"] autorelease]] autorelease];
  result = [engine scan:@"INT"];
  [self assertEquals:[result type] param1:INTtype];
}

- (void) testMultAltLoop {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"A : ('0'..'9'|'a'|'b')+ ;\n"]] autorelease];
  int Atype = [g getTokenType:@"A"];
  Interpreter * engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"a"] autorelease]] autorelease];
  Token * result = [engine scan:@"A"];
  engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"a"] autorelease]] autorelease];
  result = [engine scan:@"A"];
  [self assertEquals:[result type] param1:Atype];
  engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"1234"] autorelease]] autorelease];
  result = [engine scan:@"A"];
  [self assertEquals:[result type] param1:Atype];
  engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"aaa"] autorelease]] autorelease];
  result = [engine scan:@"A"];
  [self assertEquals:[result type] param1:Atype];
  engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"aaaa9"] autorelease]] autorelease];
  result = [engine scan:@"A"];
  [self assertEquals:[result type] param1:Atype];
  engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"b"] autorelease]] autorelease];
  result = [engine scan:@"A"];
  [self assertEquals:[result type] param1:Atype];
  engine = [[[Interpreter alloc] init:g param1:[[[ANTLRStringStream alloc] init:@"baa"] autorelease]] autorelease];
  result = [engine scan:@"A"];
  [self assertEquals:[result type] param1:Atype];
}

- (void) testSimpleLoops {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"A : ('0'..'9')+ '.' ('0'..'9')* | ('0'..'9')+ ;\n"]] autorelease];
  int Atype = [g getTokenType:@"A"];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"1234.5"] autorelease];
  Interpreter * engine = [[[Interpreter alloc] init:g param1:input] autorelease];
  Token * result = [engine scan:@"A"];
  [self assertEquals:Atype param1:[result type]];
}

- (void) testTokensRules {
  Grammar * pg = [[[Grammar alloc] init:[@"parser grammar p;\n" stringByAppendingString:@"a : (INT|FLOAT|WS)+;\n"]] autorelease];
  Grammar * g = [[[Grammar alloc] init] autorelease];
  [g importTokenVocabulary:pg];
  [g setFileName:@"<string>"];
  [g setGrammarContent:[[[[@"lexer grammar t;\n" stringByAppendingString:@"INT : (DIGIT)+ ;\n"] stringByAppendingString:@"FLOAT : (DIGIT)+ '.' (DIGIT)* ;\n"] stringByAppendingString:@"fragment DIGIT : '0'..'9';\n"] stringByAppendingString:@"WS : (' ')+ {channel=99;};\n"]];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"123 139.52"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  CommonTokenStream * tokens = [[[CommonTokenStream alloc] init:lexEngine] autorelease];
  [tokens LT:5];
  NSString * result = [tokens description];
  NSString * expecting = @"123 139.52";
  [self assertEquals:expecting param1:result];
}

@end
