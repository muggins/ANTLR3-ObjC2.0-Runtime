// $ANTLR 3.2 Aug 11, 2010 15:16:47 /usr/local/ANTLR3-ObjC2.0-Runtime/Framework/examples/simplecTreeParser/SimpleC.g 2010-08-11 15:38:21

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
#define LT 18
#define T__26 26
#define T__25 25
#define T__24 24
#define T__23 23
#define T__22 22
#define T__21 21
#define CHAR 15
#define FOR 13
#define FUNC_HDR 6
#define INT 12
#define FUNC_DEF 8
#define INT_TYPE 14
#define ID 10
#define EOF -1
#define FUNC_DECL 7
#define ARG_DEF 5
#define WS 20
#define BLOCK 9
#define PLUS 19
#define VOID 16
#define EQ 11
#define VAR_DEF 4
#define EQEQ 17
@interface SimpleCLexer : ANTLRLexer {
    DFA4 *dfa4;
}
- (void) mT__21; 
- (void) mT__22; 
- (void) mT__23; 
- (void) mT__24; 
- (void) mT__25; 
- (void) mT__26; 
- (void) mFOR; 
- (void) mINT_TYPE; 
- (void) mCHAR; 
- (void) mVOID; 
- (void) mID; 
- (void) mINT; 
- (void) mEQ; 
- (void) mEQEQ; 
- (void) mLT; 
- (void) mPLUS; 
- (void) mWS; 
- (void) mTokens; 
@end // end of SimpleCLexer interface