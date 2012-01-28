#import "TestSemanticPredicates.h"

@implementation TestSemanticPredicates


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) testPredsButSyntaxResolves {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : {p1}? A | {p2}? B ;"]] autorelease];
  NSString * expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-B->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testLL_1_Pred {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : {p1}? A | {p2}? A ;"]] autorelease];
  NSString * expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-{p1}?->:s2=>1\n"] stringByAppendingString:@".s1-{p2}?->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testLL_1_Pred_forced_k_1 {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a options {k=1;} : {p1}? A | {p2}? A ;"]] autorelease];
  NSString * expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-{p1}?->:s2=>1\n"] stringByAppendingString:@".s1-{p2}?->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testLL_2_Pred {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : {p1}? A B | {p2}? A B ;"]] autorelease];
  NSString * expecting = [[[@".s0-A->.s1\n" stringByAppendingString:@".s1-B->.s2\n"] stringByAppendingString:@".s2-{p1}?->:s3=>1\n"] stringByAppendingString:@".s2-{p2}?->:s4=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testPredicatedLoop {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : ( {p1}? A | {p2}? A )+;"]] autorelease];
  NSString * expecting = [[[@".s0-A->.s2\n" stringByAppendingString:@".s0-EOF->:s1=>3\n"] stringByAppendingString:@".s2-{p1}?->:s3=>1\n"] stringByAppendingString:@".s2-{p2}?->:s4=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testPredicatedToStayInLoop {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : ( {p1}? A )+ (A)+;"]] autorelease];
  NSString * expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-{!(p1)}?->:s2=>1\n"] stringByAppendingString:@".s1-{p1}?->:s3=>2\n"];
}

- (void) testAndPredicates {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : {p1}? {p1a}? A | {p2}? A ;"]] autorelease];
  NSString * expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-{(p1&&p1a)}?->:s2=>1\n"] stringByAppendingString:@".s1-{p2}?->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testOrPredicates {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : b | {p2}? A ;\n"] stringByAppendingString:@"b : {p1}? A | {p1a}? A ;"]] autorelease];
  NSString * expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-{(p1a||p1)}?->:s2=>1\n"] stringByAppendingString:@".s1-{p2}?->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testIgnoresHoistingDepthGreaterThanZero {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : A {p1}? | A {p2}?;"]] autorelease];
  NSString * expecting = @".s0-A->:s1=>1\n";
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:[NSArray arrayWithObjects:2, nil] expectingNonDetAlts:[NSArray arrayWithObjects:1, 2, nil] expectingAmbigInput:@"A" expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:2 hasPredHiddenByAction:NO];
}

- (void) testIgnoresPredsHiddenByActions {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : {a1} {p1}? A | {a2} {p2}? A ;"]] autorelease];
  NSString * expecting = @".s0-A->:s1=>1\n";
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:[NSArray arrayWithObjects:2, nil] expectingNonDetAlts:[NSArray arrayWithObjects:1, 2, nil] expectingAmbigInput:@"A" expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:2 hasPredHiddenByAction:YES];
}

- (void) testIgnoresPredsHiddenByActionsOneAlt {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : {p1}? A | {a2} {p2}? A ;"]] autorelease];
  NSString * expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-{p1}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:YES];
}

