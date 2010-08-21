// $ANTLR 3.2 Aug 20, 2010 18:07:53 T.g 2010-08-20 18:13:28

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
#define WS 6
#define INT 5
#define ID 4
#define EOF -1
#define T__7 7
@interface TLexer : ANTLRLexer { // line 283
// start of actions.lexer.memVars
// start of action-actionScope-memVars
}
+ (TLexer *)newTLexer:(id<ANTLRCharStream>)anInput;

- (void)mT__7; 
- (void)mID; 
- (void)mINT; 
- (void)mWS; 
- (void)mTokens; 

@end /* end of TLexer interface */
