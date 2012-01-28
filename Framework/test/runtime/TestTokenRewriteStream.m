#import "TestTokenRewriteStream.h"

@implementation TestTokenRewriteStream


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) testInsertBeforeIndex0 {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens insertBefore:0 param1:@"0"];
  NSString * result = [tokens description];
  NSString * expecting = @"0abc";
  [self assertEquals:expecting param1:result];
}

- (void) testInsertAfterLastIndex {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens insertAfter:2 param1:@"x"];
  NSString * result = [tokens description];
  NSString * expecting = @"abcx";
  [self assertEquals:expecting param1:result];
}

- (void) test2InsertBeforeAfterMiddleIndex {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:1 param1:@"x"];
  [tokens insertAfter:1 param1:@"x"];
  NSString * result = [tokens description];
  NSString * expecting = @"axbxc";
  [self assertEquals:expecting param1:result];
}

- (void) testReplaceIndex0 {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:0 param1:@"x"];
  NSString * result = [tokens description];
  NSString * expecting = @"xbc";
  [self assertEquals:expecting param1:result];
}

- (void) testReplaceLastIndex {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:2 param1:@"x"];
  NSString * result = [tokens description];
  NSString * expecting = @"abx";
  [self assertEquals:expecting param1:result];
}

- (void) testReplaceMiddleIndex {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:1 param1:@"x"];
  NSString * result = [tokens description];
  NSString * expecting = @"axc";
  [self assertEquals:expecting param1:result];
}

- (void) testToStringStartStop {
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"ID : 'a'..'z'+;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';';\n"] stringByAppendingString:@"MUL : '*';\n"] stringByAppendingString:@"ASSIGN : '=';\n"] stringByAppendingString:@"WS : ' '+;\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"x = 3 * 0;"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:4 param1:8 param2:@"0"];
  NSString * result = [tokens toOriginalString];
  NSString * expecting = @"x = 3 * 0;";
  [self assertEquals:expecting param1:result];
  result = [tokens description];
  expecting = @"x = 0;";
  [self assertEquals:expecting param1:result];
  result = [tokens description:0 param1:9];
  expecting = @"x = 0;";
  [self assertEquals:expecting param1:result];
  result = [tokens description:4 param1:8];
  expecting = @"0";
  [self assertEquals:expecting param1:result];
}

- (void) testToStringStartStop2 {
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"ID : 'a'..'z'+;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';';\n"] stringByAppendingString:@"ASSIGN : '=';\n"] stringByAppendingString:@"PLUS : '+';\n"] stringByAppendingString:@"MULT : '*';\n"] stringByAppendingString:@"WS : ' '+;\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"x = 3 * 0 + 2 * 0;"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  NSString * result = [tokens toOriginalString];
  NSString * expecting = @"x = 3 * 0 + 2 * 0;";
  [self assertEquals:expecting param1:result];
  [tokens replace:4 param1:8 param2:@"0"];
  result = [tokens description];
  expecting = @"x = 0 + 2 * 0;";
  [self assertEquals:expecting param1:result];
  result = [tokens description:0 param1:17];
  expecting = @"x = 0 + 2 * 0;";
  [self assertEquals:expecting param1:result];
  result = [tokens description:4 param1:8];
  expecting = @"0";
  [self assertEquals:expecting param1:result];
  result = [tokens description:0 param1:8];
  expecting = @"x = 0";
  [self assertEquals:expecting param1:result];
  result = [tokens description:12 param1:16];
  expecting = @"2 * 0";
  [self assertEquals:expecting param1:result];
  [tokens insertAfter:17 param1:@"// comment"];
  result = [tokens description:12 param1:18];
  expecting = @"2 * 0;// comment";
  [self assertEquals:expecting param1:result];
  result = [tokens description:0 param1:8];
  expecting = @"x = 0";
  [self assertEquals:expecting param1:result];
}

