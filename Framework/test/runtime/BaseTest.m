#import "BaseTest.h"

@implementation StreamVacuum

+ (id)newStreamVacuum:(InputStream *)in
{
        return [[StreamVacuum alloc] initWithIn:in];
}

- (id) initWithIn:(InputStream *)in
{
    if (self = [super init]) {
        buf = [[[StringBuffer alloc] init] autorelease];
        in = [[[BufferedReader alloc] init:[[[InputStreamReader alloc] init:in] autorelease]] autorelease];
    }
    return self;
}

- (void) start
{
    sucker = [[[Thread alloc] init:self] autorelease];
    [sucker start];
}

- (void) run
{

    @try {
        NSString *line = [in readLine];

        while (line != nil) {
            [buf append:line];
            [buf append:'\n'];
            line = [in readLine];
        }

    }
    @catch (IOException * ioe) {
        [System.err println:@"can't read output from process"];
    }
}

- (void) dealloc
{
    [buf release];
    [in release];
    [sucker release];
    [super dealloc];
}

/**
 * wait for the thread to finish
 */
- (void)join
{
    [sucker join];
}

- (NSString *) description
{
    return [buf description];
}

@end

@implementation FilteringTokenStream

- (id) initWithSrc:(TokenSource *)src
{
    self = [super init:src];
    if ( self != nil ) {
        hide = [[[HashSet alloc] init] autorelease];
    }
    return self;
}

- (void) dealloc
{
    [hide release];
    [super dealloc];
}

- (void) sync:(int)i
{
    [super sync:i];
    if ([hide contains:[[self get:i] type]])
        [[self get:i] setChannel:Token.HIDDEN_CHANNEL];
}

- (void) setTokenTypeChannel:(int)ttype channel:(int)channel
{
    [hide add:ttype];
}

@end

const NSString *jikes = nil;
const NSString *pathSep = [System getProperty:@"path.separator"];

/**
 * When runnning from Maven, the junit tests are run via the surefire plugin. It sets the
 * classpath for the test environment into the following property. We need to pick this up
 * for the junit tests that are going to generate and try to run code.
 */
const NSString *SUREFIRE_CLASSPATH = [System getProperty:@"surefire.test.class.path" param1:@""];

/**
 * Build up the full classpath we need, including the surefire path (if present)
 */
const NSString *CLASSPATH = [System getProperty:@"java.class.path"] + ([SUREFIRE_CLASSPATH isEqualToString:@""] ? @"" : [pathSep stringByAppendingString:SUREFIRE_CLASSPATH]);

@implementation BaseTest

@synthesize firstLineOfException;

- (void) init
{
    self = [super init];
    if ( self != nil ) {
        tmpdir = nil;
        lastTestFailed = NO;
    }
    return self;
}

- (void) dealloc
{
    if ( tmpdir ) [tmpdir release];
    if ( stderrDuringParse ) [stderrDuringParse release];
    [super dealloc];
}

