// $ANTLR 3.2 Aug 07, 2010 22:08:38 /usr/local/ANTLR3-ObjC2.0-Runtime/Framework/examples/treerewrite/TreeRewrite.g 2010-08-11 13:48:49

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
@interface TreeRewriteParser_rule_return : ANTLRParserRuleReturnScope {
    // start of ivars()
    id *tree;
    // end of ivars()
 

}

@property (retain, getter=getTree, setter=setTree:) id *tree;

// this is start of methodsDecl()
- (id *) getTree;
- (void) setTree:(id *)aTree;

// this is end of methodsDecl()
@end
@interface TreeRewriteParser_subrule_return : ANTLRParserRuleReturnScope {
    // start of ivars()
    id *tree;
    // end of ivars()
 

}

@property (retain, getter=getTree, setter=setTree:) id *tree;

// this is start of methodsDecl()
- (id *) getTree;
- (void) setTree:(id *)aTree;

// this is end of methodsDecl()
@end

#pragma mark Rule return scopes end
@interface TreeRewriteParser : ANTLRParser {

            
    id<ANTLRTreeAdaptor> treeAdaptor;

 }


- (id<ANTLRTreeAdaptor>) getTreeAdaptor;
- (void) setTreeAdaptor:(id<ANTLRTreeAdaptor>)theTreeAdaptor;

- (TreeRewriteParser_rule_return *) rule; 
- (TreeRewriteParser_subrule_return *) subrule; 


@end // end of TreeRewriteParser