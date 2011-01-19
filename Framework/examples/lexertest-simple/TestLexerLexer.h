// $ANTLR 3.3.1-SNAPSHOT Jan 18, 2011 15:10:00 TestLexer.g 2011-01-18 15:28:34

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
#define LETTER 4
#define DIGIT 5
#define ID 6
@interface TestLexer : ANTLRLexer { // line 283
// start of actions.lexer.memVars
// start of action-actionScope-memVars
}
+ (TestLexer *)newTestLexerWithCharStream:(id<ANTLRCharStream>)anInput;

- (void)mID; 
- (void)mDIGIT; 
- (void)mLETTER; 
- (void)mTokens; 

@end /* end of TestLexer interface */
