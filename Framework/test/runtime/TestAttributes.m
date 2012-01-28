#import "TestAttributes.h"

@implementation TestAttributes_Anon1

- (void) init {
  if (self = [super init]) {
    [self addObject:@"34"];
    [self addObject:@"'{'"];
    [self addObject:@"\"it's<\""];
    [self addObject:@"'\"'"];
    [self addObject:@"\"\\\"\""];
    [self addObject:@"19"];
  }
  return self;
}

@end

@implementation TestAttributes

/* Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) testEscapedLessThanInAction
{
  Grammar * g = [[[Grammar alloc] init] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  NSString * action = @"i<3; '<xmltag>'";
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:0] autorelease];
  NSString * expecting = action;
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:@"<action>"] autorelease];
  [actionST setAttribute:@"action" param1:rawTranslation];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
}

- (void) testEscaped$InAction
{
  NSString * action = @"int \\$n; \"\\$in string\\$\"";
  NSString * expecting = @"int $n; \"$in string$\"";
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"@members {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"a[User u, int i]\n"] stringByAppendingString:@"        : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"        ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:0] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
}

- (void) testArguments
{
  NSString * action = @"$i; $i.x; $u; $u.x";
  NSString * expecting = @"i; i.x; u; u.x";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"a[User u, int i]\n"] stringByAppendingString:@"        : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"        ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testComplicatedArgParsing
{
  NSString * action = [@"x, (*a).foo(21,33), 3.2+1, '\\n', " stringByAppendingString:@"\"a,oo\\nick\", {bl, \"fdkj\"eck}"];
  NSString * expecting = @"x, (*a).foo(21,33), 3.2+1, '\\n', \"a,oo\\nick\", {bl, \"fdkj\"eck}";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"a[User u, int i]\n"] stringByAppendingString:@"        : A a["] stringByAppendingString:action] stringByAppendingString:@"] B\n"] stringByAppendingString:@"        ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  [self assertEquals:expecting param1:rawTranslation];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testBracketArgParsing
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[@"parser grammar t;\n" stringByAppendingString:@"a[String[\\] ick, int i]\n"] stringByAppendingString:@"        : A \n"] stringByAppendingString:@"        ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  Rule * r = [g getRule:@"a"];
  AttributeScope * parameters = r.parameterScope;
  NSMutableArray * attrs = [parameters attributes];
  [self assertEquals:@"attribute mismatch" param1:@"String[] ick" param2:[[attrs objectAtIndex:0].decl description]];
  [self assertEquals:@"parameter name mismatch" param1:@"ick" param2:[attrs objectAtIndex:0].name];
  [self assertEquals:@"declarator mismatch" param1:@"String[]" param2:[attrs objectAtIndex:0].type];
  [self assertEquals:@"attribute mismatch" param1:@"int i" param2:[[attrs objectAtIndex:1].decl description]];
  [self assertEquals:@"parameter name mismatch" param1:@"i" param2:[attrs objectAtIndex:1].name];
  [self assertEquals:@"declarator mismatch" param1:@"int" param2:[attrs objectAtIndex:1].type];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testStringArgParsing
{
  NSString * action = @"34, '{', \"it's<\", '\"', \"\\\"\", 19";
  NSString * expecting = @"34, '{', \"it's<\", '\"', \"\\\"\", 19";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"a[User u, int i]\n"] stringByAppendingString:@"        : A a["] stringByAppendingString:action] stringByAppendingString:@"] B\n"] stringByAppendingString:@"        ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  [self assertEquals:expecting param1:rawTranslation];
  NSMutableArray * expectArgs = [[[TestAttributes_Anon1 alloc] init] autorelease];
  NSMutableArray * actualArgs = [CodeGenerator getListOfArgumentsFromAction:action param1:','];
  [self assertEquals:@"args mismatch" param1:expectArgs param2:actualArgs];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testComplicatedSingleArgParsing
{
  NSString * action = @"(*a).foo(21,33,\",\")";
  NSString * expecting = @"(*a).foo(21,33,\",\")";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"a[User u, int i]\n"] stringByAppendingString:@"        : A a["] stringByAppendingString:action] stringByAppendingString:@"] B\n"] stringByAppendingString:@"        ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  [self assertEquals:expecting param1:rawTranslation];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testArgWithLT
{
  NSString * action = @"34<50";
  NSString * expecting = @"34<50";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"a[boolean b]\n"] stringByAppendingString:@"        : A a["] stringByAppendingString:action] stringByAppendingString:@"] B\n"] stringByAppendingString:@"        ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  [self assertEquals:expecting param1:rawTranslation];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testGenericsAsArgumentDefinition
{
  NSString * action = @"$foo.get(\"ick\");";
  NSString * expecting = @"foo.get(\"ick\");";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammar = [[[[[@"parser grammar T;\n" stringByAppendingString:@"a[HashMap<String,String> foo]\n"] stringByAppendingString:@"        : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"        ;"];
  Grammar * g = [[[Grammar alloc] init:grammar] autorelease];
  Rule * ra = [g getRule:@"a"];
  NSMutableArray * attrs = [ra.parameterScope attributes];
  [self assertEquals:@"attribute mismatch" param1:@"HashMap<String,String> foo" param2:[[attrs objectAtIndex:0].decl description]];
  [self assertEquals:@"parameter name mismatch" param1:@"foo" param2:[attrs objectAtIndex:0].name];
  [self assertEquals:@"declarator mismatch" param1:@"HashMap<String,String>" param2:[attrs objectAtIndex:0].type];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testGenericsAsArgumentDefinition2
{
  NSString * action = @"$foo.get(\"ick\"); x=3;";
  NSString * expecting = @"foo.get(\"ick\"); x=3;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammar = [[[[[@"parser grammar T;\n" stringByAppendingString:@"a[HashMap<String,String> foo, int x, List<String> duh]\n"] stringByAppendingString:@"        : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"        ;"];
  Grammar * g = [[[Grammar alloc] init:grammar] autorelease];
  Rule * ra = [g getRule:@"a"];
  NSMutableArray * attrs = [ra.parameterScope attributes];
  [self assertEquals:@"attribute mismatch" param1:@"HashMap<String,String> foo" param2:[[[attrs objectAtIndex:0].decl description] trim]];
  [self assertEquals:@"parameter name mismatch" param1:@"foo" param2:[attrs objectAtIndex:0].name];
  [self assertEquals:@"declarator mismatch" param1:@"HashMap<String,String>" param2:[attrs objectAtIndex:0].type];
  [self assertEquals:@"attribute mismatch" param1:@"int x" param2:[[[attrs objectAtIndex:1].decl description] trim]];
  [self assertEquals:@"parameter name mismatch" param1:@"x" param2:[attrs objectAtIndex:1].name];
  [self assertEquals:@"declarator mismatch" param1:@"int" param2:[attrs objectAtIndex:1].type];
  [self assertEquals:@"attribute mismatch" param1:@"List<String> duh" param2:[[[attrs objectAtIndex:2].decl description] trim]];
  [self assertEquals:@"parameter name mismatch" param1:@"duh" param2:[attrs objectAtIndex:2].name];
  [self assertEquals:@"declarator mismatch" param1:@"List<String>" param2:[attrs objectAtIndex:2].type];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testGenericsAsReturnValue
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  NSString * grammar = [@"parser grammar T;\n" stringByAppendingString:@"a returns [HashMap<String,String> foo] : ;\n"];
  Grammar * g = [[[Grammar alloc] init:grammar] autorelease];
  Rule * ra = [g getRule:@"a"];
  NSMutableArray * attrs = [ra.returnScope attributes];
  [self assertEquals:@"attribute mismatch" param1:@"HashMap<String,String> foo" param2:[[attrs objectAtIndex:0].decl description]];
  [self assertEquals:@"parameter name mismatch" param1:@"foo" param2:[attrs objectAtIndex:0].name];
  [self assertEquals:@"declarator mismatch" param1:@"HashMap<String,String>" param2:[attrs objectAtIndex:0].type];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testComplicatedArgParsingWithTranslation
{
  NSString * action = [@"x, $A.text+\"3242\", (*$A).foo(21,33), 3.2+1, '\\n', " stringByAppendingString:@"\"a,oo\\nick\", {bl, \"fdkj\"eck}"];
  NSString * expecting = @"x, (A1!=null?A1.getText():null)+\"3242\", (*A1).foo(21,33), 3.2+1, '\\n', \"a,oo\\nick\", {bl, \"fdkj\"eck}";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"a[User u, int i]\n"] stringByAppendingString:@"        : A a["] stringByAppendingString:action] stringByAppendingString:@"] B\n"] stringByAppendingString:@"        ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}


/**
 * $x.start refs are checked during translation not before so ANTLR misses
 * 	 the fact that rule r has refs to predefined attributes if the ref is after
 * 	 the def of the method or self-referential.  Actually would be ok if I didn't
 * 	 convert actions to strings; keep as templates.
 * 	 June 9, 2006: made action translation leave templates not strings
 */
