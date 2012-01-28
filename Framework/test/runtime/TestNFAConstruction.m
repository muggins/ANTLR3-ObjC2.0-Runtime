#import "TestNFAConstruction.h"

@implementation TestNFAConstruction


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) testA {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : A;"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-A->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-EOF->.s5\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAB {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : A B ;"]] autorelease];
  NSString * expecting = [[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-A->.s3\n"] stringByAppendingString:@".s3-B->.s4\n"] stringByAppendingString:@".s4->:s5\n"] stringByAppendingString:@":s5-EOF->.s6\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAorB {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : A | B {;} ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s1->.s7\n"] stringByAppendingString:@".s10->.s4\n"] stringByAppendingString:@".s2-A->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4->:s5\n"] stringByAppendingString:@".s7->.s8\n"] stringByAppendingString:@".s8-B->.s9\n"] stringByAppendingString:@".s9-{}->.s10\n"] stringByAppendingString:@":s5-EOF->.s6\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testRangeOrRange {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"A : ('a'..'c' 'h' | 'q' 'j'..'l') ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s10-'q'->.s11\n"] stringByAppendingString:@".s11-'j'..'l'->.s12\n"] stringByAppendingString:@".s12->.s6\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s9\n"] stringByAppendingString:@".s3-'a'..'c'->.s4\n"] stringByAppendingString:@".s4-'h'->.s5\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s9->.s10\n"] stringByAppendingString:@":s7-<EOT>->.s8\n"];
  [self checkRule:g rule:@"A" expecting:expecting];
}

- (void) testRange {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"A : 'a'..'c' ;"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-'a'..'c'->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-<EOT>->.s5\n"];
  [self checkRule:g rule:@"A" expecting:expecting];
}

