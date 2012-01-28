#import "TestTreeWizard.h"

@implementation TestTreeWizard_Anon1

- (void) visit:(NSObject *)t {
  [elements addObject:t];
}

@end

@implementation TestTreeWizard_Anon2

- (void) visit:(NSObject *)t {
  [elements addObject:t];
}

@end

@implementation TestTreeWizard_Anon3

- (void) visit:(NSObject *)t {
  [elements addObject:t];
}

@end

@implementation TestTreeWizard_Anon4

- (void) visit:(NSObject *)t {
  [elements addObject:t];
}

@end

@implementation TestTreeWizard_Anon5

- (void) visit:(NSObject *)t parent:(NSObject *)parent childIndex:(int)childIndex labels:(NSMutableDictionary *)labels {
  [elements addObject:[[[[adaptor getText:t] stringByAppendingString:@"@"] + (parent != nil ? [adaptor getText:parent] : @"nil") stringByAppendingString:@"["] + childIndex stringByAppendingString:@"]"]];
}

@end

@implementation TestTreeWizard_Anon6

- (void) visit:(NSObject *)t parent:(NSObject *)parent childIndex:(int)childIndex labels:(NSMutableDictionary *)labels {
  [elements addObject:[[[[adaptor getText:t] stringByAppendingString:@"@"] + (parent != nil ? [adaptor getText:parent] : @"nil") stringByAppendingString:@"["] + childIndex stringByAppendingString:@"]"]];
}

@end

@implementation TestTreeWizard_Anon7

- (void) visit:(NSObject *)t {
  [elements addObject:t];
}

@end

@implementation TestTreeWizard_Anon8

- (void) visit:(NSObject *)t parent:(NSObject *)parent childIndex:(int)childIndex labels:(NSMutableDictionary *)labels {
  [elements addObject:[[[[adaptor getText:t] stringByAppendingString:@"@"] + (parent != nil ? [adaptor getText:parent] : @"nil") stringByAppendingString:@"["] + childIndex stringByAppendingString:@"]"]];
}

@end

@implementation TestTreeWizard_Anon9

- (void) visit:(NSObject *)t parent:(NSObject *)parent childIndex:(int)childIndex labels:(NSMutableDictionary *)labels {
  [elements addObject:[[[[[adaptor getText:t] stringByAppendingString:@"@"] + (parent != nil ? [adaptor getText:parent] : @"nil") stringByAppendingString:@"["] + childIndex stringByAppendingString:@"]"] + [labels objectForKey:@"a"] stringByAppendingString:@"&"] + [labels objectForKey:@"b"]];
}

@end

NSArray * const tokens = [NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"A", @"B", @"C", @"D", @"E", @"ID", @"VAR", nil];
TreeAdaptor * const adaptor = [[[CommonTreeAdaptor alloc] init] autorelease];

@implementation TestTreeWizard

- (void) testSingleNode {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"ID"];
  NSString * found = [t toStringTree];
  NSString * expecting = @"ID";
  [self assertEquals:expecting param1:found];
}

- (void) testSingleNodeWithArg {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"ID[foo]"];
  NSString * found = [t toStringTree];
  NSString * expecting = @"foo";
  [self assertEquals:expecting param1:found];
}

- (void) testSingleNodeTree {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A)"];
  NSString * found = [t toStringTree];
  NSString * expecting = @"A";
  [self assertEquals:expecting param1:found];
}

- (void) testSingleLevelTree {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C D)"];
  NSString * found = [t toStringTree];
  NSString * expecting = @"(A B C D)";
  [self assertEquals:expecting param1:found];
}

- (void) testListTree {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(nil A B C)"];
  NSString * found = [t toStringTree];
  NSString * expecting = @"A B C";
  [self assertEquals:expecting param1:found];
}

- (void) testInvalidListTree {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"A B C"];
  [self assertTrue:t == nil];
}

- (void) testDoubleLevelTree {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A (B C) (B D) E)"];
  NSString * found = [t toStringTree];
  NSString * expecting = @"(A (B C) (B D) E)";
  [self assertEquals:expecting param1:found];
}

- (void) testSingleNodeIndex {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"ID"];
  NSMutableDictionary * m = [wiz index:t];
  NSString * found = [m description];
  NSString * expecting = @"{10=[ID]}";
  [self assertEquals:expecting param1:found];
}

- (void) testNoRepeatsIndex {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C D)"];
  NSMutableDictionary * m = [wiz index:t];
  NSString * found = [self sortMapToString:m];
  NSString * expecting = @"{5=[A], 6=[B], 7=[C], 8=[D]}";
  [self assertEquals:expecting param1:found];
}

