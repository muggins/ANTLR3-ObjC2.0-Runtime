// $ANTLR 3.2 Aug 17, 2010 17:18:07 T.g 2010-08-18 08:13:02

/* =============================================================================
 * Standard antlr3 OBJC runtime definitions
 */
#import <Cocoa/Cocoa.h>
#import "antlr3.h"
/* End of standard antlr3 runtime definitions
 * =============================================================================
 */

#pragma mark Tokens
#define WS 6
#define INT 5
#define ID 4
#define EOF -1
#define T__7 7
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
#pragma mark Rule return scopes end
@interface TParser : ANTLRParser { // line 529

                    



    /** With this true, enum is seen as a keyword.  False, it's an identifier */
    BOOL enableEnum;

 }



- (void)stat; 
- (void)identifier; 
- (void)enumAsKeyword; 
- (void)enumAsID; 


@end // end of TParser/** Demonstrates how semantic predicates get hoisted out of the rule in 
 *  which they are found and used in other decisions.  This grammar illustrates
 *  how predicates can be used to distinguish between enum as a keyword and
 *  an ID *dynamically*. :)

 * Run "java org.antlr.Tool -dfa t.g" to generate DOT (graphviz) files.  See
 * the T_dec-1.dot file to see the predicates in action.
 */