- (void) testRefToReturnValueBeforeRefToPredefinedAttr
{
  NSString * action = @"$x.foo";
  NSString * expecting = @"(x!=null?x.foo:0)";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"parser grammar t;\n" stringByAppendingString:@"a : x=b {"] stringByAppendingString:action] stringByAppendingString:@"} ;\n"] stringByAppendingString:@"b returns [int foo] : B {$b.start} ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRuleLabelBeforeRefToPredefinedAttr
{
  NSString * action = @"$x.text";
  NSString * expecting = @"(x!=null?input.toString(x.start,x.stop):null)";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"parser grammar t;\n" stringByAppendingString:@"a : x=b {###"] stringByAppendingString:action] stringByAppendingString:@"!!!} ;\n"] stringByAppendingString:@"b : B ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testInvalidArguments
{
  NSString * action = @"$x";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"a[User u, int i]\n"] stringByAppendingString:@"        : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"        ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  int expectedMsgID = ErrorManager.MSG_UNKNOWN_SIMPLE_ATTRIBUTE;
  NSObject * expectedArg = @"x";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testReturnValue
{
  NSString * action = @"$x.i";
  NSString * expecting = @"x";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"a returns [int i]\n"] stringByAppendingString:@"        : 'a'\n"] stringByAppendingString:@"        ;\n"] stringByAppendingString:@"b : x=a {"] stringByAppendingString:action] stringByAppendingString:@"} ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testReturnValueWithNumber
{
  NSString * action = @"$x.i1";
  NSString * expecting = @"x";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"a returns [int i1]\n"] stringByAppendingString:@"        : 'a'\n"] stringByAppendingString:@"        ;\n"] stringByAppendingString:@"b : x=a {"] stringByAppendingString:action] stringByAppendingString:@"} ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testReturnValues
{
  NSString * action = @"$i; $i.x; $u; $u.x";
  NSString * expecting = @"retval.i; retval.i.x; retval.u; retval.u.x";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"a returns [User u, int i]\n"] stringByAppendingString:@"        : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"        ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testReturnWithMultipleRuleRefs
{
  NSString * action1 = @"$obj = $rule2.obj;";
  NSString * action2 = @"$obj = $rule3.obj;";
  NSString * expecting1 = @"obj = rule21;";
  NSString * expecting2 = @"obj = rule32;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[[[[[[@"grammar t;\n" stringByAppendingString:@"rule1 returns [ Object obj ]\n"] stringByAppendingString:@":	rule2 { "] stringByAppendingString:action1] stringByAppendingString:@" }\n"] stringByAppendingString:@"|	rule3 { "] stringByAppendingString:action2] stringByAppendingString:@" }\n"] stringByAppendingString:@";\n"] stringByAppendingString:@"rule2 returns [ Object obj ]\n"] stringByAppendingString:@":	foo='foo' { $obj = $foo.text; }\n"] stringByAppendingString:@";\n"] stringByAppendingString:@"rule3 returns [ Object obj ]\n"] stringByAppendingString:@":	bar='bar' { $obj = $bar.text; }\n"] stringByAppendingString:@";"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int i = 0;
  NSString * action = action1;
  NSString * expecting = expecting1;

  do {
    ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"rule1" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:i + 1] autorelease];
    NSString * rawTranslation = [translator translate];
    StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
    StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
    NSString * found = [actionST description];
    [self assertEquals:expecting param1:found];
    action = action2;
    expecting = expecting2;
  }
   while (i++ < 1);
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testInvalidReturnValues
{
  NSString * action = @"$x";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"a returns [User u, int i]\n"] stringByAppendingString:@"        : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"        ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  int expectedMsgID = ErrorManager.MSG_UNKNOWN_SIMPLE_ATTRIBUTE;
  NSObject * expectedArg = @"x";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testTokenLabels
{
  NSString * action = [[@"$id; $f; $id.text; $id.getText(); $id.dork " stringByAppendingString:@"$id.type; $id.line; $id.pos; "] stringByAppendingString:@"$id.channel; $id.index;"];
  NSString * expecting = @"id; f; (id!=null?id.getText():null); id.getText(); id.dork (id!=null?id.getType():0); (id!=null?id.getLine():0); (id!=null?id.getCharPositionInLine():0); (id!=null?id.getChannel():0); (id!=null?id.getTokenIndex():0);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"parser grammar t;\n" stringByAppendingString:@"a : id=ID f=FLOAT {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRuleLabels
{
  NSString * action = @"$r.x; $r.start;\n $r.stop;\n $r.tree; $a.x; $a.stop;";
  NSString * expecting = [[@"(r!=null?r.x:0); (r!=null?((Token)r.start):null);\n" stringByAppendingString:@"             (r!=null?((Token)r.stop):null);\n"] stringByAppendingString:@"             (r!=null?((Object)r.tree):null); (r!=null?r.x:0); (r!=null?((Token)r.stop):null);"];
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a returns [int x]\n"] stringByAppendingString:@"  :\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : r=a {###"] stringByAppendingString:action] stringByAppendingString:@"!!!}\n"] stringByAppendingString:@"  ;"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testAmbiguRuleRef
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"parser grammar t;\n" stringByAppendingString:@"a : A a {$a.text} | B ;"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:1 param2:[equeue.errors size]];
}

- (void) testRuleLabelsWithSpecialToken
{
  NSString * action = @"$r.x; $r.start; $r.stop; $r.tree; $a.x; $a.stop;";
  NSString * expecting = @"(r!=null?r.x:0); (r!=null?((MYTOKEN)r.start):null); (r!=null?((MYTOKEN)r.stop):null); (r!=null?((Object)r.tree):null); (r!=null?r.x:0); (r!=null?((MYTOKEN)r.stop):null);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"options {TokenLabelType=MYTOKEN;}\n"] stringByAppendingString:@"a returns [int x]\n"] stringByAppendingString:@"  :\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : r=a {###"] stringByAppendingString:action] stringByAppendingString:@"!!!}\n"] stringByAppendingString:@"  ;"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testForwardRefRuleLabels
{
  NSString * action = @"$r.x; $r.start; $r.stop; $r.tree; $a.x; $a.tree;";
  NSString * expecting = @"(r!=null?r.x:0); (r!=null?((Token)r.start):null); (r!=null?((Token)r.stop):null); (r!=null?((Object)r.tree):null); (r!=null?r.x:0); (r!=null?((Object)r.tree):null);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"b : r=a {###"] stringByAppendingString:action] stringByAppendingString:@"!!!}\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"a returns [int x]\n"] stringByAppendingString:@"  : ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testInvalidRuleLabelAccessesParameter
{
  NSString * action = @"$r.z";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a[int z] returns [int x]\n"] stringByAppendingString:@"  :\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : r=a[3] {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  int expectedMsgID = ErrorManager.MSG_INVALID_RULE_PARAMETER_REF;
  NSObject * expectedArg = @"a";
  NSObject * expectedArg2 = @"z";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testInvalidRuleLabelAccessesScopeAttribute
{
  NSString * action = @"$r.n";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a\n"] stringByAppendingString:@"scope { int n; }\n"] stringByAppendingString:@"  :\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : r=a[3] {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  int expectedMsgID = ErrorManager.MSG_INVALID_RULE_SCOPE_ATTRIBUTE_REF;
  NSObject * expectedArg = @"a";
  NSObject * expectedArg2 = @"n";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testInvalidRuleAttribute
{
  NSString * action = @"$r.blort";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a[int z] returns [int x]\n"] stringByAppendingString:@"  :\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : r=a[3] {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  int expectedMsgID = ErrorManager.MSG_UNKNOWN_RULE_ATTRIBUTE;
  NSObject * expectedArg = @"a";
  NSObject * expectedArg2 = @"blort";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testMissingRuleAttribute
{
  NSString * action = @"$r";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a[int z] returns [int x]\n"] stringByAppendingString:@"  :\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : r=a[3] {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  int expectedMsgID = ErrorManager.MSG_ISOLATED_RULE_SCOPE;
  NSObject * expectedArg = @"r";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testMissingUnlabeledRuleAttribute
{
  NSString * action = @"$a";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"parser grammar t;\n" stringByAppendingString:@"a returns [int x]:\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : a {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  int expectedMsgID = ErrorManager.MSG_ISOLATED_RULE_SCOPE;
  NSObject * expectedArg = @"a";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testNonDynamicAttributeOutsideRule
{
  NSString * action = @"public void foo() { $x; }";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"@members {'+action+'}\n"] stringByAppendingString:@"a : ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:nil param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:0] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  int expectedMsgID = ErrorManager.MSG_ATTRIBUTE_REF_NOT_IN_RULE;
  NSObject * expectedArg = @"x";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testNonDynamicAttributeOutsideRule2
{
  NSString * action = @"public void foo() { $x.y; }";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"parser grammar t;\n" stringByAppendingString:@"@members {'+action+'}\n"] stringByAppendingString:@"a : ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:nil param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:0] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  int expectedMsgID = ErrorManager.MSG_ATTRIBUTE_REF_NOT_IN_RULE;
  NSObject * expectedArg = @"x";
  NSObject * expectedArg2 = @"y";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testBasicGlobalScope
{
  NSString * action = @"$Symbols::names.add($id.text);";
  NSString * expecting = @"((Symbols_scope)Symbols_stack.peek()).names.add((id!=null?id.getText():null));";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[@"grammar t;\n" stringByAppendingString:@"scope Symbols {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"  List names;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a scope Symbols; : (id=ID ';' {"] stringByAppendingString:action] stringByAppendingString:@"} )+\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testUnknownGlobalScope
{
  NSString * action = @"$Symbols::names.add($id.text);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar t;\n" stringByAppendingString:@"a scope Symbols; : (id=ID ';' {"] stringByAppendingString:action] stringByAppendingString:@"} )+\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:2 param2:[equeue.errors size]];
  int expectedMsgID = ErrorManager.MSG_UNKNOWN_DYNAMIC_SCOPE;
  NSObject * expectedArg = @"Symbols";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testIndexedGlobalScope
{
  NSString * action = @"$Symbols[-1]::names.add($id.text);";
  NSString * expecting = @"((Symbols_scope)Symbols_stack.elementAt(Symbols_stack.size()-1-1)).names.add((id!=null?id.getText():null));";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[@"grammar t;\n" stringByAppendingString:@"scope Symbols {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"  List names;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a scope Symbols; : (id=ID ';' {"] stringByAppendingString:action] stringByAppendingString:@"} )+\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) test0IndexedGlobalScope
{
  NSString * action = @"$Symbols[0]::names.add($id.text);";
  NSString * expecting = @"((Symbols_scope)Symbols_stack.elementAt(0)).names.add((id!=null?id.getText():null));";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[@"grammar t;\n" stringByAppendingString:@"scope Symbols {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"  List names;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a scope Symbols; : (id=ID ';' {"] stringByAppendingString:action] stringByAppendingString:@"} )+\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  [self assertEquals:expecting param1:rawTranslation];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testAbsoluteIndexedGlobalScope
{
  NSString * action = @"$Symbols[3]::names.add($id.text);";
  NSString * expecting = @"((Symbols_scope)Symbols_stack.elementAt(3)).names.add((id!=null?id.getText():null));";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[@"grammar t;\n" stringByAppendingString:@"scope Symbols {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"  List names;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a scope Symbols; : (id=ID ';' {"] stringByAppendingString:action] stringByAppendingString:@"} )+\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  [self assertEquals:expecting param1:rawTranslation];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testScopeAndAttributeWithUnderscore
{
  NSString * action = @"$foo_bar::a_b;";
  NSString * expecting = @"((foo_bar_scope)foo_bar_stack.peek()).a_b;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[@"grammar t;\n" stringByAppendingString:@"scope foo_bar {\n"] stringByAppendingString:@"  int a_b;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a scope foo_bar; : (ID {"] stringByAppendingString:action] stringByAppendingString:@"} )+\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testSharedGlobalScope
{
  NSString * action = @"$Symbols::x;";
  NSString * expecting = @"((Symbols_scope)Symbols_stack.peek()).x;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[[[[@"grammar t;\n" stringByAppendingString:@"scope Symbols {\n"] stringByAppendingString:@"  String x;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a\n"] stringByAppendingString:@"scope { int y; }\n"] stringByAppendingString:@"scope Symbols;\n"] stringByAppendingString:@" : b {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@" ;\n"] stringByAppendingString:@"b : ID {$Symbols::x=$ID.text} ;\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testGlobalScopeOutsideRule
{
  NSString * action = @"public void foo() {$Symbols::names.add('foo');}";
  NSString * expecting = @"public void foo() {((Symbols_scope)Symbols_stack.peek()).names.add('foo');}";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"grammar t;\n" stringByAppendingString:@"scope Symbols {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"  List names;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"@members {'+action+'}\n"] stringByAppendingString:@"a : \n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRuleScopeOutsideRule
{
  NSString * action = @"public void foo() {$a::name;}";
  NSString * expecting = @"public void foo() {((a_scope)a_stack.peek()).name;}";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"grammar t;\n" stringByAppendingString:@"@members {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"a\n"] stringByAppendingString:@"scope { String name; }\n"] stringByAppendingString:@"  : {foo();}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:nil param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:0] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testBasicRuleScope
{
  NSString * action = @"$a::n;";
  NSString * expecting = @"((a_scope)a_stack.peek()).n;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"grammar t;\n" stringByAppendingString:@"a\n"] stringByAppendingString:@"scope {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"} : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testUnqualifiedRuleScopeAccessInsideRule
{
  NSString * action = @"$n;";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"grammar t;\n" stringByAppendingString:@"a\n"] stringByAppendingString:@"scope {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"} : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_ISOLATED_RULE_ATTRIBUTE;
  NSObject * expectedArg = @"n";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testIsolatedDynamicRuleScopeRef
{
  NSString * action = @"$a;";
  NSString * expecting = @"a_stack;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[@"grammar t;\n" stringByAppendingString:@"a\n"] stringByAppendingString:@"scope {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"} : b ;\n"] stringByAppendingString:@"b : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testDynamicRuleScopeRefInSubrule
{
  NSString * action = @"$a::n;";
  NSString * expecting = @"((a_scope)a_stack.peek()).n;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[@"grammar t;\n" stringByAppendingString:@"a\n"] stringByAppendingString:@"scope {\n"] stringByAppendingString:@"  float n;\n"] stringByAppendingString:@"} : b ;\n"] stringByAppendingString:@"b : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testIsolatedGlobalScopeRef
{
  NSString * action = @"$Symbols;";
  NSString * expecting = @"Symbols_stack;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[[[[@"grammar t;\n" stringByAppendingString:@"scope Symbols {\n"] stringByAppendingString:@"  String x;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a\n"] stringByAppendingString:@"scope { int y; }\n"] stringByAppendingString:@"scope Symbols;\n"] stringByAppendingString:@" : b {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@" ;\n"] stringByAppendingString:@"b : ID {$Symbols::x=$ID.text} ;\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRuleScopeFromAnotherRule
{
  NSString * action = @"$a::n;";
  NSString * expecting = @"((a_scope)a_stack.peek()).n;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[@"grammar t;\n" stringByAppendingString:@"a\n"] stringByAppendingString:@"scope {\n"] stringByAppendingString:@"  boolean n;\n"] stringByAppendingString:@"} : b\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testFullyQualifiedRefToCurrentRuleParameter
{
  NSString * action = @"$a.i;";
  NSString * expecting = @"i;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a[int i]: {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testFullyQualifiedRefToCurrentRuleRetVal
{
  NSString * action = @"$a.i;";
  NSString * expecting = @"retval.i;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a returns [int i, int j]: {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testSetFullyQualifiedRefToCurrentRuleRetVal
{
  NSString * action = @"$a.i = 1;";
  NSString * expecting = @"retval.i = 1;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a returns [int i, int j]: {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testIsolatedRefToCurrentRule
{
  NSString * action = @"$a;";
  NSString * expecting = @"";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : 'a' {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_ISOLATED_RULE_SCOPE;
  NSObject * expectedArg = @"a";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testIsolatedRefToRule
{
  NSString * action = @"$x;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar t;\n" stringByAppendingString:@"a : x=b {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : 'b' ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_ISOLATED_RULE_SCOPE;
  NSObject * expectedArg = @"x";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testFullyQualifiedRefToTemplateAttributeInCurrentRule
{
  NSString * action = @"$a.st;";
  NSString * expecting = @"retval.st;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : (A->{$A.text}) {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRuleRefWhenRuleHasScope
{
  NSString * action = @"$b.start;";
  NSString * expecting = @"(b1!=null?((Token)b1.start):null);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[@"grammar t;\n" stringByAppendingString:@"a : b {###"] stringByAppendingString:action] stringByAppendingString:@"!!!} ;\n"] stringByAppendingString:@"b\n"] stringByAppendingString:@"scope {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"} : 'b' \n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testDynamicScopeRefOkEvenThoughRuleRefExists
{
  NSString * action = @"$b::n;";
  NSString * expecting = @"((b_scope)b_stack.peek()).n;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[@"grammar t;\n" stringByAppendingString:@"s : b ;\n"] stringByAppendingString:@"b\n"] stringByAppendingString:@"scope {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"} : '(' b ')' {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRefToTemplateAttributeForCurrentRule
{
  NSString * action = @"$st=null;";
  NSString * expecting = @"retval.st =null;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRefToTextAttributeForCurrentRule
{
  NSString * action = @"$text";
  NSString * expecting = @"input.toString(retval.start,input.LT(-1))";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"parser grammar t;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : {###"] stringByAppendingString:action] stringByAppendingString:@"!!!}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRefToStartAttributeForCurrentRule
{
  NSString * action = @"$start;";
  NSString * expecting = @"((Token)retval.start);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"parser grammar t;\n" stringByAppendingString:@"a : {###"] stringByAppendingString:action] stringByAppendingString:@"!!!}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testTokenLabelFromMultipleAlts
{
  NSString * action = @"$ID.text;";
  NSString * action2 = @"$INT.text;";
  NSString * expecting = @"(ID1!=null?ID1.getText():null);";
  NSString * expecting2 = @"(INT2!=null?INT2.getText():null);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[@"grammar t;\n" stringByAppendingString:@"a : ID {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  | INT {"] stringByAppendingString:action2] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a';\n"] stringByAppendingString:@"INT : '0';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action2] autorelease] param3:2] autorelease];
  rawTranslation = [translator translate];
  templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  found = [actionST description];
  [self assertEquals:expecting2 param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRuleLabelFromMultipleAlts
{
  NSString * action = @"$b.text;";
  NSString * action2 = @"$c.text;";
  NSString * expecting = @"(b1!=null?input.toString(b1.start,b1.stop):null);";
  NSString * expecting2 = @"(c2!=null?input.toString(c2.start,c2.stop):null);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[@"grammar t;\n" stringByAppendingString:@"a : b {###"] stringByAppendingString:action] stringByAppendingString:@"!!!}\n"] stringByAppendingString:@"  | c {^^^"] stringByAppendingString:action2] stringByAppendingString:@"&&&}\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : 'a';\n"] stringByAppendingString:@"c : '0';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  found = [code substringFromIndex:[code rangeOfString:@"^^^"] + 3 param1:[code rangeOfString:@"&&&"]];
  [self assertEquals:expecting2 param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testUnknownDynamicAttribute
{
  NSString * action = @"$a::x";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"grammar t;\n" stringByAppendingString:@"a\n"] stringByAppendingString:@"scope {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"} : {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  int expectedMsgID = ErrorManager.MSG_UNKNOWN_DYNAMIC_SCOPE_ATTRIBUTE;
  NSObject * expectedArg = @"a";
  NSObject * expectedArg2 = @"x";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testUnknownGlobalDynamicAttribute
{
  NSString * action = @"$Symbols::x";
  NSString * expecting = action;
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar t;\n" stringByAppendingString:@"scope Symbols {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : {'+action+'}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  int expectedMsgID = ErrorManager.MSG_UNKNOWN_DYNAMIC_SCOPE_ATTRIBUTE;
  NSObject * expectedArg = @"Symbols";
  NSObject * expectedArg2 = @"x";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testUnqualifiedRuleScopeAttribute
{
  NSString * action = @"$n;";
  NSString * expecting = @"$n;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"grammar t;\n" stringByAppendingString:@"a\n"] stringByAppendingString:@"scope {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"} : b\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : {'+action+'}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  int expectedMsgID = ErrorManager.MSG_UNKNOWN_SIMPLE_ATTRIBUTE;
  NSObject * expectedArg = @"n";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testRuleAndTokenLabelTypeMismatch
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[@"grammar t;\n" stringByAppendingString:@"a : id='foo' id=b\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : ;\n"]] autorelease];
  int expectedMsgID = ErrorManager.MSG_LABEL_TYPE_CONFLICT;
  NSObject * expectedArg = @"id";
  NSObject * expectedArg2 = @"rule!=token";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testListAndTokenLabelTypeMismatch
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[@"grammar t;\n" stringByAppendingString:@"a : ids+='a' ids='b'\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : ;\n"]] autorelease];
  int expectedMsgID = ErrorManager.MSG_LABEL_TYPE_CONFLICT;
  NSObject * expectedArg = @"ids";
  NSObject * expectedArg2 = @"token!=token-list";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testListAndRuleLabelTypeMismatch
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : bs+=b bs=b\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : 'b';\n"]] autorelease];
  int expectedMsgID = ErrorManager.MSG_LABEL_TYPE_CONFLICT;
  NSObject * expectedArg = @"bs";
  NSObject * expectedArg2 = @"rule!=rule-list";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testArgReturnValueMismatch
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a[int i] returns [int x, int i]\n"] stringByAppendingString:@"  : \n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : ;\n"]] autorelease];
  int expectedMsgID = ErrorManager.MSG_ARG_RETVAL_CONFLICT;
  NSObject * expectedArg = @"i";
  NSObject * expectedArg2 = @"a";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testSimplePlusEqualLabel
{
  NSString * action = @"$ids.size();";
  NSString * expecting = @"list_ids.size();";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[@"parser grammar t;\n" stringByAppendingString:@"a : ids+=ID ( COMMA ids+=ID {"] stringByAppendingString:action] stringByAppendingString:@"})* ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testPlusEqualStringLabel
{
  NSString * action = @"$ids.size();";
  NSString * expecting = @"list_ids.size();";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : ids+='if' ( ',' ids+=ID {"] stringByAppendingString:action] stringByAppendingString:@"})* ;"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testPlusEqualSetLabel
{
  NSString * action = @"$ids.size();";
  NSString * expecting = @"list_ids.size();";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : ids+=('a'|'b') ( ',' ids+=ID {"] stringByAppendingString:action] stringByAppendingString:@"})* ;"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testPlusEqualWildcardLabel
{
  NSString * action = @"$ids.size();";
  NSString * expecting = @"list_ids.size();";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : ids+=. ( ',' ids+=ID {"] stringByAppendingString:action] stringByAppendingString:@"})* ;"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testImplicitTokenLabel
{
  NSString * action = @"$ID; $ID.text; $ID.getText()";
  NSString * expecting = @"ID1; (ID1!=null?ID1.getText():null); ID1.getText()";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : ID {"] stringByAppendingString:action] stringByAppendingString:@"} ;"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testImplicitRuleLabel
{
  NSString * action = @"$r.start;";
  NSString * expecting = @"(r1!=null?((Token)r1.start):null);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : r {###"] stringByAppendingString:action] stringByAppendingString:@"!!!} ;"] stringByAppendingString:@"r : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testReuseExistingLabelWithImplicitRuleLabel
{
  NSString * action = @"$r.start;";
  NSString * expecting = @"(x!=null?((Token)x.start):null);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : x=r {###"] stringByAppendingString:action] stringByAppendingString:@"!!!} ;"] stringByAppendingString:@"r : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testReuseExistingListLabelWithImplicitRuleLabel
{
  NSString * action = @"$r.start;";
  NSString * expecting = @"(x!=null?((Token)x.start):null);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar t;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x+=r {###"] stringByAppendingString:action] stringByAppendingString:@"!!!} ;"] stringByAppendingString:@"r : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testReuseExistingLabelWithImplicitTokenLabel
{
  NSString * action = @"$ID.text;";
  NSString * expecting = @"(x!=null?x.getText():null);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : x=ID {"] stringByAppendingString:action] stringByAppendingString:@"} ;"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testReuseExistingListLabelWithImplicitTokenLabel
{
  NSString * action = @"$ID.text;";
  NSString * expecting = @"(x!=null?x.getText():null);";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : x+=ID {"] stringByAppendingString:action] stringByAppendingString:@"} ;"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRuleLabelWithoutOutputOption
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar T;\n" stringByAppendingString:@"s : x+=a ;"] stringByAppendingString:@"a : 'a';\n"] stringByAppendingString:@"b : 'b';\n"] stringByAppendingString:@"WS : ' '|'\n';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_LIST_LABEL_INVALID_UNLESS_RETVAL_STRUCT;
  NSObject * expectedArg = @"x";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testRuleLabelOnTwoDifferentRulesAST
{
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"s : x+=a x+=b {System.out.println($x);} ;"] stringByAppendingString:@"a : 'a';\n"] stringByAppendingString:@"b : 'b';\n"] stringByAppendingString:@"WS : (' '|'\n') {skip();};\n"];
  NSString * expecting = @"[a, b]\na b\n";
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"a b" param6:NO];
  [self assertEquals:expecting param1:found];
}

- (void) testRuleLabelOnTwoDifferentRulesTemplate
{
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"s : x+=a x+=b {System.out.println($x);} ;"] stringByAppendingString:@"a : 'a' -> {%{\"hi\"}} ;\n"] stringByAppendingString:@"b : 'b' -> {%{\"mom\"}} ;\n"] stringByAppendingString:@"WS : (' '|'\n') {skip();};\n"];
  NSString * expecting = @"[hi, mom]\n";
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"a b" param6:NO];
  [self assertEquals:expecting param1:found];
}

- (void) testMissingArgs
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"a : r ;"] stringByAppendingString:@"r[int i] : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_MISSING_RULE_ARGS;
  NSObject * expectedArg = @"r";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testArgsWhenNoneDefined
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"a : r[32,34] ;"] stringByAppendingString:@"r : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_RULE_HAS_NO_ARGS;
  NSObject * expectedArg = @"r";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testReturnInitValue
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"a : r ;\n"] stringByAppendingString:@"r returns [int x=0] : 'a' {$x = 4;} ;\n"]] autorelease];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  Rule * r = [g getRule:@"r"];
  AttributeScope * retScope = r.returnScope;
  NSMutableArray * parameters = [retScope attributes];
  [self assertNotNull:@"missing return action" param1:parameters];
  [self assertEquals:1 param1:[parameters count]];
  NSString * found = [[parameters objectAtIndex:0] description];
  NSString * expecting = @"int x=0";
  [self assertEquals:expecting param1:found];
}

- (void) testMultipleReturnInitValue
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"a : r ;\n"] stringByAppendingString:@"r returns [int x=0, int y, String s=new String(\"foo\")] : 'a' {$x = 4;} ;\n"]] autorelease];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  Rule * r = [g getRule:@"r"];
  AttributeScope * retScope = r.returnScope;
  NSMutableArray * parameters = [retScope attributes];
  [self assertNotNull:@"missing return action" param1:parameters];
  [self assertEquals:3 param1:[parameters count]];
  [self assertEquals:@"int x=0" param1:[[parameters objectAtIndex:0] description]];
  [self assertEquals:@"int y" param1:[[parameters objectAtIndex:1] description]];
  [self assertEquals:@"String s=new String(\"foo\")" param1:[[parameters objectAtIndex:2] description]];
}

- (void) testCStyleReturnInitValue
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"a : r ;\n"] stringByAppendingString:@"r returns [int (*x)()=NULL] : 'a' ;\n"]] autorelease];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  Rule * r = [g getRule:@"r"];
  AttributeScope * retScope = r.returnScope;
  NSMutableArray * parameters = [retScope attributes];
  [self assertNotNull:@"missing return action" param1:parameters];
  [self assertEquals:1 param1:[parameters count]];
  NSString * found = [[parameters objectAtIndex:0] description];
  NSString * expecting = @"int (*)() x=NULL";
  [self assertEquals:expecting param1:found];
}

- (void) testArgsWithInitValues
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"a : r[32,34] ;"] stringByAppendingString:@"r[int x, int y=3] : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_ARG_INIT_VALUES_ILLEGAL;
  NSObject * expectedArg = @"y";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testArgsOnToken
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"grammar t;\n" stringByAppendingString:@"a : ID[32,34] ;"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_ARGS_ON_TOKEN_REF;
  NSObject * expectedArg = @"ID";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testArgsOnTokenInLexer
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"R : 'z' ID[32,34] ;"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_RULE_HAS_NO_ARGS;
  NSObject * expectedArg = @"ID";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testLabelOnRuleRefInLexer
{
  NSString * action = @"$i.text";
  NSString * expecting = @"(i!=null?i.getText():null)";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"lexer grammar t;\n" stringByAppendingString:@"R : 'z' i=ID {"] stringByAppendingString:action] stringByAppendingString:@"};"] stringByAppendingString:@"fragment ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"R" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRefToRuleRefInLexer
{
  NSString * action = @"$ID.text";
  NSString * expecting = @"(ID1!=null?ID1.getText():null)";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"lexer grammar t;\n" stringByAppendingString:@"R : 'z' ID {"] stringByAppendingString:action] stringByAppendingString:@"};"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"R" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testRefToRuleRefInLexerNoAttribute
{
  NSString * action = @"$ID";
  NSString * expecting = @"ID1";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"lexer grammar t;\n" stringByAppendingString:@"R : 'z' ID {"] stringByAppendingString:action] stringByAppendingString:@"};"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"R" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testCharLabelInLexer
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"R : x='z' ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testCharListLabelInLexer
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"R : x+='z' ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testWildcardCharLabelInLexer
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"R : x=. ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testWildcardCharListLabelInLexer
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[@"lexer grammar t;\n" stringByAppendingString:@"R : x+=. ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testMissingArgsInLexer
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[@"lexer grammar t;\n" stringByAppendingString:@"A : R ;"] stringByAppendingString:@"R[int i] : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_MISSING_RULE_ARGS;
  NSObject * expectedArg = @"R";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testLexerRulePropertyRefs
{
  NSString * action = @"$text $type $line $pos $channel $index $start $stop";
  NSString * expecting = @"getText() _type state.tokenStartLine state.tokenStartCharPositionInLine _channel -1 state.tokenStartCharIndex (getCharIndex()-1)";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"R : 'r' {"] stringByAppendingString:action] stringByAppendingString:@"};\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"R" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testLexerLabelRefs
{
  NSString * action = @"$a $b.text $c $d.text";
  NSString * expecting = @"a (b!=null?b.getText():null) c (d!=null?d.getText():null)";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"lexer grammar t;\n" stringByAppendingString:@"R : a='c' b='hi' c=. d=DUH {"] stringByAppendingString:action] stringByAppendingString:@"};\n"] stringByAppendingString:@"DUH : 'd' ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"R" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testSettingLexerRulePropertyRefs
{
  NSString * action = @"$text $type=1 $line=1 $pos=1 $channel=1 $index";
  NSString * expecting = @"getText() _type=1 state.tokenStartLine=1 state.tokenStartCharPositionInLine=1 _channel=1 -1";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[@"lexer grammar t;\n" stringByAppendingString:@"R : 'r' {"] stringByAppendingString:action] stringByAppendingString:@"};\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"R" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testArgsOnTokenInLexerRuleOfCombined
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[@"grammar t;\n" stringByAppendingString:@"a : R;\n"] stringByAppendingString:@"R : 'z' ID[32] ;\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  NSString * lexerGrammarStr = [g lexerGrammar];
  StringReader * sr = [[[StringReader alloc] init:lexerGrammarStr] autorelease];
  Grammar * lexerGrammar = [[[Grammar alloc] init] autorelease];
  [lexerGrammar setFileName:@"<internally-generated-lexer>"];
  [lexerGrammar importTokenVocabulary:g];
  [lexerGrammar parseAndBuildAST:sr];
  [lexerGrammar defineGrammarSymbols];
  [lexerGrammar checkNameSpaceAndActions];
  [sr close];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:lexerGrammar param2:@"Java"] autorelease];
  [lexerGrammar setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_RULE_HAS_NO_ARGS;
  NSObject * expectedArg = @"ID";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:lexerGrammar param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testMissingArgsOnTokenInLexerRuleOfCombined
{
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[@"grammar t;\n" stringByAppendingString:@"a : R;\n"] stringByAppendingString:@"R : 'z' ID ;\n"] stringByAppendingString:@"ID[int i] : 'a';\n"]] autorelease];
  NSString * lexerGrammarStr = [g lexerGrammar];
  StringReader * sr = [[[StringReader alloc] init:lexerGrammarStr] autorelease];
  Grammar * lexerGrammar = [[[Grammar alloc] init] autorelease];
  [lexerGrammar setFileName:@"<internally-generated-lexer>"];
  [lexerGrammar importTokenVocabulary:g];
  [lexerGrammar parseAndBuildAST:sr];
  [lexerGrammar defineGrammarSymbols];
  [lexerGrammar checkNameSpaceAndActions];
  [sr close];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:lexerGrammar param2:@"Java"] autorelease];
  [lexerGrammar setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_MISSING_RULE_ARGS;
  NSObject * expectedArg = @"ID";
  NSObject * expectedArg2 = nil;
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:lexerGrammar param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testTokenLabelTreeProperty
{
  NSString * action = @"$id.tree;";
  NSString * expecting = @"id_tree;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : id=ID {"] stringByAppendingString:action] stringByAppendingString:@"} ;\n"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testTokenRefTreeProperty
{
  NSString * action = @"$ID.tree;";
  NSString * expecting = @"ID1_tree;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : ID {"] stringByAppendingString:action] stringByAppendingString:@"} ;"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
}

- (void) testAmbiguousTokenRef
{
  NSString * action = @"$ID;";
  NSString * expecting = @"";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : ID ID {"] stringByAppendingString:action] stringByAppendingString:@"};"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_NONUNIQUE_REF;
  NSObject * expectedArg = @"ID";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testAmbiguousTokenRefWithProp
{
  NSString * action = @"$ID.text;";
  NSString * expecting = @"";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"grammar t;\n" stringByAppendingString:@"a : ID ID {"] stringByAppendingString:action] stringByAppendingString:@"};"] stringByAppendingString:@"ID : 'a';\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  int expectedMsgID = ErrorManager.MSG_NONUNIQUE_REF;
  NSObject * expectedArg = @"ID";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testRuleRefWithDynamicScope
{
  NSString * action = @"$field::x = $field.st;";
  NSString * expecting = @"((field_scope)field_stack.peek()).x = retval.st;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"grammar a;\n" stringByAppendingString:@"field\n"] stringByAppendingString:@"scope { StringTemplate x; }\n"] stringByAppendingString:@"    :   'y' {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"    ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"field" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testAssignToOwnRulenameAttr
{
  NSString * action = @"$rule.tree = null;";
  NSString * expecting = @"retval.tree = null;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar a;\n" stringByAppendingString:@"rule\n"] stringByAppendingString:@"    : 'y' {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"    ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"rule" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testAssignToOwnParamAttr
{
  NSString * action = @"$rule.i = 42; $i = 23;";
  NSString * expecting = @"i = 42; i = 23;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar a;\n" stringByAppendingString:@"rule[int i]\n"] stringByAppendingString:@"    : 'y' {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"    ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"rule" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testIllegalAssignToOwnRulenameAttr
{
  NSString * action = @"$rule.stop = 0;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar a;\n" stringByAppendingString:@"rule\n"] stringByAppendingString:@"    : 'y' {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"    ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"rule" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  int expectedMsgID = ErrorManager.MSG_WRITE_TO_READONLY_ATTR;
  NSObject * expectedArg = @"rule";
  NSObject * expectedArg2 = @"stop";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testIllegalAssignToLocalAttr
{
  NSString * action = @"$tree = null; $st = null; $start = 0; $stop = 0; $text = 0;";
  NSString * expecting = @"retval.tree = null; retval.st = null;   ";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"grammar a;\n" stringByAppendingString:@"rule\n"] stringByAppendingString:@"    : 'y' {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"    ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"rule" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  int expectedMsgID = ErrorManager.MSG_WRITE_TO_READONLY_ATTR;
  NSMutableArray * expectedErrors = [[[NSMutableArray alloc] init:3] autorelease];
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:@"start" param4:@""] autorelease];
  [expectedErrors addObject:expectedMessage];
  GrammarSemanticsMessage * expectedMessage2 = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:@"stop" param4:@""] autorelease];
  [expectedErrors addObject:expectedMessage2];
  GrammarSemanticsMessage * expectedMessage3 = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:@"text" param4:@""] autorelease];
  [expectedErrors addObject:expectedMessage3];
  [self checkErrors:equeue expectedMessages:expectedErrors];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
}

