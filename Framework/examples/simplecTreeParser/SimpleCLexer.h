// $ANTLR 3.2 Aug 23, 2010 21:05:19 SimpleC.g 2010-08-23 21:07:18

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
/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */

/* returnScopeInterface */


#pragma mark Rule return scopes end
#pragma mark Tokens
#define K_ID 11
#define K_RCURLY 19
#define K_RCURVE 14
#define K_EQEQ 22
#define K_INT 15
#define K_SemiColon 10
#define K_FOR 20
#define FUNC_HDR 6
#define FUNC_DEF 8
#define EOF -1
#define K_INT_TYPE 25
#define FUNC_DECL 7
#define K_COMMA 13
#define ARG_DEF 5
#define K_LCURLY 18
#define WS 26
#define K_EQ 21
#define BLOCK 9
#define K_LCURVE 12
#define K_LT 23
#define K_CHAR 16
#define K_VOID 17
#define VAR_DEF 4
#define K_PLUS 24
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
- (void)mK_SemiColon; 
- (void)mK_LT; 
- (void)mK_EQ; 
- (void)mK_EQEQ; 
- (void)mK_LCURLY; 
- (void)mK_RCURLY; 
- (void)mWS; 
- (void)mTokens; 

@end /* end of SimpleCLexer interface */
