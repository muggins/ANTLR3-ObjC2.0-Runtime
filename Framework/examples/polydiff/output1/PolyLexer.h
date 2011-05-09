// $ANTLR 3.3.1-SNAPSHOT Feb 11, 2011 09:03:22 /Users/acondit/source/antlr3/acondit_localhost/code/antlr/main/runtime/ObjC/Framework/examples/polydiff/Poly.g 2011-02-11 09:08:07

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
#define T__8 8
#define T__9 9
#define MULT 4
#define INT 5
#define ID 6
#define WS 7
/* interface lexer class */
@interface PolyLexer : ANTLRLexer { // line 283
/* ObjC start of actions.lexer.memVars */
/* ObjC end of actions.lexer.memVars */
}
+ (PolyLexer *)newPolyLexerWithCharStream:(id<ANTLRCharStream>)anInput;
/* ObjC start actions.lexer.methodsDecl */
/* ObjC end actions.lexer.methodsDecl */
- (void)mT__8; 
- (void)mT__9; 
- (NSString *)mID; 
- (NSString *)mINT; 
- (void)mWS; 
- (void)mTokens; 

@end /* end of PolyLexer interface */
