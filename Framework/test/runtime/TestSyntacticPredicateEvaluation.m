#import "TestSyntacticPredicateEvaluation.h"

@implementation TestSyntacticPredicateEvaluation

- (void) testTwoPredsWithNakedAlt {
  NSString * grammar = [[[[[[[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"s : (a ';')+ ;\n"] stringByAppendingString:@"a\n"] stringByAppendingString:@"options {\n"] stringByAppendingString:@"  k=1;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"  : (b '.')=> b '.' {System.out.println(\"alt 1\");}\n"] stringByAppendingString:@"  | (b)=> b {System.out.println(\"alt 2\");}\n"] stringByAppendingString:@"  | c       {System.out.println(\"alt 3\");}\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b\n"] stringByAppendingString:@"@init {System.out.println(\"enter b\");}\n"] stringByAppendingString:@"   : '(' 'x' ')' ;\n"] stringByAppendingString:@"c\n"] stringByAppendingString:@"@init {System.out.println(\"enter c\");}\n"] stringByAppendingString:@"   : '(' c ')' | 'x' ;\n"] stringByAppendingString:@"WS : (' '|'\\n')+ {$channel=HIDDEN;}\n"] stringByAppendingString:@"   ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"(x) ;" param6:NO];
  NSString * expecting = [[[@"enter b\n" stringByAppendingString:@"enter b\n"] stringByAppendingString:@"enter b\n"] stringByAppendingString:@"alt 2\n"];
  [self assertEquals:expecting param1:found];
  found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"(x). ;" param6:NO];
  expecting = [[@"enter b\n" stringByAppendingString:@"enter b\n"] stringByAppendingString:@"alt 1\n"];
  [self assertEquals:expecting param1:found];
  found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"((x)) ;" param6:NO];
  expecting = [[[[[@"enter b\n" stringByAppendingString:@"enter b\n"] stringByAppendingString:@"enter c\n"] stringByAppendingString:@"enter c\n"] stringByAppendingString:@"enter c\n"] stringByAppendingString:@"alt 3\n"];
  [self assertEquals:expecting param1:found];
}

- (void) testTwoPredsWithNakedAltNotLast {
  NSString * grammar = [[[[[[[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"s : (a ';')+ ;\n"] stringByAppendingString:@"a\n"] stringByAppendingString:@"options {\n"] stringByAppendingString:@"  k=1;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"  : (b '.')=> b '.' {System.out.println(\"alt 1\");}\n"] stringByAppendingString:@"  | c       {System.out.println(\"alt 2\");}\n"] stringByAppendingString:@"  | (b)=> b {System.out.println(\"alt 3\");}\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b\n"] stringByAppendingString:@"@init {System.out.println(\"enter b\");}\n"] stringByAppendingString:@"   : '(' 'x' ')' ;\n"] stringByAppendingString:@"c\n"] stringByAppendingString:@"@init {System.out.println(\"enter c\");}\n"] stringByAppendingString:@"   : '(' c ')' | 'x' ;\n"] stringByAppendingString:@"WS : (' '|'\\n')+ {$channel=HIDDEN;}\n"] stringByAppendingString:@"   ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"(x) ;" param6:NO];
  NSString * expecting = [[[@"enter b\n" stringByAppendingString:@"enter c\n"] stringByAppendingString:@"enter c\n"] stringByAppendingString:@"alt 2\n"];
  [self assertEquals:expecting param1:found];
  found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"(x). ;" param6:NO];
  expecting = [[@"enter b\n" stringByAppendingString:@"enter b\n"] stringByAppendingString:@"alt 1\n"];
  [self assertEquals:expecting param1:found];
  found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"((x)) ;" param6:NO];
  expecting = [[[[@"enter b\n" stringByAppendingString:@"enter c\n"] stringByAppendingString:@"enter c\n"] stringByAppendingString:@"enter c\n"] stringByAppendingString:@"alt 2\n"];
  [self assertEquals:expecting param1:found];
}

- (void) testLexerPred {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"s : A ;\n"] stringByAppendingString:@"A options {k=1;}\n"] stringByAppendingString:@"  : (B '.')=>B '.' {System.out.println(\"alt1\");}\n"] stringByAppendingString:@"  | B {System.out.println(\"alt2\");}"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"B : 'x'+ ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"xxx" param6:NO];
  [self assertEquals:@"alt2\n" param1:found];
  found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"xxx." param6:NO];
  [self assertEquals:@"alt1\n" param1:found];
}

