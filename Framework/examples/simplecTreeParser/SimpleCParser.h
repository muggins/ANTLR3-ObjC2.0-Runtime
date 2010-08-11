// $ANTLR 3.2 Aug 11, 2010 15:16:47 /usr/local/ANTLR3-ObjC2.0-Runtime/Framework/examples/simplecTreeParser/SimpleC.g 2010-08-11 15:38:20

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

#pragma mark Cyclic DFA interface start DFA2
@interface DFA2 : ANTLRDFA {} @end

#pragma mark Cyclic DFA interface end DFA2
#pragma mark Tokens
#define LT 18
#define T__26 26
#define T__25 25
#define T__24 24
#define T__23 23
#define T__22 22
#define T__21 21
#define CHAR 15
#define FOR 13
#define FUNC_HDR 6
#define INT 12
#define FUNC_DEF 8
#define INT_TYPE 14
#define ID 10
#define EOF -1
#define FUNC_DECL 7
#define ARG_DEF 5
#define WS 20
#define BLOCK 9
#define PLUS 19
#define VOID 16
#define EQ 11
#define VAR_DEF 4
#define EQEQ 17
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
@interface SimpleCParser_program_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_declaration_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_variable_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_declarator_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_functionHeader_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_formalParameter_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_type_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_block_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_stat_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_forStat_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_assignStat_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_expr_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_condExpr_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_aexpr_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser_atom_return : ANTLRParserRuleReturnScope {
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
@interface SimpleCParser : ANTLRParser {

    DFA2 *dfa2;
                                                                
    id<ANTLRTreeAdaptor> treeAdaptor;

 }


- (id<ANTLRTreeAdaptor>) getTreeAdaptor;
- (void) setTreeAdaptor:(id<ANTLRTreeAdaptor>)theTreeAdaptor;

- (SimpleCParser_program_return *) program; 
- (SimpleCParser_declaration_return *) declaration; 
- (SimpleCParser_variable_return *) variable; 
- (SimpleCParser_declarator_return *) declarator; 
- (SimpleCParser_functionHeader_return *) functionHeader; 
- (SimpleCParser_formalParameter_return *) formalParameter; 
- (SimpleCParser_type_return *) type; 
- (SimpleCParser_block_return *) block; 
- (SimpleCParser_stat_return *) stat; 
- (SimpleCParser_forStat_return *) forStat; 
- (SimpleCParser_assignStat_return *) assignStat; 
- (SimpleCParser_expr_return *) expr; 
- (SimpleCParser_condExpr_return *) condExpr; 
- (SimpleCParser_aexpr_return *) aexpr; 
- (SimpleCParser_atom_return *) atom; 


@end // end of SimpleCParser