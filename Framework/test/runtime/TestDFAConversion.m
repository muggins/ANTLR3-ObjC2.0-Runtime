#import "TestDFAConversion.h"

@implementation TestDFAConversion_Anon1

- (void) init {
  if (self = [super init]) {
    [self add:@"a"];
    [self add:@"b"];
  }
  return self;
}

@end

@implementation TestDFAConversion_Anon2

- (void) init {
  if (self = [super init]) {
    [self add:@"a"];
    [self add:@"b"];
  }
  return self;
}

@end

@implementation TestDFAConversion_Anon3

- (void) init {
  if (self = [super init]) {
    [self add:@"a"];
    [self add:@"b"];
  }
  return self;
}

@end

@implementation TestDFAConversion_Anon4

- (void) init {
  if (self = [super init]) {
    [self add:@"a"];
    [self add:@"b"];
  }
  return self;
}

@end

@implementation TestDFAConversion_Anon5

- (void) init {
  if (self = [super init]) {
    [self add:@"a"];
    [self add:@"b"];
    [self add:@"e"];
    [self add:@"d"];
  }
  return self;
}

@end

@implementation TestDFAConversion_Anon6

- (void) init {
  if (self = [super init]) {
    [self add:@"a"];
    [self add:@"b"];
    [self add:@"d"];
    [self add:@"e"];
  }
  return self;
}

@end

@implementation TestDFAConversion_Anon7

- (void) init {
  if (self = [super init]) {
    [self add:@"a"];
  }
  return self;
}

@end

@implementation TestDFAConversion_Anon8

- (void) init {
  if (self = [super init]) {
    [self add:@"a"];
    [self add:@"b"];
    [self add:@"c"];
  }
  return self;
}

@end

@implementation TestDFAConversion_Anon9

- (void) init {
  if (self = [super init]) {
    [self add:@"a"];
    [self add:@"b"];
    [self add:@"c"];
    [self add:@"x"];
    [self add:@"y"];
  }
  return self;
}

@end

@implementation TestDFAConversion_Anon10

- (void) init {
  if (self = [super init]) {
    [self add:@"synpred1_t"];
  }
  return self;
}

@end

@implementation TestDFAConversion_Anon11

- (void) init {
  if (self = [super init]) {
    [self add:@"synpred1_t"];
  }
  return self;
}

@end

@implementation TestDFAConversion_Anon12

- (void) init {
  if (self = [super init]) {
    [self add:@"synpred1_t"];
  }
  return self;
}

@end

@implementation TestDFAConversion

- (void) testA
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : A C | B;"]] autorelease];
  NSString *expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-B->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAB_or_AC
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : A B | A C;"]] autorelease];
  NSString *expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-B->:s2=>1\n"] stringByAppendingString:@".s1-C->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAB_or_AC_k2
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"options {k=2;}\n"] stringByAppendingString:@"a : A B | A C;"]] autorelease];
  NSString *expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-B->:s2=>1\n"] stringByAppendingString:@".s1-C->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAB_or_AC_k1
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"options {k=1;}\n"] stringByAppendingString:@"a : A B | A C;"]] autorelease];
  NSString *expecting = @".s0-A->:s1=>1\n";
  NSArray *unreachableAlts = [NSArray arrayWithObjects:2, nil];
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = @"A";
  NSArray *danglingAlts = [NSArray arrayWithObjects:2, nil];
  int numWarnings = 2;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testselfRecurseNonDet
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : A a X | A a Y;"]] autorelease];
  NSMutableArray *altsWithRecursion = [Arrays asList:[NSArray arrayWithObjects:1, 2, nil]];
  [self assertNonLLStar:g expectedBadAlts:altsWithRecursion];
}

- (void) testRecursionOverflow
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : a Y | A A A A A X ;\n"] stringByAppendingString:@"a : A a | Q;"]] autorelease];
  NSMutableArray *expectedTargetRules = [Arrays asList:[NSArray arrayWithObjects:@"a", nil]];
  int expectedAlt = 1;
  [self assertRecursionOverflow:g expectedTargetRules:expectedTargetRules expectedAlt:expectedAlt];
}

- (void) testRecursionOverflow2
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : a Y | A+ X ;\n"] stringByAppendingString:@"a : A a | Q;"]] autorelease];
  NSMutableArray *expectedTargetRules = [Arrays asList:[NSArray arrayWithObjects:@"a", nil]];
  int expectedAlt = 1;
  [self assertRecursionOverflow:g expectedTargetRules:expectedTargetRules expectedAlt:expectedAlt];
}

- (void) testRecursionOverflowWithPredOk
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : (a Y)=> a Y | A A A A A X ;\n"] stringByAppendingString:@"a : A a | Q;"]] autorelease];
  NSString *expecting = [[[[[[[[[[[@".s0-A->.s1\n" stringByAppendingString:@".s0-Q&&{synpred1_t}?->:s11=>1\n"] stringByAppendingString:@".s1-A->.s2\n"] stringByAppendingString:@".s1-Q&&{synpred1_t}?->:s10=>1\n"] stringByAppendingString:@".s2-A->.s3\n"] stringByAppendingString:@".s2-Q&&{synpred1_t}?->:s9=>1\n"] stringByAppendingString:@".s3-A->.s4\n"] stringByAppendingString:@".s3-Q&&{synpred1_t}?->:s8=>1\n"] stringByAppendingString:@".s4-A->.s5\n"] stringByAppendingString:@".s4-Q&&{synpred1_t}?->:s6=>1\n"] stringByAppendingString:@".s5-{synpred1_t}?->:s6=>1\n"] stringByAppendingString:@".s5-{true}?->:s7=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testRecursionOverflowWithPredOk2
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : (a Y)=> a Y | A A A A A X | Z;\n"] stringByAppendingString:@"a : A a | Q;"]] autorelease];
  NSString *expecting = [[[[[[[[[[[[@".s0-A->.s1\n" stringByAppendingString:@".s0-Q&&{synpred1_t}?->:s11=>1\n"] stringByAppendingString:@".s0-Z->:s12=>3\n"] stringByAppendingString:@".s1-A->.s2\n"] stringByAppendingString:@".s1-Q&&{synpred1_t}?->:s10=>1\n"] stringByAppendingString:@".s2-A->.s3\n"] stringByAppendingString:@".s2-Q&&{synpred1_t}?->:s9=>1\n"] stringByAppendingString:@".s3-A->.s4\n"] stringByAppendingString:@".s3-Q&&{synpred1_t}?->:s8=>1\n"] stringByAppendingString:@".s4-A->.s5\n"] stringByAppendingString:@".s4-Q&&{synpred1_t}?->:s6=>1\n"] stringByAppendingString:@".s5-{synpred1_t}?->:s6=>1\n"] stringByAppendingString:@".s5-{true}?->:s7=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testCannotSeePastRecursion
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"x   : y X\n"] stringByAppendingString:@"    | y Y\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"y   : L y R\n"] stringByAppendingString:@"    | B\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSMutableArray *altsWithRecursion = [Arrays asList:[NSArray arrayWithObjects:1, 2, nil]];
  [self assertNonLLStar:g expectedBadAlts:altsWithRecursion];
}

