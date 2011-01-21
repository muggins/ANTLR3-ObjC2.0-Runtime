// $ANTLR 3.3.1-SNAPSHOT Jan 20, 2011 10:02:28 SimpleC.g 2011-01-20 10:06:18

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */


/* Start cyclicDFAInterface */
#pragma mark Cyclic DFA interface start DFA4
@interface DFA4 : ANTLRDFA {
}
+ newDFA4WithRecognizer:(ANTLRBaseRecognizer *)theRecognizer;
- initWithRecognizer:(ANTLRBaseRecognizer *)recognizer;
@end /* end of DFA4 interface  */

#pragma mark Cyclic DFA interface end DFA4


#pragma mark Rule return scopes start
#pragma mark Rule return scopes end
#pragma mark Tokens
#ifdef EOF
#undef EOF
#endif
#define EOF -1
#define VAR_DEF 4
#define ARG_DEF 5
#define FUNC_HDR 6
#define FUNC_DECL 7
#define FUNC_DEF 8
#define BLOCK 9
#define K_SEMICOLON 10
#define K_ID 11
#define K_LCURVE 12
#define K_COMMA 13
#define K_RCURVE 14
#define K_INT_TYPE 15
#define K_CHAR 16
#define K_VOID 17
#define K_LCURLY 18
#define K_RCURLY 19
#define K_FOR 20
#define K_EQ 21
#define K_EQEQ 22
#define K_LT 23
#define K_PLUS 24
#define K_INT 25
#define WS 26
@interface SimpleCLexer : ANTLRLexer { // line 283
DFA4 *dfa4;
// start of actions.lexer.memVars
// start of action-actionScope-memVars
}
+ (SimpleCLexer *)newSimpleCLexerWithCharStream:(id<ANTLRCharStream>)anInput;

- (void)mK_FOR; 
- (void)mK_CHAR; 
- (void)mK_INT_TYPE; 
- (void)mK_VOID; 
- (void)mK_ID; 
- (void)mK_INT; 
- (void)mK_LCURVE; 
- (void)mK_RCURVE; 
- (void)mK_PLUS; 
- (void)mK_COMMA; 
- (void)mK_SEMICOLON; 
- (void)mK_LT; 
- (void)mK_EQ; 
- (void)mK_EQEQ; 
- (void)mK_LCURLY; 
- (void)mK_RCURLY; 
- (void)mWS; 
- (void)mTokens; 

@end /* end of SimpleCLexer interface */
