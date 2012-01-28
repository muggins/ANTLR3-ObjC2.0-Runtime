#import "TestTreeParsing.h"

@implementation TestTreeParsing

- (void) testFlatList {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP; options {ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : ID INT\n"] stringByAppendingString:@"    {System.out.println($ID+\", \"+$INT);}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"abc, 34\n" param1:found];
}

- (void) testSimpleTree {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT -> ^(ID INT);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP; options {ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : ^(ID INT)\n"] stringByAppendingString:@"    {System.out.println($ID+\", \"+$INT);}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"abc, 34\n" param1:found];
}

- (void) testFlatVsTreeDecision {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b c ;\n"] stringByAppendingString:@"b : ID INT -> ^(ID INT);\n"] stringByAppendingString:@"c : ID INT;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP; options {ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : b b ;\n"] stringByAppendingString:@"b : ID INT    {System.out.print($ID+\" \"+$INT);}\n"] stringByAppendingString:@"  | ^(ID INT) {System.out.print(\"^(\"+$ID+\" \"+$INT+')');}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 1 b 2"];
  [self assertEquals:@"^(a 1)b 2\n" param1:found];
}

- (void) testFlatVsTreeDecision2 {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : b c ;\n"] stringByAppendingString:@"b : ID INT+ -> ^(ID INT+);\n"] stringByAppendingString:@"c : ID INT+;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP; options {ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : b b ;\n"] stringByAppendingString:@"b : ID INT+    {System.out.print($ID+\" \"+$INT);}\n"] stringByAppendingString:@"  | ^(x=ID (y=INT)+) {System.out.print(\"^(\"+$x+' '+$y+')');}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 1 2 3 b 4 5"];
  [self assertEquals:@"^(a 3)b 5\n" param1:found];
}

- (void) testCyclicDFALookahead {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT+ PERIOD;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';' ;\n"] stringByAppendingString:@"PERIOD : '.' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP; options {ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : ID INT+ PERIOD {System.out.print(\"alt 1\");}"] stringByAppendingString:@"  | ID INT+ SEMI   {System.out.print(\"alt 2\");}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 1 2 3."];
  [self assertEquals:@"alt 1\n" param1:found];
}

- (void) testTemplateOutput {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=template; ASTLabelType=CommonTree;}\n"] stringByAppendingString:@"s : a {System.out.println($a.st);};\n"] stringByAppendingString:@"a : ID INT -> {new ST($INT.text)}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"s" param9:@"abc 34"];
  [self assertEquals:@"34\n" param1:found];
}

- (void) testNullableChildList {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT? -> ^(ID INT?);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP; options {ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : ^(ID INT?)\n"] stringByAppendingString:@"    {System.out.println($ID);}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc"];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testNullableChildList2 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT? SEMI -> ^(ID INT?) SEMI ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP; options {ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : ^(ID INT?) SEMI\n"] stringByAppendingString:@"    {System.out.println($ID);}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc;"];
  [self assertEquals:@"abc\n" param1:found];
}

- (void) testNullableChildList3 {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x=ID INT? (y=ID)? SEMI -> ^($x INT? $y?) SEMI ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP; options {ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : ^(ID INT? b) SEMI\n"] stringByAppendingString:@"    {System.out.println($ID+\", \"+$b.text);}\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : ID? ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc def;"];
  [self assertEquals:@"abc, def\n" param1:found];
}

- (void) testActionsAfterRoot {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : x=ID INT? SEMI -> ^($x INT?) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP; options {ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a @init {int x=0;} : ^(ID {x=1;} {x=2;} INT?)\n"] stringByAppendingString:@"    {System.out.println($ID+\", \"+x);}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc;"];
  [self assertEquals:@"abc, 2\n" param1:found];
}

- (void) testWildcardLookahead {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID '+'^ INT;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';' ;\n"] stringByAppendingString:@"PERIOD : '.' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[@"tree grammar TP; options {tokenVocab=T; ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : ^('+' . INT) {System.out.print(\"alt 1\");}"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a + 2"];
  [self assertEquals:@"alt 1\n" param1:found];
}

- (void) testWildcardLookahead2 {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID '+'^ INT;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';' ;\n"] stringByAppendingString:@"PERIOD : '.' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP; options {tokenVocab=T; ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : ^('+' . INT) {System.out.print(\"alt 1\");}"] stringByAppendingString:@"  | ^('+' . .)   {System.out.print(\"alt 2\");}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a + 2"];
  [self assertEquals:@"alt 1\n" param1:found];
}

- (void) testWildcardLookahead3 {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID '+'^ INT;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';' ;\n"] stringByAppendingString:@"PERIOD : '.' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP; options {tokenVocab=T; ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : ^('+' ID INT) {System.out.print(\"alt 1\");}"] stringByAppendingString:@"  | ^('+' . .)   {System.out.print(\"alt 2\");}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a + 2"];
  [self assertEquals:@"alt 1\n" param1:found];
}

- (void) testWildcardPlusLookahead {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID '+'^ INT;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';' ;\n"] stringByAppendingString:@"PERIOD : '.' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[@"tree grammar TP; options {tokenVocab=T; ASTLabelType=CommonTree;}\n" stringByAppendingString:@"a : ^('+' INT INT ) {System.out.print(\"alt 1\");}"] stringByAppendingString:@"  | ^('+' .+)   {System.out.print(\"alt 2\");}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a + 2"];
  [self assertEquals:@"alt 2\n" param1:found];
}

@end
