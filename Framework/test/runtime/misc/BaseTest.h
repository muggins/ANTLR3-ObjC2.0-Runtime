#import <Foundation/Foundation.h>
// #import "Tool.h"
// #import "Label.h"
#import "CommonTokenStream.h"
#import "Token.h"
#import "TokenSource.h"
#import "ANTLRErrorListener.h"
// #import "ErrorManager.h"
// #import "GrammarSemanticsMessage.h"
// #import "Message.h"
// #import "After.h"
// #import "Assert.h"
// #import "Before.h"
// #import "ST.h"

@interface StreamVacuum : NSObject {
  NSString *buf;
  BufferedReader *in;
  Thread *sucker;
}

@property (retain) NSString *buf;
@property (retain) BufferedReader *in;
@property (retain) Thread *sucker;

- (id) initWithIn:(InputStream *)in;
- (void) start;
- (void) run;
- (void) join;
- (NSString *) description;
@end

@interface FilteringTokenStream : CommonTokenStream {
  NSSet *hide;
}

- (id) initWithSrc:(CommonTokenSource *)src;
- (void) sync:(int)i;
- (void) setTokenTypeChannel:(int)ttype channel:(int)channel;
@end

extern const NSString *jikes;
extern const NSString *pathSep;

/**
 * When runnning from Maven, the junit tests are run via the surefire plugin. It sets the
 * classpath for the test environment into the following property. We need to pick this up
 * for the junit tests that are going to generate and try to run code.
 */
extern const NSString *SUREFIRE_CLASSPATH;

/**
 * Build up the full classpath we need, including the surefire path (if present)
 */
extern NSString * const CLASSPATH;

@interface BaseTest : NSObject {
  NSString * tmpdir;

  /**
   * reset during setUp and set to true if we find a problem
 */
  BOOL lastTestFailed;

  /**
   * If error during parser execution, store stderr here; can't return
   * stdout and stderr.  This doesn't trap errors from running antlr.
 */
  NSString * stderrDuringParse;
}

@property(nonatomic, retain, readonly) NSString * firstLineOfException;
- (void) init;
- (void) setUp;
- (void) tearDown;
- (Tool *) newTool:(NSArray *)args;
- (Tool *) newTool;
- (BOOL) compile:(NSString *)fileName;
- (BOOL) antlr:(NSString *)fileName grammarFileName:(NSString *)grammarFileName grammarStr:(NSString *)grammarStr debug:(BOOL)debug;
- (NSString *) execLexer:(NSString *)grammarFileName grammarStr:(NSString *)grammarStr lexerName:(NSString *)lexerName input:(NSString *)input debug:(BOOL)debug;
- (NSString *) execParser:(NSString *)grammarFileName grammarStr:(NSString *)grammarStr parserName:(NSString *)parserName lexerName:(NSString *)lexerName startRuleName:(NSString *)startRuleName input:(NSString *)input debug:(BOOL)debug;
- (NSString *) execTreeParser:(NSString *)parserGrammarFileName parserGrammarStr:(NSString *)parserGrammarStr parserName:(NSString *)parserName treeParserGrammarFileName:(NSString *)treeParserGrammarFileName treeParserGrammarStr:(NSString *)treeParserGrammarStr treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName input:(NSString *)input;
- (NSString *) execTreeParser:(NSString *)parserGrammarFileName parserGrammarStr:(NSString *)parserGrammarStr parserName:(NSString *)parserName treeParserGrammarFileName:(NSString *)treeParserGrammarFileName treeParserGrammarStr:(NSString *)treeParserGrammarStr treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName input:(NSString *)input debug:(BOOL)debug;
- (BOOL) rawGenerateAndBuildRecognizer:(NSString *)grammarFileName grammarStr:(NSString *)grammarStr parserName:(NSString *)parserName lexerName:(NSString *)lexerName debug:(BOOL)debug;
- (NSString *) rawExecRecognizer:(NSString *)parserName treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName parserBuildsTrees:(BOOL)parserBuildsTrees parserBuildsTemplate:(BOOL)parserBuildsTemplate treeParserBuildsTrees:(BOOL)treeParserBuildsTrees debug:(BOOL)debug;
- (NSString *) execRecognizer;
- (void) writeRecognizerAndCompile:(NSString *)parserName treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName parserBuildsTrees:(BOOL)parserBuildsTrees parserBuildsTemplate:(BOOL)parserBuildsTemplate treeParserBuildsTrees:(BOOL)treeParserBuildsTrees debug:(BOOL)debug;
- (void) checkGrammarSemanticsError:(ErrorQueue *)equeue expectedMessage:(GrammarSemanticsMessage *)expectedMessage;
- (void) checkGrammarSemanticsWarning:(ErrorQueue *)equeue expectedMessage:(GrammarSemanticsMessage *)expectedMessage;
- (void) checkError:(ErrorQueue *)equeue expectedMessage:(Message *)expectedMessage;
- (void) writeFile:(NSString *)dir fileName:(NSString *)fileName content:(NSString *)content;
- (void) mkdir:(NSString *)dir;
- (void) writeTestFile:(NSString *)parserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName debug:(BOOL)debug;
- (void) writeLexerTestFile:(NSString *)lexerName debug:(BOOL)debug;
- (void) writeTreeTestFile:(NSString *)parserName treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName debug:(BOOL)debug;
- (void) writeTreeAndTreeTestFile:(NSString *)parserName treeParserName:(NSString *)treeParserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName treeParserStartRuleName:(NSString *)treeParserStartRuleName debug:(BOOL)debug;
- (void) writeTemplateTestFile:(NSString *)parserName lexerName:(NSString *)lexerName parserStartRuleName:(NSString *)parserStartRuleName debug:(BOOL)debug;
- (void) eraseFiles:(NSString *)filesEndingWith;
- (void) eraseFiles;
- (void) eraseTempDir;
- (NSMutableArray *) realElements:(NSMutableArray *)elements;
- (NSMutableArray *) realElements:(NSMutableDictionary *)elements;
- (NSString *) sortLinesInString:(NSString *)s;
- (NSString *) sortMapToString:(NSMutableDictionary *)m;
- (void) assertEquals:(NSString *)msg a:(NSObject *)a b:(NSObject *)b;
- (void) assertEquals:(NSObject *)a b:(NSObject *)b;
- (void) assertEquals:(NSString *)msg a:(long)a b:(long)b;
- (void) assertEquals:(long)a b:(long)b;
- (void) assertTrue:(NSString *)msg b:(BOOL)b;
- (void) assertTrue:(BOOL)b;
- (void) assertFalse:(NSString *)msg b:(BOOL)b;
- (void) assertFalse:(BOOL)b;
- (void) assertNotNull:(NSString *)msg p:(NSObject *)p;
- (void) assertNotNull:(NSObject *)p;
- (void) assertNull:(NSString *)msg p:(NSObject *)p;
- (void) assertNull:(NSObject *)p;
@end
