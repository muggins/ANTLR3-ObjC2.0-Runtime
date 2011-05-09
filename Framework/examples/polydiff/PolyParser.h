// $ANTLR ${project.version} ${buildNumber} Poly.g 2011-05-06 19:17:59

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
#define ID 4
#define INT 5
#define MULT 6
#define WS 7
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
/* returnScopeInterface PolyParser_poly_return */
@interface PolyParser_poly_return :ANTLRParserRuleReturnScope { /* returnScopeInterface line 1838 */
/* AST returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* ObjC start of memVars() */
}
/* start properties */
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree;
+ (PolyParser_poly_return *)newPolyParser_poly_return;
/* this is start of set and get methods */
/* AST returnScopeInterface.methodsDecl */
- (ANTLRCommonTree *)getTree;

- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */



/* returnScopeInterface PolyParser_term_return */
@interface PolyParser_term_return :ANTLRParserRuleReturnScope { /* returnScopeInterface line 1838 */
/* AST returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* ObjC start of memVars() */
}
/* start properties */
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree;
+ (PolyParser_term_return *)newPolyParser_term_return;
/* this is start of set and get methods */
/* AST returnScopeInterface.methodsDecl */
- (ANTLRCommonTree *)getTree;

- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */



/* returnScopeInterface PolyParser_exp_return */
@interface PolyParser_exp_return :ANTLRParserRuleReturnScope { /* returnScopeInterface line 1838 */
/* AST returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* ObjC start of memVars() */
}
/* start properties */
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree;
+ (PolyParser_exp_return *)newPolyParser_exp_return;
/* this is start of set and get methods */
/* AST returnScopeInterface.methodsDecl */
- (ANTLRCommonTree *)getTree;

- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */




/* Interface grammar class */
@interface PolyParser : ANTLRParser { /* line 572 */
/* ObjC start of ruleAttributeScopeMemVar */


/* ObjC end of ruleAttributeScopeMemVar */
/* ObjC start of globalAttributeScopeMemVar */


/* ObjC end of globalAttributeScopeMemVar */
/* ObjC start of actions.(actionScope).memVars */
/* ObjC end of actions.(actionScope).memVars */
/* ObjC start of memVars */
/* AST parserHeaderFile.memVars */
NSInteger ruleLevel;
NSArray *ruleNames;
  /* AST super.memVars */
/* AST parserMemVars */
id<ANTLRTreeAdaptor> treeAdaptor;   /* AST parserMemVars */
/* ObjC end of memVars */

 }

/* ObjC start of actions.(actionScope).properties */
/* ObjC end of actions.(actionScope).properties */
/* ObjC start of properties */
/* AST parserHeaderFile.properties */
  /* AST super.properties */
/* AST parserProperties */
@property (retain, getter=getTreeAdaptor, setter=setTreeAdaptor:) id<ANTLRTreeAdaptor> treeAdaptor;   /* AST parserproperties */
/* ObjC end of properties */

+ (void) initialize;
+ (id) newPolyParser:(id<ANTLRTokenStream>)aStream;
/* ObjC start of actions.(actionScope).methodsDecl */
/* ObjC end of actions.(actionScope).methodsDecl */

/* ObjC start of methodsDecl */
/* AST parserHeaderFile.methodsDecl */
  /* AST super.methodsDecl */
/* AST parserMethodsDecl */
- (id<ANTLRTreeAdaptor>) getTreeAdaptor;
- (void) setTreeAdaptor:(id<ANTLRTreeAdaptor>)theTreeAdaptor;   /* AST parsermethodsDecl */
/* ObjC end of methodsDecl */

- (PolyParser_poly_return *)poly; 
- (PolyParser_term_return *)term; 
- (PolyParser_exp_return *)exp; 


@end /* end of PolyParser interface */