- (void) testHoist2 {
  Grammar * g = [[[Grammar alloc] init:[[[@"parser grammar P;\n" stringByAppendingString:@"a : b | c ;\n"] stringByAppendingString:@"b : {p1}? A ;\n"] stringByAppendingString:@"c : {p2}? A ;\n"]] autorelease];
  NSString * expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-{p1}?->:s2=>1\n"] stringByAppendingString:@".s1-{p2}?->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testHoistCorrectContext {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : b | {p2}? ID ;\n"] stringByAppendingString:@"b : {p1}? ID | INT ;\n"]] autorelease];
  NSString * expecting = [[[@".s0-ID->.s1\n" stringByAppendingString:@".s0-INT->:s2=>1\n"] stringByAppendingString:@".s1-{p1}?->:s2=>1\n"] stringByAppendingString:@".s1-{p2}?->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testDefaultPredNakedAltIsLast {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : b | ID ;\n"] stringByAppendingString:@"b : {p1}? ID | INT ;\n"]] autorelease];
  NSString * expecting = [[[@".s0-ID->.s1\n" stringByAppendingString:@".s0-INT->:s2=>1\n"] stringByAppendingString:@".s1-{p1}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testDefaultPredNakedAltNotLast {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : ID | b ;\n"] stringByAppendingString:@"b : {p1}? ID | INT ;\n"]] autorelease];
  NSString * expecting = [[[@".s0-ID->.s1\n" stringByAppendingString:@".s0-INT->:s3=>2\n"] stringByAppendingString:@".s1-{!(p1)}?->:s2=>1\n"] stringByAppendingString:@".s1-{p1}?->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testLeftRecursivePred {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : {p1}? a | ID ;\n"]] autorelease];
  NSString * expecting = [[@".s0-ID->.s1\n" stringByAppendingString:@".s1-{p1}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"];
  DecisionProbe.verbose = YES;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:[self newTool] param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  if ([g numberOfDecisions] == 0) {
    [g buildNFA];
    [g createLookaheadDFAs:NO];
  }
  DFA * dfa = [g getLookaheadDFA:1];
  [self assertEquals:nil param1:dfa];
  [self assertEquals:@"unexpected number of expected problems" param1:1 param2:[equeue size]];
  Message * msg = (Message *)[equeue.errors get:0];
  [self assertTrue:@"warning must be a left recursion msg" param1:[msg conformsToProtocol:@protocol(LeftRecursionCyclesMessage)]];
}

