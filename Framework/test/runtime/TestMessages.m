#import "TestMessages.h"

@implementation TestMessages


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) testMessageStringificationIsConsistent {
  NSString * action = @"$other.tree = null;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[@"grammar a;\n" stringByAppendingString:@"options { output = AST;}"] stringByAppendingString:@"otherrule\n"] stringByAppendingString:@"    : 'y' ;"] stringByAppendingString:@"rule\n"] stringByAppendingString:@"    : other=otherrule {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"    ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"rule" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  int expectedMsgID = ErrorManager.MSG_WRITE_TO_READONLY_ATTR;
  NSObject * expectedArg = @"other";
  NSObject * expectedArg2 = @"tree";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  NSString * expectedMessageString = [expectedMessage description];
  [self assertEquals:expectedMessageString param1:[expectedMessage description]];
}

@end