- (void) testRepeatsIndex {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B (A C B) B D D)"];
  NSMutableDictionary * m = [wiz index:t];
  NSString * found = [self sortMapToString:m];
  NSString * expecting = @"{5=[A, A], 6=[B, B, B], 7=[C], 8=[D, D]}";
  [self assertEquals:expecting param1:found];
}

- (void) testNoRepeatsVisit {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C D)"];
  NSMutableArray * elements = [[[NSMutableArray alloc] init] autorelease];
  [wiz visit:t param1:[wiz getTokenType:@"B"] param2:[[[TestTreeWizard_Anon1 alloc] init] autorelease]];
  NSString * found = [elements description];
  NSString * expecting = @"[B]";
  [self assertEquals:expecting param1:found];
}

- (void) testNoRepeatsVisit2 {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B (A C B) B D D)"];
  NSMutableArray * elements = [[[NSMutableArray alloc] init] autorelease];
  [wiz visit:t param1:[wiz getTokenType:@"C"] param2:[[[TestTreeWizard_Anon2 alloc] init] autorelease]];
  NSString * found = [elements description];
  NSString * expecting = @"[C]";
  [self assertEquals:expecting param1:found];
}

- (void) testRepeatsVisit {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B (A C B) B D D)"];
  NSMutableArray * elements = [[[NSMutableArray alloc] init] autorelease];
  [wiz visit:t param1:[wiz getTokenType:@"B"] param2:[[[TestTreeWizard_Anon3 alloc] init] autorelease]];
  NSString * found = [elements description];
  NSString * expecting = @"[B, B, B]";
  [self assertEquals:expecting param1:found];
}

- (void) testRepeatsVisit2 {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B (A C B) B D D)"];
  NSMutableArray * elements = [[[NSMutableArray alloc] init] autorelease];
  [wiz visit:t param1:[wiz getTokenType:@"A"] param2:[[[TestTreeWizard_Anon4 alloc] init] autorelease]];
  NSString * found = [elements description];
  NSString * expecting = @"[A, A]";
  [self assertEquals:expecting param1:found];
}

- (void) testRepeatsVisitWithContext {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B (A C B) B D D)"];
  NSMutableArray * elements = [[[NSMutableArray alloc] init] autorelease];
  [wiz visit:t param1:[wiz getTokenType:@"B"] param2:[[[TestTreeWizard_Anon5 alloc] init] autorelease]];
  NSString * found = [elements description];
  NSString * expecting = @"[B@A[0], B@A[1], B@A[2]]";
  [self assertEquals:expecting param1:found];
}

- (void) testRepeatsVisitWithNullParentAndContext {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B (A C B) B D D)"];
  NSMutableArray * elements = [[[NSMutableArray alloc] init] autorelease];
  [wiz visit:t param1:[wiz getTokenType:@"A"] param2:[[[TestTreeWizard_Anon6 alloc] init] autorelease]];
  NSString * found = [elements description];
  NSString * expecting = @"[A@nil[0], A@A[1]]";
  [self assertEquals:expecting param1:found];
}

- (void) testVisitPattern {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C (A B) D)"];
  NSMutableArray * elements = [[[NSMutableArray alloc] init] autorelease];
  [wiz visit:t param1:@"(A B)" param2:[[[TestTreeWizard_Anon7 alloc] init] autorelease]];
  NSString * found = [elements description];
  NSString * expecting = @"[A]";
  [self assertEquals:expecting param1:found];
}

- (void) testVisitPatternMultiple {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C (A B) (D (A B)))"];
  NSMutableArray * elements = [[[NSMutableArray alloc] init] autorelease];
  [wiz visit:t param1:@"(A B)" param2:[[[TestTreeWizard_Anon8 alloc] init] autorelease]];
  NSString * found = [elements description];
  NSString * expecting = @"[A@A[2], A@D[0]]";
  [self assertEquals:expecting param1:found];
}

- (void) testVisitPatternMultipleWithLabels {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C (A[foo] B[bar]) (D (A[big] B[dog])))"];
  NSMutableArray * elements = [[[NSMutableArray alloc] init] autorelease];
  [wiz visit:t param1:@"(%a:A %b:B)" param2:[[[TestTreeWizard_Anon9 alloc] init] autorelease]];
  NSString * found = [elements description];
  NSString * expecting = @"[foo@A[2]foo&bar, big@D[0]big&dog]";
  [self assertEquals:expecting param1:found];
}

- (void) testParse {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C)"];
  BOOL valid = [wiz parse:t param1:@"(A B C)"];
  [self assertTrue:valid];
}

- (void) testParseSingleNode {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"A"];
  BOOL valid = [wiz parse:t param1:@"A"];
  [self assertTrue:valid];
}

- (void) testParseFlatTree {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(nil A B C)"];
  BOOL valid = [wiz parse:t param1:@"(nil A B C)"];
  [self assertTrue:valid];
}