- (void) testIgnorePredFromLL2AltLastAltIsDefaultTrue {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : {p1}? A B | A C | {p2}? A | {p3}? A | A ;\n"]] autorelease];
  NSString * expecting = [[[[[@".s0-A->.s1\n" stringByAppendingString:@".s1-B->:s2=>1\n"] stringByAppendingString:@".s1-C->:s3=>2\n"] stringByAppendingString:@".s1-{p2}?->:s4=>3\n"] stringByAppendingString:@".s1-{p3}?->:s5=>4\n"] stringByAppendingString:@".s1-{true}?->:s6=>5\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testIgnorePredFromLL2AltPredUnionNeeded {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : {p1}? A B | A C | {p2}? A | A | {p3}? A ;\n"]] autorelease];
  NSString * expecting = [[[[[@".s0-A->.s1\n" stringByAppendingString:@".s1-B->:s2=>1\n"] stringByAppendingString:@".s1-C->:s3=>2\n"] stringByAppendingString:@".s1-{!((p3||p2))}?->:s5=>4\n"] stringByAppendingString:@".s1-{p2}?->:s4=>3\n"] stringByAppendingString:@".s1-{p3}?->:s6=>5\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testPredGets2SymbolSyntacticContext {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : b | A B | C ;\n"] stringByAppendingString:@"b : {p1}? A B ;\n"]] autorelease];
  NSString * expecting = [[[[@".s0-A->.s1\n" stringByAppendingString:@".s0-C->:s5=>3\n"] stringByAppendingString:@".s1-B->.s2\n"] stringByAppendingString:@".s2-{p1}?->:s3=>1\n"] stringByAppendingString:@".s2-{true}?->:s4=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testMatchesLongestThenTestPred {
  Grammar * g = [[[Grammar alloc] init:[[[@"parser grammar P;\n" stringByAppendingString:@"a : b | c ;\n"] stringByAppendingString:@"b : {p}? A ;\n"] stringByAppendingString:@"c : {q}? (A|B)+ ;"]] autorelease];
  NSString * expecting = [[[@".s0-A->.s1\n" stringByAppendingString:@".s0-B->:s3=>2\n"] stringByAppendingString:@".s1-{p}?->:s2=>1\n"] stringByAppendingString:@".s1-{q}?->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testPredsUsedAfterRecursionOverflow {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"s : {p1}? e '.' | {p2}? e ':' ;\n"] stringByAppendingString:@"e : '(' e ')' | INT ;\n"]] autorelease];
  NSString * expecting = [[[[[@".s0-'('->.s1\n" stringByAppendingString:@".s0-INT->.s4\n"] stringByAppendingString:@".s1-{p1}?->:s2=>1\n"] stringByAppendingString:@".s1-{p2}?->:s3=>2\n"] stringByAppendingString:@".s4-{p1}?->:s2=>1\n"] stringByAppendingString:@".s4-{p2}?->:s3=>2\n"];
  DecisionProbe.verbose = YES;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:[self newTool] param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  if ([g numberOfDecisions] == 0) {
    [g buildNFA];
    [g createLookaheadDFAs:NO];
  }
  [self assertEquals:@"unexpected number of expected problems" param1:0 param2:[equeue size]];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testPredsUsedAfterK2FailsNoRecursionOverflow {
  Grammar * g = [[[Grammar alloc] init:[[[@"grammar P;\n" stringByAppendingString:@"options {k=2;}\n"] stringByAppendingString:@"s : {p1}? e '.' | {p2}? e ':' ;\n"] stringByAppendingString:@"e : '(' e ')' | INT ;\n"]] autorelease];
  NSString * expecting = [[[[[[[[[@".s0-'('->.s1\n" stringByAppendingString:@".s0-INT->.s6\n"] stringByAppendingString:@".s1-'('->.s2\n"] stringByAppendingString:@".s1-INT->.s5\n"] stringByAppendingString:@".s2-{p1}?->:s3=>1\n"] stringByAppendingString:@".s2-{p2}?->:s4=>2\n"] stringByAppendingString:@".s5-{p1}?->:s3=>1\n"] stringByAppendingString:@".s5-{p2}?->:s4=>2\n"] stringByAppendingString:@".s6-'.'->:s3=>1\n"] stringByAppendingString:@".s6-':'->:s4=>2\n"];
  DecisionProbe.verbose = YES;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:[self newTool] param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  if ([g numberOfDecisions] == 0) {
    [g buildNFA];
    [g createLookaheadDFAs:NO];
  }
  [self assertEquals:@"unexpected number of expected problems" param1:0 param2:[equeue size]];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testLexerMatchesLongestThenTestPred {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar P;\n" stringByAppendingString:@"B : {p}? 'a' ;\n"] stringByAppendingString:@"C : {q}? ('a'|'b')+ ;"]] autorelease];
  NSString * expecting = [[[[[@".s0-'a'->.s1\n" stringByAppendingString:@".s0-'b'->:s4=>2\n"] stringByAppendingString:@".s1-'a'..'b'->:s4=>2\n"] stringByAppendingString:@".s1-<EOT>->.s2\n"] stringByAppendingString:@".s2-{p}?->:s3=>1\n"] stringByAppendingString:@".s2-{q}?->:s4=>2\n"];
  [self checkDecision:g decision:2 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testLexerMatchesLongestMinusPred {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar P;\n" stringByAppendingString:@"B : 'a' ;\n"] stringByAppendingString:@"C : ('a'|'b')+ ;"]] autorelease];
  NSString * expecting = [[[@".s0-'a'->.s1\n" stringByAppendingString:@".s0-'b'->:s3=>2\n"] stringByAppendingString:@".s1-'a'..'b'->:s3=>2\n"] stringByAppendingString:@".s1-<EOT>->:s2=>1\n"];
  [self checkDecision:g decision:2 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testGatedPred {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar P;\n" stringByAppendingString:@"B : {p}? => 'a' ;\n"] stringByAppendingString:@"C : {q}? => ('a'|'b')+ ;"]] autorelease];
  NSString * expecting = [[[[[@".s0-'a'&&{(q||p)}?->.s1\n" stringByAppendingString:@".s0-'b'&&{q}?->:s4=>2\n"] stringByAppendingString:@".s1-'a'..'b'&&{q}?->:s4=>2\n"] stringByAppendingString:@".s1-<EOT>&&{(q||p)}?->.s2\n"] stringByAppendingString:@".s2-{p}?->:s3=>1\n"] stringByAppendingString:@".s2-{q}?->:s4=>2\n"];
  [self checkDecision:g decision:2 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testGatedPredHoistsAndCanBeInStopState {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar u;\n" stringByAppendingString:@"a : b+ ;\n"] stringByAppendingString:@"b : 'x' | {p}?=> 'y' ;"]] autorelease];
  NSString * expecting = [[@".s0-'x'->:s2=>1\n" stringByAppendingString:@".s0-'y'&&{p}?->:s3=>1\n"] stringByAppendingString:@".s0-EOF->:s1=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testGatedPredInCyclicDFA {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar P;\n" stringByAppendingString:@"A : {p}?=> ('a')+ 'x' ;\n"] stringByAppendingString:@"B : {q}?=> ('a'|'b')+ 'x' ;"]] autorelease];
  NSString * expecting = [[[[[[[@".s0-'a'&&{(q||p)}?->.s1\n" stringByAppendingString:@".s0-'b'&&{q}?->:s5=>2\n"] stringByAppendingString:@".s1-'a'&&{(q||p)}?->.s1\n"] stringByAppendingString:@".s1-'b'&&{q}?->:s5=>2\n"] stringByAppendingString:@".s1-'x'&&{(q||p)}?->.s2\n"] stringByAppendingString:@".s2-<EOT>&&{(q||p)}?->.s3\n"] stringByAppendingString:@".s3-{p}?->:s4=>1\n"] stringByAppendingString:@".s3-{q}?->:s5=>2\n"];
  [self checkDecision:g decision:3 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testGatedPredNotActuallyUsedOnEdges {
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar P;\n" stringByAppendingString:@"A : ('a' | {p}?=> 'a')\n"] stringByAppendingString:@"  | 'a' 'b'\n"] stringByAppendingString:@"  ;"]] autorelease];
  NSString * expecting1 = [[@".s0-'a'->.s1\n" stringByAppendingString:@".s1-{!(p)}?->:s2=>1\n"] stringByAppendingString:@".s1-{p}?->:s3=>2\n"];
  NSString * expecting2 = [[@".s0-'a'->.s1\n" stringByAppendingString:@".s1-'b'->:s2=>2\n"] stringByAppendingString:@".s1-<EOT>->:s3=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting1 expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
  [self checkDecision:g decision:2 expecting:expecting2 expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testGatedPredDoesNotForceAllToBeGated {
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar w;\n" stringByAppendingString:@"a : b | c ;\n"] stringByAppendingString:@"b : {p}? B ;\n"] stringByAppendingString:@"c : {q}?=> d ;\n"] stringByAppendingString:@"d : {r}? C ;\n"]] autorelease];
  NSString * expecting = [@".s0-B->:s1=>1\n" stringByAppendingString:@".s0-C&&{q}?->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testGatedPredDoesNotForceAllToBeGated2 {
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"grammar w;\n" stringByAppendingString:@"a : b | c ;\n"] stringByAppendingString:@"b : {p}? B ;\n"] stringByAppendingString:@"c : {q}?=> d ;\n"] stringByAppendingString:@"d : {r}?=> C\n"] stringByAppendingString:@"  | B\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSString * expecting = [[[@".s0-B->.s1\n" stringByAppendingString:@".s0-C&&{(q&&r)}?->:s3=>2\n"] stringByAppendingString:@".s1-{p}?->:s2=>1\n"] stringByAppendingString:@".s1-{q}?->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) testORGatedPred {
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"grammar w;\n" stringByAppendingString:@"a : b | c ;\n"] stringByAppendingString:@"b : {p}? B ;\n"] stringByAppendingString:@"c : {q}?=> d ;\n"] stringByAppendingString:@"d : {r}?=> C\n"] stringByAppendingString:@"  | {s}?=> B\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSString * expecting = [[[@".s0-B->.s1\n" stringByAppendingString:@".s0-C&&{(q&&r)}?->:s3=>2\n"] stringByAppendingString:@".s1-{(q&&s)}?->:s3=>2\n"] stringByAppendingString:@".s1-{p}?->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}


/**
 * The following grammar should yield an error that rule 'a' has
 * insufficient semantic info pulled from 'b'.
 */
- (void) testIncompleteSemanticHoistedContext {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a : b | B;\n"] stringByAppendingString:@"b : {p1}? B | B ;"]] autorelease];
  NSString * expecting = @".s0-B->:s1=>1\n";
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:[NSArray arrayWithObjects:2, nil] expectingNonDetAlts:[NSArray arrayWithObjects:1, 2, nil] expectingAmbigInput:@"B" expectingInsufficientPredAlts:[NSArray arrayWithObjects:1, nil] expectingDanglingAlts:nil expectingNumWarnings:3 hasPredHiddenByAction:NO];
}

- (void) testIncompleteSemanticHoistedContextk2 {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a : b | A B;\n"] stringByAppendingString:@"b : {p1}? A B | A B ;"]] autorelease];
  NSString * expecting = [@".s0-A->.s1\n" stringByAppendingString:@".s1-B->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:[NSArray arrayWithObjects:2, nil] expectingNonDetAlts:[NSArray arrayWithObjects:1, 2, nil] expectingAmbigInput:@"A B" expectingInsufficientPredAlts:[NSArray arrayWithObjects:1, nil] expectingDanglingAlts:nil expectingNumWarnings:3 hasPredHiddenByAction:NO];
}

- (void) testIncompleteSemanticHoistedContextInFOLLOW {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[@"parser grammar t;\n" stringByAppendingString:@"options {k=1;}\n"] stringByAppendingString:@"a : A? ;\n"] stringByAppendingString:@"b : X a {p1}? A | Y a A ;"]] autorelease];
  NSString * expecting = @".s0-A->:s1=>1\n";
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:[NSArray arrayWithObjects:2, nil] expectingNonDetAlts:[NSArray arrayWithObjects:1, 2, nil] expectingAmbigInput:@"A" expectingInsufficientPredAlts:[NSArray arrayWithObjects:2, nil] expectingDanglingAlts:nil expectingNumWarnings:3 hasPredHiddenByAction:NO];
}

