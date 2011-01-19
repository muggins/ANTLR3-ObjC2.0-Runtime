// $ANTLR 3.3.1-SNAPSHOT Jan 18, 2011 15:10:00 SymbolTable.g 2011-01-18 15:28:42

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

/* parserHeaderFile */

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
#define T__7 7
#define T__8 8
#define T__9 9
#define T__10 10
#define T__11 11
#define T__12 12
#define T__13 13
#define T__14 14
#define ID 4
#define INT 5
#define WS 6
#pragma mark Dynamic Global Scopes
@interface Symbols_Scope : ANTLRSymbolsScope {  /* globalAttributeScopeDecl */
ANTLRPtrBuffer * names;
}
/* start of properties */

@property (retain, getter=getnames, setter=setnames:) ANTLRPtrBuffer * names;

/* end properties */

+ (Symbols_Scope *)newSymbols_Scope;
/* start of iterated get and set functions */

- (ANTLRPtrBuffer *)getnames;
- (void)setnames:(ANTLRPtrBuffer *)aVal;

/* End of iterated get and set functions */

@end /* end of Symbols_Scope interface */

#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
#pragma mark Rule return scopes end
@interface SymbolTableParser : ANTLRParser { /* line 572 */
// start of globalAttributeScopeMemVar
/* globalAttributeScopeMemVar */
//ANTLRSymbolStack *gStack;
ANTLRSymbolStack *Symbols_stack;
Symbols_Scope *Symbols_scope;

// start of action-actionScope-memVars

int level;

// start of ruleAttributeScopeMemVar


// Start of memVars

 }

// start of action-actionScope-methodsDecl


- (void)prog; 
- (void)globals; 
- (void)method; 
- (void)block; 
- (void)stat; 
- (void)decl; 


@end /* end of SymbolTableParser interface */