- (void) testWildcard {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C)"];
  BOOL valid = [wiz parse:t param1:@"(A . .)"];
  [self assertTrue:valid];
}

- (void) testParseWithText {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B[foo] C[bar])"];
  BOOL valid = [wiz parse:t param1:@"(A B[foo] C)"];
  [self assertTrue:valid];
}

- (void) testParseWithText2 {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B[T__32] (C (D E[a])))"];
  BOOL valid = [wiz parse:t param1:@"(A B[foo] C)"];
  [self assertEquals:@"(A T__32 (C (D a)))" param1:[t toStringTree]];
}

- (void) testParseWithTextFails {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C)"];
  BOOL valid = [wiz parse:t param1:@"(A[foo] B C)"];
  [self assertTrue:!valid];
}

- (void) testParseLabels {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C)"];
  NSMutableDictionary * labels = [[[NSMutableDictionary alloc] init] autorelease];
  BOOL valid = [wiz parse:t param1:@"(%a:A %b:B %c:C)" param2:labels];
  [self assertTrue:valid];
  [self assertEquals:@"A" param1:[[labels objectForKey:@"a"] description]];
  [self assertEquals:@"B" param1:[[labels objectForKey:@"b"] description]];
  [self assertEquals:@"C" param1:[[labels objectForKey:@"c"] description]];
}

- (void) testParseWithWildcardLabels {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C)"];
  NSMutableDictionary * labels = [[[NSMutableDictionary alloc] init] autorelease];
  BOOL valid = [wiz parse:t param1:@"(A %b:. %c:.)" param2:labels];
  [self assertTrue:valid];
  [self assertEquals:@"B" param1:[[labels objectForKey:@"b"] description]];
  [self assertEquals:@"C" param1:[[labels objectForKey:@"c"] description]];
}

- (void) testParseLabelsAndTestText {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B[foo] C)"];
  NSMutableDictionary * labels = [[[NSMutableDictionary alloc] init] autorelease];
  BOOL valid = [wiz parse:t param1:@"(%a:A %b:B[foo] %c:C)" param2:labels];
  [self assertTrue:valid];
  [self assertEquals:@"A" param1:[[labels objectForKey:@"a"] description]];
  [self assertEquals:@"foo" param1:[[labels objectForKey:@"b"] description]];
  [self assertEquals:@"C" param1:[[labels objectForKey:@"c"] description]];
}

- (void) testParseLabelsInNestedTree {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A (B C) (D E))"];
  NSMutableDictionary * labels = [[[NSMutableDictionary alloc] init] autorelease];
  BOOL valid = [wiz parse:t param1:@"(%a:A (%b:B %c:C) (%d:D %e:E) )" param2:labels];
  [self assertTrue:valid];
  [self assertEquals:@"A" param1:[[labels objectForKey:@"a"] description]];
  [self assertEquals:@"B" param1:[[labels objectForKey:@"b"] description]];
  [self assertEquals:@"C" param1:[[labels objectForKey:@"c"] description]];
  [self assertEquals:@"D" param1:[[labels objectForKey:@"d"] description]];
  [self assertEquals:@"E" param1:[[labels objectForKey:@"e"] description]];
}

- (void) testEquals {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t1 = (CommonTree *)[wiz create:@"(A B C)"];
  CommonTree * t2 = (CommonTree *)[wiz create:@"(A B C)"];
  BOOL same = [TreeWizard isEqualTo:t1 param1:t2 param2:adaptor];
  [self assertTrue:same];
}

- (void) testEqualsWithText {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t1 = (CommonTree *)[wiz create:@"(A B[foo] C)"];
  CommonTree * t2 = (CommonTree *)[wiz create:@"(A B[foo] C)"];
  BOOL same = [TreeWizard isEqualTo:t1 param1:t2 param2:adaptor];
  [self assertTrue:same];
}

- (void) testEqualsWithMismatchedText {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t1 = (CommonTree *)[wiz create:@"(A B[foo] C)"];
  CommonTree * t2 = (CommonTree *)[wiz create:@"(A B C)"];
  BOOL same = [TreeWizard isEqualTo:t1 param1:t2 param2:adaptor];
  [self assertTrue:!same];
}

- (void) testFindPattern {
  TreeWizard * wiz = [[[TreeWizard alloc] init:adaptor param1:tokens] autorelease];
  CommonTree * t = (CommonTree *)[wiz create:@"(A B C (A[foo] B[bar]) (D (A[big] B[dog])))"];
  NSMutableArray * subtrees = [wiz find:t param1:@"(A B)"];
  NSMutableArray * elements = subtrees;
  NSString * found = [elements description];
  NSString * expecting = @"[foo, big]";
  [self assertEquals:expecting param1:found];
}

@end