- (void) testIncompleteSemanticHoistedContextInFOLLOWk2 {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a : (A B)? ;\n"] stringByAppendingString:@"b : X a {p1}? A B | Y a A B | Z a ;"]] autorelease];
  NSString * expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s0-EOF->:s3=>2\n"] stringByAppendingString:@".s1-B->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:[NSArray arrayWithObjects:1, 2, nil] expectingAmbigInput:@"A B" expectingInsufficientPredAlts:[NSArray arrayWithObjects:2, nil] expectingDanglingAlts:nil expectingNumWarnings:2 hasPredHiddenByAction:NO];
}

- (void) testIncompleteSemanticHoistedContextInFOLLOWDueToHiddenPred {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a : (A B)? ;\n"] stringByAppendingString:@"b : X a {p1}? A B | Y a {a1} {p2}? A B | Z a ;"]] autorelease];
  NSString * expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s0-EOF->:s3=>2\n"] stringByAppendingString:@".s1-B->:s2=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:[NSArray arrayWithObjects:1, 2, nil] expectingAmbigInput:@"A B" expectingInsufficientPredAlts:[NSArray arrayWithObjects:2, nil] expectingDanglingAlts:nil expectingNumWarnings:2 hasPredHiddenByAction:YES];
}


/**
 * The following grammar should yield an error that rule 'a' has
 * insufficient semantic info pulled from 'b'.  This is the same
 * as the previous case except that the D prevents the B path from
 * "pinching" together into a single NFA state.
 * 
 * This test also demonstrates that just because B D could predict
 * alt 1 in rule 'a', it is unnecessary to continue NFA->DFA
 * conversion to include an edge for D.  Alt 1 is the only possible
 * prediction because we resolve the ambiguity by choosing alt 1.
 */
