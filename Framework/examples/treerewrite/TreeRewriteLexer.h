// $ANTLR 3.3.1-SNAPSHOT Jan 18, 2011 15:10:00 TreeRewrite.g 2011-01-19 07:53:03

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
#define EOF -1
#define INT 4
#define WS 5
@interface TreeRewriteLexer : ANTLRLexer { // line 283
// start of actions.lexer.memVars
// start of action-actionScope-memVars
}
+ (TreeRewriteLexer *)newTreeRewriteLexerWithCharStream:(id<ANTLRCharStream>)anInput;

- (void)mINT; 
- (void)mWS; 
- (void)mTokens; 

@end /* end of TreeRewriteLexer interface */
