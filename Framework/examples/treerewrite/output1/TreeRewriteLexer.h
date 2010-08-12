// $ANTLR 3.2 Aug 07, 2010 22:08:38 /usr/local/ANTLR3-ObjC2.0-Runtime/Framework/examples/treerewrite/TreeRewrite.g 2010-08-11 13:48:49

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