// $ANTLR 3.2 Aug 17, 2010 17:18:07 T.g 2010-08-18 08:13:02

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
#define WS 6
#define INT 5
#define ID 4
#define EOF -1
#define T__7 7
@interface TLexer : ANTLRLexer { // line 283
}
+ (TLexer *)newTLexer:(id<ANTLRCharStream>)anInput;

- (void) mT__7; 
- (void) mID; 
- (void) mINT; 
- (void) mWS; 
- (void) mTokens; 
@end // end of TLexer interface