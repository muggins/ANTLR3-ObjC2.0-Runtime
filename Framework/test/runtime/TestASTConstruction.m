#import "TestASTConstruction.h"

@implementation TestASTConstruction


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
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT A <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testNakeRulePlusInLexer {
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar P;\n" stringByAppendingString:@"A : B+;\n"] stringByAppendingString:@"B : 'a';"]] autorelease];
  NSString * expecting = @" ( rule A ARG RET scope ( BLOCK ( ALT ( + ( BLOCK ( ALT B <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"A"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testRulePlus {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : (b)+;\n"] stringByAppendingString:@"b : B;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( + ( BLOCK ( ALT b <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testNakedRulePlus {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : b+;\n"] stringByAppendingString:@"b : B;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( + ( BLOCK ( ALT b <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testRuleOptional {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : (b)?;\n"] stringByAppendingString:@"b : B;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( ? ( BLOCK ( ALT b <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testNakedRuleOptional {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : b?;\n"] stringByAppendingString:@"b : B;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( ? ( BLOCK ( ALT b <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testRuleStar {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : (b)*;\n"] stringByAppendingString:@"b : B;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( * ( BLOCK ( ALT b <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testNakedRuleStar {
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar P;\n" stringByAppendingString:@"a : b*;\n"] stringByAppendingString:@"b : B;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( * ( BLOCK ( ALT b <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testCharStar {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : 'a'*;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( * ( BLOCK ( ALT 'a' <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testCharStarInLexer {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"B : 'b'*;"]] autorelease];
  NSString * expecting = @" ( rule B ARG RET scope ( BLOCK ( ALT ( * ( BLOCK ( ALT 'b' <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"B"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testStringStar {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : 'while'*;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( * ( BLOCK ( ALT 'while' <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testStringStarInLexer {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"B : 'while'*;"]] autorelease];
  NSString * expecting = @" ( rule B ARG RET scope ( BLOCK ( ALT ( * ( BLOCK ( ALT 'while' <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"B"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testCharPlus {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : 'a'+;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( + ( BLOCK ( ALT 'a' <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testCharPlusInLexer {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"B : 'b'+;"]] autorelease];
  NSString * expecting = @" ( rule B ARG RET scope ( BLOCK ( ALT ( + ( BLOCK ( ALT 'b' <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"B"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testCharOptional {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : 'a'?;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( ? ( BLOCK ( ALT 'a' <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testCharOptionalInLexer {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"B : 'b'?;"]] autorelease];
  NSString * expecting = @" ( rule B ARG RET scope ( BLOCK ( ALT ( ? ( BLOCK ( ALT 'b' <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"B"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testCharRangePlus {
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar P;\n" stringByAppendingString:@"ID : 'a'..'z'+;"]] autorelease];
  NSString * expecting = @" ( rule ID ARG RET scope ( BLOCK ( ALT ( + ( BLOCK ( ALT ( .. 'a' 'z' ) <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"ID"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testLabel {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : x=ID;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( = x ID ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testLabelOfOptional {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : x=ID?;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( ? ( BLOCK ( ALT ( = x ID ) <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testLabelOfClosure {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : x=ID*;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( * ( BLOCK ( ALT ( = x ID ) <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testRuleLabel {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar P;\n" stringByAppendingString:@"a : x=b;\n"] stringByAppendingString:@"b : ID;\n"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( = x b ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testSetLabel {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : x=(A|B);\n"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( = x ( BLOCK ( ALT A <end-of-alt> ) ( ALT B <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testNotSetLabel {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : x=~(A|B);\n"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( = x ( ~ ( BLOCK ( ALT A <end-of-alt> ) ( ALT B <end-of-alt> ) <end-of-block> ) ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testNotSetListLabel {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : x+=~(A|B);\n"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( += x ( ~ ( BLOCK ( ALT A <end-of-alt> ) ( ALT B <end-of-alt> ) <end-of-block> ) ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testNotSetListLabelInLoop {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : x+=~(A|B)+;\n"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( + ( BLOCK ( ALT ( += x ( ~ ( BLOCK ( ALT A <end-of-alt> ) ( ALT B <end-of-alt> ) <end-of-block> ) ) ) <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testRuleLabelOfPositiveClosure {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar P;\n" stringByAppendingString:@"a : x=b+;\n"] stringByAppendingString:@"b : ID;\n"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( + ( BLOCK ( ALT ( = x b ) <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testListLabelOfClosure {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : x+=ID*;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( * ( BLOCK ( ALT ( += x ID ) <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testListLabelOfClosure2 {
  Grammar * g = [[[Grammar alloc] init:[@"grammar P;\n" stringByAppendingString:@"a : x+='int'*;"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( * ( BLOCK ( ALT ( += x 'int' ) <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testRuleListLabelOfPositiveClosure {
  Grammar * g = [[[Grammar alloc] init:[[[@"grammar P;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x+=b+;\n"] stringByAppendingString:@"b : ID;\n"]] autorelease];
  NSString * expecting = @" ( rule a ARG RET scope ( BLOCK ( ALT ( + ( BLOCK ( ALT ( += x b ) <end-of-alt> ) <end-of-block> ) ) <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"a"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testRootTokenInStarLoop {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar Expr;\n" stringByAppendingString:@"options { backtrack=true; }\n"] stringByAppendingString:@"a : ('*'^)* ;\n"]] autorelease];
  NSString * expecting = @" ( rule synpred1_Expr ARG RET scope ( BLOCK ( ALT '*' <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"synpred1_Expr"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

- (void) testActionInStarLoop {
  Grammar * g = [[[Grammar alloc] init:[[@"grammar Expr;\n" stringByAppendingString:@"options { backtrack=true; }\n"] stringByAppendingString:@"a : ({blort} 'x')* ;\n"]] autorelease];
  NSString * expecting = @" ( rule synpred1_Expr ARG RET scope ( BLOCK ( ALT blort 'x' <end-of-alt> ) <end-of-block> ) <end-of-rule> )";
  NSString * found = [[g getRule:@"synpred1_Expr"].tree toStringTree];
  [self assertEquals:expecting param1:found];
}

@end
