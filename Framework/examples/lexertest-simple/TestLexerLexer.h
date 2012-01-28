// $ANTLR ${project.version} ${buildNumber} TestLexer.g 2011-06-20 13:48:42

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Foundation/Foundation.h>
#import <ANTLR/ANTLR.h>
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

/* Start cyclicDFAInterface */

#pragma mark Rule return scopes Interface start
#pragma mark Rule return scopes Interface end
#pragma mark Tokens
#ifdef EOF
#undef EOF
#endif
#define EOF -1
#define DIGIT 4
#define ID 5
#define LETTER 6
/* interface lexer class */
@interface TestLexer : Lexer { // line 283
/* ObjC start of actions.lexer.memVars */
/* ObjC end of actions.lexer.memVars */
}
+ (void) initialize;
+ (TestLexer *)newTestLexerWithCharStream:(id<CharStream>)anInput;
/* ObjC start actions.lexer.methodsDecl */
/* ObjC end actions.lexer.methodsDecl */
- (void) mID ; 
- (void) mDIGIT ; 
- (void) mLETTER ; 
- (void) mTokens ; 

@end /* end of TestLexer interface */

