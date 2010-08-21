// $ANTLR 3.2 Aug 20, 2010 18:07:53 TestLexer.g 2010-08-20 18:13:23

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
#define DIGIT 5
#define ID 6
#define EOF -1
#define LETTER 4
@interface TestLexer : ANTLRLexer { // line 283
// start of actions.lexer.memVars
// start of action-actionScope-memVars
}
+ (TestLexer *)newTestLexer:(id<ANTLRCharStream>)anInput;

- (void)mID; 
- (void)mDIGIT; 
- (void)mLETTER; 
- (void)mTokens; 

@end /* end of TestLexer interface */
