#import "TestLeftRecursion.h"

@implementation TestLeftRecursion

- (void) init {
  if (self = [super init]) {
    debug = NO;
  }
  return self;
}

- (void) testSimple {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"s : a {System.out.println($a.text);} ;\n"] stringByAppendingString:@"a : a ID\n"] stringByAppendingString:@"  | ID"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"a b c" param6:debug];
  NSString * expecting = @"abc\n";
  [self assertEquals:expecting param1:found];
}

- (void) testSemPred {
  NSString * grammar = [[[[[[@"grammar T;\n" stringByAppendingString:@"s : a {System.out.println($a.text);} ;\n"] stringByAppendingString:@"a : a {true}? ID\n"] stringByAppendingString:@"  | ID"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSString * found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"s" param5:@"a b c" param6:debug];
  NSString * expecting = @"abc\n";
  [self assertEquals:expecting param1:found];
}

- (void) testTernaryExpr {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"e : e '*'^ e"] stringByAppendingString:@"  | e '+'^ e"] stringByAppendingString:@"  | e '?'<assoc=right>^ e ':'! e"] stringByAppendingString:@"  | e '='<assoc=right>^ e"] stringByAppendingString:@"  | ID"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSArray * tests = [NSArray arrayWithObjects:@"a", @"a", @"a+b", @"(+ a b)", @"a*b", @"(* a b)", @"a?b:c", @"(? a b c)", @"a=b=c", @"(= a (= b c))", @"a?b+c:d", @"(? a (+ b c) d)", @"a?b=c:d", @"(? a (= b c) d)", @"a? b?c:d : e", @"(? a (? b c d) e)", @"a?b: c?d:e", @"(? a b (? c d e))", nil];
  [self runTests:grammar tests:tests startRule:@"e"];
}

- (void) testDeclarationsUsingASTOperators {
  NSString * grammar = [[[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"declarator\n"] stringByAppendingString:@"        : declarator '['^ e ']'!\n"] stringByAppendingString:@"        | declarator '['^ ']'!\n"] stringByAppendingString:@"        | declarator '('^ ')'!\n"] stringByAppendingString:@"        | '*'^ declarator\n"] stringByAppendingString:@"        | '('! declarator ')'!\n"] stringByAppendingString:@"        | ID\n"] stringByAppendingString:@"        ;\n"] stringByAppendingString:@"e : INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSArray * tests = [NSArray arrayWithObjects:@"a", @"a", @"*a", @"(* a)", @"**a", @"(* (* a))", @"a[3]", @"([ a 3)", @"b[]", @"([ b)", @"(a)", @"a", @"a[]()", @"(( ([ a))", @"a[][]", @"([ ([ a))", @"*a[]", @"(* ([ a))", @"(*a)[]", @"([ (* a))", nil];
  [self runTests:grammar tests:tests startRule:@"declarator"];
}

- (void) testDeclarationsUsingRewriteOperators {
  NSString * grammar = [[[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"declarator\n"] stringByAppendingString:@"        : declarator '[' e ']' -> ^('[' declarator e)\n"] stringByAppendingString:@"        | declarator '[' ']' -> ^('[' declarator)\n"] stringByAppendingString:@"        | declarator '(' ')' -> ^('(' declarator)\n"] stringByAppendingString:@"        | '*' declarator -> ^('*' declarator) \n"] stringByAppendingString:@"        | '(' declarator ')' -> declarator\n"] stringByAppendingString:@"        | ID -> ID\n"] stringByAppendingString:@"        ;\n"] stringByAppendingString:@"e : INT ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSArray * tests = [NSArray arrayWithObjects:@"a", @"a", @"*a", @"(* a)", @"**a", @"(* (* a))", @"a[3]", @"([ a 3)", @"b[]", @"([ b)", @"(a)", @"a", @"a[]()", @"(( ([ a))", @"a[][]", @"([ ([ a))", @"*a[]", @"(* ([ a))", @"(*a)[]", @"([ (* a))", nil];
  [self runTests:grammar tests:tests startRule:@"declarator"];
}

- (void) testExpressionsUsingASTOperators {
  NSString * grammar = [[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"e : e '.'^ ID\n"] stringByAppendingString:@"  | e '.'^ 'this'\n"] stringByAppendingString:@"  | '-'^ e\n"] stringByAppendingString:@"  | e '*'^ e\n"] stringByAppendingString:@"  | e ('+'^|'-'^) e\n"] stringByAppendingString:@"  | INT\n"] stringByAppendingString:@"  | ID\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSArray * tests = [NSArray arrayWithObjects:@"a", @"a", @"1", @"1", @"a+1", @"(+ a 1)", @"a*1", @"(* a 1)", @"a.b", @"(. a b)", @"a.this", @"(. a this)", @"a-b+c", @"(+ (- a b) c)", @"a+b*c", @"(+ a (* b c))", @"a.b+1", @"(+ (. a b) 1)", @"-a", @"(- a)", @"-a+b", @"(+ (- a) b)", @"-a.b", @"(- (. a b))", nil];
  [self runTests:grammar tests:tests startRule:@"e"];
}

- (void) testExpressionsUsingRewriteOperators {
  NSString * grammar = [[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"e : e '.' ID 				-> ^('.' e ID)\n"] stringByAppendingString:@"  | e '.' 'this' 			-> ^('.' e 'this')\n"] stringByAppendingString:@"  | '-' e 					-> ^('-' e)\n"] stringByAppendingString:@"  | e '*' b=e 				-> ^('*' e $b)\n"] stringByAppendingString:@"  | e (op='+'|op='-') b=e	-> ^($op e $b)\n"] stringByAppendingString:@"  | INT 					-> INT\n"] stringByAppendingString:@"  | ID 					-> ID\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSArray * tests = [NSArray arrayWithObjects:@"a", @"a", @"1", @"1", @"a+1", @"(+ a 1)", @"a*1", @"(* a 1)", @"a.b", @"(. a b)", @"a.this", @"(. a this)", @"a+b*c", @"(+ a (* b c))", @"a.b+1", @"(+ (. a b) 1)", @"-a", @"(- a)", @"-a+b", @"(+ (- a) b)", @"-a.b", @"(- (. a b))", nil];
  [self runTests:grammar tests:tests startRule:@"e"];
}

- (void) testExpressionAssociativity {
  NSString * grammar = [[[[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"e\n"] stringByAppendingString:@"  : e '.'^ ID\n"] stringByAppendingString:@"  | '-'^ e\n"] stringByAppendingString:@"  | e '^'<assoc=right>^ e\n"] stringByAppendingString:@"  | e '*'^ e\n"] stringByAppendingString:@"  | e ('+'^|'-'^) e\n"] stringByAppendingString:@"  | e ('='<assoc=right>^ |'+='<assoc=right>^) e\n"] stringByAppendingString:@"  | INT\n"] stringByAppendingString:@"  | ID\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"ID : 'a'..'z'+ ;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSArray * tests = [NSArray arrayWithObjects:@"a", @"a", @"1", @"1", @"a+1", @"(+ a 1)", @"a*1", @"(* a 1)", @"a.b", @"(. a b)", @"a-b+c", @"(+ (- a b) c)", @"a+b*c", @"(+ a (* b c))", @"a.b+1", @"(+ (. a b) 1)", @"-a", @"(- a)", @"-a+b", @"(+ (- a) b)", @"-a.b", @"(- (. a b))", @"a^b^c", @"(^ a (^ b c))", @"a=b=c", @"(= a (= b c))", @"a=b=c+d.e", @"(= a (= b (+ c (. d e))))", nil];
  [self runTests:grammar tests:tests startRule:@"e"];
}

