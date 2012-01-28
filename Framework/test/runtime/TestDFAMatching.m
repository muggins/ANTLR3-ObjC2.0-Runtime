#import "TestDFAMatching.h"

@implementation TestDFAMatching


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) testSimpleAltCharTest {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"A : {;}'a' | 'b' | 'c';"]] autorelease];
  [g buildNFA];
  [g createLookaheadDFAs:NO];
  DFA * dfa = [g getLookaheadDFA:1];
  [self checkPrediction:dfa input:@"a" expected:1];
  [self checkPrediction:dfa input:@"b" expected:2];
  [self checkPrediction:dfa input:@"c" expected:3];
  [self checkPrediction:dfa input:@"d" expected:NFA.INVALID_ALT_NUMBER];
}

- (void) testSets {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"A : {;}'a'..'z' | ';' | '0'..'9' ;"]] autorelease];
  [g buildNFA];
  [g createLookaheadDFAs:NO];
  DFA * dfa = [g getLookaheadDFA:1];
  [self checkPrediction:dfa input:@"a" expected:1];
  [self checkPrediction:dfa input:@"q" expected:1];
  [self checkPrediction:dfa input:@"z" expected:1];
  [self checkPrediction:dfa input:@";" expected:2];
  [self checkPrediction:dfa input:@"9" expected:3];
}

- (void) testFiniteCommonLeftPrefixes {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a' 'b' | 'a' 'c' | 'd' 'e' ;"]] autorelease];
  [g buildNFA];
  [g createLookaheadDFAs:NO];
  DFA * dfa = [g getLookaheadDFA:1];
  [self checkPrediction:dfa input:@"ab" expected:1];
  [self checkPrediction:dfa input:@"ac" expected:2];
  [self checkPrediction:dfa input:@"de" expected:3];
  [self checkPrediction:dfa input:@"q" expected:NFA.INVALID_ALT_NUMBER];
}

- (void) testSimpleLoops {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"A : (DIGIT)+ '.' DIGIT | (DIGIT)+ ;\n"] stringByAppendingString:@"fragment DIGIT : '0'..'9' ;\n"]] autorelease];
  [g buildNFA];
  [g createLookaheadDFAs:NO];
  DFA * dfa = [g getLookaheadDFA:3];
  [self checkPrediction:dfa input:@"32" expected:2];
  [self checkPrediction:dfa input:@"999.2" expected:1];
  [self checkPrediction:dfa input:@".2" expected:NFA.INVALID_ALT_NUMBER];
}

- (void) checkPrediction:(DFA *)dfa input:(NSString *)input expected:(int)expected {
  ANTLRStringStream * stream = [[[ANTLRStringStream alloc] init:input] autorelease];
  [self assertEquals:[dfa predict:stream] param1:expected];
}

@end
