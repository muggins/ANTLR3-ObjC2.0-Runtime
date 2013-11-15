#import "TestLexer.h"

@implementation TestLexer


/**
 * Public default constructor used by TestRig
 */
- (id) init
{
    if (self = [super init]) {
        debug = NO;
    }
    return self;
}

- (void) testSetText
{
    NSString *grammar = @"grammar P;\na : A {System.out.println(input);} ;\nA : '\\\\' 't' {setText(\"\t\");} ;\nWS : (' '|'\\n') {$channel=HIDDEN;} ;";
    NSString *found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"\\t" param6:debug];
    [self assertEquals:@"\t\n" param1:found];
}

- (void) testRefToRuleDoesNotSetTokenNorEmitAnother
{
    NSString *grammar = @"grammar P;\na : A EOF {System.out.println(input);} ;\nA : '-' I ;\nI : '0'..'9'+ ;\nWS : (' '|'\\n') {$channel=HIDDEN;} ;";
    NSString *found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"-34" param6:debug];
    [self assertEquals:@"-34\n" param1:found];
}

- (void) testRefToRuleDoesNotSetChannel
{
    NSString *grammar = @"grammar P;\na : A EOF {NSLog(@\"%@\", $A.text+\", channel=\"+$A.channel);} ;\nA : '-' WS I ;\nI : '0'..'9'+ ;\nWS : (' '|'\\n') {$channel=HIDDEN;} ;";
    NSString *found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"- 34" param6:debug];
    [self assertEquals:@"- 34, channel=0\n" param1:found];
}

- (void) testWeCanSetType
{
    NSString *grammar = @"grammar P;\ntokens {X;}\na : X EOF {NSLog(@\"%@\", input);} ;\nA : '-' I {$type = X;} ;\nI : '0'..'9'+ ;\nWS : (' '|'\\n') {$channel=HIDDEN;} ;";
    NSString *found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"-34" param6:debug];
    [self assertEquals:@"-34\n" param1:found];
}

- (void) testRefToFragment
{
    NSString *grammar = @"grammar P;\na : A {NSLog( @"%@", input);} ;\nA : '-' I ;\nfragment I : '0'..'9'+ ;\nWS : (' '|'\\n') {$channel=HIDDEN;} ;";
    NSString *found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"-34" param6:debug];
    [self assertEquals:@"-34\n" param1:found];
}

- (void) testMultipleRefToFragment
{
    NSString *grammar = @"grammar P;\na : A EOF {NSLog(@\"%@\", input);} ;\nA : I '.' I ;\nfragment I : '0'..'9'+ ;\nWS : (' '|'\\n') {$channel=HIDDEN;} ;";
    NSString *found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"3.14159" param6:debug];
    [self assertEquals:@"3.14159\n" param1:found];
}

- (void) testLabelInSubrule
{
    NSString *grammar = @"grammar P;\na : A EOF ;\nA : 'hi' WS (v=I)? {$channel=0; NSLog($v.text);} ;\nfragment I : '0'..'9'+ ;\nWS : (' '|'\\n') {$channel=HIDDEN;} ;";
    NSString *found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"hi 342" param6:debug];
    [self assertEquals:@"342\n" param1:found];
}

- (void) testRefToTokenInLexer
{
    NSString *grammar = @"grammar P;\na : A EOF ;\nA : I {NSLog(@\" %@\", $I.text);} ;\nfragment I : '0'..'9'+ ;\nWS : (' '|'\\n') {$channel=HIDDEN;} ;";
    NSString *found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"342" param6:debug];
    [self assertEquals:@"342\n" param1:found];
}

- (void) testListLabelInLexer
{
    NSString *grammar = @"grammar P;\na : A ;\nA : i+=I+ {for (Object t : $i) NSLog(\" %@\", ((Token)t).getText());} ;\nfragment I : '0'..'9'+ ;\nWS : (' '|'\\n') {$channel=HIDDEN;} ;";
    NSString * found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"33 297" param6:debug];
    [self assertEquals:@" 33 297\n" param1:found];
}

- (void) testDupListRefInLexer
{
    NSString *grammar = @"grammar P;\na : A ;\nA : i+=I WS i+=I {$channel=0; for (Object t : $i) NSLog(@\" %@\", ((Token)t).getText());} ;\nfragment I : '0'..'9'+ ;\nWS : (' '|'\\n') {$channel=HIDDEN;} ;"];
    NSString *found = [self execParser:@"P.g" param1:grammar param2:@"PParser" param3:@"PLexer" param4:@"a" param5:@"33 297" param6:debug];
    [self assertEquals:@" 33 297\n" param1:found];
}

- (void) testCharLabelInLexer
{
    NSString *grammar = @"grammar T;\na : B ;\nB : x='a' {NSLog(\" %@\", (char)$x);} ;\n";
    NSString *found = [self execParser:@"T.g" param1:grammar param2:@"TParser" param3:@"TLexer" param4:@"a" param5:@"a" param6:debug];
    [self assertEquals:@"a\n" param1:found];
}

- (void) testRepeatedLabelInLexer
{
    NSString *grammar = @"lexer grammar T;\nB : x='a' x='b' ;\n";
    BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:nil param3:@"T" param4:NO];
    BOOL expecting = YES;
    [self assertEquals:expecting param1:found];
}

- (void) testRepeatedRuleLabelInLexer
{
    NSString *grammar = @"lexer grammar T;\nB : x=A x=A ;\nfragment A : 'a' ;\n";
    BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:nil param3:@"T" param4:NO];
    BOOL expecting = YES;
    [self assertEquals:expecting param1:found];
}

- (void) testIsolatedEOTEdge
{
    NSString *grammar = @"lexer grammar T;\nQUOTED_CONTENT \n        : 'q' (~'q')* (('x' 'q') )* 'q' ; \n";
    BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:nil param3:@"T" param4:NO];
    BOOL expecting = YES;
    [self assertEquals:expecting param1:found];
}

- (void) testEscapedLiterals
{
    NSString *grammar = @"lexer grammar T;\nA : '\\\"' ;\nB : '\\\\\\\"' ;\n";
    BOOL found = [self rawGenerateAndBuildRecognizer:@"T.g" param1:grammar param2:nil param3:@"T" param4:NO];
    BOOL expecting = YES;
    [self assertEquals:expecting param1:found];
}

- (void) testNewlineLiterals
{
    Grammar *g = [[[Grammar alloc] init:[@"lexer grammar T;\nA : '\\n\\n' ;\n"]] autorelease];
    NSString *expecting = @"match(\"\\n\\n\")";
    Tool *antlr = [self newTool];
    [antlr setOutputDirectory:nil];
    CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
    [g setCodeGenerator:generator];
    [generator genRecognizer];
    StringTemplate * codeST = [generator recognizerST];
    NSString *code = [codeST description];
    NSInteger m = [code rangeOfString:@"match(\""];
    NSString *found = [code substringFromIndex:m param1:m + [expecting length]];
    [self assertEquals:expecting param1:found];
}

@end
