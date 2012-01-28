#import "TestRewriteTemplates.h"

@implementation TestRewriteTemplates

- (void) init {
  if (self = [super init]) {
    debug = NO;
  }
  return self;
}

- (void) testDelete {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : ID INT -> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"" param1:found];
}

- (void) testAction {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : ID INT -> {new ST($ID.text)} ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testEmbeddedLiteralConstructor {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : ID INT -> {%{$ID.text}} ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testInlineTemplate {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : ID INT -> template(x={$ID},y={$INT}) <<x:<x.text>, y:<y.text>;>> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"x:abc, y:34;\n" param1:found];
}

- (void) testNamedTemplate {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : ID INT -> foo(x={$ID.text},y={$INT.text}) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testIndirectTemplate {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : ID INT -> ({\"foo\"})(x={$ID.text},y={$INT.text}) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testInlineTemplateInvokingLib {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : ID INT -> template(x={$ID.text},y={$INT.text}) \"<foo(x,y)>\" ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testPredicatedAlts {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : ID INT -> {false}? foo(x={$ID.text},y={$INT.text})\n"] stringByAppendingString:@"           -> foo(x={\"hi\"}, y={$ID.text})\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"hi abc\n" param1:found];
}

- (void) testTemplateReturn {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : b {System.out.println($b.st.render());} ;\n"] stringByAppendingString:@"b : ID INT -> foo(x={$ID.text},y={$INT.text}) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"abc 34\n" param1:found];
}

- (void) testReturnValueWithTemplate {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a : b {System.out.println($b.i);} ;\n"] stringByAppendingString:@"b returns [int i] : ID INT {$i=8;} ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"8\n" param1:found];
}

- (void) testTemplateRefToDynamicAttributes {
  NSString * grammar = [[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a scope {String id;} : ID {$a::id=$ID.text;} b\n"] stringByAppendingString:@"	{System.out.println($b.st.render());}\n"] stringByAppendingString:@"   ;\n"] stringByAppendingString:@"b : INT -> foo(x={$a::id}) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"abc 34" param6:debug];
  [self assertEquals:@"abc \n" param1:found];
}

- (void) testSingleNode {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {ASTLabelType=CommonTree; output=template;}\n"] stringByAppendingString:@"s : a {System.out.println($a.st.render());} ;\n"] stringByAppendingString:@"a : ID -> template(x={$ID.text}) <<|<x>|>> ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc"];
  [self assertEquals:@"|abc|\n" param1:found];
}

- (void) testSingleNodeRewriteMode {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP;\n" stringByAppendingString:@"options {ASTLabelType=CommonTree; output=template; rewrite=true;}\n"] stringByAppendingString:@"s : a {System.out.println(input.getTokenStream().toString(0,0));} ;\n"] stringByAppendingString:@"a : ID -> template(x={$ID.text}) <<|<x>|>> ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc"];
  [self assertEquals:@"|abc|\n" param1:found];
}

- (void) testRewriteRuleAndRewriteModeOnSimpleElements {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {ASTLabelType=CommonTree; output=template; rewrite=true;}\n"] stringByAppendingString:@"a: ^(A B) -> {ick}\n"] stringByAppendingString:@" | y+=INT -> {ick}\n"] stringByAppendingString:@" | x=ID -> {ick}\n"] stringByAppendingString:@" | BLORT -> {ick}\n"] stringByAppendingString:@" ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.warnings size]];
}

- (void) testRewriteRuleAndRewriteModeIgnoreActionsPredicates {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {ASTLabelType=CommonTree; output=template; rewrite=true;}\n"] stringByAppendingString:@"a: {action} {action2} x=A -> {ick}\n"] stringByAppendingString:@" | {pred1}? y+=B -> {ick}\n"] stringByAppendingString:@" | C {action} -> {ick}\n"] stringByAppendingString:@" | {pred2}?=> z+=D -> {ick}\n"] stringByAppendingString:@" | (E)=> ^(F G) -> {ick}\n"] stringByAppendingString:@" ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.warnings size]];
}

- (void) testRewriteRuleAndRewriteModeNotSimple {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {ASTLabelType=CommonTree; output=template; rewrite=true;}\n"] stringByAppendingString:@"a  : ID+ -> {ick}\n"] stringByAppendingString:@"   | INT INT -> {ick}\n"] stringByAppendingString:@"   ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  [antlr generateRecognizer:g];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.warnings size]];
}

- (void) testRewriteRuleAndRewriteModeRefRule {
  ErrorQueue * equeue = [[[ErrorQueue alloc] init] autorelease];
  [ErrorManager setErrorListener:equeue];
  Grammar * g = [[[Grammar alloc] init:[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {ASTLabelType=CommonTree; output=template; rewrite=true;}\n"] stringByAppendingString:@"a  : b+ -> {ick}\n"] stringByAppendingString:@"   | b b A -> {ick}\n"] stringByAppendingString:@"   ;\n"] stringByAppendingString:@"b  : B ;\n"]] autorelease];
  Tool * antlr = [self newTool];
  [antlr setOutputDirectory:nil];
  CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
  [g setCodeGenerator:generator];
  [generator genRecognizer];
  [self assertEquals:[@"unexpected errors: " stringByAppendingString:equeue] param1:0 param2:[equeue.warnings size]];
}

@end
