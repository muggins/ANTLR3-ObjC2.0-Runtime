// $ANTLR 3.3.1-SNAPSHOT Jan 20, 2011 10:02:28 Combined.g 2011-01-20 10:06:11

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
#define ID 4
#define INT 5
#define WS 6
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
#pragma mark Rule return scopes end
@interface CombinedParser : ANTLRParser { /* line 572 */
// start of globalAttributeScopeMemVar


// start of action-actionScope-memVars
// start of ruleAttributeScopeMemVar


// Start of memVars

 }

// start of action-actionScope-methodsDecl
+ (id) newCombinedParser:(id<ANTLRTreeNodeStream>)aStream;



- (void)stat; 
- (void)identifier; 


@end /* end of CombinedParser interface */
