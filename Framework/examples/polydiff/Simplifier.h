// $ANTLR ${project.version} ${buildNumber} Simplifier.g 2011-05-06 19:19:02

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLR.h>
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
#define ID 4
#define INT 5
#define MULT 6
#define WS 7
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
/* returnScopeInterface Simplifier_poly_return */
@interface Simplifier_poly_return :ANTLRTreeRuleReturnScope { /* returnScopeInterface line 1838 */
/* ASTTreeParser returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* ObjC start of memVars() */
}
/* start properties */
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree;
+ (Simplifier_poly_return *)newSimplifier_poly_return;
/* this is start of set and get methods */
/* ASTTreeParser returnScopeInterface.methodsDecl */
- (ANTLRCommonTree *)getTree;
- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */



/* returnScopeInterface Simplifier_synpred1_Simplifier_return */
@interface Simplifier_synpred1_Simplifier_return :ANTLRTreeRuleReturnScope { /* returnScopeInterface line 1838 */
/* ASTTreeParser returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* ObjC start of memVars() */
}
/* start properties */
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree;
+ (Simplifier_synpred1_Simplifier_return *)newSimplifier_synpred1_Simplifier_return;
/* this is start of set and get methods */
/* ASTTreeParser returnScopeInterface.methodsDecl */
- (ANTLRCommonTree *)getTree;
- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */



/* returnScopeInterface Simplifier_synpred2_Simplifier_return */
@interface Simplifier_synpred2_Simplifier_return :ANTLRTreeRuleReturnScope { /* returnScopeInterface line 1838 */
/* ASTTreeParser returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* ObjC start of memVars() */
}
/* start properties */
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree;
+ (Simplifier_synpred2_Simplifier_return *)newSimplifier_synpred2_Simplifier_return;
/* this is start of set and get methods */
/* ASTTreeParser returnScopeInterface.methodsDecl */
- (ANTLRCommonTree *)getTree;
- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */



/* returnScopeInterface Simplifier_synpred3_Simplifier_return */
@interface Simplifier_synpred3_Simplifier_return :ANTLRTreeRuleReturnScope { /* returnScopeInterface line 1838 */
/* ASTTreeParser returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* ObjC start of memVars() */
}
/* start properties */
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree;
+ (Simplifier_synpred3_Simplifier_return *)newSimplifier_synpred3_Simplifier_return;
/* this is start of set and get methods */
/* ASTTreeParser returnScopeInterface.methodsDecl */
- (ANTLRCommonTree *)getTree;
- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */



/* returnScopeInterface Simplifier_synpred4_Simplifier_return */
@interface Simplifier_synpred4_Simplifier_return :ANTLRTreeRuleReturnScope { /* returnScopeInterface line 1838 */
/* ASTTreeParser returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* ObjC start of memVars() */
}
/* start properties */
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree;
+ (Simplifier_synpred4_Simplifier_return *)newSimplifier_synpred4_Simplifier_return;
/* this is start of set and get methods */
/* ASTTreeParser returnScopeInterface.methodsDecl */
- (ANTLRCommonTree *)getTree;
- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */




/* Interface grammar class */
@interface Simplifier : ANTLRTreeParser { /* line 572 */
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

SEL synpred2_SimplifierSelector;
SEL synpred1_SimplifierSelector;
SEL synpred4_SimplifierSelector;
SEL synpred3_SimplifierSelector;
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
+ (id) newSimplifier:(id<ANTLRTreeNodeStream>)aStream;
/* ObjC start of actions.(actionScope).methodsDecl */
/* ObjC end of actions.(actionScope).methodsDecl */

/* ObjC start of methodsDecl */
/* AST parserHeaderFile.methodsDecl */
  /* AST super.methodsDecl */
/* AST parserMethodsDecl */
- (id<ANTLRTreeAdaptor>) getTreeAdaptor;
- (void) setTreeAdaptor:(id<ANTLRTreeAdaptor>)theTreeAdaptor;   /* AST parsermethodsDecl */
/* ObjC end of methodsDecl */

- (Simplifier_poly_return *)poly; 
- (void)synpred1_Simplifier_fragment; 
- (void)synpred2_Simplifier_fragment; 
- (void)synpred3_Simplifier_fragment; 
- (void)synpred4_Simplifier_fragment; 


@end /* end of Simplifier interface */

