#import "TestHeteroAST.h"

@implementation TestHeteroAST

- (void) init {
  if (self = [super init]) {
    debug = NO;
  }
  return self;
}

- (void) testToken {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID<V> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a<V>\n" param1:found];
}

- (void) testTokenCommonTree {
  NSString * grammar = [[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID<CommonTree> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a\n" param1:found];
}

- (void) testTokenWithQualifiedType {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID<TParser.V> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a<V>\n" param1:found];
}

- (void) testNamedType {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID<node=V> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a<V>\n" param1:found];
}

- (void) testTokenWithLabel {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : x=ID<V> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a<V>\n" param1:found];
}

- (void) testTokenWithListLabel {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : x+=ID<V> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a<V>\n" param1:found];
}

- (void) testTokenRoot {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID<V>^ ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a<V>\n" param1:found];
}

- (void) testTokenRootWithListLabel {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : x+=ID<V>^ ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a<V>\n" param1:found];
}

- (void) testString {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : 'begin'<V> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"begin" param6:debug];
  [self assertEquals:@"begin<V>\n" param1:found];
}

- (void) testStringRoot {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : 'begin'<V>^ ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"begin" param6:debug];
  [self assertEquals:@"begin<V>\n" param1:found];
}

- (void) testRewriteToken {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID -> ID<V> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"a<V>\n" param1:found];
}

