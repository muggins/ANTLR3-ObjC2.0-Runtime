// $ANTLR 3.3.1-SNAPSHOT Jan 30, 2011 08:28:24 PolyPrinter.g 2011-01-30 08:45:32

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
#ifdef EOF
#undef EOF
#endif
#define EOF -1
#define T__8 8
#define T__9 9
#define MULT 4
#define INT 5
#define ID 6
#define WS 7
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
/* returnScopeInterface */
@interface PolyPrinter_poly_return :ANTLRTreeRuleReturnScope { /* returnScopeInterface line 1838 */
ST *st; /* start of memVars() */
}
 /* start properties */
+ (PolyPrinter_poly_return *)newPolyPrinter_poly_return;
/* this is start of set and get methods */
/* AST returnScopeInterface.methodsdecl */
- (id) getTemplate;  /* methodsDecl */
@end /* end of returnScopeInterface interface */

#pragma mark Rule return scopes end
@interface PolyPrinter : ANTLRTreeParser { /* line 572 */
// start of globalAttributeScopeMemVar


// start of action-actionScope-memVars
// start of ruleAttributeScopeMemVar


// Start of memVars

 }

// start of action-actionScope-methodsDecl
+ (id) newPolyPrinter:(id<ANTLRTreeNodeStream>)aStream;



- (PolyPrinter_poly_return *)poly; 


@end /* end of PolyPrinter interface */