- (void) test2ReplaceMiddleIndex {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:1 param1:@"x"];
  [tokens replace:1 param1:@"y"];
  NSString * result = [tokens description];
  NSString * expecting = @"ayc";
  [self assertEquals:expecting param1:result];
}

- (void) test2ReplaceMiddleIndex1InsertBefore {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:0 param1:@"_"];
  [tokens replace:1 param1:@"x"];
  [tokens replace:1 param1:@"y"];
  NSString * result = [tokens description];
  NSString * expecting = @"_ayc";
  [self assertEquals:expecting param1:result];
}

- (void) testReplaceThenDeleteMiddleIndex {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:1 param1:@"x"];
  [tokens delete:1];
  NSString * result = [tokens description];
  NSString * expecting = @"ac";
  [self assertEquals:expecting param1:result];
}

- (void) testInsertInPriorReplace {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:0 param1:2 param2:@"x"];
  [tokens insertBefore:1 param1:@"0"];
  NSException * exc = nil;

  @try {
    [tokens description];
  }
  @catch (IllegalArgumentException * iae) {
    exc = iae;
  }
  NSString * expecting = @"insert op <InsertBeforeOp@[@1,1:1='b',<5>,1:1]:\"0\"> within boundaries of previous <ReplaceOp@[@0,0:0='a',<4>,1:0]..[@2,2:2='c',<6>,1:2]:\"x\">";
  [self assertNotNull:exc];
  [self assertEquals:expecting param1:[exc message]];
}

- (void) testInsertThenReplaceSameIndex {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:0 param1:@"0"];
  [tokens replace:0 param1:@"x"];
  NSString * result = [tokens description];
  NSString * expecting = @"0xbc";
  [self assertEquals:expecting param1:result];
}

- (void) test2InsertMiddleIndex {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:1 param1:@"x"];
  [tokens insertBefore:1 param1:@"y"];
  NSString * result = [tokens description];
  NSString * expecting = @"ayxbc";
  [self assertEquals:expecting param1:result];
}

- (void) test2InsertThenReplaceIndex0 {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:0 param1:@"x"];
  [tokens insertBefore:0 param1:@"y"];
  [tokens replace:0 param1:@"z"];
  NSString * result = [tokens description];
  NSString * expecting = @"yxzbc";
  [self assertEquals:expecting param1:result];
}

- (void) testReplaceThenInsertBeforeLastIndex {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:2 param1:@"x"];
  [tokens insertBefore:2 param1:@"y"];
  NSString * result = [tokens description];
  NSString * expecting = @"abyx";
  [self assertEquals:expecting param1:result];
}

- (void) testInsertThenReplaceLastIndex {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:2 param1:@"y"];
  [tokens replace:2 param1:@"x"];
  NSString * result = [tokens description];
  NSString * expecting = @"abyx";
  [self assertEquals:expecting param1:result];
}

- (void) testReplaceThenInsertAfterLastIndex {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:2 param1:@"x"];
  [tokens insertAfter:2 param1:@"y"];
  NSString * result = [tokens description];
  NSString * expecting = @"abxy";
  [self assertEquals:expecting param1:result];
}

- (void) testReplaceRangeThenInsertAtLeftEdge {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcccba"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:2 param1:4 param2:@"x"];
  [tokens insertBefore:2 param1:@"y"];
  NSString * result = [tokens description];
  NSString * expecting = @"abyxba";
  [self assertEquals:expecting param1:result];
}

- (void) testReplaceRangeThenInsertAtRightEdge {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcccba"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:2 param1:4 param2:@"x"];
  [tokens insertBefore:4 param1:@"y"];
  NSException * exc = nil;

  @try {
    [tokens description];
  }
  @catch (IllegalArgumentException * iae) {
    exc = iae;
  }
  NSString * expecting = @"insert op <InsertBeforeOp@[@4,4:4='c',<6>,1:4]:\"y\"> within boundaries of previous <ReplaceOp@[@2,2:2='c',<6>,1:2]..[@4,4:4='c',<6>,1:4]:\"x\">";
  [self assertNotNull:exc];
  [self assertEquals:expecting param1:[exc message]];
}

