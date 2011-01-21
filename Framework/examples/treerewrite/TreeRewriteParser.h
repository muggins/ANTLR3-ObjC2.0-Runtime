// $ANTLR 3.3.1-SNAPSHOT Jan 18, 2011 15:10:00 TreeRewrite.g 2011-01-19 07:53:03

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
#define INT 4
#define WS 5
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
/* returnScopeInterface */
@interface TreeRewriteParser_rule_return :ANTLRParserRuleReturnScope { /* returnScopeInterface line 1806 */
/* AST returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* start of memVars() */
}
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree; /* start properties */
+ (TreeRewriteParser_rule_return *)newTreeRewriteParser_rule_return;
/* this is start of set and get methods */
/* AST returnScopeInterface.methodsdecl */
- (ANTLRCommonTree *)getTree;
- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */
/* returnScopeInterface */
@interface TreeRewriteParser_subrule_return :ANTLRParserRuleReturnScope { /* returnScopeInterface line 1806 */
/* AST returnScopeInterface.memVars */
ANTLRCommonTree *tree; /* start of memVars() */
}
/* AST returnScopeInterface.properties */
@property (retain, getter=getTree, setter=setTree:) ANTLRCommonTree *tree; /* start properties */
+ (TreeRewriteParser_subrule_return *)newTreeRewriteParser_subrule_return;
/* this is start of set and get methods */
/* AST returnScopeInterface.methodsdecl */
- (ANTLRCommonTree *)getTree;
- (void) setTree:(ANTLRCommonTree *)aTree;
  /* methodsDecl */
@end /* end of returnScopeInterface interface */

#pragma mark Rule return scopes end
@interface TreeRewriteParser : ANTLRParser { /* line 572 */
// start of globalAttributeScopeMemVar


// start of action-actionScope-memVars
// start of ruleAttributeScopeMemVar


// Start of memVars
/* AST parserHeaderFile.memVars */
/* AST parsermemVars */
id<ANTLRTreeAdaptor> treeAdaptor;

 }

// start of action-actionScope-methodsDecl

/* AST parserHeaderFile.methodsdecl */
/* AST parserMethodsDecl */
- (id<ANTLRTreeAdaptor>) getTreeAdaptor;
- (void) setTreeAdaptor:(id<ANTLRTreeAdaptor>)theTreeAdaptor;

- (TreeRewriteParser_rule_return *)rule; 
- (TreeRewriteParser_subrule_return *)subrule; 


@end /* end of TreeRewriteParser interface */
