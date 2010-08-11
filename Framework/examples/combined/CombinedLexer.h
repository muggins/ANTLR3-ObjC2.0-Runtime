// $ANTLR 3.2 Aug 11, 2010 15:16:47 Combined.g 2010-08-11 15:34:21

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
#define INT 5
#define WS 6
#define ID 4
#define EOF -1
@interface CombinedLexer : ANTLRLexer {
}
- (void) mID; 
- (void) mINT; 
- (void) mWS; 
- (void) mTokens; 
@end // end of CombinedLexer interface