- (void) testIncompleteSemanticHoistedContext2 {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a : b | B;\n"] stringByAppendingString:@"b : {p1}? B | B D ;"]] autorelease];
  NSString * expecting = @".s0-B->:s1=>1\n";
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:[NSArray arrayWithObjects:2, nil] expectingNonDetAlts:[NSArray arrayWithObjects:1, 2, nil] expectingAmbigInput:@"B" expectingInsufficientPredAlts:[NSArray arrayWithObjects:1, nil] expectingDanglingAlts:nil expectingNumWarnings:3 hasPredHiddenByAction:NO];
}

- (void) testTooFewSemanticPredicates {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : {p1}? A | A | A ;"]] autorelease];
  NSString * expecting = @".s0-A->:s1=>1\n";
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:[NSArray arrayWithObjects:2, 3, nil] expectingNonDetAlts:[NSArray arrayWithObjects:1, 2, 3, nil] expectingAmbigInput:@"A" expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:2 hasPredHiddenByAction:NO];
}

- (void) testPredWithK1 {
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"\tlexer grammar TLexer;\n" stringByAppendingString:@"A\n"] stringByAppendingString:@"options {\n"] stringByAppendingString:@"  k=1;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"  : {p1}? ('x')+ '.'\n"] stringByAppendingString:@"  | {p2}? ('x')+ '.'\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSString * expecting = [[@".s0-'x'->.s1\n" stringByAppendingString:@".s1-{p1}?->:s2=>1\n"] stringByAppendingString:@".s1-{p2}?->:s3=>2\n"];
  NSArray * unreachableAlts = nil;
  NSArray * nonDetAlts = nil;
  NSString * ambigInput = nil;
  NSArray * insufficientPredAlts = nil;
  NSArray * danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:3 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingInsufficientPredAlts:insufficientPredAlts expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings hasPredHiddenByAction:NO];
}