- (void) testLexerWithPredLongerThanAlt {
  NSString * grammar = [[[[[[[[@"grammar T;\n" stringByAppendingString:@"s : A ;\n"] stringByAppendingString:@"A options {k=1;}\n"] stringByAppendingString:@"  : (B '.')=>B {System.out.println(\"alt1\");}\n"] stringByAppendingString:@"  | B {System.out.println(\"alt2\");}"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"D : '.' {System.out.println(\"D\");} ;\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"B : 'x'+ ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"xxx" param6:NO];
  [self assertEquals:@"alt2\n" param1:found];
  found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"xxx." param6:NO];
  [self assertEquals:@"alt1\nD\n" param1:found];
}

- (void) testLexerPredCyclicPrediction {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"s : A ;\n"] stringByAppendingString:@"A : (B)=>(B|'y'+) {System.out.println(\"alt1\");}\n"] stringByAppendingString:@"  | B {System.out.println(\"alt2\");}\n"] stringByAppendingString:@"  | 'y'+ ';'"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"B : 'x'+ ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"xxx" param6:NO];
  [self assertEquals:@"alt1\n" param1:found];
}

- (void) testLexerPredCyclicPrediction2 {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"s : A ;\n"] stringByAppendingString:@"A : (B '.')=>(B|'y'+) {System.out.println(\"alt1\");}\n"] stringByAppendingString:@"  | B {System.out.println(\"alt2\");}\n"] stringByAppendingString:@"  | 'y'+ ';'"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"fragment\n"] stringByAppendingString:@"B : 'x'+ ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"xxx" param6:NO];
  [self assertEquals:@"alt2\n" param1:found];
}

- (void) testSimpleNestedPred {
  NSString * grammar = [[[[[[[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"s : (expr ';')+ ;\n"] stringByAppendingString:@"expr\n"] stringByAppendingString:@"options {\n"] stringByAppendingString:@"  k=1;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"@init {System.out.println(\"enter expr \"+input.LT(1).getText());}\n"] stringByAppendingString:@"  : (atom 'x') => atom 'x'\n"] stringByAppendingString:@"  | atom\n"] stringByAppendingString:@";\n"] stringByAppendingString:@"atom\n"] stringByAppendingString:@"@init {System.out.println(\"enter atom \"+input.LT(1).getText());}\n"] stringByAppendingString:@"   : '(' expr ')'\n"] stringByAppendingString:@"   | INT\n"] stringByAppendingString:@"   ;\n"] stringByAppendingString:@"INT: '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n')+ {$channel=HIDDEN;}\n"] stringByAppendingString:@"   ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"(34)x;" param6:NO];
  NSString * expecting = [[[[[[[[@"enter expr (\n" stringByAppendingString:@"enter atom (\n"] stringByAppendingString:@"enter expr 34\n"] stringByAppendingString:@"enter atom 34\n"] stringByAppendingString:@"enter atom 34\n"] stringByAppendingString:@"enter atom (\n"] stringByAppendingString:@"enter expr 34\n"] stringByAppendingString:@"enter atom 34\n"] stringByAppendingString:@"enter atom 34\n"];
  [self assertEquals:expecting param1:found];
}

- (void) testTripleNestedPredInLexer {
  NSString * grammar = [[[[[[[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"s : (.)+ {System.out.println(\"done\");} ;\n"] stringByAppendingString:@"EXPR\n"] stringByAppendingString:@"options {\n"] stringByAppendingString:@"  k=1;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"@init {System.out.println(\"enter expr \"+(char)input.LT(1));}\n"] stringByAppendingString:@"  : (ATOM 'x') => ATOM 'x' {System.out.println(\"ATOM x\");}\n"] stringByAppendingString:@"  | ATOM {System.out.println(\"ATOM \"+$ATOM.text);}\n"] stringByAppendingString:@";\n"] stringByAppendingString:@"fragment ATOM\n"] stringByAppendingString:@"@init {System.out.println(\"enter atom \"+(char)input.LT(1));}\n"] stringByAppendingString:@"   : '(' EXPR ')'\n"] stringByAppendingString:@"   | INT\n"] stringByAppendingString:@"   ;\n"] stringByAppendingString:@"fragment INT: '0'..'9'+ ;\n"] stringByAppendingString:@"fragment WS : (' '|'\\n')+ \n"] stringByAppendingString:@"   ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"((34)x)x" param6:NO];
  NSString * expecting = [[[[[[[[[[[[[[[[[[[[[[[[@"enter expr (\n" stringByAppendingString:@"enter atom (\n"] stringByAppendingString:@"enter expr (\n"] stringByAppendingString:@"enter atom (\n"] stringByAppendingString:@"enter expr 3\n"] stringByAppendingString:@"enter atom 3\n"] stringByAppendingString:@"enter atom 3\n"] stringByAppendingString:@"enter atom (\n"] stringByAppendingString:@"enter expr 3\n"] stringByAppendingString:@"enter atom 3\n"] stringByAppendingString:@"enter atom 3\n"] stringByAppendingString:@"enter atom (\n"] stringByAppendingString:@"enter expr (\n"] stringByAppendingString:@"enter atom (\n"] stringByAppendingString:@"enter expr 3\n"] stringByAppendingString:@"enter atom 3\n"] stringByAppendingString:@"enter atom 3\n"] stringByAppendingString:@"enter atom (\n"] stringByAppendingString:@"enter expr 3\n"] stringByAppendingString:@"enter atom 3\n"] stringByAppendingString:@"enter atom 3\n"] stringByAppendingString:@"ATOM 34\n"] stringByAppendingString:@"ATOM x\n"] stringByAppendingString:@"ATOM x\n"] stringByAppendingString:@"done\n"];
  [self assertEquals:expecting param1:found];
}

