// $ANTLR 3.2 Aug 17, 2010 17:18:07 /usr/local/ANTLR3-ObjC2.0-Runtime/Framework/examples/simplecTreeParser/SimpleCTP.g 2010-08-17 17:19:24

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

#pragma mark Tokens
#define K_ID 10
#define T__26 26
#define T__25 25
#define T__24 24
#define T__23 23
#define K_EQEQ 16
#define T__22 22
#define K_INT 11
#define T__21 21
#define K_FOR 14
#define FUNC_HDR 6
#define FUNC_DEF 8
#define EOF -1
#define K_INT_TYPE 19
#define FUNC_DECL 7
#define ARG_DEF 5
#define WS 20
#define K_EQ 15
#define BLOCK 9
#define K_LT 17
#define K_CHAR 12
#define K_VOID 13
#define VAR_DEF 4
#define K_PLUS 18
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
@interface SimpleCTP_expr_return :ANTLRTreeRuleReturnScope { // line 1672
 // start of ivars()
}

// start properties
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree;
+ (SimpleCTP_expr_return *)newSimpleCTP_expr_return;
// this is start of set and get methods
  // methodsDecl
@end

#pragma mark Rule return scopes end
@interface SimpleCTP : ANTLRTreeParser { // line 529

                                                    


 }



- (void)program; 
- (void)declaration; 
- (void)variable; 
- (void)declarator; 
- (void)functionHeader; 
- (void)formalParameter; 
- (void)type; 
- (void)block; 
- (void)stat; 
- (void)forStat; 
- (SimpleCTP_expr_return *)expr; 
- (void)atom; 


@end // end of SimpleCTP