// $ANTLR 3.2 Aug 11, 2010 15:04:17 TreeRewrite.g 2010-08-11 15:08:03

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */


#pragma mark Rule return scopes start
#pragma mark Rule return scopes end
#pragma mark Tokens
#define INT 4
#define WS 5
#define EOF -1
@interface TreeRewriteLexer : ANTLRLexer {
}
- (void) mINT; 
- (void) mWS; 
- (void) mTokens; 
@end // end of TreeRewriteLexer interface