- (void) testPredWithArbitraryLookahead {
  Grammar * g = [[[Grammar alloc] init:[[[@"\tlexer grammar TLexer;\n" stringByAppendingString:@"A : {p1}? ('x')+ '.'\n"] stringByAppendingString:@"  | {p2}? ('x')+ '.'\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSString * expecting = [[[[@".s0-'x'->.s1\n" stringByAppendingString:@".s1-'.'->.s2\n"] stringByAppendingString:@".s1-'x'->.s1\n"] stringByAppendingString:@".s2-{p1}?->:s3=>1\n"] stringByAppendingString:@".s2-{p2}?->:s4=>2\n"];
  NSArray * unreachableAlts = nil;
  NSArray * nonDetAlts = nil;
  NSString * ambigInput = nil;
  NSArray * insufficientPredAlts = nil;
  NSArray * danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:3 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingInsufficientPredAlts:insufficientPredAlts expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings hasPredHiddenByAction:NO];
}

- (void) testUniquePredicateOR {
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[[@"parser grammar v;\n" stringByAppendingString:@"\n"] stringByAppendingString:@"a : {a}? b\n"] stringByAppendingString:@"  | {b}? b\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"b : {c}? (X)+ ;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"c : a\n"] stringByAppendingString:@"  | b\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSString * expecting = [[@".s0-X->.s1\n" stringByAppendingString:@".s1-{((a&&c)||(b&&c))}?->:s2=>1\n"] stringByAppendingString:@".s1-{c}?->:s3=>2\n"];
  NSArray * unreachableAlts = nil;
  NSArray * nonDetAlts = nil;
  NSString * ambigInput = nil;
  NSArray * insufficientPredAlts = nil;
  NSArray * danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:3 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingInsufficientPredAlts:insufficientPredAlts expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings hasPredHiddenByAction:NO];
}

- (void) testSemanticContextPreventsEarlyTerminationOfClosure {
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"parser grammar T;\n" stringByAppendingString:@"a : loop SEMI | ID SEMI\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"loop\n"] stringByAppendingString:@"    : {while}? ID\n"] stringByAppendingString:@"    | {do}? ID\n"] stringByAppendingString:@"    | {for}? ID\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSString * expecting = [[[@".s0-ID->.s1\n" stringByAppendingString:@".s1-SEMI->.s2\n"] stringByAppendingString:@".s2-{(for||do||while)}?->:s3=>1\n"] stringByAppendingString:@".s2-{true}?->:s4=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingInsufficientPredAlts:nil expectingDanglingAlts:nil expectingNumWarnings:0 hasPredHiddenByAction:NO];
}

- (void) _template {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : A | B;"]] autorelease];
  NSString * expecting = @"\n";
  NSArray * unreachableAlts = nil;
  NSArray * nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString * ambigInput = @"L ID R";
  NSArray * insufficientPredAlts = [NSArray arrayWithObjects:1, nil];
  NSArray * danglingAlts = nil;
  int numWarnings = 1;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingInsufficientPredAlts:insufficientPredAlts expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings hasPredHiddenByAction:NO];
}

- (void) checkDecision:(Grammar *)g decision:(int)decision expecting:(NSString *)expecting expectingUnreachableAlts:(NSArray *)expectingUnreachableAlts expectingNonDetAlts:(NSArray *)expectingNonDetAlts expectingAmbigInput:(NSString *)expectingAmbigInput expectingInsufficientPredAlts:(NSArray *)expectingInsufficientPredAlts expectingDanglingAlts:(NSArray *)expectingDanglingAlts expectingNumWarnings:(int)expectingNumWarnings hasPredHiddenByAction:(BOOL)hasPredHiddenByAction {
  DecisionProbe.verbose = YES;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:[self newTool] param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  if ([g numberOfDecisions] == 0) {
    [g buildNFA];
    [g createLookaheadDFAs:NO];
  }
  if ([equeue size] != expectingNumWarnings) {
    [System.err println:[@"Warnings issued: " stringByAppendingString:equeue]];
  }
  [self assertEquals:@"unexpected number of expected problems" param1:expectingNumWarnings param2:[equeue size]];
  DFA * dfa = [g getLookaheadDFA:decision];
  FASerializer * serializer = [[[FASerializer alloc] init:g] autorelease];
  NSString * result = [serializer serialize:dfa.startState];
  NSMutableArray * unreachableAlts = [dfa unreachableAlts];
  if (expectingUnreachableAlts != nil) {
    BitSet * s = [[[BitSet alloc] init] autorelease];
    [s addAll:expectingUnreachableAlts];
    BitSet * s2 = [[[BitSet alloc] init] autorelease];
    [s2 addAll:unreachableAlts];
    [self assertEquals:@"unreachable alts mismatch" param1:s param2:s2];
  }
   else {
    [self assertEquals:@"unreachable alts mismatch" param1:0 param2:unreachableAlts != nil ? [unreachableAlts count] : 0];
  }
  if (expectingAmbigInput != nil) {
    Message * msg = [self getNonDeterminismMessage:equeue.warnings];
    [self assertNotNull:@"no nondeterminism warning?" param1:msg];
    [self assertTrue:[@"expecting nondeterminism; found " stringByAppendingString:[[msg class] name]] param1:[msg conformsToProtocol:@protocol(GrammarNonDeterminismMessage)]];
    GrammarNonDeterminismMessage * nondetMsg = [self getNonDeterminismMessage:equeue.warnings];
    NSMutableArray * labels = [nondetMsg.probe getSampleNonDeterministicInputSequence:nondetMsg.problemState];
    NSString * input = [nondetMsg.probe getInputSequenceDisplay:labels];
    [self assertEquals:expectingAmbigInput param1:input];
  }
  if (expectingNonDetAlts != nil) {
    GrammarNonDeterminismMessage * nondetMsg = [self getNonDeterminismMessage:equeue.warnings];
    [self assertNotNull:[@"found no nondet alts; expecting: " stringByAppendingString:[self str:expectingNonDetAlts]] param1:nondetMsg];
    NSMutableArray * nonDetAlts = [nondetMsg.probe getNonDeterministicAltsForState:nondetMsg.problemState];
    BitSet * s = [[[BitSet alloc] init] autorelease];
    [s addAll:expectingNonDetAlts];
    BitSet * s2 = [[[BitSet alloc] init] autorelease];
    [s2 addAll:nonDetAlts];
    [self assertEquals:@"nondet alts mismatch" param1:s param2:s2];
    [self assertEquals:@"mismatch between expected hasPredHiddenByAction" param1:hasPredHiddenByAction param2:nondetMsg.problemState.dfa.hasPredicateBlockedByAction];
  }
   else {
    GrammarNonDeterminismMessage * nondetMsg = [self getNonDeterminismMessage:equeue.warnings];
    [self assertNull:@"found nondet alts, but expecting none" param1:nondetMsg];
  }
  if (expectingInsufficientPredAlts != nil) {
    GrammarInsufficientPredicatesMessage * insuffPredMsg = [self getGrammarInsufficientPredicatesMessage:equeue.warnings];
    [self assertNotNull:[@"found no GrammarInsufficientPredicatesMessage alts; expecting: " stringByAppendingString:[self str:expectingNonDetAlts]] param1:insuffPredMsg];
    NSMutableDictionary * locations = insuffPredMsg.altToLocations;
    Set * actualAlts = [locations allKeys];
    BitSet * s = [[[BitSet alloc] init] autorelease];
    [s addAll:expectingInsufficientPredAlts];
    BitSet * s2 = [[[BitSet alloc] init] autorelease];
    [s2 addAll:actualAlts];
    [self assertEquals:@"mismatch between insufficiently covered alts" param1:s param2:s2];
    [self assertEquals:@"mismatch between expected hasPredHiddenByAction" param1:hasPredHiddenByAction param2:insuffPredMsg.problemState.dfa.hasPredicateBlockedByAction];
  }
   else {
    GrammarInsufficientPredicatesMessage * nondetMsg = [self getGrammarInsufficientPredicatesMessage:equeue.warnings];
    if (nondetMsg != nil) {
      [System.out println:equeue.warnings];
    }
    [self assertNull:@"found insufficiently covered alts, but expecting none" param1:nondetMsg];
  }
  [self assertEquals:expecting param1:result];
}

- (GrammarNonDeterminismMessage *) getNonDeterminismMessage:(NSMutableArray *)warnings {

  for (int i = 0; i < [warnings count]; i++) {
    Message * m = (Message *)[warnings objectAtIndex:i];
    if ([m conformsToProtocol:@protocol(GrammarNonDeterminismMessage)]) {
      return (GrammarNonDeterminismMessage *)m;
    }
  }

  return nil;
}

- (GrammarInsufficientPredicatesMessage *) getGrammarInsufficientPredicatesMessage:(NSMutableArray *)warnings {

  for (int i = 0; i < [warnings count]; i++) {
    Message * m = (Message *)[warnings objectAtIndex:i];
    if ([m conformsToProtocol:@protocol(GrammarInsufficientPredicatesMessage)]) {
      return (GrammarInsufficientPredicatesMessage *)m;
    }
  }

  return nil;
}

- (NSString *) str:(NSArray *)elements {
  StringBuffer * buf = [[[StringBuffer alloc] init] autorelease];

  for (int i = 0; i < elements.length; i++) {
    if (i > 0) {
      [buf append:@", "];
    }
    int element = elements[i];
    [buf append:element];
  }

  return [buf description];
}

@end
