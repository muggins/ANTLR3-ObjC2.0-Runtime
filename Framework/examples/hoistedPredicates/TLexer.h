// $ANTLR 3.2 Aug 21, 2010 19:57:13 T.g 2010-08-21 20:43:11

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
