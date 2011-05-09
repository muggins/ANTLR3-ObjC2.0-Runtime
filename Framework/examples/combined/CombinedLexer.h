// $ANTLR ${project.version} ${buildNumber} Combined.g 2011-05-06 11:53:18

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLR.h>
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

/* Start cyclicDFAInterface */

#pragma mark Rule return scopes start
#pragma mark Rule return scopes end
#pragma mark Tokens
#ifdef EOF
#undef EOF
#endif
#define EOF -1
#define ID 4
#define INT 5
#define WS 6
/* interface lexer class */
@interface CombinedLexer : ANTLRLexer { // line 283
/* ObjC start of actions.lexer.memVars */
/* ObjC end of actions.lexer.memVars */
}
+ (void) initialize;
+ (CombinedLexer *)newCombinedLexerWithCharStream:(id<ANTLRCharStream>)anInput;
/* ObjC start actions.lexer.methodsDecl */
/* ObjC end actions.lexer.methodsDecl */
- (void) mID ; 
- (void) mINT ; 
- (void) mWS ; 
- (void) mTokens ; 

@end /* end of CombinedLexer interface */

