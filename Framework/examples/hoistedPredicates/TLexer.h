// $ANTLR 3.3.1-SNAPSHOT Jan 20, 2011 10:02:28 T.g 2011-01-20 10:06:15

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
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
#define T__7 7
#define ID 4
#define INT 5
#define WS 6
@interface TLexer : ANTLRLexer { // line 283
// start of actions.lexer.memVars
// start of action-actionScope-memVars
}
+ (TLexer *)newTLexerWithCharStream:(id<ANTLRCharStream>)anInput;

- (void)mT__7; 
- (void)mID; 
- (void)mINT; 
- (void)mWS; 
- (void)mTokens; 

@end /* end of TLexer interface */
