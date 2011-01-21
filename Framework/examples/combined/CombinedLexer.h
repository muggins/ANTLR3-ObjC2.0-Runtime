// $ANTLR 3.3.1-SNAPSHOT Jan 20, 2011 10:02:28 Combined.g 2011-01-20 10:06:11

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
#define ID 4
#define INT 5
#define WS 6
@interface CombinedLexer : ANTLRLexer { // line 283
// start of actions.lexer.memVars
// start of action-actionScope-memVars
}
+ (CombinedLexer *)newCombinedLexerWithCharStream:(id<ANTLRCharStream>)anInput;

- (void)mID; 
- (void)mINT; 
- (void)mWS; 
- (void)mTokens; 

@end /* end of CombinedLexer interface */
