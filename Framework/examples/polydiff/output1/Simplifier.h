// $ANTLR 3.3.1-SNAPSHOT Feb 11, 2011 09:03:22 /Users/acondit/source/antlr3/acondit_localhost/code/antlr/main/runtime/ObjC/Framework/examples/polydiff/Simplifier.g 2011-02-11 09:07:52

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

#pragma mark Cyclic DFA interface start DFA1
@interface DFA1 : DFA {
}
+ newDFA1WithRecognizer:(BaseRecognizer *)theRecognizer;
- initWithRecognizer:(BaseRecognizer *)recognizer;
@end /* end of DFA1 interface  */

#pragma mark Cyclic DFA interface end DFA1

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
@interface Simplifier_poly_return :TreeRuleReturnScope { /* returnScopeInterface line 1838 */
/* ASTTreeParser returnScopeInterface.memVars */
CommonTree *tree; /* ObjC start of memVars() */
}
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) CommonTree *tree; /* start properties */
+ (Simplifier_poly_return *)newSimplifier_poly_return;
/* this is start of set and get methods */
/* ASTTreeParser returnScopeInterface.methodsDecl */
- (CommonTree *)getTree;
- (void) setTree:(CommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */
/* returnScopeInterface */
@interface Simplifier_synpred1_Simplifier_return :TreeRuleReturnScope { /* returnScopeInterface line 1838 */
/* ASTTreeParser returnScopeInterface.memVars */
CommonTree *tree; /* ObjC start of memVars() */
}
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) CommonTree *tree; /* start properties */
+ (Simplifier_synpred1_Simplifier_return *)newSimplifier_synpred1_Simplifier_return;
/* this is start of set and get methods */
/* ASTTreeParser returnScopeInterface.methodsDecl */
- (CommonTree *)getTree;
- (void) setTree:(CommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */
/* returnScopeInterface */
@interface Simplifier_synpred2_Simplifier_return :TreeRuleReturnScope { /* returnScopeInterface line 1838 */
/* ASTTreeParser returnScopeInterface.memVars */
CommonTree *tree; /* ObjC start of memVars() */
}
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) CommonTree *tree; /* start properties */
+ (Simplifier_synpred2_Simplifier_return *)newSimplifier_synpred2_Simplifier_return;
/* this is start of set and get methods */
/* ASTTreeParser returnScopeInterface.methodsDecl */
- (CommonTree *)getTree;
- (void) setTree:(CommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */
/* returnScopeInterface */
@interface Simplifier_synpred3_Simplifier_return :TreeRuleReturnScope { /* returnScopeInterface line 1838 */
/* ASTTreeParser returnScopeInterface.memVars */
CommonTree *tree; /* ObjC start of memVars() */
}
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) CommonTree *tree; /* start properties */
+ (Simplifier_synpred3_Simplifier_return *)newSimplifier_synpred3_Simplifier_return;
/* this is start of set and get methods */
/* ASTTreeParser returnScopeInterface.methodsDecl */
- (CommonTree *)getTree;
- (void) setTree:(CommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */
/* returnScopeInterface */
@interface Simplifier_synpred4_Simplifier_return :TreeRuleReturnScope { /* returnScopeInterface line 1838 */
/* ASTTreeParser returnScopeInterface.memVars */
CommonTree *tree; /* ObjC start of memVars() */
}
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) CommonTree *tree; /* start properties */
+ (Simplifier_synpred4_Simplifier_return *)newSimplifier_synpred4_Simplifier_return;
/* this is start of set and get methods */
/* ASTTreeParser returnScopeInterface.methodsDecl */
- (CommonTree *)getTree;
- (void) setTree:(CommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */

#pragma mark Rule attributes scope memVars
#pragma mark Rule attributes scope methodsDecl

/* Interface grammar class */
@interface Simplifier : TreeParser { /* line 572 */
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
id<TreeAdaptor> treeAdaptor;   /* AST parsermemVars */
/* ObjC end of memVars */

DFA1 *dfa1;
SEL synpred2_SimplifierSelector;
SEL synpred1_SimplifierSelector;
SEL synpred4_SimplifierSelector;
SEL synpred3_SimplifierSelector;
 }

+ (id) newSimplifier:(id<TTreeNodeStream>)aStream;
/* ObjC start of actions.(actionScope).methodsDecl */
/* ObjC end of actions.(actionScope).methodsDecl */

/* ObjC start of methodsDecl */
/* AST parserHeaderFile.methodsDecl */
  /* AST super.methodsDecl */
/* AST parsermethodsDecl */
- (id<TreeAdaptor>) getTreeAdaptor;
- (void) setTreeAdaptor:(id<TreeAdaptor>)theTreeAdaptor;   /* AST parsermethodsDecl */
/* ObjC end of methodsDecl */

- (Simplifier_poly_return *)poly; 
- (void)synpred1_Simplifier_fragment; 
- (void)synpred2_Simplifier_fragment; 
- (void)synpred3_Simplifier_fragment; 
- (void)synpred4_Simplifier_fragment; 


@end /* end of Simplifier interface */