- (void) testTreeParserWithSynPred {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT+ (PERIOD|SEMI);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';' ;\n"] stringByAppendingString:@"PERIOD : '.' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[@"tree grammar TP;\n" stringByAppendingString:@"options {k=1; backtrack=true; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ID INT+ PERIOD {System.out.print(\"alt 1\");}"] stringByAppendingString:@"  | ID INT+ SEMI   {System.out.print(\"alt 2\");}\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 1 2 3;"];
  [self assertEquals:@"alt 2\n" param1:found];
}

- (void) testTreeParserWithNestedSynPred {
  NSString * grammar = [[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT+ (PERIOD|SEMI);\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"SEMI : ';' ;\n"] stringByAppendingString:@"PERIOD : '.' ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {k=1; backtrack=true; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"a : ID b {System.out.print(\" a:alt 1\");}"] stringByAppendingString:@"  | ID INT+ SEMI   {System.out.print(\" a:alt 2\");}\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"b : INT PERIOD  {System.out.print(\"b:alt 1\");}"] stringByAppendingString:@"  | INT+ PERIOD {System.out.print(\"b:alt 2\");}"] stringByAppendingString:@"  ;"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"a 1 2 3."];
  [self assertEquals:@"b:alt 2 a:alt 1\n" param1:found];
}

- (void) testSynPredWithOutputTemplate {
  NSString * grammar = [[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=template;}\n"] stringByAppendingString:@"a\n"] stringByAppendingString:@"options {\n"] stringByAppendingString:@"  k=1;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"  : ('x'+ 'y')=> 'x'+ 'y' -> template(a={$text}) <<1:<a>;>>\n"] stringByAppendingString:@"  | 'x'+ 'z' -> template(a={$text}) <<2:<a>;>>\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"WS : (' '|'\\n')+ {$channel=HIDDEN;}\n"] stringByAppendingString:@"   ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"xxxy" param6:NO];
  [self assertEquals:@"1:xxxy;\n" param1:found];
}

- (void) testSynPredWithOutputAST {
  NSString * grammar = [[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a\n"] stringByAppendingString:@"options {\n"] stringByAppendingString:@"  k=1;\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"  : ('x'+ 'y')=> 'x'+ 'y'\n"] stringByAppendingString:@"  | 'x'+ 'z'\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"WS : (' '|'\\n')+ {$channel=HIDDEN;}\n"] stringByAppendingString:@"   ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"xxxy" param6:NO];
  [self assertEquals:@"x x x y\n" param1:found];
}

- (void) testOptionalBlockWithSynPred {
  NSString * grammar = [[[@"grammar T;\n" stringByAppendingString:@"\n"] stringByAppendingString:@"a : ( (b)=> b {System.out.println(\"b\");})? b ;\n"] stringByAppendingString:@"b : 'x' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"xx" param6:NO];
  [self assertEquals:@"b\n" param1:found];
  found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"x" param6:NO];
  [self assertEquals:@"" param1:found];
}

- (void) testSynPredK2 {
  NSString * grammar = [[[@"grammar T;\n" stringByAppendingString:@"\n"] stringByAppendingString:@"a : (b)=> b {System.out.println(\"alt1\");} | 'a' 'c' ;\n"] stringByAppendingString:@"b : 'a' 'b' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"ab" param6:NO];
  [self assertEquals:@"alt1\n" param1:found];
}

- (void) testSynPredKStar {
  NSString * grammar = [[[@"grammar T;\n" stringByAppendingString:@"\n"] stringByAppendingString:@"a : (b)=> b {System.out.println(\"alt1\");} | 'a'+ 'c' ;\n"] stringByAppendingString:@"b : 'a'+ 'b' ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"aaab" param6:NO];
  [self assertEquals:@"alt1\n" param1:found];
}

@end
