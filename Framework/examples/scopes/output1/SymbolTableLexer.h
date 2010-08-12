// $ANTLR 3.2 Aug 11, 2010 15:04:17 /usr/local/ANTLR3-ObjC2.0-Runtime/Framework/examples/scopes/SymbolTable.g 2010-08-11 15:10:39

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

#pragma mark Cyclic DFA interface start DFA4
@interface DFA4 : ANTLRDFA {} @end

#pragma mark Cyclic DFA interface end DFA4

#pragma mark Rule return scopes start
#pragma mark Rule return scopes end
#pragma mark Tokens
#define WS 6
#define T__12 12
#define T__11 11
#define T__14 14
#define T__13 13
#define T__10 10
#define INT 5
#define ID 4
#define EOF -1
#define T__9 9
#define T__8 8
#define T__7 7
@interface SymbolTableLexer : ANTLRLexer {
    DFA4 *dfa4;
}
- (void) mT__7; 
- (void) mT__8; 
- (void) mT__9; 
- (void) mT__10; 
- (void) mT__11; 
- (void) mT__12; 
- (void) mT__13; 
- (void) mT__14; 
- (void) mID; 
- (void) mINT; 
- (void) mWS; 
- (void) mTokens; 
@end // end of SymbolTableLexer interface