#import "TestCharDFAConversion.h"

@implementation TestCharDFAConversion


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) testSimpleRangeVersusChar {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a'..'z' '@' | 'k' '$' ;"]] autorelease];
  [g createLookaheadDFAs];
  NSString * expecting = [[[@".s0-'k'->.s1\n" stringByAppendingString:@".s0-{'a'..'j', 'l'..'z'}->:s2=>1\n"] stringByAppendingString:@".s1-'$'->:s3=>2\n"] stringByAppendingString:@".s1-'@'->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testRangeWithDisjointSet {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a'..'z' '@'\n"] stringByAppendingString:@"  | ('k'|'9'|'p') '$'\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  [g createLookaheadDFAs];
  NSString * expecting = [[[[@".s0-'9'->:s3=>2\n" stringByAppendingString:@".s0-{'a'..'j', 'l'..'o', 'q'..'z'}->:s2=>1\n"] stringByAppendingString:@".s0-{'k', 'p'}->.s1\n"] stringByAppendingString:@".s1-'$'->:s3=>2\n"] stringByAppendingString:@".s1-'@'->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testDisjointSetCollidingWithTwoRanges {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : ('a'..'z'|'0'..'9') '@'\n"] stringByAppendingString:@"  | ('k'|'9'|'p') '$'\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  [g createLookaheadDFAs:NO];
  NSString * expecting = [[[@".s0-{'0'..'8', 'a'..'j', 'l'..'o', 'q'..'z'}->:s2=>1\n" stringByAppendingString:@".s0-{'9', 'k', 'p'}->.s1\n"] stringByAppendingString:@".s1-'$'->:s3=>2\n"] stringByAppendingString:@".s1-'@'->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testDisjointSetCollidingWithTwoRangesCharsFirst {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"A : ('k'|'9'|'p') '$'\n"] stringByAppendingString:@"  | ('a'..'z'|'0'..'9') '@'\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSString * expecting = [[[@".s0-{'0'..'8', 'a'..'j', 'l'..'o', 'q'..'z'}->:s3=>2\n" stringByAppendingString:@".s0-{'9', 'k', 'p'}->.s1\n"] stringByAppendingString:@".s1-'$'->:s2=>1\n"] stringByAppendingString:@".s1-'@'->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testDisjointSetCollidingWithTwoRangesAsSeparateAlts {
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a'..'z' '@'\n"] stringByAppendingString:@"  | 'k' '$'\n"] stringByAppendingString:@"  | '9' '$'\n"] stringByAppendingString:@"  | 'p' '$'\n"] stringByAppendingString:@"  | '0'..'9' '@'\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSString * expecting = [[[[[[[[[[@".s0-'0'..'8'->:s8=>5\n" stringByAppendingString:@".s0-'9'->.s6\n"] stringByAppendingString:@".s0-'k'->.s1\n"] stringByAppendingString:@".s0-'p'->.s4\n"] stringByAppendingString:@".s0-{'a'..'j', 'l'..'o', 'q'..'z'}->:s2=>1\n"] stringByAppendingString:@".s1-'$'->:s3=>2\n"] stringByAppendingString:@".s1-'@'->:s2=>1\n"] stringByAppendingString:@".s4-'$'->:s5=>4\n"] stringByAppendingString:@".s4-'@'->:s2=>1\n"] stringByAppendingString:@".s6-'$'->:s7=>3\n"] stringByAppendingString:@".s6-'@'->:s8=>5\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testKeywordVersusID {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"IF : 'if' ;\n"] stringByAppendingString:@"ID : ('a'..'z')+ ;\n"]] autorelease];
  NSString * expecting = [@".s0-'a'..'z'->:s2=>1\n" stringByAppendingString:@".s0-<EOT>->:s1=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
  expecting = [[[[[@".s0-'i'->.s1\n" stringByAppendingString:@".s0-{'a'..'h', 'j'..'z'}->:s4=>2\n"] stringByAppendingString:@".s1-'f'->.s2\n"] stringByAppendingString:@".s1-<EOT>->:s4=>2\n"] stringByAppendingString:@".s2-'a'..'z'->:s4=>2\n"] stringByAppendingString:@".s2-<EOT>->:s3=>1\n"];
  [self checkDecision:g decision:2 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testIdenticalRules {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a' ;\n"] stringByAppendingString:@"B : 'a' ;\n"]] autorelease];
  NSString * expecting = [@".s0-'a'->.s1\n" stringByAppendingString:@".s1-<EOT>->:s2=>1\n"];
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:[NSArray arrayWithObjects:2, nil]];
  [self assertEquals:@"unexpected number of expected problems" param1:1 param2:[equeue size]];
  Message * msg = (Message *)[equeue.errors get:0];
  [self assertTrue:@"warning must be an unreachable alt" param1:[msg conformsToProtocol:@protocol(GrammarUnreachableAltsMessage)]];
  GrammarUnreachableAltsMessage * u = (GrammarUnreachableAltsMessage *)msg;
  [self assertEquals:@"[2]" param1:[u.alts description]];
}

- (void) testAdjacentNotCharLoops {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"A : (~'r')+ ;\n"] stringByAppendingString:@"B : (~'s')+ ;\n"]] autorelease];
  NSString * expecting = [[[[[@".s0-'r'->:s3=>2\n" stringByAppendingString:@".s0-'s'->:s2=>1\n"] stringByAppendingString:@".s0-{'\\u0000'..'q', 't'..'\\uFFFF'}->.s1\n"] stringByAppendingString:@".s1-'r'->:s3=>2\n"] stringByAppendingString:@".s1-<EOT>->:s2=>1\n"] stringByAppendingString:@".s1-{'\\u0000'..'q', 't'..'\\uFFFF'}->.s1\n"];
  [self checkDecision:g decision:3 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNonAdjacentNotCharLoops {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"A : (~'r')+ ;\n"] stringByAppendingString:@"B : (~'t')+ ;\n"]] autorelease];
  NSString * expecting = [[[[[@".s0-'r'->:s3=>2\n" stringByAppendingString:@".s0-'t'->:s2=>1\n"] stringByAppendingString:@".s0-{'\\u0000'..'q', 's', 'u'..'\\uFFFF'}->.s1\n"] stringByAppendingString:@".s1-'r'->:s3=>2\n"] stringByAppendingString:@".s1-<EOT>->:s2=>1\n"] stringByAppendingString:@".s1-{'\\u0000'..'q', 's', 'u'..'\\uFFFF'}->.s1\n"];
  [self checkDecision:g decision:3 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testLoopsWithOptimizedOutExitBranches {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"A : 'x'* ~'x'+ ;\n"]] autorelease];
  NSString * expecting = [@".s0-'x'->:s1=>1\n" stringByAppendingString:@".s0-{'\\u0000'..'w', 'y'..'\\uFFFF'}->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
  DFAOptimizer * optimizer = [[[DFAOptimizer alloc] init:g] autorelease];
  [optimizer optimize];
  FASerializer * serializer = [[[FASerializer alloc] init:g] autorelease];
  DFA * dfa = [g getLookaheadDFA:1];
  NSString * result = [serializer serialize:dfa.startState];
  expecting = @".s0-'x'->:s1=>1\n";
  [self assertEquals:expecting param1:result];
}

