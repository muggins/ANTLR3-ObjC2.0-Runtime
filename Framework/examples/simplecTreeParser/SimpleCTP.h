// $ANTLR 3.2 Aug 11, 2010 15:16:47 SimpleCTP.g 2010-08-11 17:06:37

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
@interface SimpleCTP_expr_return : ANTLRTreeRuleReturnScope {
    // start of ivars()
    // end of ivars()
 

}

@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree;

// this is start of methodsDecl()
// this is end of methodsDecl()
@end

#pragma mark Rule return scopes end
@interface SimpleCTP : ANTLRTreeParser {

                                                    

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