- (void) testReplaceRangeThenInsertAfterRightEdge {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcccba"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:2 param1:4 param2:@"x"];
  [tokens insertAfter:4 param1:@"y"];
  NSString * result = [tokens description];
  NSString * expecting = @"abxyba";
  [self assertEquals:expecting param1:result];
}

- (void) testReplaceAll {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcccba"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:0 param1:6 param2:@"x"];
  NSString * result = [tokens description];
  NSString * expecting = @"x";
  [self assertEquals:expecting param1:result];
}

- (void) testReplaceSubsetThenFetch {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcccba"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:2 param1:4 param2:@"xyz"];
  NSString * result = [tokens description:0 param1:6];
  NSString * expecting = @"abxyzba";
  [self assertEquals:expecting param1:result];
}

- (void) testReplaceThenReplaceSuperset {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcccba"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:2 param1:4 param2:@"xyz"];
  [tokens replace:3 param1:5 param2:@"foo"];
  NSException * exc = nil;

  @try {
    [tokens description];
  }
  @catch (IllegalArgumentException * iae) {
    exc = iae;
  }
  NSString * expecting = @"replace op boundaries of <ReplaceOp@[@3,3:3='c',<6>,1:3]..[@5,5:5='b',<5>,1:5]:\"foo\"> overlap with previous <ReplaceOp@[@2,2:2='c',<6>,1:2]..[@4,4:4='c',<6>,1:4]:\"xyz\">";
  [self assertNotNull:exc];
  [self assertEquals:expecting param1:[exc message]];
}

- (void) testReplaceThenReplaceLowerIndexedSuperset {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcccba"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:2 param1:4 param2:@"xyz"];
  [tokens replace:1 param1:3 param2:@"foo"];
  NSException * exc = nil;

  @try {
    [tokens description];
  }
  @catch (IllegalArgumentException * iae) {
    exc = iae;
  }
  NSString * expecting = @"replace op boundaries of <ReplaceOp@[@1,1:1='b',<5>,1:1]..[@3,3:3='c',<6>,1:3]:\"foo\"> overlap with previous <ReplaceOp@[@2,2:2='c',<6>,1:2]..[@4,4:4='c',<6>,1:4]:\"xyz\">";
  [self assertNotNull:exc];
  [self assertEquals:expecting param1:[exc message]];
}

- (void) testReplaceSingleMiddleThenOverlappingSuperset {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcba"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:2 param1:2 param2:@"xyz"];
  [tokens replace:0 param1:3 param2:@"foo"];
  NSString * result = [tokens description];
  NSString * expecting = @"fooa";
  [self assertEquals:expecting param1:result];
}

- (void) testCombineInserts {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:0 param1:@"x"];
  [tokens insertBefore:0 param1:@"y"];
  NSString * result = [tokens description];
  NSString * expecting = @"yxabc";
  [self assertEquals:expecting param1:result];
}

- (void) testCombine3Inserts {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:1 param1:@"x"];
  [tokens insertBefore:0 param1:@"y"];
  [tokens insertBefore:1 param1:@"z"];
  NSString * result = [tokens description];
  NSString * expecting = @"yazxbc";
  [self assertEquals:expecting param1:result];
}

- (void) testCombineInsertOnLeftWithReplace {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:0 param1:2 param2:@"foo"];
  [tokens insertBefore:0 param1:@"z"];
  NSString * result = [tokens description];
  NSString * expecting = @"zfoo";
  [self assertEquals:expecting param1:result];
}

- (void) testCombineInsertOnLeftWithDelete {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens delete:0 param1:2];
  [tokens insertBefore:0 param1:@"z"];
  NSString * result = [tokens description];
  NSString * expecting = @"z";
  [self assertEquals:expecting param1:result];
}