- (void) testIllegalAssignRuleRefAttr
{
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
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testIllegalAssignTokenRefAttr
{
  NSString * action = @"$ID.text = \"test\";";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"grammar a;\n" stringByAppendingString:@"ID\n"] stringByAppendingString:@"    : 'y' ;"] stringByAppendingString:@"rule\n"] stringByAppendingString:@"    : ID {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"    ;"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"rule" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  int expectedMsgID = ErrorManager.MSG_WRITE_TO_READONLY_ATTR;
  NSObject * expectedArg = @"ID";
  NSObject * expectedArg2 = @"text";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testAssignToTreeNodeAttribute
{
  NSString * action = @"$tree.scope = localScope;";
  NSString * expecting = @"((Object)retval.tree).scope = localScope;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[[@"grammar a;\n" stringByAppendingString:@"options { output=AST; }"] stringByAppendingString:@"rule\n"] stringByAppendingString:@"@init {\n"] stringByAppendingString:@"   Scope localScope=null;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"@after {\n"] stringByAppendingString:@"   ###$tree.scope = localScope;!!!\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"   : 'a' -> ^('a')\n"] stringByAppendingString:@";"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
}

- (void) testDoNotTranslateAttributeCompare
{
  NSString * action = @"$a.line == $b.line";
  NSString * expecting = @"(a!=null?a.getLine():0) == (b!=null?b.getLine():0)";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"lexer grammar a;\n" stringByAppendingString:@"RULE:\n"] stringByAppendingString:@"     a=ID b=ID {"] stringByAppendingString:action] stringByAppendingString:@"}"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"ID : 'id';"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"RULE" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  [self assertEquals:expecting param1:found];
}

