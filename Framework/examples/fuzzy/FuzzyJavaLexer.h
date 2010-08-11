// $ANTLR 3.2 Aug 11, 2010 15:16:47 /usr/local/ANTLR3-ObjC2.0-Runtime/Framework/examples/fuzzy/FuzzyJava.g 2010-08-11 15:18:36

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

#pragma mark Cyclic DFA interface start DFA38
@interface DFA38 : ANTLRDFA {} @end

#pragma mark Cyclic DFA interface end DFA38

#pragma mark Rule return scopes start
#pragma mark Rule return scopes end
#pragma mark Tokens
#define STAT 15
#define CLASS 10
#define ESC 19
#define CHAR 21
#define ID 8
#define EOF -1
#define QID 9
#define TYPE 11
#define IMPORT 6
#define WS 4
#define ARG 12
#define QIDStar 5
#define SL_COMMENT 18
#define RETURN 7
#define FIELD 14
#define CALL 16
#define COMMENT 17
#define METHOD 13
#define STRING 20
@interface FuzzyJava : ANTLRLexer {
    DFA38 *dfa38;
    SEL synpred5_FuzzyJavaSelector;
    SEL synpred8_FuzzyJavaSelector;
    SEL synpred9_FuzzyJavaSelector;
    SEL synpred2_FuzzyJavaSelector;
    SEL synpred1_FuzzyJavaSelector;
    SEL synpred3_FuzzyJavaSelector;
    SEL synpred7_FuzzyJavaSelector;
    SEL synpred6_FuzzyJavaSelector;
    SEL synpred4_FuzzyJavaSelector;
}
- (void) mIMPORT; 
- (void) mRETURN; 
- (void) mCLASS; 
- (void) mMETHOD; 
- (void) mFIELD; 
- (void) mSTAT; 
- (void) mCALL; 
- (void) mCOMMENT; 
- (void) mSL_COMMENT; 
- (void) mSTRING; 
- (void) mCHAR; 
- (void) mWS; 
- (void) mQID; 
- (void) mQIDStar; 
- (void) mTYPE; 
- (void) mARG; 
- (void) mID; 
- (void) mESC; 
- (void) mTokens; 
- (BOOL) synpred1_FuzzyJava; 
- (BOOL) synpred2_FuzzyJava; 
- (BOOL) synpred3_FuzzyJava; 
- (BOOL) synpred4_FuzzyJava; 
- (BOOL) synpred5_FuzzyJava; 
- (BOOL) synpred6_FuzzyJava; 
- (BOOL) synpred7_FuzzyJava; 
- (BOOL) synpred8_FuzzyJava; 
- (BOOL) synpred9_FuzzyJava; 
@end // end of FuzzyJava interface