- (void) setUp
{
    lastTestFailed = NO;
    tmpdir = [[[[File alloc] init:[System getProperty:@"java.io.tmpdir"] param1:[[NSString stringWithFormat:@"antlr-%@-", [self className] stringByAppendingString:@"-"] + [System currentTimeMillis]] autorelease] absolutePath];
    [ErrorManager resetErrorState];
}

- (void) tearDown
{
    if (!lastTestFailed)
        [self eraseTempDir];
}

- (Tool *) newTool:(NSArray *)args
{
    Tool * tool = [[[Tool alloc] init:args] autorelease];
    [tool setOutputDirectory:tmpdir];
    return tool;
}

- (Tool *) newTool
{
    Tool * tool = [[[Tool alloc] init] autorelease];
    [tool setOutputDirectory:tmpdir];
    return tool;
}

- (BOOL) compile:(NSString *)fileName
{
    NSString * compiler = @"javac";
    NSString * classpathOption = @"-classpath";
    if (jikes != nil) {
        compiler = jikes;
        classpathOption = @"-bootclasspath";
    }
    NSArray * args = [NSArray arrayWithObjects:compiler,
            @"-d",
            tmpdir,
            classpathOption,
            [tmpdir stringByAppendingFormat:@"%@%@/%@", pathSep CLASSPATH, fileName],
            nil];
    NSString * cmdLine = [compiler stringByAppendingString:@" -d %@ %@ %@%@%@ %@", tmpdir, classpathOption, tmpdir, pathSep, CLASSPATH, fileName];
    File * outputDir = [[[File alloc] init:tmpdir] autorelease];

    @try {
        Process *process = [[Runtime runtime] exec:args param1:nil param2:outputDir];
        StreamVacuum * stdout = [[[StreamVacuum alloc] init:[process inputStream]] autorelease];
        StreamVacuum * stderr = [[[StreamVacuum alloc] init:[process errorStream]] autorelease];
        [stdout start];
        [stderr start];
        [process waitFor];
        [stdout join];
        [stderr join];
        if ([[stdout description] length] > 0) {
            [System.err println:[@"compile stdout from: " stringByAppendingString:cmdLine]];
            [System.err println:stdout];
        }
        if ([[stderr description] length] > 0) {
            [System.err println:[@"compile stderr from: " stringByAppendingString:cmdLine]];
            [System.err println:stderr];
        }
        int ret = [process exitValue];
        return ret == 0;
    }
    @catch (NSException * e) {
        [System.err println:@"can't exec compilation"];
        [e printStackTrace:System.err];
        return NO;
    }
}

/**
 * Return true if all is ok, no errors
 */
- (BOOL) antlr:(NSString *)fileName grammarFileName:(NSString *)grammarFileName grammarStr:(NSString *)grammarStr debug:(BOOL)debug
{
    BOOL allIsWell = YES;
    [self mkdir:tmpdir];
    [self writeFile:tmpdir fileName:fileName content:grammarStr];

    @try {
        AMutableArray * options = [[AMutableArray arrayWithCapacity:5] retain];
        if ( debug ) {
            [options addObject:@"-debug"];
        }
        [options addObject:@"-o"];
        [options addObject:tmpdir];
        [options addObject:@"-lib"];
        [options addObject:tmpdir];
        [options addObject:[[[[File alloc] init:tmpdir param1:grammarFileName] autorelease] description]];
        NSArray * optionsA = [NSArray array];
        [options toArray:optionsA];
        Tool * antlr = [self newTool:optionsA];
        [antlr process];
        ANTLRErrorListener * listener = [ErrorManager errorListener];
        if ([listener conformsToProtocol:@protocol(ErrorQueue)]) {
            ErrorQueue * equeue = (ErrorQueue *)listener;
            if ([equeue.errors size] > 0) {
                allIsWell = NO;
                [System.err println:[@"antlr reports errors from " stringByAppendingString:options]];

                for (int i = 0; i < [equeue.errors size]; i++) {
                    Message * msg = (Message *)[equeue.errors get:i];
                    [System.err println:msg];
                }

                [System.out println:@"!!!\ngrammar:"];
                [System.out println:grammarStr];
                [System.out println:@"###"];
            }
        }
    }
    @catch (NSException * e) {
        allIsWell = NO;
        [System.err println:[@"problems building grammar: " stringByAppendingString:e]];
        [e printStackTrace:System.err];
    }
    return allIsWell;
}

- (NSString *) execLexer:(NSString *)grammarFileName grammarStr:(NSString *)grammarStr lexerName:(NSString *)lexerName input:(NSString *)input debug:(BOOL)debug
{
    [self rawGenerateAndBuildRecognizer:grammarFileName grammarStr:grammarStr parserName:nil lexerName:lexerName debug:debug];
    [self writeFile:tmpdir fileName:@"input" content:input];
    return [self rawExecRecognizer:nil treeParserName:nil lexerName:lexerName parserStartRuleName:nil treeParserStartRuleName:nil parserBuildsTrees:NO parserBuildsTemplate:NO treeParserBuildsTrees:NO debug:debug];
}

- (NSString *) execParser:(NSString *)grammarFileName grammarStr:(NSString *)grammarStr parserName:(NSString *)parserName lexerName:(NSString *)lexerName startRuleName:(NSString *)startRuleName input:(NSString *)input debug:(BOOL)debug
{
    [self rawGenerateAndBuildRecognizer:grammarFileName grammarStr:grammarStr parserName:parserName lexerName:lexerName debug:debug];
    [self writeFile:tmpdir fileName:@"input" content:input];
    BOOL parserBuildsTrees = [grammarStr rangeOfString:@"output=AST"] >= 0 || [grammarStr rangeOfString:@"output = AST"] >= 0;
    BOOL parserBuildsTemplate = [grammarStr rangeOfString:@"output=template"] >= 0 || [grammarStr rangeOfString:@"output = template"] >= 0;
    return [self rawExecRecognizer:parserName treeParserName:nil lexerName:lexerName parserStartRuleName:startRuleName treeParserStartRuleName:nil parserBuildsTrees:parserBuildsTrees parserBuildsTemplate:parserBuildsTemplate treeParserBuildsTrees:NO debug:debug];
}

- (NSString *) execTreeParser:(NSString *)parserGrammarFileName parserGrammarStr:(NSString *)parserGrammarStr parserName:(NSString *)parserName treeParserGrammarFileName:(NSString *)treeParserGrammarFileName treeParserGrammarStr:(NSString *)treeParserGrammarStr treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName input:(NSString *)input {
    return [self execTreeParser:parserGrammarFileName parserGrammarStr:parserGrammarStr parserName:parserName treeParserGrammarFileName:treeParserGrammarFileName treeParserGrammarStr:treeParserGrammarStr treeParserName:treeParserName lexerName:lexerName parserStartRuleName:parserStartRuleName treeParserStartRuleName:treeParserStartRuleName input:input debug:NO];
}

- (NSString *) execTreeParser:(NSString *)parserGrammarFileName parserGrammarStr:(NSString *)parserGrammarStr parserName:(NSString *)parserName treeParserGrammarFileName:(NSString *)treeParserGrammarFileName treeParserGrammarStr:(NSString *)treeParserGrammarStr treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName input:(NSString *)input debug:(BOOL)debug
{
    [self rawGenerateAndBuildRecognizer:parserGrammarFileName grammarStr:parserGrammarStr parserName:parserName lexerName:lexerName debug:debug];
    [self rawGenerateAndBuildRecognizer:treeParserGrammarFileName grammarStr:treeParserGrammarStr parserName:treeParserName lexerName:lexerName debug:debug];
    [self writeFile:tmpdir fileName:@"input" content:input];
    BOOL parserBuildsTrees = [parserGrammarStr rangeOfString:@"output=AST"] >= 0 || [parserGrammarStr rangeOfString:@"output = AST"] >= 0;
    BOOL treeParserBuildsTrees = [treeParserGrammarStr rangeOfString:@"output=AST"] >= 0 || [treeParserGrammarStr rangeOfString:@"output = AST"] >= 0;
    BOOL parserBuildsTemplate = [parserGrammarStr rangeOfString:@"output=template"] >= 0 || [parserGrammarStr rangeOfString:@"output = template"] >= 0;
    return [self rawExecRecognizer:parserName treeParserName:treeParserName lexerName:lexerName parserStartRuleName:parserStartRuleName treeParserStartRuleName:treeParserStartRuleName parserBuildsTrees:parserBuildsTrees parserBuildsTemplate:parserBuildsTemplate treeParserBuildsTrees:treeParserBuildsTrees debug:debug];
}


/**
 * Return true if all is well
 */
- (BOOL) rawGenerateAndBuildRecognizer:(NSString *)grammarFileName grammarStr:(NSString *)grammarStr parserName:(NSString *)parserName lexerName:(NSString *)lexerName debug:(BOOL)debug
{
    [System.out println:grammarStr];
    BOOL allIsWell = [self antlr:grammarFileName grammarFileName:grammarFileName grammarStr:grammarStr debug:debug];
    if (lexerName != nil) {
        BOOL ok;
        if (parserName != nil) {
            ok = [self compile:[parserName stringByAppendingString:@".java"]];
            if (!ok) {
                allIsWell = NO;
            }
        }
        ok = [self compile:[lexerName stringByAppendingString:@".java"]];
        if (!ok) {
            allIsWell = NO;
        }
    }
     else {
        BOOL ok = [self compile:[parserName stringByAppendingString:@".java"]];
        if (!ok) {
            allIsWell = NO;
        }
    }
    return allIsWell;
}

- (NSString *) rawExecRecognizer:(NSString *)parserName treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName parserBuildsTrees:(BOOL)parserBuildsTrees parserBuildsTemplate:(BOOL)parserBuildsTemplate treeParserBuildsTrees:(BOOL)treeParserBuildsTrees debug:(BOOL)debug
{
    stderrDuringParse = nil;
    [self writeRecognizerAndCompile:parserName treeParserName:treeParserName lexerName:lexerName parserStartRuleName:parserStartRuleName treeParserStartRuleName:treeParserStartRuleName parserBuildsTrees:parserBuildsTrees parserBuildsTemplate:parserBuildsTemplate treeParserBuildsTrees:treeParserBuildsTrees debug:debug];
    return [self execRecognizer];
}

- (NSString *) execRecognizer
{

    @try {
        NSArray * args = [NSArray arrayWithObjects:@"java", @"-classpath", [[tmpdir stringByAppendingString:pathSep] stringByAppendingString:CLASSPATH], @"Test", [[[[File alloc] init:tmpdir param1:@"input"] autorelease] absolutePath], nil];
        Process * process = [[Runtime runtime] exec:args param1:nil param2:[[[File alloc] init:tmpdir] autorelease]];
        StreamVacuum * stdoutVacuum = [[[StreamVacuum alloc] init:[process inputStream]] autorelease];
        StreamVacuum * stderrVacuum = [[[StreamVacuum alloc] init:[process errorStream]] autorelease];
        [stdoutVacuum start];
        [stderrVacuum start];
        [process waitFor];
        [stdoutVacuum join];
        [stderrVacuum join];
        NSString * output = nil;
        output = [stdoutVacuum description];
        if ([[stderrVacuum description] length] > 0) {
            stderrDuringParse = [stderrVacuum description];
        }
        return output;
    }
    @catch (NSException * e) {
        [System.err println:@"can't exec recognizer"];
        [e printStackTrace:System.err];
    }
    return nil;
}

- (void) writeRecognizerAndCompile:(NSString *)parserName treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName parserBuildsTrees:(BOOL)parserBuildsTrees parserBuildsTemplate:(BOOL)parserBuildsTemplate treeParserBuildsTrees:(BOOL)treeParserBuildsTrees debug:(BOOL)debug
{
    if (treeParserBuildsTrees && parserBuildsTrees) {
        [self writeTreeAndTreeTestFile:parserName treeParserName:treeParserName lexerName:lexerName parserStartRuleName:parserStartRuleName treeParserStartRuleName:treeParserStartRuleName debug:debug];
    }
     else if (parserBuildsTrees) {
        [self writeTreeTestFile:parserName treeParserName:treeParserName lexerName:lexerName parserStartRuleName:parserStartRuleName treeParserStartRuleName:treeParserStartRuleName debug:debug];
    }
     else if (parserBuildsTemplate) {
        [self writeTemplateTestFile:parserName lexerName:lexerName parserStartRuleName:parserStartRuleName debug:debug];
    }
     else if (parserName == nil) {
        [self writeLexerTestFile:lexerName debug:debug];
    }
     else {
        [self writeTestFile:parserName lexerName:lexerName parserStartRuleName:parserStartRuleName debug:debug];
    }
    [self compile:@"Test.java"];
}

- (void) checkGrammarSemanticsError:(ErrorQueue *)equeue expectedMessage:(GrammarSemanticsMessage *)expectedMessage
{
    Message * foundMsg = nil;

    for (int i = 0; i < [equeue.errors size]; i++) {
        Message * m = (Message *)[equeue.errors get:i];
        if (m.msgID == expectedMessage.msgID) {
            foundMsg = m;
        }
    }

    [self assertNotNull:[[@"no error; " stringByAppendingString:expectedMessage.msgID] stringByAppendingString:@" expected"] p:foundMsg];
    [self assertTrue:@"error is not a GrammarSemanticsMessage" b:[foundMsg conformsToProtocol:@protocol(GrammarSemanticsMessage)]];
    [self assertEquals:expectedMessage.arg b:foundMsg.arg];
    if ([equeue size] != 1) {
        [System.err println:equeue];
    }
}

- (void) checkGrammarSemanticsWarning:(ErrorQueue *)equeue expectedMessage:(GrammarSemanticsMessage *)expectedMessage
{
    Message * foundMsg = nil;

    for (int i = 0; i < [equeue.warnings size]; i++) {
        Message * m = (Message *)[equeue.warnings get:i];
        if (m.msgID == expectedMessage.msgID) {
            foundMsg = m;
        }
    }

    [self assertNotNull:[[@"no error; " stringByAppendingString:expectedMessage.msgID] stringByAppendingString:@" expected"] p:foundMsg];
    [self assertTrue:@"error is not a GrammarSemanticsMessage" b:[foundMsg conformsToProtocol:@protocol(GrammarSemanticsMessage)]];
    [self assertEquals:expectedMessage.arg b:foundMsg.arg];
}

- (void) checkError:(ErrorQueue *)equeue expectedMessage:(Message *)expectedMessage
{
    Message * foundMsg = nil;

    for (int i = 0; i < [equeue.errors size]; i++) {
        Message * m = (Message *)[equeue.errors get:i];
        if (m.msgID == expectedMessage.msgID) {
            foundMsg = m;
        }
    }

    [self assertTrue:[[@"no error; " stringByAppendingString:expectedMessage.msgID] stringByAppendingString:@" expected"] b:[equeue.errors size] > 0];
    [self assertTrue:[@"too many errors; " stringByAppendingString:equeue.errors] b:[equeue.errors size] <= 1];
    [self assertNotNull:[@"couldn't find expected error: " stringByAppendingString:expectedMessage.msgID] p:foundMsg];
    [self assertEquals:expectedMessage.arg b:foundMsg.arg];
    [self assertEquals:expectedMessage.arg2 b:foundMsg.arg2];
    [ErrorManager resetErrorState];
}

- (void) writeFile:(NSString *)dir fileName:(NSString *)fileName content:(NSString *)content
{

    @try {
        File * f = [[[File alloc] init:dir param1:fileName] autorelease];
        FileWriter * w = [[[FileWriter alloc] init:f] autorelease];
        BufferedWriter * bw = [[[BufferedWriter alloc] init:w] autorelease];
        [bw write:content];
        [bw close];
        [w close];
    }
    @catch (IOException * ioe) {
        [System.err println:@"can't write file"];
        [ioe printStackTrace:System.err];
    }
}

- (void) mkdir:(NSString *)dir
{
    File * f = [[[File alloc] init:dir] autorelease];
    [f mkdirs];
}

- (void) writeTestFile:(NSString *)parserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName debug:(BOOL)debug
{
    ST * outputFileST = [[[ST alloc] init:[[[[[[[[[[[[[[[@"import org.antlr.runtime.*;\n" stringByAppendingString:@"import org.antlr.runtime.tree.*;\n"] stringByAppendingString:@"import org.antlr.runtime.debug.*;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"class Profiler2 extends Profiler {\n"] stringByAppendingString:@"      public void terminate() { ; }\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"public class Test {\n"] stringByAppendingString:@"      public static void main(String[] args) throws Exception {\n"] stringByAppendingString:@"                CharStream input = new ANTLRFileStream(args[0]);\n"] stringByAppendingString:@"                <lexerName> lex = new <lexerName>(input);\n"] stringByAppendingString:@"                CommonTokenStream tokens = new CommonTokenStream(lex);\n"] stringByAppendingString:@"                <createParser>\n"] stringByAppendingString:@"              parser.<parserStartRuleName>();\n"] stringByAppendingString:@"      }\n"] stringByAppendingString:@"}"]] autorelease];
    ST * createParserST = [[[ST alloc] init:[[@"                Profiler2 profiler = new Profiler2();\n" stringByAppendingString:@"              <parserName> parser = new <parserName>(tokens,profiler);\n"] stringByAppendingString:@"                profiler.setParser(parser);\n"]] autorelease];
    if (!debug) {
        createParserST = [[[ST alloc] init:@"                <parserName> parser = new <parserName>(tokens);\n"] autorelease];
    }
    [outputFileST add:@"createParser" param1:createParserST];
    [outputFileST add:@"parserName" param1:parserName];
    [outputFileST add:@"lexerName" param1:lexerName];
    [outputFileST add:@"parserStartRuleName" param1:parserStartRuleName];
    [self writeFile:tmpdir fileName:@"Test.java" content:[outputFileST render]];
}

- (void) writeLexerTestFile:(NSString *)lexerName debug:(BOOL)debug
{
    ST * outputFileST = [[[ST alloc] init:[[[[[[[[[[[[[[@"import org.antlr.runtime.*;\n" stringByAppendingString:@"import org.antlr.runtime.tree.*;\n"] stringByAppendingString:@"import org.antlr.runtime.debug.*;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"class Profiler2 extends Profiler {\n"] stringByAppendingString:@"      public void terminate() { ; }\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"public class Test {\n"] stringByAppendingString:@"      public static void main(String[] args) throws Exception {\n"] stringByAppendingString:@"                CharStream input = new ANTLRFileStream(args[0]);\n"] stringByAppendingString:@"              <lexerName> lex = new <lexerName>(input);\n"] stringByAppendingString:@"                CommonTokenStream tokens = new CommonTokenStream(lex);\n"] stringByAppendingString:@"              System.out.println(tokens);\n"] stringByAppendingString:@"      }\n"] stringByAppendingString:@"}"]] autorelease];
    [outputFileST add:@"lexerName" param1:lexerName];
    [self writeFile:tmpdir fileName:@"Test.java" content:[outputFileST render]];
}

- (void) writeTreeTestFile:(NSString *)parserName treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName debug:(BOOL)debug
{
    ST * outputFileST = [[[ST alloc] init:[[[[[[[[[[[[[[[[[[[[[[[[[[@"import org.antlr.runtime.*;\n" stringByAppendingString:@"import org.antlr.runtime.tree.*;\n"] stringByAppendingString:@"import org.antlr.runtime.debug.*;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"class Profiler2 extends Profiler {\n"] stringByAppendingString:@"      public void terminate() { ; }\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"public class Test {\n"] stringByAppendingString:@"      public static void main(String[] args) throws Exception {\n"] stringByAppendingString:@"                CharStream input = new ANTLRFileStream(args[0]);\n"] stringByAppendingString:@"              <lexerName> lex = new <lexerName>(input);\n"] stringByAppendingString:@"                TokenRewriteStream tokens = new TokenRewriteStream(lex);\n"] stringByAppendingString:@"                <createParser>\n"] stringByAppendingString:@"                <parserName>.<parserStartRuleName>_return r = parser.<parserStartRuleName>();\n"] stringByAppendingString:@"                <if(!treeParserStartRuleName)>\n"] stringByAppendingString:@"              if ( r.tree!=null ) {\n"] stringByAppendingString:@"                        System.out.println(((Tree)r.tree).toStringTree());\n"] stringByAppendingString:@"                        ((CommonTree)r.tree).sanityCheckParentAndChildIndexes();\n"] stringByAppendingString:@"         }\n"] stringByAppendingString:@"                <else>\n"] stringByAppendingString:@"              CommonTreeNodeStream nodes = new CommonTreeNodeStream((Tree)r.tree);\n"] stringByAppendingString:@"              nodes.setTokenStream(tokens);\n"] stringByAppendingString:@"                <treeParserName> walker = new <treeParserName>(nodes);\n"] stringByAppendingString:@"              walker.<treeParserStartRuleName>();\n"] stringByAppendingString:@"              <endif>\n"] stringByAppendingString:@"      }\n"] stringByAppendingString:@"}"]] autorelease];
    ST * createParserST = [[[ST alloc] init:[[@"                Profiler2 profiler = new Profiler2();\n" stringByAppendingString:@"              <parserName> parser = new <parserName>(tokens,profiler);\n"] stringByAppendingString:@"                profiler.setParser(parser);\n"]] autorelease];
    if (!debug) {
        createParserST = [[[ST alloc] init:@"                <parserName> parser = new <parserName>(tokens);\n"] autorelease];
    }
    [outputFileST add:@"createParser" param1:createParserST];
    [outputFileST add:@"parserName" param1:parserName];
    [outputFileST add:@"treeParserName" param1:treeParserName];
    [outputFileST add:@"lexerName" param1:lexerName];
    [outputFileST add:@"parserStartRuleName" param1:parserStartRuleName];
    [outputFileST add:@"treeParserStartRuleName" param1:treeParserStartRuleName];
    [self writeFile:tmpdir fileName:@"Test.java" content:[outputFileST render]];
}


/**
 * Parser creates trees and so does the tree parser
 */
- (void) writeTreeAndTreeTestFile:(NSString *)parserName treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName debug:(BOOL)debug
{
    ST * outputFileST = [[[ST alloc] init:[[[[[[[[[[[[[[[[[[[[[[@"import org.antlr.runtime.*;\n" stringByAppendingString:@"import org.antlr.runtime.tree.*;\n"] stringByAppendingString:@"import org.antlr.runtime.debug.*;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"class Profiler2 extends Profiler {\n"] stringByAppendingString:@"      public void terminate() { ; }\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"public class Test {\n"] stringByAppendingString:@"      public static void main(String[] args) throws Exception {\n"] stringByAppendingString:@"                CharStream input = new ANTLRFileStream(args[0]);\n"] stringByAppendingString:@"              <lexerName> lex = new <lexerName>(input);\n"] stringByAppendingString:@"                TokenRewriteStream tokens = new TokenRewriteStream(lex);\n"] stringByAppendingString:@"                <createParser>\n"] stringByAppendingString:@"                <parserName>.<parserStartRuleName>_return r = parser.<parserStartRuleName>();\n"] stringByAppendingString:@"                ((CommonTree)r.tree).sanityCheckParentAndChildIndexes();\n"] stringByAppendingString:@"                CommonTreeNodeStream nodes = new CommonTreeNodeStream((Tree)r.tree);\n"] stringByAppendingString:@"              nodes.setTokenStream(tokens);\n"] stringByAppendingString:@"                <treeParserName> walker = new <treeParserName>(nodes);\n"] stringByAppendingString:@"              <treeParserName>.<treeParserStartRuleName>_return r2 = walker.<treeParserStartRuleName>();\n"] stringByAppendingString:@"        CommonTree rt = ((CommonTree)r2.tree);\n"] stringByAppendingString:@"       if ( rt!=null ) System.out.println(((CommonTree)r2.tree).toStringTree());\n"] stringByAppendingString:@"        }\n"] stringByAppendingString:@"}"]] autorelease];
    ST * createParserST = [[[ST alloc] init:[[@"                Profiler2 profiler = new Profiler2();\n" stringByAppendingString:@"              <parserName> parser = new <parserName>(tokens,profiler);\n"] stringByAppendingString:@"                profiler.setParser(parser);\n"]] autorelease];
    if (!debug) {
        createParserST = [[[ST alloc] init:@"                <parserName> parser = new <parserName>(tokens);\n"] autorelease];
    }
    [outputFileST add:@"createParser" param1:createParserST];
    [outputFileST add:@"parserName" param1:parserName];
    [outputFileST add:@"treeParserName" param1:treeParserName];
    [outputFileST add:@"lexerName" param1:lexerName];
    [outputFileST add:@"parserStartRuleName" param1:parserStartRuleName];
    [outputFileST add:@"treeParserStartRuleName" param1:treeParserStartRuleName];
    [self writeFile:tmpdir fileName:@"Test.java" content:[outputFileST render]];
}

- (void) writeTemplateTestFile:(NSString *)parserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName debug:(BOOL)debug
{
    ST * outputFileST = [[[ST alloc] init:[[[[[[[[[[[[[[[[[[[[[[[[@"import org.antlr.runtime.*;\n" stringByAppendingString:@"import org.stringtemplate.v4.*;\n"] stringByAppendingString:@"import org.antlr.runtime.debug.*;\n"] stringByAppendingString:@"import java.io.*;\n"] stringByAppendingString:@"\n"] stringByAppendingString:@"class Profiler2 extends Profiler {\n"] stringByAppendingString:@"      public void terminate() { ; }\n"] stringByAppendingString:@"}\n"] stringByAppendingString:@"public class Test {\n"] stringByAppendingString:@"      static String templates =\n"] stringByAppendingString:@"               \"foo(x,y) ::= \\\"\\<x> \\<y>\\\"\";\n"] stringByAppendingString:@"        static STGroup group = new STGroupString(templates);\n"] stringByAppendingString:@"      public static void main(String[] args) throws Exception {\n"] stringByAppendingString:@"                CharStream input = new ANTLRFileStream(args[0]);\n"] stringByAppendingString:@"                <lexerName> lex = new <lexerName>(input);\n"] stringByAppendingString:@"                CommonTokenStream tokens = new CommonTokenStream(lex);\n"] stringByAppendingString:@"                <createParser>\n"] stringByAppendingString:@"       parser.setTemplateLib(group);\n"] stringByAppendingString:@"                <parserName>.<parserStartRuleName>_return r = parser.<parserStartRuleName>();\n"] stringByAppendingString:@"                if ( r.st!=null )\n"] stringByAppendingString:@"                        System.out.print(r.st.render());\n"] stringByAppendingString:@"         else\n"] stringByAppendingString:@"                        System.out.print(\"\");\n"] stringByAppendingString:@"      }\n"] stringByAppendingString:@"}"]] autorelease];
    ST * createParserST = [[[ST alloc] init:[[@"                Profiler2 profiler = new Profiler2();\n" stringByAppendingString:@"              <parserName> parser = new <parserName>(tokens,profiler);\n"] stringByAppendingString:@"                profiler.setParser(parser);\n"]] autorelease];
    if (!debug) {
        createParserST = [[[ST alloc] init:@"                <parserName> parser = new <parserName>(tokens);\n"] autorelease];
    }
    [outputFileST add:@"createParser" param1:createParserST];
    [outputFileST add:@"parserName" param1:parserName];
    [outputFileST add:@"lexerName" param1:lexerName];
    [outputFileST add:@"parserStartRuleName" param1:parserStartRuleName];
    [self writeFile:tmpdir fileName:@"Test.java" content:[outputFileST render]];
}

- (void) eraseFiles:(NSString *)filesEndingWith
{
    File * tmpdirF = [[[File alloc] init:tmpdir] autorelease];
    NSArray * files = [tmpdirF list];

    for (int i = 0; files != nil && i < files.length; i++) {
        if ([files[i] endsWith:filesEndingWith]) {
            [[[[File alloc] init:[tmpdir stringByAppendingString:@"/"] + files[i]] autorelease] delete];
        }
    }

}

- (void) eraseFiles
{
    File * tmpdirF = [[[File alloc] init:tmpdir] autorelease];
    NSArray * files = [tmpdirF list];

    for (int i = 0; files != nil && i < files.length; i++) {
        [[[[File alloc] init:[tmpdir stringByAppendingString:@"/"] + files[i]] autorelease] delete];
    }

}

- (void) eraseTempDir
{
    File * tmpdirF = [[[File alloc] init:tmpdir] autorelease];
    if ([tmpdirF exists]) {
        [self eraseFiles];
        [tmpdirF delete];
    }
}

- (NSString *) firstLineOfException
{
    if (stderrDuringParse == nil) {
        return nil;
    }
    NSArray * lines = [stderrDuringParse split:@"\n"];
    NSString * prefix = @"Exception in thread \"main\" ";
    return [lines[0] substring:[prefix length] param1:[lines[0] count]];
}

- (NSMutableArray *) realElements:(NSMutableArray *)elements {
    NSMutableArray * n = [[[NSMutableArray alloc] init] autorelease];

    for (int i = Label.NUM_FAUX_LABELS + Label.MIN_TOKEN_TYPE - 1; i < [elements count]; i++) {
        NSObject * o = (NSObject *)[elements objectAtIndex:i];
        if (o != nil) {
            [n addObject:o];
        }
    }

    return n;
}

- (NSMutableArray *) realElements:(NSMutableDictionary *)elements
{
    NSMutableArray * n = [[[NSMutableArray alloc] init] autorelease];
    NSEnumerator * iterator = [[elements allKeys] iterator];

    while ([iterator hasNext]) {
        NSString * tokenID = (NSString *)[iterator nextObject];
        if ([elements objectForKey:tokenID] >= Label.MIN_TOKEN_TYPE) {
            [n addObject:[tokenID stringByAppendingString:@"="] + [elements objectForKey:tokenID]];
        }
    }

    [Collections sort:n];
    return n;
}

- (NSString *) sortLinesInString:(NSString *)s
{
    NSString * lines[] = [s componentsSeparatedByString:@"\n"];
    [Arrays sort:lines];
    NSMutableArray * linesL = [Arrays asList:lines];
    StringBuffer * buf = [[[StringBuffer alloc] init] autorelease];

    for (NSString * l in linesL) {
        [buf append:l];
        [buf append:'\n'];
    }

    return [buf description];
}


/**
 * When looking at a result set that consists of a Map/HashTable
 * we cannot rely on the output order, as the hashing algorithm or other aspects
 * of the implementation may be different on differnt JDKs or platforms. Hence
 * we take the Map, convert the keys to a List, sort them and Stringify the Map, which is a
 * bit of a hack, but guarantees that we get the same order on all systems. We assume that
 * the keys are strings.
 * 
 * @param m The Map that contains keys we wish to return in sorted order
 * @return A string that represents all the keys in sorted order.
 */
- (NSString *) sortMapToString:(NSMutableDictionary *)m
{
    [System.out println:[@"Map toString looks like: " stringByAppendingString:[m description]]];
    if (m == nil) {
        return nil;
    }
    TreeMap * nset = [[[TreeMap alloc] init:m] autorelease];
    [System.out println:[@"Tree map looks like: " stringByAppendingString:[nset description]]];
    return [nset description];
}

- (void) assertEquals:(NSString *)msg a:(NSObject *)a b:(NSObject *)b
{

    @try {
        [Assert assertEquals:msg param1:a param2:b];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

- (void) assertEquals:(NSObject *)a b:(NSObject *)b
{

    @try {
        [Assert assertEquals:a param1:b];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

- (void) assertEquals:(NSString *)msg a:(long)a b:(long)b
{

    @try {
        [Assert assertEquals:msg param1:a param2:b];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

- (void) assertEquals:(long)a b:(long)b
{

    @try {
        [Assert assertEquals:a param1:b];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

- (void) assertTrue:(NSString *)msg b:(BOOL)b
{

    @try {
        [Assert assertTrue:msg param1:b];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

- (void) assertTrue:(BOOL)b
{

    @try {
        [Assert assertTrue:b];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

- (void) assertFalse:(NSString *)msg b:(BOOL)b
{

    @try {
        [Assert assertFalse:msg param1:b];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

- (void) assertFalse:(BOOL)b
{

    @try {
        [Assert assertFalse:b];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

- (void) assertNotNull:(NSString *)msg p:(NSObject *)p
{

    @try {
        [Assert assertNotNull:msg param1:p];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

- (void) assertNotNull:(NSObject *)p
{

    @try {
        [Assert assertNotNull:p];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

- (void) assertNull:(NSString *)msg p:(NSObject *)p
{

    @try {
        [Assert assertNull:msg param1:p];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

- (void) assertNull:(NSObject *)p
{

    @try {
        [Assert assertNull:p];
    }
    @catch (NSException * e) {
        lastTestFailed = YES;
        @throw e;
    }
}

@end