- (void) testDoNotTranslateScopeAttributeCompare
{
  NSString * action = @"if ($rule::foo == \"foo\" || 1) { System.out.println(\"ouch\"); }";
  NSString * expecting = @"if (((rule_scope)rule_stack.peek()).foo == \"foo\" || 1) { System.out.println(\"ouch\"); }";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[[[[[@"grammar a;\n" stringByAppendingString:@"rule\n"] stringByAppendingString:@"scope {\n"] stringByAppendingString:@"   String foo;"] stringByAppendingString:@"} :\n"] stringByAppendingString:@"     twoIDs"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"twoIDs:\n"] stringByAppendingString:@"    ID ID {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"ID : 'id';"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"twoIDs" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  BOOL foundScopeSetAttributeRef = NO;

  for (int i = 0; i < [translator.chunks size]; i++) {
    NSObject * chunk = [translator.chunks get:i];
    if ([chunk conformsToProtocol:@protocol(StringTemplate)]) {
      if ([[((StringTemplate *)chunk) name] isEqualTo:@"scopeSetAttributeRef"]) {
        foundScopeSetAttributeRef = YES;
      }
    }
  }

  [self assertFalse:@"action translator used scopeSetAttributeRef template in comparison!" param1:foundScopeSetAttributeRef];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
  [self assertEquals:expecting param1:found];
}

