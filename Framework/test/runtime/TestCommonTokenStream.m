#import "TestCommonTokenStream.h"

@implementation TestCommonTokenStream_Anon1

@synthesize sourceName;

- (void) init {
  if (self = [super init]) {
    [tokens[0] setChannel:Lexer.HIDDEN];
    [tokens[2] setChannel:Lexer.HIDDEN];
    [tokens[5] setChannel:Lexer.HIDDEN];
    [tokens[6] setChannel:Lexer.HIDDEN];
    [tokens[8] setChannel:Lexer.HIDDEN];
    i = 0;
    tokens = [NSArray arrayWithObjects:[[[CommonToken alloc] init:1 param1:@" "] autorelease], [[[CommonToken alloc] init:1 param1:@"x"] autorelease], [[[CommonToken alloc] init:1 param1:@" "] autorelease], [[[CommonToken alloc] init:1 param1:@"="] autorelease], [[[CommonToken alloc] init:1 param1:@"34"] autorelease], [[[CommonToken alloc] init:1 param1:@" "] autorelease], [[[CommonToken alloc] init:1 param1:@" "] autorelease], [[[CommonToken alloc] init:1 param1:@";"] autorelease], [[[CommonToken alloc] init:1 param1:@"\n"] autorelease], [[[CommonToken alloc] init:Token.EOF param1:@""] autorelease], nil];
  }
  return self;
}

- (Token *) nextToken {
  return tokens[i++];
}

- (void) dealloc {
  [tokens release];
  [super dealloc];
}

@end

@implementation TestCommonTokenStream

- (void) testFirstToken {
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"ID : 'a'..'z'+;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';';\n"] stringByAppendingString:@"ASSIGN : '=';\n"] stringByAppendingString:@"PLUS : '+';\n"] stringByAppendingString:@"MULT : '*';\n"] stringByAppendingString:@"WS : ' '+;\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"x = 3 * 0 + 2 * 0;"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  BufferedTokenStream * tokens = [[[BufferedTokenStream alloc] init:lexEngine] autorelease];
  NSString * result = [[tokens LT:1] text];
  NSString * expecting = @"x";
  [self assertEquals:expecting param1:result];
}

- (void) test2ndToken {
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"ID : 'a'..'z'+;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';';\n"] stringByAppendingString:@"ASSIGN : '=';\n"] stringByAppendingString:@"PLUS : '+';\n"] stringByAppendingString:@"MULT : '*';\n"] stringByAppendingString:@"WS : ' '+;\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"x = 3 * 0 + 2 * 0;"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  BufferedTokenStream * tokens = [[[BufferedTokenStream alloc] init:lexEngine] autorelease];
  NSString * result = [[tokens LT:2] text];
  NSString * expecting = @" ";
  [self assertEquals:expecting param1:result];
}

- (void) testCompleteBuffer {
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"ID : 'a'..'z'+;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';';\n"] stringByAppendingString:@"ASSIGN : '=';\n"] stringByAppendingString:@"PLUS : '+';\n"] stringByAppendingString:@"MULT : '*';\n"] stringByAppendingString:@"WS : ' '+;\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"x = 3 * 0 + 2 * 0;"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  BufferedTokenStream * tokens = [[[BufferedTokenStream alloc] init:lexEngine] autorelease];
  int i = 1;
  Token * t = [tokens LT:i];

  while ([t type] != Token.EOF) {
    i++;
    t = [tokens LT:i];
  }

  [tokens LT:i++];
  [tokens LT:i++];
  NSString * result = [tokens description];
  NSString * expecting = @"x = 3 * 0 + 2 * 0;";
  [self assertEquals:expecting param1:result];
}

- (void) testCompleteBufferAfterConsuming {
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"ID : 'a'..'z'+;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';';\n"] stringByAppendingString:@"ASSIGN : '=';\n"] stringByAppendingString:@"PLUS : '+';\n"] stringByAppendingString:@"MULT : '*';\n"] stringByAppendingString:@"WS : ' '+;\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"x = 3 * 0 + 2 * 0;"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  BufferedTokenStream * tokens = [[[BufferedTokenStream alloc] init:lexEngine] autorelease];
  Token * t = [tokens LT:1];

  while ([t type] != Token.EOF) {
    [tokens consume];
    t = [tokens LT:1];
  }

  [tokens consume];
  [tokens LT:1];
  [tokens consume];
  [tokens LT:1];
  NSString * result = [tokens description];
  NSString * expecting = @"x = 3 * 0 + 2 * 0;";
  [self assertEquals:expecting param1:result];
}

- (void) testLookback {
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"ID : 'a'..'z'+;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';';\n"] stringByAppendingString:@"ASSIGN : '=';\n"] stringByAppendingString:@"PLUS : '+';\n"] stringByAppendingString:@"MULT : '*';\n"] stringByAppendingString:@"WS : ' '+;\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"x = 3 * 0 + 2 * 0;"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  BufferedTokenStream * tokens = [[[BufferedTokenStream alloc] init:lexEngine] autorelease];
  [tokens consume];
  Token * t = [tokens LT:-1];
  [self assertEquals:@"x" param1:[t text]];
  [tokens consume];
  [tokens consume];
  t = [tokens LT:-3];
  [self assertEquals:@"x" param1:[t text]];
  t = [tokens LT:-2];
  [self assertEquals:@" " param1:[t text]];
  t = [tokens LT:-1];
  [self assertEquals:@"=" param1:[t text]];
}

- (void) testOffChannel {
  TokenSource * lexer = [[[TestCommonTokenStream_Anon1 alloc] init] autorelease];
  CommonTokenStream * tokens = [[[CommonTokenStream alloc] init:lexer] autorelease];
  [self assertEquals:@"x" param1:[[tokens LT:1] text]];
  [tokens consume];
  [self assertEquals:@"=" param1:[[tokens LT:1] text]];
  [self assertEquals:@"x" param1:[[tokens LT:-1] text]];
  [tokens consume];
  [self assertEquals:@"34" param1:[[tokens LT:1] text]];
  [self assertEquals:@"=" param1:[[tokens LT:-1] text]];
  [tokens consume];
  [self assertEquals:@";" param1:[[tokens LT:1] text]];
  [self assertEquals:@"34" param1:[[tokens LT:-1] text]];
  [tokens consume];
  [self assertEquals:Token.EOF param1:[tokens LA:1]];
  [self assertEquals:@";" param1:[[tokens LT:-1] text]];
  [self assertEquals:@"34" param1:[[tokens LT:-2] text]];
  [self assertEquals:@"=" param1:[[tokens LT:-3] text]];
  [self assertEquals:@"x" param1:[[tokens LT:-4] text]];
}

@end