- (void) testCharSetInParser {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : A|'b' ;"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-A..'b'->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-EOF->.s5\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testABorCD {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : A B | C D;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s1->.s8\n"] stringByAppendingString:@".s10-D->.s11\n"] stringByAppendingString:@".s11->.s5\n"] stringByAppendingString:@".s2-A->.s3\n"] stringByAppendingString:@".s3-B->.s4\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5->:s6\n"] stringByAppendingString:@".s8->.s9\n"] stringByAppendingString:@".s9-C->.s10\n"] stringByAppendingString:@":s6-EOF->.s7\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testbA {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : b A ;\n"] stringByAppendingString:@"b : B ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5-B->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s8-A->.s9\n"] stringByAppendingString:@".s9->:s10\n"] stringByAppendingString:@":s10-EOF->.s11\n"] stringByAppendingString:@":s7->.s8\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testbA_bC {
  Grammar * g = [[[Grammar alloc] init:[[[@"parser grammar P;\n" stringByAppendingString:@"a : b A ;\n"] stringByAppendingString:@"b : B ;\n"] stringByAppendingString:@"c : b C;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s12->.s13\n"] stringByAppendingString:@".s13-C->.s14\n"] stringByAppendingString:@".s14->:s15\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5-B->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s8-A->.s9\n"] stringByAppendingString:@".s9->:s10\n"] stringByAppendingString:@":s10-EOF->.s11\n"] stringByAppendingString:@":s15-EOF->.s16\n"] stringByAppendingString:@":s7->.s12\n"] stringByAppendingString:@":s7->.s8\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAorEpsilon {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : A | ;"]] autorelease];
  NSString * expecting = [[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s1->.s7\n"] stringByAppendingString:@".s2-A->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4->:s5\n"] stringByAppendingString:@".s7->.s8\n"] stringByAppendingString:@".s8->.s9\n"] stringByAppendingString:@".s9->.s4\n"] stringByAppendingString:@":s5-EOF->.s6\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAOptional {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : (A)?;"]] autorelease];
  NSString * expecting = [[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s8\n"] stringByAppendingString:@".s3-A->.s4\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5->:s6\n"] stringByAppendingString:@".s8->.s5\n"] stringByAppendingString:@":s6-EOF->.s7\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testNakedAoptional {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : A?;"]] autorelease];
  NSString * expecting = [[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s8\n"] stringByAppendingString:@".s3-A->.s4\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5->:s6\n"] stringByAppendingString:@".s8->.s5\n"] stringByAppendingString:@":s6-EOF->.s7\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAorBthenC {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : (A | B) C;"]] autorelease];
}

- (void) testAplus {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : (A)+;"]] autorelease];
  NSString * expecting = [[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-A->.s5\n"] stringByAppendingString:@".s5->.s3\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@":s7-EOF->.s8\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testNakedAplus {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : A+;"]] autorelease];
  NSString * expecting = [[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-A->.s5\n"] stringByAppendingString:@".s5->.s3\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@":s7-EOF->.s8\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAplusNonGreedy {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"A : (options {greedy=false;}:'0'..'9')+ ;\n"]] autorelease];
  NSString * expecting = [[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-'0'..'9'->.s5\n"] stringByAppendingString:@".s5->.s3\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@":s7-<EOT>->.s8\n"];
  [self checkRule:g rule:@"A" expecting:expecting];
}

- (void) testAorBplus {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : (A | B{action})+ ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s10->.s11\n"] stringByAppendingString:@".s11-B->.s12\n"] stringByAppendingString:@".s12-{}->.s13\n"] stringByAppendingString:@".s13->.s6\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s10\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-A->.s5\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->.s3\n"] stringByAppendingString:@".s6->.s7\n"] stringByAppendingString:@".s7->:s8\n"] stringByAppendingString:@":s8-EOF->.s9\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAorBorEmptyPlus {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : (A | B | )+ ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s10->.s11\n"] stringByAppendingString:@".s10->.s13\n"] stringByAppendingString:@".s11-B->.s12\n"] stringByAppendingString:@".s12->.s6\n"] stringByAppendingString:@".s13->.s14\n"] stringByAppendingString:@".s14->.s15\n"] stringByAppendingString:@".s15->.s6\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s10\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-A->.s5\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->.s3\n"] stringByAppendingString:@".s6->.s7\n"] stringByAppendingString:@".s7->:s8\n"] stringByAppendingString:@":s8-EOF->.s9\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAStar {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : (A)*;"]] autorelease];
  NSString * expecting = [[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s9\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-A->.s5\n"] stringByAppendingString:@".s5->.s3\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s9->.s6\n"] stringByAppendingString:@":s7-EOF->.s8\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testNestedAstar {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : (A*)*;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s10->:s11\n"] stringByAppendingString:@".s13->.s8\n"] stringByAppendingString:@".s14->.s10\n"] stringByAppendingString:@".s2->.s14\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4->.s13\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6-A->.s7\n"] stringByAppendingString:@".s7->.s5\n"] stringByAppendingString:@".s7->.s8\n"] stringByAppendingString:@".s8->.s9\n"] stringByAppendingString:@".s9->.s10\n"] stringByAppendingString:@".s9->.s3\n"] stringByAppendingString:@":s11-EOF->.s12\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testPlusNestedInStar {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : (A+)*;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s10->:s11\n"] stringByAppendingString:@".s13->.s10\n"] stringByAppendingString:@".s2->.s13\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6-A->.s7\n"] stringByAppendingString:@".s7->.s5\n"] stringByAppendingString:@".s7->.s8\n"] stringByAppendingString:@".s8->.s9\n"] stringByAppendingString:@".s9->.s10\n"] stringByAppendingString:@".s9->.s3\n"] stringByAppendingString:@":s11-EOF->.s12\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testStarNestedInPlus {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : (A*)+;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s10->:s11\n"] stringByAppendingString:@".s13->.s8\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4->.s13\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6-A->.s7\n"] stringByAppendingString:@".s7->.s5\n"] stringByAppendingString:@".s7->.s8\n"] stringByAppendingString:@".s8->.s9\n"] stringByAppendingString:@".s9->.s10\n"] stringByAppendingString:@".s9->.s3\n"] stringByAppendingString:@":s11-EOF->.s12\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testNakedAstar {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : A*;"]] autorelease];
  NSString * expecting = [[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s9\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-A->.s5\n"] stringByAppendingString:@".s5->.s3\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s9->.s6\n"] stringByAppendingString:@":s7-EOF->.s8\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAorBstar {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : (A | B{action})* ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s10->.s11\n"] stringByAppendingString:@".s11-B->.s12\n"] stringByAppendingString:@".s12-{}->.s13\n"] stringByAppendingString:@".s13->.s6\n"] stringByAppendingString:@".s14->.s7\n"] stringByAppendingString:@".s2->.s14\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s10\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-A->.s5\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->.s3\n"] stringByAppendingString:@".s6->.s7\n"] stringByAppendingString:@".s7->:s8\n"] stringByAppendingString:@":s8-EOF->.s9\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAorBOptionalSubrule {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : ( A | B )? ;"]] autorelease];
  NSString * expecting = [[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s8\n"] stringByAppendingString:@".s3-A..B->.s4\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5->:s6\n"] stringByAppendingString:@".s8->.s5\n"] stringByAppendingString:@":s6-EOF->.s7\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testPredicatedAorB {
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar P;\n" stringByAppendingString:@"a : {p1}? A | {p2}? B ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s1->.s8\n"] stringByAppendingString:@".s10-B->.s11\n"] stringByAppendingString:@".s11->.s5\n"] stringByAppendingString:@".s2-{p1}?->.s3\n"] stringByAppendingString:@".s3-A->.s4\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5->:s6\n"] stringByAppendingString:@".s8->.s9\n"] stringByAppendingString:@".s9-{p2}?->.s10\n"] stringByAppendingString:@":s6-EOF->.s7\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testMultiplePredicates {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : {p1}? {p1a}? A | {p2}? B | {p3} b;\n"] stringByAppendingString:@"b : {p4}? B ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s1->.s9\n"] stringByAppendingString:@".s10-{p2}?->.s11\n"] stringByAppendingString:@".s11-B->.s12\n"] stringByAppendingString:@".s12->.s6\n"] stringByAppendingString:@".s13->.s14\n"] stringByAppendingString:@".s14-{}->.s15\n"] stringByAppendingString:@".s15->.s16\n"] stringByAppendingString:@".s16->.s17\n"] stringByAppendingString:@".s17->.s18\n"] stringByAppendingString:@".s18-{p4}?->.s19\n"] stringByAppendingString:@".s19-B->.s20\n"] stringByAppendingString:@".s2-{p1}?->.s3\n"] stringByAppendingString:@".s20->:s21\n"] stringByAppendingString:@".s22->.s6\n"] stringByAppendingString:@".s3-{p1a}?->.s4\n"] stringByAppendingString:@".s4-A->.s5\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s9->.s10\n"] stringByAppendingString:@".s9->.s13\n"] stringByAppendingString:@":s21->.s22\n"] stringByAppendingString:@":s7-EOF->.s8\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testSets {
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar P;\n" stringByAppendingString:@"a : ( A | B )+ ;\n"] stringByAppendingString:@"b : ( A | B{;} )+ ;\n"] stringByAppendingString:@"c : (A|B) (A|B) ;\n"] stringByAppendingString:@"d : ( A | B )* ;\n"] stringByAppendingString:@"e : ( A | B )? ;"]] autorelease];
  NSString * expecting = [[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-A..B->.s5\n"] stringByAppendingString:@".s5->.s3\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@":s7-EOF->.s8\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
  expecting = [[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s10->.s11\n"] stringByAppendingString:@".s11-B->.s12\n"] stringByAppendingString:@".s12-{}->.s13\n"] stringByAppendingString:@".s13->.s6\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s10\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-A->.s5\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->.s3\n"] stringByAppendingString:@".s6->.s7\n"] stringByAppendingString:@".s7->:s8\n"] stringByAppendingString:@":s8-EOF->.s9\n"];
  [self checkRule:g rule:@"b" expecting:expecting];
  expecting = [[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-A..B->.s3\n"] stringByAppendingString:@".s3-A..B->.s4\n"] stringByAppendingString:@".s4->:s5\n"] stringByAppendingString:@":s5-EOF->.s6\n"];
  [self checkRule:g rule:@"c" expecting:expecting];
  expecting = [[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s9\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-A..B->.s5\n"] stringByAppendingString:@".s5->.s3\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s9->.s6\n"] stringByAppendingString:@":s7-EOF->.s8\n"];
  [self checkRule:g rule:@"d" expecting:expecting];
  expecting = [[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s8\n"] stringByAppendingString:@".s3-A..B->.s4\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5->:s6\n"] stringByAppendingString:@".s8->.s5\n"] stringByAppendingString:@":s6-EOF->.s7\n"];
  [self checkRule:g rule:@"e" expecting:expecting];
}

- (void) testNotSet {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"tokens { A; B; C; }\n"] stringByAppendingString:@"a : ~A ;\n"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-B..C->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-EOF->.s5\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
  NSString * expectingGrammarStr = [@"1:8: parser grammar P;\n" stringByAppendingString:@"a : ~ A ;"];
  [self assertEquals:expectingGrammarStr param1:[g description]];
}

- (void) testNotSingletonBlockSet {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"tokens { A; B; C; }\n"] stringByAppendingString:@"a : ~(A) ;\n"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-B..C->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-EOF->.s5\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
  NSString * expectingGrammarStr = [@"1:8: parser grammar P;\n" stringByAppendingString:@"a : ~ ( A ) ;"];
  [self assertEquals:expectingGrammarStr param1:[g description]];
}

- (void) testNotCharSet {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"A : ~'3' ;\n"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-{'\\u0000'..'2', '4'..'\\uFFFF'}->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-<EOT>->.s5\n"];
  [self checkRule:g rule:@"A" expecting:expecting];
  NSString * expectingGrammarStr = [[@"1:7: lexer grammar P;\n" stringByAppendingString:@"A : ~ '3' ;\n"] stringByAppendingString:@"Tokens : A ;"];
  [self assertEquals:expectingGrammarStr param1:[g description]];
}

- (void) testNotBlockSet {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"A : ~('3'|'b') ;\n"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-{'\\u0000'..'2', '4'..'a', 'c'..'\\uFFFF'}->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-<EOT>->.s5\n"];
  [self checkRule:g rule:@"A" expecting:expecting];
  NSString * expectingGrammarStr = [[@"1:7: lexer grammar P;\n" stringByAppendingString:@"A : ~ ( '3' | 'b' ) ;\n"] stringByAppendingString:@"Tokens : A ;"];
  [self assertEquals:expectingGrammarStr param1:[g description]];
}

- (void) testNotSetLoop {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"A : ~('3')* ;\n"]] autorelease];
  NSString * expecting = [[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s9\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-{'\\u0000'..'2', '4'..'\\uFFFF'}->.s5\n"] stringByAppendingString:@".s5->.s3\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s9->.s6\n"] stringByAppendingString:@":s7-<EOT>->.s8\n"];
  [self checkRule:g rule:@"A" expecting:expecting];
  NSString * expectingGrammarStr = [[@"1:7: lexer grammar P;\n" stringByAppendingString:@"A : (~ ( '3' ) )* ;\n"] stringByAppendingString:@"Tokens : A ;"];
  [self assertEquals:expectingGrammarStr param1:[g description]];
}

- (void) testNotBlockSetLoop {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"A : ~('3'|'b')* ;\n"]] autorelease];
  NSString * expecting = [[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s9\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-{'\\u0000'..'2', '4'..'a', 'c'..'\\uFFFF'}->.s5\n"] stringByAppendingString:@".s5->.s3\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s9->.s6\n"] stringByAppendingString:@":s7-<EOT>->.s8\n"];
  [self checkRule:g rule:@"A" expecting:expecting];
  NSString * expectingGrammarStr = [[@"1:7: lexer grammar P;\n" stringByAppendingString:@"A : (~ ( '3' | 'b' ) )* ;\n"] stringByAppendingString:@"Tokens : A ;"];
  [self assertEquals:expectingGrammarStr param1:[g description]];
}

- (void) testSetsInCombinedGrammarSentToLexer {
  Grammar * g = [[[Grammar alloc] init:[@"grammar t;\n" stringByAppendingString:@"A : '{' ~('}')* '}';\n"]] autorelease];
  NSString * result = [g lexerGrammar];
  NSString * expecting = [[[@"lexer grammar t;\n" stringByAppendingString:@"\n"] stringByAppendingString:@"// $ANTLR src \"<string>\" 2\n"] stringByAppendingString:@"A : '{' ~('}')* '}';\n"];
  [self assertEquals:result param1:expecting];
}

- (void) testLabeledNotSet {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"tokens { A; B; C; }\n"] stringByAppendingString:@"a : t=~A ;\n"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-B..C->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-EOF->.s5\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
  NSString * expectingGrammarStr = [@"1:8: parser grammar P;\n" stringByAppendingString:@"a : t=~ A ;"];
  [self assertEquals:expectingGrammarStr param1:[g description]];
}

- (void) testLabeledNotCharSet {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"A : t=~'3' ;\n"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-{'\\u0000'..'2', '4'..'\\uFFFF'}->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-<EOT>->.s5\n"];
  [self checkRule:g rule:@"A" expecting:expecting];
  NSString * expectingGrammarStr = [[@"1:7: lexer grammar P;\n" stringByAppendingString:@"A : t=~ '3' ;\n"] stringByAppendingString:@"Tokens : A ;"];
  [self assertEquals:expectingGrammarStr param1:[g description]];
}

- (void) testLabeledNotBlockSet {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"A : t=~('3'|'b') ;\n"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-{'\\u0000'..'2', '4'..'a', 'c'..'\\uFFFF'}->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-<EOT>->.s5\n"];
  [self checkRule:g rule:@"A" expecting:expecting];
  NSString * expectingGrammarStr = [[@"1:7: lexer grammar P;\n" stringByAppendingString:@"A : t=~ ( '3' | 'b' ) ;\n"] stringByAppendingString:@"Tokens : A ;"];
  [self assertEquals:expectingGrammarStr param1:[g description]];
}

- (void) testEscapedCharLiteral {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : '\\n';"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-'\\n'->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-EOF->.s5\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testEscapedStringLiteral {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : 'a\\nb\\u0030c\\'';"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-'a\\nb\\u0030c\\''->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-EOF->.s5\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_RuleBlock {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : 'a'{;}|'b';"]] autorelease];
  NSString * expecting = [[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s1->.s9\n"] stringByAppendingString:@".s10-'b'->.s11\n"] stringByAppendingString:@".s11->.s6\n"] stringByAppendingString:@".s2-{synpred1_t}?->.s3\n"] stringByAppendingString:@".s3-'a'->.s4\n"] stringByAppendingString:@".s4-{}->.s5\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s9->.s10\n"] stringByAppendingString:@":s7-EOF->.s8\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_RuleSetBlock {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : 'a'|'b';"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-'a'..'b'->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-EOF->.s5\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_SimpleBlock {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a'{;}|'b') ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s10->.s11\n"] stringByAppendingString:@".s11-'b'->.s12\n"] stringByAppendingString:@".s12->.s7\n"] stringByAppendingString:@".s2->.s10\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3-{synpred1_t}?->.s4\n"] stringByAppendingString:@".s4-'a'->.s5\n"] stringByAppendingString:@".s5-{}->.s6\n"] stringByAppendingString:@".s6->.s7\n"] stringByAppendingString:@".s7->:s8\n"] stringByAppendingString:@":s8-EOF->.s9\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_SetBlock {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a'|'b') ;"]] autorelease];
  NSString * expecting = [[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2-'a'..'b'->.s3\n"] stringByAppendingString:@".s3->:s4\n"] stringByAppendingString:@":s4-EOF->.s5\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_StarBlock {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a'{;}|'b')* ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s12->.s13\n"] stringByAppendingString:@".s13-{synpred2_t}?->.s14\n"] stringByAppendingString:@".s14-'b'->.s15\n"] stringByAppendingString:@".s15->.s8\n"] stringByAppendingString:@".s16->.s9\n"] stringByAppendingString:@".s2->.s16\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s12\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-{synpred1_t}?->.s5\n"] stringByAppendingString:@".s5-'a'->.s6\n"] stringByAppendingString:@".s6-{}->.s7\n"] stringByAppendingString:@".s7->.s8\n"] stringByAppendingString:@".s8->.s3\n"] stringByAppendingString:@".s8->.s9\n"] stringByAppendingString:@".s9->:s10\n"] stringByAppendingString:@":s10-EOF->.s11\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_StarSetBlock_IgnoresPreds {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a'|'b')* ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s9\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-'a'..'b'->.s5\n"] stringByAppendingString:@".s5->.s3\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s9->.s6\n"] stringByAppendingString:@":s7-EOF->.s8\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_StarSetBlock {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a'|'b'{;})* ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s11->.s12\n"] stringByAppendingString:@".s12-{synpred2_t}?->.s13\n"] stringByAppendingString:@".s13-'b'->.s14\n"] stringByAppendingString:@".s14-{}->.s15\n"] stringByAppendingString:@".s15->.s7\n"] stringByAppendingString:@".s16->.s8\n"] stringByAppendingString:@".s2->.s16\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s11\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-{synpred1_t}?->.s5\n"] stringByAppendingString:@".s5-'a'->.s6\n"] stringByAppendingString:@".s6->.s7\n"] stringByAppendingString:@".s7->.s3\n"] stringByAppendingString:@".s7->.s8\n"] stringByAppendingString:@".s8->:s9\n"] stringByAppendingString:@":s9-EOF->.s10\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_StarBlock1Alt {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a')* ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s10->.s7\n"] stringByAppendingString:@".s2->.s10\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-{synpred1_t}?->.s5\n"] stringByAppendingString:@".s5-'a'->.s6\n"] stringByAppendingString:@".s6->.s3\n"] stringByAppendingString:@".s6->.s7\n"] stringByAppendingString:@".s7->:s8\n"] stringByAppendingString:@":s8-EOF->.s9\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_PlusBlock {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a'{;}|'b')+ ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s12->.s13\n"] stringByAppendingString:@".s13-{synpred2_t}?->.s14\n"] stringByAppendingString:@".s14-'b'->.s15\n"] stringByAppendingString:@".s15->.s8\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s12\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-{synpred1_t}?->.s5\n"] stringByAppendingString:@".s5-'a'->.s6\n"] stringByAppendingString:@".s6-{}->.s7\n"] stringByAppendingString:@".s7->.s8\n"] stringByAppendingString:@".s8->.s3\n"] stringByAppendingString:@".s8->.s9\n"] stringByAppendingString:@".s9->:s10\n"] stringByAppendingString:@":s10-EOF->.s11\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_PlusSetBlock {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a'|'b'{;})+ ;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s11->.s12\n"] stringByAppendingString:@".s12-{synpred2_t}?->.s13\n"] stringByAppendingString:@".s13-'b'->.s14\n"] stringByAppendingString:@".s14-{}->.s15\n"] stringByAppendingString:@".s15->.s7\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s11\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-{synpred1_t}?->.s5\n"] stringByAppendingString:@".s5-'a'->.s6\n"] stringByAppendingString:@".s6->.s7\n"] stringByAppendingString:@".s7->.s3\n"] stringByAppendingString:@".s7->.s8\n"] stringByAppendingString:@".s8->:s9\n"] stringByAppendingString:@":s9-EOF->.s10\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_PlusBlock1Alt {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a')+ ;"]] autorelease];
  NSString * expecting = [[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3->.s4\n"] stringByAppendingString:@".s4-{synpred1_t}?->.s5\n"] stringByAppendingString:@".s5-'a'->.s6\n"] stringByAppendingString:@".s6->.s3\n"] stringByAppendingString:@".s6->.s7\n"] stringByAppendingString:@".s7->:s8\n"] stringByAppendingString:@":s8-EOF->.s9\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_OptionalBlock2Alts {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a'{;}|'b')?;"]] autorelease];
  NSString * expecting = [[[[[[[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s10->.s11\n"] stringByAppendingString:@".s10->.s14\n"] stringByAppendingString:@".s11-{synpred2_t}?->.s12\n"] stringByAppendingString:@".s12-'b'->.s13\n"] stringByAppendingString:@".s13->.s7\n"] stringByAppendingString:@".s14->.s7\n"] stringByAppendingString:@".s2->.s10\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s3-{synpred1_t}?->.s4\n"] stringByAppendingString:@".s4-'a'->.s5\n"] stringByAppendingString:@".s5-{}->.s6\n"] stringByAppendingString:@".s6->.s7\n"] stringByAppendingString:@".s7->:s8\n"] stringByAppendingString:@":s8-EOF->.s9\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_OptionalBlock1Alt {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a')?;"]] autorelease];
  NSString * expecting = [[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s2->.s3\n"] stringByAppendingString:@".s2->.s9\n"] stringByAppendingString:@".s3-{synpred1_t}?->.s4\n"] stringByAppendingString:@".s4-'a'->.s5\n"] stringByAppendingString:@".s5->.s6\n"] stringByAppendingString:@".s6->:s7\n"] stringByAppendingString:@".s9->.s6\n"] stringByAppendingString:@":s7-EOF->.s8\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) testAutoBacktracking_ExistingPred {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"a : ('a')=> 'a' | 'b';"]] autorelease];
  NSString * expecting = [[[[[[[[[[@".s0->.s1\n" stringByAppendingString:@".s1->.s2\n"] stringByAppendingString:@".s1->.s8\n"] stringByAppendingString:@".s10->.s5\n"] stringByAppendingString:@".s2-{synpred1_t}?->.s3\n"] stringByAppendingString:@".s3-'a'->.s4\n"] stringByAppendingString:@".s4->.s5\n"] stringByAppendingString:@".s5->:s6\n"] stringByAppendingString:@".s8->.s9\n"] stringByAppendingString:@".s9-'b'->.s10\n"] stringByAppendingString:@":s6-EOF->.s7\n"];
  [self checkRule:g rule:@"a" expecting:expecting];
}

- (void) checkRule:(Grammar *)g rule:(NSString *)rule expecting:(NSString *)expecting {
  [g buildNFA];
  State * startState = [g getRuleStartState:rule];
  FASerializer * serializer = [[[FASerializer alloc] init:g] autorelease];
  NSString * result = [serializer serialize:startState];
  [self assertEquals:expecting param1:result];
}

@end