- (void) testTreeRuleStopAttributeIsInvalid
{
  NSString * action = @"$r.x; $r.start; $r.stop";
  NSString * expecting = @"(r!=null?r.x:0); (r!=null?((CommonTree)r.start):null); $r.stop";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[@"tree grammar t;\n" stringByAppendingString:@"options {ASTLabelType=CommonTree;}\n"] stringByAppendingString:@"a returns [int x]\n"] stringByAppendingString:@"  :\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : r=a {###"] stringByAppendingString:action] stringByAppendingString:@"!!!}\n"] stringByAppendingString:@"  ;"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  int expectedMsgID = ErrorManager.MSG_UNKNOWN_RULE_ATTRIBUTE;
  NSObject * expectedArg = @"a";
  NSObject * expectedArg2 = @"stop";
  GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg param4:expectedArg2] autorelease];
  [System.out println:[@"equeue:" stringByAppendingString:equeue]];
  [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testRefToTextAttributeForCurrentTreeRule
{
  NSString * action = @"$text";
  NSString * expecting = [[@"input.getTokenStream().toString(\n" stringByAppendingString:@"              input.getTreeAdaptor().getTokenStartIndex(retval.start),\n"] stringByAppendingString:@"              input.getTreeAdaptor().getTokenStopIndex(retval.start))"];
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"tree grammar t;\n" stringByAppendingString:@"options {ASTLabelType=CommonTree;}\n"] stringByAppendingString:@"a : {###"] stringByAppendingString:action] stringByAppendingString:@"!!!}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  StringTemplate * codeST = [generator recognizerST];
  NSString * code = [codeST description];
  NSString * found = [code substringFromIndex:[code rangeOfString:@"###"] + 3 param1:[code rangeOfString:@"!!!"]];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) testTypeOfGuardedAttributeRefIsCorrect
{
  NSString * action = @"int x = $b::n;";
  NSString * expecting = @"int x = ((b_scope)b_stack.peek()).n;";
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[[@"grammar t;\n" stringByAppendingString:@"s : b ;\n"] stringByAppendingString:@"b\n"] stringByAppendingString:@"scope {\n"] stringByAppendingString:@"  int n;\n"] stringByAppendingString:@"} : '(' b ')' {"] stringByAppendingString:action] stringByAppendingString:@"}\n"] stringByAppendingString:@"  ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  ActionTranslator * translator = [[[ActionTranslator alloc] init:generator param1:@"b" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
  NSString * rawTranslation = [translator translate];
  StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
  StringTemplate * actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
  NSString * found = [actionST description];
  [self assertEquals:expecting param1:found];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.errors size]];
}

