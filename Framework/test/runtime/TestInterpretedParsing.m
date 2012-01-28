#import "TestInterpretedParsing.h"

@implementation TestInterpretedParsing


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) testSimpleParse {
  Grammar * pg = [[[Grammar alloc] init:[[[@"parser grammar p;\n" stringByAppendingString:@"prog : WHILE ID LCURLY (assign)* RCURLY EOF;\n"] stringByAppendingString:@"assign : ID ASSIGN expr SEMI ;\n"] stringByAppendingString:@"expr : INT | FLOAT | ID ;\n"]] autorelease];
  Grammar * g = [[[Grammar alloc] init] autorelease];
  [g importTokenVocabulary:pg];
  [g setFileName:[Grammar.IGNORE_STRING_IN_GRAMMAR_FILE_NAME stringByAppendingString:@"string"]];
  [g setGrammarContent:[[[[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"WHILE : 'while';\n"] stringByAppendingString:@"LCURLY : '{';\n"] stringByAppendingString:@"RCURLY : '}';\n"] stringByAppendingString:@"ASSIGN : '=';\n"] stringByAppendingString:@"SEMI : ';';\n"] stringByAppendingString:@"ID : ('a'..'z')+ ;\n"] stringByAppendingString:@"INT : (DIGIT)+ ;\n"] stringByAppendingString:@"FLOAT : (DIGIT)+ '.' (DIGIT)* ;\n"] stringByAppendingString:@"fragment DIGIT : '0'..'9';\n"] stringByAppendingString:@"WS : (' ')+ ;\n"]];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"while x { i=1; y=3.42; z=y; }"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  FilteringTokenStream * tokens = [[[FilteringTokenStream alloc] init:lexEngine] autorelease];
  [tokens setTokenTypeChannel:[g getTokenType:@"WS"] param1:99];
  Interpreter * parseEngine = [[[Interpreter alloc] init:pg param1:tokens] autorelease];
  ParseTree * t = [parseEngine parse:@"prog"];
  NSString * result = [t toStringTree];
  NSString * expecting = @"(<grammar p> (prog while x { (assign i = (expr 1) ;) (assign y = (expr 3.42) ;) (assign z = (expr y) ;) } <EOF>))";
  [self assertEquals:expecting param1:result];
}

- (void) testMismatchedTokenError {
  Grammar * pg = [[[Grammar alloc] init:[[[@"parser grammar p;\n" stringByAppendingString:@"prog : WHILE ID LCURLY (assign)* RCURLY;\n"] stringByAppendingString:@"assign : ID ASSIGN expr SEMI ;\n"] stringByAppendingString:@"expr : INT | FLOAT | ID ;\n"]] autorelease];
  Grammar * g = [[[Grammar alloc] init] autorelease];
  [g setFileName:[Grammar.IGNORE_STRING_IN_GRAMMAR_FILE_NAME stringByAppendingString:@"string"]];
  [g importTokenVocabulary:pg];
  [g setGrammarContent:[[[[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"WHILE : 'while';\n"] stringByAppendingString:@"LCURLY : '{';\n"] stringByAppendingString:@"RCURLY : '}';\n"] stringByAppendingString:@"ASSIGN : '=';\n"] stringByAppendingString:@"SEMI : ';';\n"] stringByAppendingString:@"ID : ('a'..'z')+ ;\n"] stringByAppendingString:@"INT : (DIGIT)+ ;\n"] stringByAppendingString:@"FLOAT : (DIGIT)+ '.' (DIGIT)* ;\n"] stringByAppendingString:@"fragment DIGIT : '0'..'9';\n"] stringByAppendingString:@"WS : (' ')+ ;\n"]];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"while x { i=1 y=3.42; z=y; }"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  FilteringTokenStream * tokens = [[[FilteringTokenStream alloc] init:lexEngine] autorelease];
  [tokens setTokenTypeChannel:[g getTokenType:@"WS"] param1:99];
  Interpreter * parseEngine = [[[Interpreter alloc] init:pg param1:tokens] autorelease];
  ParseTree * t = [parseEngine parse:@"prog"];
  NSString * result = [t toStringTree];
  NSString * expecting = @"(<grammar p> (prog while x { (assign i = (expr 1) MismatchedTokenException(5!=9))))";
  [self assertEquals:expecting param1:result];
}