- (void) testSynPredResolvesRecursion
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"x   : (y X)=> y X\n"] stringByAppendingString:@"    | y Y\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"y   : L y R\n"] stringByAppendingString:@"    | B\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSString *expecting = [[[[[@".s0-B->.s4\n" stringByAppendingString:@".s0-L->.s1\n"] stringByAppendingString:@".s1-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"] stringByAppendingString:@".s4-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s4-{true}?->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testSynPredMissingInMiddle
{
  Grammar *g = [[[Grammar alloc] init:[[[[@"parser grammar t;\n" stringByAppendingString:@"x   : (A)=> X\n"] stringByAppendingString:@"    | X\n"] stringByAppendingString:@"	 | (C)=> X"] stringByAppendingString:@"    ;\n"]] autorelease];
  NSString *expecting = [[[@".s0-X->.s1\n" stringByAppendingString:@".s1-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s1-{synpred2_t}?->:s4=>3\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testAutoBacktrackAndPredMissingInMiddle
{
  Grammar *g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"x   : (A)=> X\n"] stringByAppendingString:@"    | X\n"] stringByAppendingString:@"	 | (C)=> X"] stringByAppendingString:@"    ;\n"]] autorelease];
  NSString *expecting = [[[@".s0-X->.s1\n" stringByAppendingString:@".s1-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s1-{synpred2_t}?->:s3=>2\n"] stringByAppendingString:@".s1-{synpred3_t}?->:s4=>3\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testSemPredResolvesRecursion
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"x   : {p}? y X\n"] stringByAppendingString:@"    | y Y\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"y   : L y R\n"] stringByAppendingString:@"    | B\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSString *expecting = [[[[[@".s0-B->.s4\n" stringByAppendingString:@".s0-L->.s1\n"] stringByAppendingString:@".s1-{p}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"] stringByAppendingString:@".s4-{p}?->:s2=>1\n"] stringByAppendingString:@".s4-{true}?->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testSemPredResolvesRecursion2
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"x\n"] stringByAppendingString:@"options {k=1;}\n"] stringByAppendingString:@"   : {p}? y X\n"] stringByAppendingString:@"    | y Y\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"y   : L y R\n"] stringByAppendingString:@"    | B\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSString *expecting = [[[[[@".s0-B->.s4\n" stringByAppendingString:@".s0-L->.s1\n"] stringByAppendingString:@".s1-{p}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"] stringByAppendingString:@".s4-{p}?->:s2=>1\n"] stringByAppendingString:@".s4-{true}?->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testSemPredResolvesRecursion3
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"x\n"] stringByAppendingString:@"options {k=2;}\n"] stringByAppendingString:@"   : {p}? y X\n"] stringByAppendingString:@"    | y Y\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"y   : L y R\n"] stringByAppendingString:@"    | B\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSString *expecting = [[[[[[[[[@".s0-B->.s6\n" stringByAppendingString:@".s0-L->.s1\n"] stringByAppendingString:@".s1-B->.s5\n"] stringByAppendingString:@".s1-L->.s2\n"] stringByAppendingString:@".s2-{p}?->:s3=>1\n"] stringByAppendingString:@".s2-{true}?->:s4=>2\n"] stringByAppendingString:@".s5-{p}?->:s3=>1\n"] stringByAppendingString:@".s5-{true}?->:s4=>2\n"] stringByAppendingString:@".s6-X->:s3=>1\n"] stringByAppendingString:@".s6-Y->:s4=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testSynPredResolvesRecursion2
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"statement\n"] stringByAppendingString:@"    :     (reference ASSIGN)=> reference ASSIGN expr\n"] stringByAppendingString:@"    |     expr\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"expr:     reference\n"] stringByAppendingString:@"    |     INT\n"] stringByAppendingString:@"    |     FLOAT\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"reference\n"] stringByAppendingString:@"    :     ID L argument_list R\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"argument_list\n"] stringByAppendingString:@"    :     expr COMMA expr\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSString *expecting = [[[@".s0-ID->.s1\n" stringByAppendingString:@".s0-INT..FLOAT->:s3=>2\n"] stringByAppendingString:@".s1-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testSynPredResolvesRecursion3
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[[[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"statement\n"] stringByAppendingString:@"options {k=1;}\n"] stringByAppendingString:@"    :     (reference ASSIGN)=> reference ASSIGN expr\n"] stringByAppendingString:@"    |     expr\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"expr:     reference\n"] stringByAppendingString:@"    |     INT\n"] stringByAppendingString:@"    |     FLOAT\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"reference\n"] stringByAppendingString:@"    :     ID L argument_list R\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"argument_list\n"] stringByAppendingString:@"    :     expr COMMA expr\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSString *expecting = [[[@".s0-ID->.s1\n" stringByAppendingString:@".s0-INT..FLOAT->:s3=>2\n"] stringByAppendingString:@".s1-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testSynPredResolvesRecursion4
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[[[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"statement\n"] stringByAppendingString:@"options {k=2;}\n"] stringByAppendingString:@"    :     (reference ASSIGN)=> reference ASSIGN expr\n"] stringByAppendingString:@"    |     expr\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"expr:     reference\n"] stringByAppendingString:@"    |     INT\n"] stringByAppendingString:@"    |     FLOAT\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"reference\n"] stringByAppendingString:@"    :     ID L argument_list R\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"argument_list\n"] stringByAppendingString:@"    :     expr COMMA expr\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSString *expecting = [[[[@".s0-ID->.s1\n" stringByAppendingString:@".s0-INT..FLOAT->:s4=>2\n"] stringByAppendingString:@".s1-L->.s2\n"] stringByAppendingString:@".s2-{synpred1_t}?->:s3=>1\n"] stringByAppendingString:@".s2-{true}?->:s4=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testSynPredResolvesRecursionInLexer
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"A :     (B ';')=> B ';'\n"] stringByAppendingString:@"  |     B '.'\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"B :     '(' B ')'\n"] stringByAppendingString:@"  |     'x'\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSString *expecting = [[[[[@".s0-'('->.s1\n" stringByAppendingString:@".s0-'x'->.s4\n"] stringByAppendingString:@".s1-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"] stringByAppendingString:@".s4-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s4-{true}?->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testAutoBacktrackResolvesRecursionInLexer
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[[@"lexer grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"A :     B ';'\n"] stringByAppendingString:@"  |     B '.'\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"B :     '(' B ')'\n"] stringByAppendingString:@"  |     'x'\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSString *expecting = [[[[[@".s0-'('->.s1\n" stringByAppendingString:@".s0-'x'->.s4\n"] stringByAppendingString:@".s1-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"] stringByAppendingString:@".s4-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s4-{true}?->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testAutoBacktrackResolvesRecursion
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"options {backtrack=true;}\n"] stringByAppendingString:@"x   : y X\n"] stringByAppendingString:@"    | y Y\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"y   : L y R\n"] stringByAppendingString:@"    | B\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSString *expecting = [[[[[@".s0-B->.s4\n" stringByAppendingString:@".s0-L->.s1\n"] stringByAppendingString:@".s1-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"] stringByAppendingString:@".s4-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s4-{true}?->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testselfRecurseNonDet2
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : P a P | P;"]] autorelease];
  NSString *expecting = [[@".s0-P->.s1\n" stringByAppendingString:@".s1-EOF->:s3=>2\n"] stringByAppendingString:@".s1-P->:s2=>1\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = @"P P";
  NSArray *danglingAlts = nil;
  int numWarnings = 1;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testIndirectRecursionLoop
{
  Grammar *g = [[[Grammar alloc] init:[[[@"parser grammar t;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : b X ;\n"] stringByAppendingString:@"b : a B ;\n"]] autorelease];
  DecisionProbe.verbose = YES;
  ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Set *leftRecursive = [g leftRecursiveRules];
  Set *expectedRules = [[[TestDFAConversion_Anon1 alloc] init] autorelease];
  [self assertEquals:expectedRules param1:[self ruleNames:leftRecursive]];
  [self assertEquals:1 param1:[equeue.errors size]];
  Message *msg = (Message *)[equeue.errors get:0];
  [self assertTrue:[@"expecting left recursion cycles; found " stringByAppendingString:[[msg class] name]] param1:[msg conformsToProtocol:@protocol(LeftRecursionCyclesMessage)]];
  LeftRecursionCyclesMessage *cyclesMsg = (LeftRecursionCyclesMessage *)msg;
  NSMutableArray *result = cyclesMsg.cycles;
  Set *expecting = [[[TestDFAConversion_Anon2 alloc] init] autorelease];
  [self assertEquals:expecting param1:[self ruleNames2:result]];
}

- (void) testIndirectRecursionLoop2
{
  Grammar *g = [[[Grammar alloc] init:[[[[@"parser grammar t;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : i b X ;\n"] stringByAppendingString:@"b : a B ;\n"] stringByAppendingString:@"i : ;\n"]] autorelease];
  DecisionProbe.verbose = YES;
  ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Set *leftRecursive = [g leftRecursiveRules];
  Set *expectedRules = [[[TestDFAConversion_Anon3 alloc] init] autorelease];
  [self assertEquals:expectedRules param1:[self ruleNames:leftRecursive]];
  [self assertEquals:1 param1:[equeue.errors size]];
  Message *msg = (Message *)[equeue.errors get:0];
  [self assertTrue:[@"expecting left recursion cycles; found " stringByAppendingString:[[msg class] name]] param1:[msg conformsToProtocol:@protocol(LeftRecursionCyclesMessage)]];
  LeftRecursionCyclesMessage *cyclesMsg = (LeftRecursionCyclesMessage *)msg;
  NSMutableArray *result = cyclesMsg.cycles;
  Set *expecting = [[[TestDFAConversion_Anon4 alloc] init] autorelease];
  [self assertEquals:expecting param1:[self ruleNames2:result]];
}

- (void) testIndirectRecursionLoop3
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : i b X ;\n"] stringByAppendingString:@"b : a B ;\n"] stringByAppendingString:@"i : ;\n"] stringByAppendingString:@"d : e ;\n"] stringByAppendingString:@"e : d ;\n"]] autorelease];
  DecisionProbe.verbose = YES;
  ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Set *leftRecursive = [g leftRecursiveRules];
  Set *expectedRules = [[[TestDFAConversion_Anon5 alloc] init] autorelease];
  [self assertEquals:expectedRules param1:[self ruleNames:leftRecursive]];
  [self assertEquals:1 param1:[equeue.errors size]];
  Message *msg = (Message *)[equeue.errors get:0];
  [self assertTrue:[@"expecting left recursion cycles; found " stringByAppendingString:[[msg class] name]] param1:[msg conformsToProtocol:@protocol(LeftRecursionCyclesMessage)]];
  LeftRecursionCyclesMessage *cyclesMsg = (LeftRecursionCyclesMessage *)msg;
  NSMutableArray *result = cyclesMsg.cycles;
  Set *expecting = [[[TestDFAConversion_Anon6 alloc] init] autorelease];
  [self assertEquals:expecting param1:[self ruleNames2:result]];
}

- (void) testifThenElse
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : IF s (E s)? | B;\n"] stringByAppendingString:@"slist: s SEMI ;"]] autorelease];
  NSString *expecting = [@".s0-E->:s1=>1\n" stringByAppendingString:@".s0-SEMI->:s2=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = @"E";
  NSArray *danglingAlts = nil;
  int numWarnings = 1;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
  expecting = [@".s0-B->:s2=>2\n" stringByAppendingString:@".s0-IF->:s1=>1\n"];
  [self checkDecision:g decision:2 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testifThenElseChecksStackSuffixConflict
{
  Grammar *g = [[[Grammar alloc] init:[[[@"parser grammar t;\n" stringByAppendingString:@"slist: s SEMI ;\n"] stringByAppendingString:@"s : IF s el | B;\n"] stringByAppendingString:@"el: (E s)? ;\n"]] autorelease];
  NSString *expecting = [@".s0-E->:s1=>1\n" stringByAppendingString:@".s0-SEMI->:s2=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = @"E";
  NSArray *danglingAlts = nil;
  int numWarnings = 1;
  [self checkDecision:g decision:2 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
  expecting = [@".s0-B->:s2=>2\n" stringByAppendingString:@".s0-IF->:s1=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testInvokeRule
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a : b A\n"] stringByAppendingString:@"  | b B\n"] stringByAppendingString:@"  | C\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : X\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSString *expecting = [[[@".s0-C->:s4=>3\n" stringByAppendingString:@".s0-X->.s1\n"] stringByAppendingString:@".s1-A->:s2=>1\n"] stringByAppendingString:@".s1-B->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testDoubleInvokeRuleLeftEdge
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a : b X\n"] stringByAppendingString:@"  | b Y\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : c B\n"] stringByAppendingString:@"  | c\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"c : C ;\n"]] autorelease];
  NSString *expecting = [[[[[@".s0-C->.s1\n" stringByAppendingString:@".s1-B->.s2\n"] stringByAppendingString:@".s1-X->:s3=>1\n"] stringByAppendingString:@".s1-Y->:s4=>2\n"] stringByAppendingString:@".s2-X->:s3=>1\n"] stringByAppendingString:@".s2-Y->:s4=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
  expecting = [[@".s0-C->.s1\n" stringByAppendingString:@".s1-B->:s2=>1\n"] stringByAppendingString:@".s1-X..Y->:s3=>2\n"];
  [self checkDecision:g decision:2 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testimmediateTailRecursion
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : A a | A B;"]] autorelease];
  NSString *expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-A->:s3=>1\n"] stringByAppendingString:@".s1-B->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAStar_immediateTailRecursion
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : A a | ;"]] autorelease];
  NSString *expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-EOF->:s2=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testNoStartRule
{
  ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : A a | X;"]] autorelease];
  Tool *antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator *generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  Message *msg = (Message *)[equeue.warnings get:0];
  [self assertTrue:[@"expecting no start rules; found " stringByAppendingString:[[msg class] name]] param1:[msg conformsToProtocol:@protocol(GrammarSemanticsMessage)]];
}

- (void) testAStar_immediateTailRecursion2
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : A a | A ;"]] autorelease];
  NSString *expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-A->:s2=>1\n"] stringByAppendingString:@".s1-EOF->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testimmediateLeftRecursion
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : a A | B;"]] autorelease];
  Set *leftRecursive = [g leftRecursiveRules];
  Set *expectedRules = [[[TestDFAConversion_Anon7 alloc] init] autorelease];
  [self assertEquals:expectedRules param1:[self ruleNames:leftRecursive]];
}

- (void) testIndirectLeftRecursion
{
  Grammar *g = [[[Grammar alloc] init:[[[[@"parser grammar t;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : b | A ;\n"] stringByAppendingString:@"b : c ;\n"] stringByAppendingString:@"c : a | C ;\n"]] autorelease];
  Set *leftRecursive = [g leftRecursiveRules];
  Set *expectedRules = [[[TestDFAConversion_Anon8 alloc] init] autorelease];
  [self assertEquals:expectedRules param1:[self ruleNames:leftRecursive]];
}

- (void) testLeftRecursionInMultipleCycles
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"s : a x ;\n"] stringByAppendingString:@"a : b | A ;\n"] stringByAppendingString:@"b : c ;\n"] stringByAppendingString:@"c : a | C ;\n"] stringByAppendingString:@"x : y | X ;\n"] stringByAppendingString:@"y : x ;\n"]] autorelease];
  Set *leftRecursive = [g leftRecursiveRules];
  Set *expectedRules = [[[TestDFAConversion_Anon9 alloc] init] autorelease];
  [self assertEquals:expectedRules param1:[self ruleNames:leftRecursive]];
}

- (void) testCycleInsideRuleDoesNotForceInfiniteRecursion
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : a ;\n"] stringByAppendingString:@"a : (A|)+ B;\n"]] autorelease];
  Set *leftRecursive = [g leftRecursiveRules];
  Set *expectedRules = [[[HashSet alloc] init] autorelease];
  [self assertEquals:expectedRules param1:leftRecursive];
}

- (void) testAStar
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : ( A )* ;"]] autorelease];
  NSString *expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-EOF->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAorBorCStar
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : ( A | B | C )* ;"]] autorelease];
  NSString *expecting = [@".s0-A..C->:s1=>1\n" stringByAppendingString:@".s0-EOF->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAPlus
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : ( A )+ ;"]] autorelease];
  NSString *expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-EOF->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAPlusNonGreedyWhenDeterministic
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : (options {greedy=false;}:A)+ ;\n"]] autorelease];
  NSString *expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-EOF->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAPlusNonGreedyWhenNonDeterministic
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : (options {greedy=false;}:A)+ A+ ;\n"]] autorelease];
  NSString *expecting = @".s0-A->:s1=>2\n";
  NSArray *unreachableAlts = [NSArray arrayWithObjects:1, nil];
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = @"A";
  NSArray *danglingAlts = nil;
  int numWarnings = 2;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testAPlusGreedyWhenNonDeterministic
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : (options {greedy=true;}:A)+ A+ ;\n"]] autorelease];
  NSString *expecting = @".s0-A->:s1=>1\n";
  NSArray *unreachableAlts = [NSArray arrayWithObjects:2, nil];
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 1;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testAorBorCPlus
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : ( A | B | C )+ ;"]] autorelease];
  NSString *expecting = [@".s0-A..C->:s1=>1\n" stringByAppendingString:@".s0-EOF->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAOptional
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : ( A )? B ;"]] autorelease];
  NSString *expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-B->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAorBorCOptional
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : ( A | B | C )? Z ;"]] autorelease];
  NSString *expecting = [@".s0-A..C->:s1=>1\n" stringByAppendingString:@".s0-Z->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAStarBOrAStarC
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : (A)* B | (A)* C;"]] autorelease];
  NSString *expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-B->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
  expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-C->:s2=>2\n"];
  [self checkDecision:g decision:2 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
  expecting = [[[[[@".s0-A->.s1\n" stringByAppendingString:@".s0-B->:s2=>1\n"] stringByAppendingString:@".s0-C->:s3=>2\n"] stringByAppendingString:@".s1-A->.s1\n"] stringByAppendingString:@".s1-B->:s2=>1\n"] stringByAppendingString:@".s1-C->:s3=>2\n"];
  [self checkDecision:g decision:3 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAStarBOrAPlusC
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : (A)* B | (A)+ C;"]] autorelease];
  NSString *expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-B->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
  expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-C->:s2=>2\n"];
  [self checkDecision:g decision:2 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
  expecting = [[[[@".s0-A->.s1\n" stringByAppendingString:@".s0-B->:s2=>1\n"] stringByAppendingString:@".s1-A->.s1\n"] stringByAppendingString:@".s1-B->:s2=>1\n"] stringByAppendingString:@".s1-C->:s3=>2\n"];
  [self checkDecision:g decision:3 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testAOrBPlusOrAPlus
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : (A|B)* X | (A)+ Y;"]] autorelease];
  NSString *expecting = [@".s0-A..B->:s1=>1\n" stringByAppendingString:@".s0-X->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
  expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-Y->:s2=>2\n"];
  [self checkDecision:g decision:2 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
  expecting = [[[[@".s0-A->.s1\n" stringByAppendingString:@".s0-B..X->:s2=>1\n"] stringByAppendingString:@".s1-A->.s1\n"] stringByAppendingString:@".s1-B..X->:s2=>1\n"] stringByAppendingString:@".s1-Y->:s3=>2\n"];
  [self checkDecision:g decision:3 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testLoopbackAndExit
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : (A|B)+ B;"]] autorelease];
  NSString *expecting = [[[@".s0-A->:s3=>1\n" stringByAppendingString:@".s0-B->.s1\n"] stringByAppendingString:@".s1-A..B->:s3=>1\n"] stringByAppendingString:@".s1-EOF->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testOptionalAltAndBypass
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : (A|B)? B;"]] autorelease];
  NSString *expecting = [[[@".s0-A->:s2=>1\n" stringByAppendingString:@".s0-B->.s1\n"] stringByAppendingString:@".s1-B->:s2=>1\n"] stringByAppendingString:@".s1-EOF->:s3=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testResolveLL1ByChoosingFirst
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : A C | A C;"]] autorelease];
  NSString *expecting = [@".s0-A->.s1\n" stringByAppendingString:@".s1-C->:s2=>1\n"];
  NSArray *unreachableAlts = [NSArray arrayWithObjects:2, nil];
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = @"A C";
  NSArray *danglingAlts = nil;
  int numWarnings = 2;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testResolveLL2ByChoosingFirst
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : A B | A B;"]] autorelease];
  NSString *expecting = [@".s0-A->.s1\n" stringByAppendingString:@".s1-B->:s2=>1\n"];
  NSArray *unreachableAlts = [NSArray arrayWithObjects:2, nil];
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = @"A B";
  NSArray *danglingAlts = nil;
  int numWarnings = 2;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testResolveLL2MixAlt
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : A B | A C | A B | Z;"]] autorelease];
  NSString *expecting = [[[@".s0-A->.s1\n" stringByAppendingString:@".s0-Z->:s4=>4\n"] stringByAppendingString:@".s1-B->:s2=>1\n"] stringByAppendingString:@".s1-C->:s3=>2\n"];
  NSArray *unreachableAlts = [NSArray arrayWithObjects:3, nil];
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 3, nil];
  NSString *ambigInput = @"A B";
  NSArray *danglingAlts = nil;
  int numWarnings = 2;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testIndirectIFThenElseStyleAmbig
{
  Grammar *g = [[[Grammar alloc] init:[[[[@"parser grammar t;\n" stringByAppendingString:@"s : stat ;\n"] stringByAppendingString:@"stat : LCURLY ( cg )* RCURLY | E SEMI  ;\n"] stringByAppendingString:@"cg : (c)+ (stat)* ;\n"] stringByAppendingString:@"c : CASE E ;\n"]] autorelease];
  NSString *expecting = [@".s0-CASE->:s2=>1\n" stringByAppendingString:@".s0-LCURLY..E->:s1=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = @"CASE";
  NSArray *danglingAlts = nil;
  int numWarnings = 1;
  [self checkDecision:g decision:3 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testComplement
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a : ~(A | B | C) | C {;} ;\n"] stringByAppendingString:@"b : X Y Z ;"]] autorelease];
  NSString *expecting = [@".s0-C->:s2=>2\n" stringByAppendingString:@".s0-X..Z->:s1=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testComplementToken
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"a : ~C | C {;} ;\n"] stringByAppendingString:@"b : X Y Z ;"]] autorelease];
  NSString *expecting = [@".s0-C->:s2=>2\n" stringByAppendingString:@".s0-X..Z->:s1=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testComplementChar
{
  Grammar *g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"A : ~'x' | 'x' {;} ;\n"]] autorelease];
  NSString *expecting = [@".s0-'x'->:s2=>2\n" stringByAppendingString:@".s0-{'\\u0000'..'w', 'y'..'\\uFFFF'}->:s1=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testComplementCharSet
{
  Grammar *g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"A : ~(' '|'\t'|'x'|'y') | 'x';\n"] stringByAppendingString:@"B : 'y' ;"]] autorelease];
  NSString *expecting = [@".s0-'y'->:s2=>2\n" stringByAppendingString:@".s0-{'\\u0000'..'\\b', '\\n'..'\\u001F', '!'..'x', 'z'..'\\uFFFF'}->:s1=>1\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testNoSetCollapseWithActions
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : (A | B {foo}) | C;"]] autorelease];
  NSString *expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-B->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testRuleAltsSetCollapse
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : A | B | C ;"]] autorelease];
  NSString *expecting = @" ( grammar t ( rule a ARG RET scope ( BLOCK ( ALT A <end-of-alt> ) ( ALT B <end-of-alt> ) ( ALT C <end-of-alt> ) <end-of-block> ) <end-of-rule> ) )";
  [self assertEquals:expecting param1:[[g grammarTree] toStringTree]];
}

- (void) testTokensRuleAltsDoNotCollapse
{
  Grammar *g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"A : 'a';"] stringByAppendingString:@"B : 'b';\n"]] autorelease];
  NSString *expecting = [@".s0-'a'->:s1=>1\n" stringByAppendingString:@".s0-'b'->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testMultipleSequenceCollision
{
  Grammar *g = [[[Grammar alloc] init:[[[[@"parser grammar t;\n" stringByAppendingString:@"a : (A{;}|B)\n"] stringByAppendingString:@"  | (A{;}|B)\n"] stringByAppendingString:@"  | A\n"] stringByAppendingString:@"  ;"]] autorelease];
  NSString *expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-B->:s2=>1\n"];
  NSArray *unreachableAlts = [NSArray arrayWithObjects:2, 3, nil];
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, 3, nil];
  NSString *ambigInput = @"A";
  NSArray *danglingAlts = nil;
  int numWarnings = 3;
  [self checkDecision:g decision:3 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testMultipleAltsSameSequenceCollision
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a : type ID \n"] stringByAppendingString:@"  | type ID\n"] stringByAppendingString:@"  | type ID\n"] stringByAppendingString:@"  | type ID\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"type : I | F;"]] autorelease];
  NSString *expecting = [@".s0-I..F->.s1\n" stringByAppendingString:@".s1-ID->:s2=>1\n"];
  NSArray *unreachableAlts = [NSArray arrayWithObjects:2, 3, 4, nil];
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, 3, 4, nil];
  NSString *ambigInput = @"I..F ID";
  NSArray *danglingAlts = nil;
  int numWarnings = 2;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testFollowReturnsToLoopReenteringSameRule
{
  Grammar *g = [[[Grammar alloc] init:[[[@"parser grammar t;\n" stringByAppendingString:@"sl : L ( esc | ~(R|SLASH) )* R ;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"esc : SLASH ( N | D03 (D07)? ) ;"]] autorelease];
  NSString *expecting = [[@".s0-R->:s3=>3\n" stringByAppendingString:@".s0-SLASH->:s1=>1\n"] stringByAppendingString:@".s0-{L, N..D07}->:s2=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = @"D07";
  NSArray *danglingAlts = nil;
  int numWarnings = 1;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testTokenCallsAnotherOnLeftEdge
{
  Grammar *g = [[[Grammar alloc] init:[[[[@"lexer grammar t;\n" stringByAppendingString:@"F   :   I '.'\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"I   :   '0'\n"] stringByAppendingString:@"    ;\n"]] autorelease];
  NSString *expecting = [[@".s0-'0'->.s1\n" stringByAppendingString:@".s1-'.'->:s3=>1\n"] stringByAppendingString:@".s1-<EOT>->:s2=>2\n"];
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testSelfRecursionAmbigAlts
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"s : a;\n"] stringByAppendingString:@"a   :   L ID R\n"] stringByAppendingString:@"    |   L a R\n"] stringByAppendingString:@"    |   b\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"b   :   ID\n"] stringByAppendingString:@"    ;\n"]] autorelease];
  NSString *expecting = [[[[@".s0-ID->:s5=>3\n" stringByAppendingString:@".s0-L->.s1\n"] stringByAppendingString:@".s1-ID->.s2\n"] stringByAppendingString:@".s1-L->:s4=>2\n"] stringByAppendingString:@".s2-R->:s3=>1\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = @"L ID R";
  NSArray *danglingAlts = nil;
  int numWarnings = 1;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testIndirectRecursionAmbigAlts
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"s   :   a ;\n"] stringByAppendingString:@"a   :   L ID R\n"] stringByAppendingString:@"    |   b\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"b   :   ID\n"] stringByAppendingString:@"    |   L a R\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSString *expecting = [[[[@".s0-ID->:s4=>2\n" stringByAppendingString:@".s0-L->.s1\n"] stringByAppendingString:@".s1-ID->.s2\n"] stringByAppendingString:@".s1-L->:s4=>2\n"] stringByAppendingString:@".s2-R->:s3=>1\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = @"L ID R";
  NSArray *danglingAlts = nil;
  int numWarnings = 1;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testTailRecursionInvokedFromArbitraryLookaheadDecision
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a : b X\n"] stringByAppendingString:@"  | b Y\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"b : A\n"] stringByAppendingString:@"  | A b\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  NSMutableArray *altsWithRecursion = [Arrays asList:[NSArray arrayWithObjects:1, 2, nil]];
  [self assertNonLLStar:g expectedBadAlts:altsWithRecursion];
}

- (void) testWildcardStarK1AndNonGreedyByDefaultInParser
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : A block EOF ;\n"] stringByAppendingString:@"block : L .* R ;"]] autorelease];
  NSString *expecting = [@".s0-A..L->:s2=>1\n" stringByAppendingString:@".s0-R->:s1=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testWildcardPlusK1AndNonGreedyByDefaultInParser
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : A block EOF ;\n"] stringByAppendingString:@"block : L .+ R ;"]] autorelease];
  NSString *expecting = [@".s0-A..L->:s2=>1\n" stringByAppendingString:@".s0-R->:s1=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testGatedSynPred
{
  Grammar *g = [[[Grammar alloc] init:[[[@"parser grammar t;\n" stringByAppendingString:@"x   : (X)=> X\n"] stringByAppendingString:@"    | Y\n"] stringByAppendingString:@"    ;\n"]] autorelease];
  NSString *expecting = [@".s0-X&&{synpred1_t}?->:s1=>1\n" stringByAppendingString:@".s0-Y->:s2=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
  Set *preds = g.synPredNamesUsedInDFA;
  Set *expectedPreds = [[[TestDFAConversion_Anon10 alloc] init] autorelease];
  [self assertEquals:@"predicate names not recorded properly in grammar" param1:expectedPreds param2:preds];
}

- (void) testHoistedGatedSynPred
{
  Grammar *g = [[[Grammar alloc] init:[[[@"parser grammar t;\n" stringByAppendingString:@"x   : (X)=> X\n"] stringByAppendingString:@"    | X\n"] stringByAppendingString:@"    ;\n"]] autorelease];
  NSString *expecting = [[@".s0-X->.s1\n" stringByAppendingString:@".s1-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
  Set *preds = g.synPredNamesUsedInDFA;
  Set *expectedPreds = [[[TestDFAConversion_Anon11 alloc] init] autorelease];
  [self assertEquals:@"predicate names not recorded properly in grammar" param1:expectedPreds param2:preds];
}

- (void) testHoistedGatedSynPred2
{
  Grammar *g = [[[Grammar alloc] init:[[[@"parser grammar t;\n" stringByAppendingString:@"x   : (X)=> (X|Y)\n"] stringByAppendingString:@"    | X\n"] stringByAppendingString:@"    ;\n"]] autorelease];
  NSString *expecting = [[[@".s0-X->.s1\n" stringByAppendingString:@".s0-Y&&{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s1-{synpred1_t}?->:s2=>1\n"] stringByAppendingString:@".s1-{true}?->:s3=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
  Set *preds = g.synPredNamesUsedInDFA;
  Set *expectedPreds = [[[TestDFAConversion_Anon12 alloc] init] autorelease];
  [self assertEquals:@"predicate names not recorded properly in grammar" param1:expectedPreds param2:preds];
}

- (void) testGreedyGetsNoErrorForAmbig
{
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : IF s (options {greedy=true;} : E s)? | B;\n"] stringByAppendingString:@"slist: s SEMI ;"]] autorelease];
  NSString *expecting = [@".s0-E->:s1=>1\n" stringByAppendingString:@".s0-SEMI->:s2=>2\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = nil;
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 0;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
  expecting = [@".s0-B->:s2=>2\n" stringByAppendingString:@".s0-IF->:s1=>1\n"];
  [self checkDecision:g decision:2 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) testGreedyNonLLStarStillGetsError
{
  Grammar *g = [[[Grammar alloc] init:[[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"x   : ( options {greedy=true;}\n"] stringByAppendingString:@"	   : y X\n"] stringByAppendingString:@"      | y Y\n"] stringByAppendingString:@"	   )\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"y   : L y R\n"] stringByAppendingString:@"    | B\n"] stringByAppendingString:@"    ;"]] autorelease];
  NSMutableArray *altsWithRecursion = [Arrays asList:[NSArray arrayWithObjects:1, 2, nil]];
  [self assertNonLLStar:g expectedBadAlts:altsWithRecursion];
}

- (void) testGreedyRecOverflowStillGetsError {
  Grammar *g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"s : (options {greedy=true;} : a Y | A A A A A X) ;\n"] stringByAppendingString:@"a : A a | Q;"]] autorelease];
  NSMutableArray *expectedTargetRules = [Arrays asList:[NSArray arrayWithObjects:@"a", nil]];
  int expectedAlt = 1;
  [self assertRecursionOverflow:g expectedTargetRules:expectedTargetRules expectedAlt:expectedAlt];
}

- (void) testCyclicTableCreation
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : A+ X | A+ Y ;"]] autorelease];
  NSString *expecting = [@".s0-A->:s1=>1\n" stringByAppendingString:@".s0-B->:s2=>2\n"];
}

- (void) _template
{
  Grammar *g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : A | B;"]] autorelease];
  NSString *expecting = @"\n";
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:nil expectingNonDetAlts:nil expectingAmbigInput:nil expectingDanglingAlts:nil expectingNumWarnings:0];
}

- (void) assertNonLLStar:(Grammar *)g expectedBadAlts:(NSMutableArray *)expectedBadAlts
{
  DecisionProbe.verbose = YES;
  ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  if ([g numberOfDecisions] == 0) {
    [g buildNFA];
    [g createLookaheadDFAs:NO];
  }
  NonRegularDecisionMessage *msg = [self getNonRegularDecisionMessage:equeue.errors];
  [self assertTrue:@"expected fatal non-LL(*) msg" param1:msg != nil];
  NSMutableArray *alts = [[[NSMutableArray alloc] init] autorelease];
  [alts addObjectsFromArray:msg.altsWithRecursion];
  [Collections sort:alts];
  [self assertEquals:expectedBadAlts param1:alts];
}

- (void) assertRecursionOverflow:(Grammar *)g expectedTargetRules:(NSMutableArray *)expectedTargetRules expectedAlt:(int)expectedAlt
{
  DecisionProbe.verbose = YES;
  ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  if ([g numberOfDecisions] == 0) {
    [g buildNFA];
    [g createLookaheadDFAs:NO];
  }
  RecursionOverflowMessage *msg = [self getRecursionOverflowMessage:equeue.errors];
  [self assertTrue:[@"missing expected recursion overflow msg" stringByAppendingString:msg] param1:msg != nil];
  [self assertEquals:@"target rules mismatch" param1:[expectedTargetRules description] param2:[msg.targetRules description]];
  [self assertEquals:@"mismatched alt" param1:expectedAlt param2:msg.alt];
}

- (void) testWildcardInTreeGrammar
{
  Grammar *g = [[[Grammar alloc] init:[@"tree grammar t;\n" stringByAppendingString:@"a : A B | A . ;\n"]] autorelease];
  NSString *expecting = [[@".s0-A->.s1\n" stringByAppendingString:@".s1-A->:s3=>2\n"] stringByAppendingString:@".s1-B->:s2=>1\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 1;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) testWildcardInTreeGrammar2
{
  Grammar *g = [[[Grammar alloc] init:[@"tree grammar t;\n" stringByAppendingString:@"a : ^(A X Y) | ^(A . .) ;\n"]] autorelease];
  NSString *expecting = [[[[[[[@".s0-A->.s1\n" stringByAppendingString:@".s1-DOWN->.s2\n"] stringByAppendingString:@".s2-X->.s3\n"] stringByAppendingString:@".s2-{A, Y}->:s6=>2\n"] stringByAppendingString:@".s3-Y->.s4\n"] stringByAppendingString:@".s3-{DOWN, A..X}->:s6=>2\n"] stringByAppendingString:@".s4-DOWN->:s6=>2\n"] stringByAppendingString:@".s4-UP->:s5=>1\n"];
  NSArray *unreachableAlts = nil;
  NSArray *nonDetAlts = [NSArray arrayWithObjects:1, 2, nil];
  NSString *ambigInput = nil;
  NSArray *danglingAlts = nil;
  int numWarnings = 1;
  [self checkDecision:g decision:1 expecting:expecting expectingUnreachableAlts:unreachableAlts expectingNonDetAlts:nonDetAlts expectingAmbigInput:ambigInput expectingDanglingAlts:danglingAlts expectingNumWarnings:numWarnings];
}

- (void) checkDecision:(Grammar *)g
              decision:(int)decision
             expecting:(NSString *)expecting
expectingUnreachableAlts:(NSArray *)expectingUnreachableAlts
  expectingNonDetAlts:(NSArray *)expectingNonDetAlts
  expectingAmbigInput:(NSString *)expectingAmbigInput
expectingDanglingAlts:(NSArray *)expectingDanglingAlts
 expectingNumWarnings:(int)expectingNumWarnings
{
  DecisionProbe.verbose = YES;
  ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  if ([g numberOfDecisions] == 0) {
    [g buildNFA];
    [g createLookaheadDFAs:NO];
  }
  CodeGenerator *generator = [[[CodeGenerator alloc] init:[self newTool] param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  if ([equeue size] != expectingNumWarnings) {
    [System.err println:[@"Warnings issued: " stringByAppendingString:equeue]];
  }
  [self assertEquals:@"unexpected number of expected problems" param1:expectingNumWarnings param2:[equeue size]];
  DFA *dfa = [g getLookaheadDFA:decision];
  [self assertNotNull:[@"no DFA for decision " stringByAppendingString:decision] param1:dfa];
  FASerializer *serializer = [[[FASerializer alloc] init:g] autorelease];
  NSString *result = [serializer serialize:dfa.startState];
  NSMutableArray *unreachableAlts = [dfa unreachableAlts];
  if (expectingUnreachableAlts != nil) {
    BitSet *s = [[[BitSet alloc] init] autorelease];
    [s addAll:expectingUnreachableAlts];
    BitSet *s2 = [[[BitSet alloc] init] autorelease];
    [s2 addAll:unreachableAlts];
    [self assertEquals:@"unreachable alts mismatch" param1:s param2:s2];
  }
   else {
    [self assertEquals:@"number of unreachable alts" param1:0 param2:unreachableAlts != nil ? [unreachableAlts count] : 0];
  }
  if (expectingAmbigInput != nil) {
    Message *msg = (Message *)[equeue.warnings get:0];
    [self assertTrue:[@"expecting nondeterminism; found " stringByAppendingString:[[msg class] name]] param1:[msg conformsToProtocol:@protocol(GrammarNonDeterminismMessage)]];
    GrammarNonDeterminismMessage *nondetMsg = [self getNonDeterminismMessage:equeue.warnings];
    NSMutableArray *labels = [nondetMsg.probe getSampleNonDeterministicInputSequence:nondetMsg.problemState];
    NSString *input = [nondetMsg.probe getInputSequenceDisplay:labels];
    [self assertEquals:expectingAmbigInput param1:input];
  }
  if (expectingNonDetAlts != nil) {
    RecursionOverflowMessage *recMsg = nil;
    GrammarNonDeterminismMessage *nondetMsg = [self getNonDeterminismMessage:equeue.warnings];
    NSMutableArray *nonDetAlts = nil;
    if (nondetMsg != nil) {
      nonDetAlts = [nondetMsg.probe getNonDeterministicAltsForState:nondetMsg.problemState];
    }
     else {
      recMsg = [self getRecursionOverflowMessage:equeue.warnings];
      if (recMsg != nil) {
      }
    }
    BitSet *s = [[[BitSet alloc] init] autorelease];
    [s addAll:expectingNonDetAlts];
    BitSet *s2 = [[[BitSet alloc] init] autorelease];
    [s2 addAll:nonDetAlts];
    [self assertEquals:@"nondet alts mismatch" param1:s param2:s2];
    [self assertTrue:[@"found no nondet alts; expecting: " stringByAppendingString:[self str:expectingNonDetAlts]] param1:nondetMsg != nil || recMsg != nil];
  }
   else {
    GrammarNonDeterminismMessage *nondetMsg = [self getNonDeterminismMessage:equeue.warnings];
    [self assertNull:@"found nondet alts, but expecting none" param1:nondetMsg];
  }
  [self assertEquals:expecting param1:result];
}

- (GrammarNonDeterminismMessage *) getNonDeterminismMessage:(NSMutableArray *)warnings {

  for (int i = 0; i < [warnings count]; i++) {
    Message *m = (Message *)[warnings objectAtIndex:i];
    if ([m conformsToProtocol:@protocol(GrammarNonDeterminismMessage)]) {
      return (GrammarNonDeterminismMessage *)m;
    }
  }

  return nil;
}

- (NonRegularDecisionMessage *) getNonRegularDecisionMessage:(NSMutableArray *)errors
{
  for (int i = 0; i < [errors count]; i++) {
    Message *m = (Message *)[errors objectAtIndex:i];
    if ([m conformsToProtocol:@protocol(NonRegularDecisionMessage)]) {
      return (NonRegularDecisionMessage *)m;
    }
  }

  return nil;
}

- (RecursionOverflowMessage *) getRecursionOverflowMessage:(NSMutableArray *)warnings
{
  for (int i = 0; i < [warnings count]; i++) {
    Message *m = (Message *)[warnings objectAtIndex:i];
    if ([m conformsToProtocol:@protocol(RecursionOverflowMessage)]) {
      return (RecursionOverflowMessage *)m;
    }
  }

  return nil;
}

- (LeftRecursionCyclesMessage *) getLeftRecursionCyclesMessage:(NSMutableArray *)warnings
{
  for (int i = 0; i < [warnings count]; i++) {
    Message *m = (Message *)[warnings objectAtIndex:i];
    if ([m conformsToProtocol:@protocol(LeftRecursionCyclesMessage)]) {
      return (LeftRecursionCyclesMessage *)m;
    }
  }

  return nil;
}

- (GrammarDanglingStateMessage *) getDanglingStateMessage:(NSMutableArray *)warnings
{
  for (int i = 0; i < [warnings count]; i++) {
    Message *m = (Message *)[warnings objectAtIndex:i];
    if ([m conformsToProtocol:@protocol(GrammarDanglingStateMessage)]) {
      return (GrammarDanglingStateMessage *)m;
    }
  }

  return nil;
}

- (NSString *) str:(NSArray *)elements
{
  StringBuffer *buf = [[[StringBuffer alloc] init] autorelease];

  for (int i = 0; i < elements.length; i++) {
    if (i > 0) {
      [buf append:@", "];
    }
    int element = elements[i];
    [buf append:element];
  }

  return [buf description];
}

- (Set *) ruleNames:(Set *)rules
{
  Set *x = [[[HashSet alloc] init] autorelease];

  for (Rule *r in rules) {
    [x add:r.name];
  }

  return x;
}

- (Set *) ruleNames2:(NSMutableArray *)rules {
  Set *x = [[[HashSet alloc] init] autorelease];

  for (HashSet *s in rules) {
    [x addAll:[self ruleNames:s]];
  }

  return x;
}

@end
