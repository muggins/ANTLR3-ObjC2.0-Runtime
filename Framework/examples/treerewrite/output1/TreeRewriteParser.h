// $ANTLR 3.2 Aug 20, 2010 15:00:19 /usr/local/ANTLR3-ObjC2.0-Runtime/Framework/examples/treerewrite/TreeRewrite.g 2010-08-20 15:03:14

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

#pragma mark Tokens
#define WS 5
#define INT 4
#define EOF -1
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
@interface TreeRewriteParser_rule_return :ParserRuleReturnScope { // line 1672
// returnScopeInterface.memVars
CommonTree *tree; // start of memVars()
}

// start properties
@property (retain, getter=getTree, setter=setTree:) CommonTree *tree;
+ (TreeRewriteParser_rule_return *)newTreeRewriteParser_rule_return;
// this is start of set and get methods
// returnScopeInterface.methodsdecl
- (CommonTree *)getTree;
- (void) setTree:(CommonTree *)aTree;
  // methodsDecl
@end 
@interface TreeRewriteParser_subrule_return :ParserRuleReturnScope { // line 1672
// returnScopeInterface.memVars
CommonTree *tree; // start of memVars()
}

// start properties
@property (retain, getter=getTree, setter=setTree:) CommonTree *tree;
+ (TreeRewriteParser_subrule_return *)newTreeRewriteParser_subrule_return;
// this is start of set and get methods
// returnScopeInterface.methodsdecl
- (CommonTree *)getTree;
- (void) setTree:(CommonTree *)aTree;
  // methodsDecl
@end 

#pragma mark Rule return scopes end
@interface TreeRewriteParser : Parser { // line 529
// start of globalAttributeScopeMemVar


// start of action-actionScope-memVars
// start of ruleAttributeScopeMemVar


// Start of memVars
// parserHeaderFile.memVars
// parsermemVars
id<TreeAdaptor> treeAdaptor;

 }

// start of action-actionScope-methodsDecl

// parserHeaderFile.methodsdecl
// parserMethodsDecl
- (id<TreeAdaptor>) getTreeAdaptor;
- (void) setTreeAdaptor:(id<TreeAdaptor>)theTreeAdaptor;

- (TreeRewriteParser_rule_return *)mrule; 
- (TreeRewriteParser_subrule_return *)msubrule; 


@end /* end of TreeRewriteParser interface */
