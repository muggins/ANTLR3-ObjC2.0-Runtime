// $ANTLR 3.3.1-SNAPSHOT Jan 18, 2011 15:10:00 SimpleCTP.g 2011-01-18 15:28:45

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

/* treeParserHeaderFile */

#ifndef ANTLR3TokenTypeAlreadyDefined
#define ANTLR3TokenTypeAlreadyDefined
typedef enum {
    ANTLR_EOF = -1,
    INVALID,
    EOR,
    DOWN,
    UP,
    MIN
} ANTLR3TokenType;
#endif

#pragma mark Tokens
#define EOF -1
#define VAR_DEF 4
#define ARG_DEF 5
#define FUNC_HDR 6
#define FUNC_DECL 7
#define FUNC_DEF 8
#define BLOCK 9
#define K_SEMICOLON 10
#define K_ID 11
#define K_LCURVE 12
#define K_COMMA 13
#define K_RCURVE 14
#define K_INT_TYPE 15
#define K_CHAR 16
#define K_VOID 17
#define K_LCURLY 18
#define K_RCURLY 19
#define K_FOR 20
#define K_EQ 21
#define K_EQEQ 22
#define K_LT 23
#define K_PLUS 24
#define K_INT 25
#define WS 26
#pragma mark Dynamic Global Scopes
@interface Symbols_Scope : ANTLRSymbolsScope {  /* globalAttributeScopeDecl */
ANTLRCommonTree * tree;
}
/* start of properties */

@property (retain, getter=gettree, setter=settree:) ANTLRCommonTree * tree;

/* end properties */

+ (Symbols_Scope *)newSymbols_Scope;
/* start of iterated get and set functions */

- (ANTLRCommonTree *)gettree;
- (void)settree:(ANTLRCommonTree *)aVal;

/* End of iterated get and set functions */

@end /* end of Symbols_Scope interface */

#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
/* returnScopeInterface */
@interface SimpleCTP_expr_return :ANTLRTreeRuleReturnScope { /* returnScopeInterface line 1806 */
 /* start of memVars() */
}
 /* start properties */
+ (SimpleCTP_expr_return *)newSimpleCTP_expr_return;
/* this is start of set and get methods */
  /* methodsDecl */
@end /* end of returnScopeInterface interface */

#pragma mark Rule return scopes end
@interface SimpleCTP : ANTLRTreeParser { /* line 572 */
// start of globalAttributeScopeMemVar
/* globalAttributeScopeMemVar */
//ANTLRSymbolStack *gStack;
ANTLRSymbolStack *Symbols_stack;
Symbols_Scope *Symbols_scope;

// start of action-actionScope-memVars
// start of ruleAttributeScopeMemVar


// Start of memVars

 }

// start of action-actionScope-methodsDecl


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


@end /* end of SimpleCTP interface */
