// $ANTLR 3.3.1-SNAPSHOT Jan 20, 2011 10:02:28 T.g 2011-01-20 10:06:14

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
#define ID 4
#define INT 5
#define WS 6
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
#pragma mark Rule return scopes end
@interface TParser : ANTLRParser { /* line 572 */
// start of globalAttributeScopeMemVar


// start of action-actionScope-memVars

/* With this true, enum is seen as a keyword.  False, it's an identifier */
BOOL enableEnum;

// start of ruleAttributeScopeMemVar


// Start of memVars

 }

// start of action-actionScope-methodsDecl
+ (id) newTParser:(id<ANTLRTreeNodeStream>)aStream;



- (void)stat; 
- (void)identifier; 
- (void)enumAsKeyword; 
- (void)enumAsID; 


@end /* end of TParser interface */
/** Demonstrates how semantic predicates get hoisted out of the rule in 
 *  which they are found and used in other decisions.  This grammar illustrates
 *  how predicates can be used to distinguish between enum as a keyword and
 *  an ID *dynamically*. :)

 * Run "java org.antlr.Tool -dfa t.g" to generate DOT (graphviz) files.  See
 * the T_dec-1.dot file to see the predicates in action.
 */