- (void) checkError:(ErrorQueue *)equeue expectedMessage:(GrammarSemanticsMessage *)expectedMessage
{
  Message * foundMsg = nil;

  for (int i = 0; i < [equeue.errors size]; i++) {
    Message * m = (Message *)[equeue.errors get:i];
    if (m.msgID == expectedMessage.msgID) {
      foundMsg = m;
    }
  }

  [self assertTrue:[[@"no error; " stringByAppendingString:expectedMessage.msgID] stringByAppendingString:@" expected"] param1:[equeue.errors size] > 0];
  [self assertNotNull:[[@"couldn't find expected error: " stringByAppendingString:expectedMessage.msgID] stringByAppendingString:@" in "] + equeue param1:foundMsg];
  [self assertTrue:@"error is not a GrammarSemanticsMessage" param1:[foundMsg conformsToProtocol:@protocol(GrammarSemanticsMessage)]];
  [self assertEquals:expectedMessage.arg param1:foundMsg.arg];
  [self assertEquals:expectedMessage.arg2 param1:foundMsg.arg2];
}


/**
 * Allow checking for multiple errors in one test
 */
- (void) checkErrors:(ErrorQueue *)equeue expectedMessages:(NSMutableArray *)expectedMessages {
  NSMutableArray * messageExpected = [[[NSMutableArray alloc] init:[equeue.errors size]] autorelease];

  for (int i = 0; i < [equeue.errors size]; i++) {
    Message * m = (Message *)[equeue.errors get:i];
    BOOL foundMsg = NO;

    for (int j = 0; j < [expectedMessages count]; j++) {
      Message * em = (Message *)[expectedMessages objectAtIndex:j];
      if (m.msgID == em.msgID && [m.arg isEqualTo:em.arg] && [m.arg2 isEqualTo:em.arg2]) {
        foundMsg = YES;
      }
    }

    if (foundMsg) {
      [messageExpected addObject:i param1:Boolean.TRUE];
    }
     else
      [messageExpected addObject:i param1:Boolean.FALSE];
  }


  for (int i = 0; i < [equeue.errors size]; i++) {
    [self assertTrue:[@"unexpected error:" stringByAppendingString:[equeue.errors get:i]] param1:[((NSNumber *)[messageExpected objectAtIndex:i]) booleanValue]];
  }

}

@end