- (void) testNonGreedy {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"CMT : '/*' ( options {greedy=false;} : . )* '*/' ;"]] autorelease];
  NSString * expecting = [[[@".s0-'*'->.s1\n" stringByAppendingString:@".s0-{'\\u0000'..')', '+'..'\\uFFFF'}->:s3=>1\n"] stringByAppendingString:@".s1-'/'->:s2=>2\n"] stringByAppendingString:@".s1-{'\\u0000'..'.', '0'..'\\uFFFF'}->:s3=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNonGreedyWildcardStar {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"SLCMT : '//' ( options {greedy=false;} : . )* '\n' ;"]] autorelease];
  NSString * expecting = [@".s0-'\\n'->:s1=>2\n" stringByAppendingString:@".s0-{'\\u0000'..'\\t', '\\u000B'..'\\uFFFF'}->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNonGreedyByDefaultWildcardStar {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"SLCMT : '//' .* '\n' ;"]] autorelease];
  NSString * expecting = [@".s0-'\\n'->:s1=>2\n" stringByAppendingString:@".s0-{'\\u0000'..'\\t', '\\u000B'..'\\uFFFF'}->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNonGreedyWildcardPlus {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"SLCMT : '//' ( options {greedy=false;} : . )+ '\n' ;"]] autorelease];
  NSString * expecting = [@".s0-'\\n'->:s1=>2\n" stringByAppendingString:@".s0-{'\\u0000'..'\\t', '\\u000B'..'\\uFFFF'}->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNonGreedyByDefaultWildcardPlus {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"SLCMT : '//' .+ '\n' ;"]] autorelease];
  NSString * expecting = [@".s0-'\\n'->:s1=>2\n" stringByAppendingString:@".s0-{'\\u0000'..'\\t', '\\u000B'..'\\uFFFF'}->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNonGreedyByDefaultWildcardPlusWithParens {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"SLCMT : '//' (.)+ '\n' ;"]] autorelease];
  NSString * expecting = [@".s0-'\\n'->:s1=>2\n" stringByAppendingString:@".s0-{'\\u0000'..'\\t', '\\u000B'..'\\uFFFF'}->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNonWildcardNonGreedy {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"DUH : (options {greedy=false;}:'x'|'y')* 'xy' ;"]] autorelease];
  NSString * expecting = [[[@".s0-'x'->.s1\n" stringByAppendingString:@".s0-'y'->:s4=>2\n"] stringByAppendingString:@".s1-'x'->:s3=>1\n"] stringByAppendingString:@".s1-'y'->:s2=>3\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNonWildcardEOTMakesItWorkWithoutNonGreedyOption {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"DUH : ('x'|'y')* 'xy' ;"]] autorelease];
  NSString * expecting = [[[[[@".s0-'x'->.s1\n" stringByAppendingString:@".s0-'y'->:s4=>1\n"] stringByAppendingString:@".s1-'x'->:s4=>1\n"] stringByAppendingString:@".s1-'y'->.s2\n"] stringByAppendingString:@".s2-'x'..'y'->:s4=>1\n"] stringByAppendingString:@".s2-<EOT>->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testAltConflictsWithLoopThenExit {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"STRING : '\"' (options {greedy=false;}: '\\\\\"' | .)* '\"' ;\n"]] autorelease];
  NSString * expecting = [[[[@".s0-'\"'->:s1=>3\n" stringByAppendingString:@".s0-'\\\\'->.s2\n"] stringByAppendingString:@".s0-{'\\u0000'..'!', '#'..'[', ']'..'\\uFFFF'}->:s4=>2\n"] stringByAppendingString:@".s2-'\"'->:s3=>1\n"] stringByAppendingString:@".s2-{'\\u0000'..'!', '#'..'\\uFFFF'}->:s4=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNonGreedyLoopThatNeverLoops {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"DUH : (options {greedy=false;}:'x')+ ;"]] autorelease];
  NSString * expecting = @":s0=>2\n";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:[NSArray arrayWithObjects:1, nil]];
  [self assertEquals:@"unexpected number of expected problems" param1:1 param2:[equeue size]];
  Message * msg = (Message *)[equeue.errors get:0];
  [self assertTrue:@"warning must be an unreachable alt" param1:[msg conformsToProtocol:@protocol(GrammarUnreachableAltsMessage)]];
  GrammarUnreachableAltsMessage * u = (GrammarUnreachableAltsMessage *)msg;
  [self assertEquals:@"[1]" param1:[u.alts description]];
}

- (void) testRecursive {
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[[@"lexer grammar duh;\n" stringByAppendingString:@"SUBTEMPLATE\n"] stringByAppendingString:@"        :       '{'\n"] stringByAppendingString:@"                ( SUBTEMPLATE\n"] stringByAppendingString:@"                | ESC\n"] stringByAppendingString:@"                | ~('}'|'\\\\'|'{')\n"] stringByAppendingString:@"                )*\n"] stringByAppendingString:@"                '}'\n"] stringByAppendingString:@"        ;\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"ESC     :       '\\\\' . ;"]] autorelease];
  [g createLookaheadDFAs];
  NSString * expecting = [[[@".s0-'\\\\'->:s2=>2\n" stringByAppendingString:@".s0-'{'->:s1=>1\n"] stringByAppendingString:@".s0-'}'->:s4=>4\n"] stringByAppendingString:@".s0-{'\\u0000'..'[', ']'..'z', '|', '~'..'\\uFFFF'}->:s3=>3\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testRecursive2 {
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[[@"lexer grammar duh;\n" stringByAppendingString:@"SUBTEMPLATE\n"] stringByAppendingString:@"        :       '{'\n"] stringByAppendingString:@"                ( SUBTEMPLATE\n"] stringByAppendingString:@"                | ESC\n"] stringByAppendingString:@"                | ~('}'|'{')\n"] stringByAppendingString:@"                )*\n"] stringByAppendingString:@"                '}'\n"] stringByAppendingString:@"        ;\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"ESC     :       '\\\\' . ;"]] autorelease];
  [g createLookaheadDFAs];
  NSString * expecting = [[[[[[[[[@".s0-'\\\\'->.s3\n" stringByAppendingString:@".s0-'{'->:s2=>1\n"] stringByAppendingString:@".s0-'}'->:s1=>4\n"] stringByAppendingString:@".s0-{'\\u0000'..'[', ']'..'z', '|', '~'..'\\uFFFF'}->:s5=>3\n"] stringByAppendingString:@".s3-'\\\\'->:s8=>2\n"] stringByAppendingString:@".s3-'{'->:s7=>2\n"] stringByAppendingString:@".s3-'}'->.s4\n"] stringByAppendingString:@".s3-{'\\u0000'..'[', ']'..'z', '|', '~'..'\\uFFFF'}->:s6=>2\n"] stringByAppendingString:@".s4-'\\u0000'..'\\uFFFF'->:s6=>2\n"] stringByAppendingString:@".s4-<EOT>->:s5=>3\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNotFragmentInLexer {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar T;\n" stringByAppendingString:@"A : 'a' | ~B {;} ;\n"] stringByAppendingString:@"fragment B : 'a' ;\n"]] autorelease];
  [g createLookaheadDFAs];
  NSString * expecting = [@".s0-'a'->:s1=>1\n" stringByAppendingString:@".s0-{'\\u0000'..'`', 'b'..'\\uFFFF'}->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNotSetFragmentInLexer {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar T;\n" stringByAppendingString:@"A : B | ~B {;} ;\n"] stringByAppendingString:@"fragment B : 'a'|'b' ;\n"]] autorelease];
  [g createLookaheadDFAs];
  NSString * expecting = [@".s0-'a'..'b'->:s1=>1\n" stringByAppendingString:@".s0-{'\\u0000'..'`', 'c'..'\\uFFFF'}->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNotTokenInLexer {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar T;\n" stringByAppendingString:@"A : 'x' ('a' | ~B {;}) ;\n"] stringByAppendingString:@"B : 'a' ;\n"]] autorelease];
  [g createLookaheadDFAs];
  NSString * expecting = [@".s0-'a'->:s1=>1\n" stringByAppendingString:@".s0-{'\\u0000'..'`', 'b'..'\\uFFFF'}->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNotComplicatedSetRuleInLexer {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar T;\n" stringByAppendingString:@"A : B | ~B {;} ;\n"] stringByAppendingString:@"fragment B : 'a'|'b'|'c'..'e'|C ;\n"] stringByAppendingString:@"fragment C : 'f' ;\n"]] autorelease];
  NSString * expecting = [@".s0-'a'..'f'->:s1=>1\n" stringByAppendingString:@".s0-{'\\u0000'..'`', 'g'..'\\uFFFF'}->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testNotSetWithRuleInLexer {
  Grammar * g = [[[Grammar alloc] init:[[[[@"lexer grammar T;\n" stringByAppendingString:@"T : ~('a' | B) | 'a';\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"B : 'b' ;\n"] stringByAppendingString:@"C : ~'x'{;} ;"]] autorelease];
  NSString * expecting = [[[@".s0-'b'->:s3=>2\n" stringByAppendingString:@".s0-'x'->:s2=>1\n"] stringByAppendingString:@".s0-{'\\u0000'..'a', 'c'..'w', 'y'..'\\uFFFF'}->.s1\n"] stringByAppendingString:@".s1-<EOT>->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testSetCallsRuleWithNot {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar A;\n" stringByAppendingString:@"T : ~'x' ;\n"] stringByAppendingString:@"S : 'x' (T | 'x') ;\n"]] autorelease];
  NSString * expecting = [@".s0-'x'->:s2=>2\n" stringByAppendingString:@".s0-{'\\u0000'..'w', 'y'..'\\uFFFF'}->:s1=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) testSynPredInLexer {
  Grammar * g = [[[Grammar alloc] init:[[[[@"lexer grammar T;\n" stringByAppendingString:@"LT:  '<' ' '*\n"] stringByAppendingString:@"  |  ('<' IDENT) => '<' IDENT '>'\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"IDENT:    'a'+;\n"]] autorelease];
  NSString * expecting = [@".s0-'<'->:s1=>1\n" stringByAppendingString:@".s0-'a'->:s2=>2\n"];
  [self checkDecision:g decision:4 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) _template {
  Grammar * g = [[[Grammar alloc] init:[@"grammar T;\n" stringByAppendingString:@"a : A | B;"]] autorelease];
  NSString * expecting = @"\n";
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil];
}

- (void) checkDecision:(Grammar *)g decision:(int)decision expecting:(NSString *)expecting expectingUnreachableAlts:(NSArray *)expectingUnreachableAlts {
  if ([g codeGenerator] == nil) {
    CodeGenerator * generator = [[[CodeGenerator alloc] init:nil param1:g param2:@"Java"] autorelease];
    [g setCodeGenerator:generator];
    [g buildNFA];
    [g createLookaheadDFAs:NO];
  }
  DFA * dfa = [g getLookaheadDFA:decision];
  [self assertNotNull:[@"unknown decision #" stringByAppendingString:decision] param1:dfa];
  FASerializer * serializer = [[[FASerializer alloc] init:g] autorelease];
  NSString * result = [serializer serialize:dfa.startState];
  NSMutableArray * nonDetAlts = [dfa unreachableAlts];
  if (expectingUnreachableAlts == nil) {
    if (nonDetAlts != nil && [nonDetAlts count] != 0) {
      [System.err println:[@"nondeterministic alts (should be empty): " stringByAppendingString:nonDetAlts]];
    }
    [self assertEquals:@"unreachable alts mismatch" param1:0 param2:nonDetAlts != nil ? [nonDetAlts count] : 0];
  }
   else {

    for (int i = 0; i < expectingUnreachableAlts.length; i++) {
      [self assertTrue:@"unreachable alts mismatch" param1:nonDetAlts != nil ? [nonDetAlts containsObject:[[[NSNumber alloc] init:expectingUnreachableAlts[i]] autorelease]] : NO];
    }

  }
  [self assertEquals:expecting param1:result];
}

@end