- (void) testMismatchedSetError {
  Grammar * pg = [[[Grammar alloc] init:[[[@"parser grammar p;\n" stringByAppendingString:@"prog : WHILE ID LCURLY (assign)* RCURLY;\n"] stringByAppendingString:@"assign : ID ASSIGN expr SEMI ;\n"] stringByAppendingString:@"expr : INT | FLOAT | ID ;\n"]] autorelease];
  Grammar * g = [[[Grammar alloc] init] autorelease];
  [g importTokenVocabulary:pg];
  [g setFileName:@"<string>"];
  [g setGrammarContent:[[[[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"WHILE : 'while';\n"] stringByAppendingString:@"LCURLY : '{';\n"] stringByAppendingString:@"RCURLY : '}';\n"] stringByAppendingString:@"ASSIGN : '=';\n"] stringByAppendingString:@"SEMI : ';';\n"] stringByAppendingString:@"ID : ('a'..'z')+ ;\n"] stringByAppendingString:@"INT : (DIGIT)+ ;\n"] stringByAppendingString:@"FLOAT : (DIGIT)+ '.' (DIGIT)* ;\n"] stringByAppendingString:@"fragment DIGIT : '0'..'9';\n"] stringByAppendingString:@"WS : (' ')+ ;\n"]];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"while x { i=; y=3.42; z=y; }"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  FilteringTokenStream * tokens = [[[FilteringTokenStream alloc] init:lexEngine] autorelease];
  [tokens setTokenTypeChannel:[g getTokenType:@"WS"] param1:99];
  Interpreter * parseEngine = [[[Interpreter alloc] init:pg param1:tokens] autorelease];
  ParseTree * t = [parseEngine parse:@"prog"];
  NSString * result = [t toStringTree];
  NSString * expecting = @"(<grammar p> (prog while x { (assign i = (expr MismatchedSetException(9!={5,10,11})))))";
  [self assertEquals:expecting param1:result];
}

- (void) testNoViableAltError {
  Grammar * pg = [[[Grammar alloc] init:[[[@"parser grammar p;\n" stringByAppendingString:@"prog : WHILE ID LCURLY (assign)* RCURLY;\n"] stringByAppendingString:@"assign : ID ASSIGN expr SEMI ;\n"] stringByAppendingString:@"expr : {;}INT | FLOAT | ID ;\n"]] autorelease];
  Grammar * g = [[[Grammar alloc] init] autorelease];
  [g importTokenVocabulary:pg];
  [g setFileName:@"<string>"];
  [g setGrammarContent:[[[[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"WHILE : 'while';\n"] stringByAppendingString:@"LCURLY : '{';\n"] stringByAppendingString:@"RCURLY : '}';\n"] stringByAppendingString:@"ASSIGN : '=';\n"] stringByAppendingString:@"SEMI : ';';\n"] stringByAppendingString:@"ID : ('a'..'z')+ ;\n"] stringByAppendingString:@"INT : (DIGIT)+ ;\n"] stringByAppendingString:@"FLOAT : (DIGIT)+ '.' (DIGIT)* ;\n"] stringByAppendingString:@"fragment DIGIT : '0'..'9';\n"] stringByAppendingString:@"WS : (' ')+ ;\n"]];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"while x { i=; y=3.42; z=y; }"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  FilteringTokenStream * tokens = [[[FilteringTokenStream alloc] init:lexEngine] autorelease];
  [tokens setTokenTypeChannel:[g getTokenType:@"WS"] param1:99];
  Interpreter * parseEngine = [[[Interpreter alloc] init:pg param1:tokens] autorelease];
  ParseTree * t = [parseEngine parse:@"prog"];
  NSString * result = [t toStringTree];
  NSString * expecting = @"(<grammar p> (prog while x { (assign i = (expr NoViableAltException(9@[4:1: expr : ( INT | FLOAT | ID );])))))";
  [self assertEquals:expecting param1:result];
}

@end
