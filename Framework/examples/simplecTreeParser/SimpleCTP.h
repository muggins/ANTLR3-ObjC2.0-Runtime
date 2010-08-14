// $ANTLR 3.2 Aug 13, 2010 19:41:25 /usr/local/ANTLR3-ObjC2.0-Runtime/Framework/examples/simplecTreeParser/SimpleCTP.g 2010-08-13 19:44:39

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

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
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
@interface SimpleCTP_expr_return : ANTLRTreeRuleReturnScope { // line 1672
 // start of ivars()
    ANTLRCommonTree *tree;
}

@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree;

// this is start of set and get methods
  // methodsDecl
- (ANTLRCommonTree *)getTree;
- (void)setTree:(ANTLRCommonTree *)aTree;
// this is end of set and get methods
@end

#pragma mark Rule return scopes end
@interface SimpleCTP : ANTLRTreeParser { // line 529

                                                    

 }



- (void) program; 
- (void) declaration; 
- (void) variable; 
- (void) declarator; 
- (void) functionHeader; 
- (void) formalParameter; 
- (void) type; 
- (void) block; 
- (void) stat; 
- (void) forStat; 
- (SimpleCTP_expr_return *) expr; 
- (void) atom; 


@end // end of SimpleCTP