- (void) testDisjointInserts {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:1 param1:@"x"];
  [tokens insertBefore:2 param1:@"y"];
  [tokens insertBefore:0 param1:@"z"];
  NSString * result = [tokens description];
  NSString * expecting = @"zaxbyc";
  [self assertEquals:expecting param1:result];
}

- (void) testOverlappingReplace {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:1 param1:2 param2:@"foo"];
  [tokens replace:0 param1:3 param2:@"bar"];
  NSString * result = [tokens description];
  NSString * expecting = @"bar";
  [self assertEquals:expecting param1:result];
}

- (void) testOverlappingReplace2 {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:0 param1:3 param2:@"bar"];
  [tokens replace:1 param1:2 param2:@"foo"];
  NSException * exc = nil;

  @try {
    [tokens description];
  }
  @catch (IllegalArgumentException * iae) {
    exc = iae;
  }
  NSString * expecting = @"replace op boundaries of <ReplaceOp@[@1,1:1='b',<5>,1:1]..[@2,2:2='c',<6>,1:2]:\"foo\"> overlap with previous <ReplaceOp@[@0,0:0='a',<4>,1:0]..[@3,3:3='c',<6>,1:3]:\"bar\">";
  [self assertNotNull:exc];
  [self assertEquals:expecting param1:[exc message]];
}

- (void) testOverlappingReplace3 {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:1 param1:2 param2:@"foo"];
  [tokens replace:0 param1:2 param2:@"bar"];
  NSString * result = [tokens description];
  NSString * expecting = @"barc";
  [self assertEquals:expecting param1:result];
}

- (void) testOverlappingReplace4 {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:1 param1:2 param2:@"foo"];
  [tokens replace:1 param1:3 param2:@"bar"];
  NSString * result = [tokens description];
  NSString * expecting = @"abar";
  [self assertEquals:expecting param1:result];
}

- (void) testDropIdenticalReplace {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:1 param1:2 param2:@"foo"];
  [tokens replace:1 param1:2 param2:@"foo"];
  NSString * result = [tokens description];
  NSString * expecting = @"afooc";
  [self assertEquals:expecting param1:result];
}

- (void) testDropPrevCoveredInsert {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:1 param1:@"foo"];
  [tokens replace:1 param1:2 param2:@"foo"];
  NSString * result = [tokens description];
  NSString * expecting = @"afoofoo";
  [self assertEquals:expecting param1:result];
}

- (void) testLeaveAloneDisjointInsert {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:1 param1:@"x"];
  [tokens replace:2 param1:3 param2:@"foo"];
  NSString * result = [tokens description];
  NSString * expecting = @"axbfoo";
  [self assertEquals:expecting param1:result];
}

- (void) testLeaveAloneDisjointInsert2 {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abcc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens replace:2 param1:3 param2:@"foo"];
  [tokens insertBefore:1 param1:@"x"];
  NSString * result = [tokens description];
  NSString * expecting = @"axbfoo";
  [self assertEquals:expecting param1:result];
}

- (void) testInsertBeforeTokenThenDeleteThatToken {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';\n"] stringByAppendingString:@"B : 'b';\n"] stringByAppendingString:@"C : 'c';\n"]] autorelease];
  CharStream * input = [[[ANTLRStringStream alloc] init:@"abc"] autorelease];
  Interpreter * lexEngine = [[[Interpreter alloc] init:g param1:input] autorelease];
  TokenRewriteStream * tokens = [[[TokenRewriteStream alloc] init:lexEngine] autorelease];
  [tokens fill];
  [tokens insertBefore:2 param1:@"y"];
  [tokens delete:2];
  NSString * result = [tokens description];
  NSString * expecting = @"aby";
  [self assertEquals:expecting param1:result];
}

@end