- (void) testRewriteTokenWithArgs {
  NSString * grammar = [[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {\n"] stringByAppendingString:@"static class V extends CommonTree {\n"] stringByAppendingString:@"  public int x,y,z;\n"] stringByAppendingString:@"  public V(int ttype, int x, int y, int z) { this.x=x; this.y=y; this.z=z; token=new CommonToken(ttype,\"\"); }\n"] stringByAppendingString:@"  public V(int ttype, Token t, int x) { token=t; this.x=x;}\n"] stringByAppendingString:@"  public String toString() { return (token!=null?token.getText():\"\")+\"<V>;\"+x+y+z;}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID -> ID<V>[42,19,30] ID<V>[$ID,99] ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
  [self assertEquals:@"<V>;421930 a<V>;9900\n" param1:found];
}

- (void) testRewriteTokenRoot {
  NSString * grammar = [[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID INT -> ^(ID<V> INT) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a 2" param6:debug];
  [self assertEquals:@"(a<V> 2)\n" param1:found];
}

- (void) testRewriteString {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : 'begin' -> 'begin'<V> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"begin" param6:debug];
  [self assertEquals:@"begin<V>\n" param1:found];
}

- (void) testRewriteStringRoot {
  NSString * grammar = [[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : 'begin' INT -> ^('begin'<V> INT) ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"begin 2" param6:debug];
  [self assertEquals:@"(begin<V> 2)\n" param1:found];
}

- (void) testRewriteRuleResults {
  NSString * grammar = [[[[[[[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"tokens {LIST;}\n"] stringByAppendingString:@"@members {\n"] stringByAppendingString:@"static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"static class W extends CommonTree {\n"] stringByAppendingString:@"  public W(int tokenType, String txt) { super(new CommonToken(tokenType,txt)); }\n"] stringByAppendingString:@"  public W(Token t) { token=t;}\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<W>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : id (',' id)* -> ^(LIST<W>[\"LIST\"] id+);\n"] stringByAppendingString:@"id : ID -> ID<V>;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a,b,c" param6:debug];
  [self assertEquals:@"(LIST<W> a<V> b<V> c<V>)\n" param1:found];
}

- (void) testCopySemanticsWithHetero {
  NSString * grammar = [[[[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"@members {\n"] stringByAppendingString:@"static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Token t) { token=t;}\n"] stringByAppendingString:@"  public V(V node) { super(node); }\n\n"] stringByAppendingString:@"  public Tree dupNode() { return new V(this); }\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : type ID (',' ID)* ';' -> ^(type ID)+;\n"] stringByAppendingString:@"type : 'int'<V> ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"int a, b, c;" param6:debug];
  [self assertEquals:@"(int<V> a) (int<V> b) (int<V> c)\n" param1:found];
}

- (void) testTreeParserRewriteFlatList {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[[[[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"@members {\n"] stringByAppendingString:@"static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Object t) { super((CommonTree)t); }\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"static class W extends CommonTree {\n"] stringByAppendingString:@"  public W(Object t) { super((CommonTree)t); }\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<W>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID INT -> INT<V> ID<W>\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"34<V> abc<W>\n" param1:found];
}

- (void) testTreeParserRewriteTree {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID INT;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[[[[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"@members {\n"] stringByAppendingString:@"static class V extends CommonTree {\n"] stringByAppendingString:@"  public V(Object t) { super((CommonTree)t); }\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"static class W extends CommonTree {\n"] stringByAppendingString:@"  public W(Object t) { super((CommonTree)t); }\n"] stringByAppendingString:@"  public String toString() { return token.getText()+\"<W>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID INT -> ^(INT<V> ID<W>)\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc 34"];
  [self assertEquals:@"(34<V> abc<W>)\n" param1:found];
}

- (void) testTreeParserRewriteImaginary {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"tokens { ROOT; }\n"] stringByAppendingString:@"@members {\n"] stringByAppendingString:@"class V extends CommonTree {\n"] stringByAppendingString:@"  public V(int tokenType) { super(new CommonToken(tokenType)); }\n"] stringByAppendingString:@"  public String toString() { return tokenNames[token.getType()]+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID -> ROOT<V> ID\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc"];
  [self assertEquals:@"ROOT<V> abc\n" param1:found];
}

- (void) testTreeParserRewriteImaginaryWithArgs {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"tokens { ROOT; }\n"] stringByAppendingString:@"@members {\n"] stringByAppendingString:@"class V extends CommonTree {\n"] stringByAppendingString:@"  public int x;\n"] stringByAppendingString:@"  public V(int tokenType, int x) { super(new CommonToken(tokenType)); this.x=x;}\n"] stringByAppendingString:@"  public String toString() { return tokenNames[token.getType()]+\"<V>;\"+x;}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID -> ROOT<V>[42] ID\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc"];
  [self assertEquals:@"ROOT<V>;42 abc\n" param1:found];
}

- (void) testTreeParserRewriteImaginaryRoot {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"tokens { ROOT; }\n"] stringByAppendingString:@"@members {\n"] stringByAppendingString:@"class V extends CommonTree {\n"] stringByAppendingString:@"  public V(int tokenType) { super(new CommonToken(tokenType)); }\n"] stringByAppendingString:@"  public String toString() { return tokenNames[token.getType()]+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID -> ^(ROOT<V> ID)\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc"];
  [self assertEquals:@"(ROOT<V> abc)\n" param1:found];
}

- (void) testTreeParserRewriteImaginaryFromReal {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"tokens { ROOT; }\n"] stringByAppendingString:@"@members {\n"] stringByAppendingString:@"class V extends CommonTree {\n"] stringByAppendingString:@"  public V(int tokenType) { super(new CommonToken(tokenType)); }\n"] stringByAppendingString:@"  public V(int tokenType, Object tree) { super((CommonTree)tree); token.setType(tokenType); }\n"] stringByAppendingString:@"  public String toString() { return tokenNames[token.getType()]+\"<V>@\"+token.getLine();}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID -> ROOT<V>[$ID]\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc"];
  [self assertEquals:@"ROOT<V>@1\n" param1:found];
}

- (void) testTreeParserAutoHeteroAST {
  NSString * grammar = [[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"a : ID ';' ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+;\n"] stringByAppendingString:@"WS : (' '|'\\n') {$channel=HIDDEN;} ;\n"];
  NSString * treeGrammar = [[[[[[[[[[@"tree grammar TP;\n" stringByAppendingString:@"options {output=AST; ASTLabelType=CommonTree; tokenVocab=T;}\n"] stringByAppendingString:@"tokens { ROOT; }\n"] stringByAppendingString:@"@members {\n"] stringByAppendingString:@"class V extends CommonTree {\n"] stringByAppendingString:@"  public V(CommonTree t) { super(t); }\n"] stringByAppendingString:@"  public String toString() { return super.toString()+\"<V>\";}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"a : ID<V> ';'<V>\n"] stringByAppendingString:@"  ;\n"];
  NSString * found = [self execTreeParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TP.g" param4:treeGrammar param5:@"TP" param6:@"TLexer" param7:@"a" param8:@"a" param9:@"abc;"];
  [self assertEquals:@"abc<V> ;<V>\n" param1:found];
}

@end