- (void) testJavaExpressions {
  NSString * grammar = [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"expressionList\n"] stringByAppendingString:@"    :   e (','! e)*\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"e   :   '('! e ')'!\n"] stringByAppendingString:@"    |   'this' \n"] stringByAppendingString:@"    |   'super'\n"] stringByAppendingString:@"    |   INT\n"] stringByAppendingString:@"    |   ID\n"] stringByAppendingString:@"    |   type '.'^ 'class'\n"] stringByAppendingString:@"    |   e '.'^ ID\n"] stringByAppendingString:@"    |   e '.'^ 'this'\n"] stringByAppendingString:@"    |   e '.'^ 'super' '('^ expressionList? ')'!\n"] stringByAppendingString:@"    |   e '.'^ 'new'^ ID '('! expressionList? ')'!\n"] stringByAppendingString:@"	 |	 'new'^ type ( '(' expressionList? ')'! | (options {k=1;}:'[' e ']'!)+)\n"] stringByAppendingString:@"    |   e '['^ e ']'!\n"] stringByAppendingString:@"    |   '('^ type ')'! e\n"] stringByAppendingString:@"    |   e ('++'^ | '--'^)\n"] stringByAppendingString:@"    |   e '('^ expressionList? ')'!\n"] stringByAppendingString:@"    |   ('+'^|'-'^|'++'^|'--'^) e\n"] stringByAppendingString:@"    |   ('~'^|'!'^) e\n"] stringByAppendingString:@"    |   e ('*'^|'/'^|'%'^) e\n"] stringByAppendingString:@"    |   e ('+'^|'-'^) e\n"] stringByAppendingString:@"    |   e ('<'^ '<' | '>'^ '>' '>' | '>'^ '>') e\n"] stringByAppendingString:@"    |   e ('<='^ | '>='^ | '>'^ | '<'^) e\n"] stringByAppendingString:@"    |   e 'instanceof'^ e\n"] stringByAppendingString:@"    |   e ('=='^ | '!='^) e\n"] stringByAppendingString:@"    |   e '&'^ e\n"] stringByAppendingString:@"    |   e '^'<assoc=right>^ e\n"] stringByAppendingString:@"    |   e '|'^ e\n"] stringByAppendingString:@"    |   e '&&'^ e\n"] stringByAppendingString:@"    |   e '||'^ e\n"] stringByAppendingString:@"    |   e '?' e ':' e\n"] stringByAppendingString:@"    |   e ('='<assoc=right>^\n"] stringByAppendingString:@"          |'+='<assoc=right>^\n"] stringByAppendingString:@"          |'-='<assoc=right>^\n"] stringByAppendingString:@"          |'*='<assoc=right>^\n"] stringByAppendingString:@"          |'/='<assoc=right>^\n"] stringByAppendingString:@"          |'&='<assoc=right>^\n"] stringByAppendingString:@"          |'|='<assoc=right>^\n"] stringByAppendingString:@"          |'^='<assoc=right>^\n"] stringByAppendingString:@"          |'>>='<assoc=right>^\n"] stringByAppendingString:@"          |'>>>='<assoc=right>^\n"] stringByAppendingString:@"          |'<<='<assoc=right>^\n"] stringByAppendingString:@"          |'%='<assoc=right>^) e\n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"type: ID \n"] stringByAppendingString:@"    | ID '['^ ']'!\n"] stringByAppendingString:@"    | 'int'\n"] stringByAppendingString:@"	 | 'int' '['^ ']'! \n"] stringByAppendingString:@"    ;\n"] stringByAppendingString:@"ID : ('a'..'z'|'A'..'Z'|'_'|'$')+;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSArray * tests = [NSArray arrayWithObjects:@"a", @"a", @"1", @"1", @"a+1", @"(+ a 1)", @"a*1", @"(* a 1)", @"a.b", @"(. a b)", @"a-b+c", @"(+ (- a b) c)", @"a+b*c", @"(+ a (* b c))", @"a.b+1", @"(+ (. a b) 1)", @"-a", @"(- a)", @"-a+b", @"(+ (- a) b)", @"-a.b", @"(- (. a b))", @"a^b^c", @"(^ a (^ b c))", @"a=b=c", @"(= a (= b c))", @"a=b=c+d.e", @"(= a (= b (+ c (. d e))))", @"a|b&c", @"(| a (& b c))", @"(a|b)&c", @"(& (| a b) c)", @"a > b", @"(> a b)", @"a >> b", @"(> a b)", @"a < b", @"(< a b)", @"(T)x", @"(( T x)", @"new A().b", @"(. (new A () b)", @"(T)t.f()", @"(( (( T (. t f)))", @"a.f(x)==T.c", @"(== (( (. a f) x) (. T c))", @"a.f().g(x,1)", @"(( (. (( (. a f)) g) x 1)", @"new T[((n-1) * x) + 1]", @"(new T [ (+ (* (- n 1) x) 1))", nil];
  [self runTests:grammar tests:tests startRule:@"e"];
}

- (void) testReturnValueAndActions {
  NSString * grammar = [[[[[[[[@"grammar T;\n" stringByAppendingString:@"s : e {System.out.println($e.v);} ;\n"] stringByAppendingString:@"e returns [int v, List<String> ignored]\n"] stringByAppendingString:@"  : e '*' b=e {$v *= $b.v;}\n"] stringByAppendingString:@"  | e '+' b=e {$v += $b.v;}\n"] stringByAppendingString:@"  | INT {$v = $INT.int;}\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSArray * tests = [NSArray arrayWithObjects:@"4", @"4", @"1+2", @"3", nil];
  [self runTests:grammar tests:tests startRule:@"s"];
}

- (void) testReturnValueAndActionsAndASTs {
  NSString * grammar = [[[[[[[[[@"grammar T;\n" stringByAppendingString:@"options {output=AST;}\n"] stringByAppendingString:@"s : e {System.out.print(\"v=\"+$e.v+\", \");} ;\n"] stringByAppendingString:@"e returns [int v, List<String> ignored]\n"] stringByAppendingString:@"  : e '*'^ b=e {$v *= $b.v;}\n"] stringByAppendingString:@"  | e '+'^ b=e {$v += $b.v;}\n"] stringByAppendingString:@"  | INT {$v = $INT.int;}\n"] stringByAppendingString:@"  ;\n"] stringByAppendingString:@"INT : '0'..'9'+ ;\n"] stringByAppendingString:@"WS : (' '|'\\n') {skip();} ;\n"];
  NSArray * tests = [NSArray arrayWithObjects:@"4", @"v=4, 4", @"1+2", @"v=3, (+ 1 2)", nil];
  [self runTests:grammar tests:tests startRule:@"s"];
}

- (void) runTests:(NSString *)grammar tests:(NSArray *)tests startRule:(NSString *)startRule {
  [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:debug];
  BOOL parserBuildsTrees = [grammar rangeOfString:@"output=AST"] >= 0 || [grammar rangeOfString:@"output = AST"] >= 0;
  [self writeRecognizerAndCompile:@"TParser" param1:nil param2:@"TLexer" param3:startRule param4:nil param5:parserBuildsTrees param6:NO param7:NO param8:debug];

  for (int i = 0; i < tests.length; i += 2) {
    NSString * test = tests[i];
    NSString * expecting = [tests[i + 1] stringByAppendingString:@"\n"];
    [self writeFile:tmpdir param1:@"input" param2:test];
    NSString * found = [self execRecognizer];
    [System.out print:[[test stringByAppendingString:@" -> "] stringByAppendingString:found]];
    [self assertEquals:expecting param1:found];
  }

}

@end
