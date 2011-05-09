// $ANTLR 3.3.1-SNAPSHOT Feb 11, 2011 09:03:22 /Users/acondit/source/antlr3/acondit_localhost/code/antlr/main/runtime/ObjC/Framework/examples/polydiff/Poly.g 2011-02-11 09:08:07

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLR.h>
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
@interface PolyParser_poly_return :ANTLRParserRuleReturnScope { /* returnScopeInterface line 1838 */
/* AST returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* ObjC start of memVars() */
}
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree; /* start properties */
+ (PolyParser_poly_return *)newPolyParser_poly_return;
/* this is start of set and get methods */
/* AST returnScopeInterface.methodsDecl */
- (ANTLRCommonTree *)getTree;
- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */
/* returnScopeInterface */
@interface PolyParser_term_return :ANTLRParserRuleReturnScope { /* returnScopeInterface line 1838 */
/* AST returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* ObjC start of memVars() */
}
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree; /* start properties */
+ (PolyParser_term_return *)newPolyParser_term_return;
/* this is start of set and get methods */
/* AST returnScopeInterface.methodsDecl */
- (ANTLRCommonTree *)getTree;
- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */
/* returnScopeInterface */
@interface PolyParser_exp_return :ANTLRParserRuleReturnScope { /* returnScopeInterface line 1838 */
/* AST returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* ObjC start of memVars() */
}
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree; /* start properties */
+ (PolyParser_exp_return *)newPolyParser_exp_return;
/* this is start of set and get methods */
/* AST returnScopeInterface.methodsDecl */
- (ANTLRCommonTree *)getTree;
- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */

#pragma mark Rule attributes scope memVars
#pragma mark Rule attributes scope methodsDecl

/* Interface grammar class */
@interface PolyParser : ANTLRParser { /* line 572 */
/* ObjC start of globalAttributeScopeMemVar */


/* ObjC start of actions.(actionScope).memVars */
/* ObjC end of actions.(actionScope).memVars */
/* ObjC start of ruleAttributeScopeMemVar */


/* ObjC start of memVars */
/* AST parserHeaderFile.memVars */
NSInteger ruleLevel;
NSArray *ruleNames;
  /* AST super.memVars */
/* AST parsermemVars */
id<ANTLRTreeAdaptor> treeAdaptor;   /* AST parsermemVars */
/* ObjC end of memVars */

 }

+ (id) newPolyParser:(id<ANTLRTokenStream>)aStream;
/* ObjC start of actions.(actionScope).methodsDecl */
/* ObjC end of actions.(actionScope).methodsDecl */

/* ObjC start of methodsDecl */
/* AST parserHeaderFile.methodsDecl */
  /* AST super.methodsDecl */
/* AST parsermethodsDecl */
- (id<ANTLRTreeAdaptor>) getTreeAdaptor;
- (void) setTreeAdaptor:(id<ANTLRTreeAdaptor>)theTreeAdaptor;   /* AST parsermethodsDecl */
/* ObjC end of methodsDecl */

- (PolyParser_poly_return *)poly; 
- (PolyParser_term_return *)term; 
- (PolyParser_exp_return *)exp; 


@end /* end of PolyParser interface */
