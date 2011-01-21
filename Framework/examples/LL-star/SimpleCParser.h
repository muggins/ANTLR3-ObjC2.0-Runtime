// $ANTLR 3.3.1-SNAPSHOT Jan 20, 2011 10:02:28 SimpleC.g 2011-01-20 10:06:12

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

#pragma mark Cyclic DFA interface start DFA2
@interface DFA2 : ANTLRDFA {
}
+ newDFA2WithRecognizer:(ANTLRBaseRecognizer *)theRecognizer;
- initWithRecognizer:(ANTLRBaseRecognizer *)recognizer;
@end /* end of DFA2 interface  */

#pragma mark Cyclic DFA interface end DFA2

#pragma mark Tokens
#define EOF -1
#define T__7 7
#define T__8 8
#define T__9 9
#define T__10 10
#define T__11 11
#define T__12 12
#define T__13 13
#define T__14 14
#define T__15 15
#define T__16 16
#define T__17 17
#define T__18 18
#define T__19 19
#define T__20 20
#define ID 4
#define INT 5
#define WS 6
#pragma mark Dynamic Global Scopes
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
#pragma mark Rule return scopes end
@interface SimpleCParser : ANTLRParser { /* line 572 */
// start of globalAttributeScopeMemVar


// start of action-actionScope-memVars
// start of ruleAttributeScopeMemVar


// Start of memVars

DFA2 *dfa2;
 }

// start of action-actionScope-methodsDecl
+ (id) newSimpleCParser:(id<ANTLRTreeNodeStream>)aStream;



- (void)program; 
- (void)declaration; 
- (void)variable; 
- (void)declarator; 
- (NSString *)functionHeader; 
- (void)formalParameter; 
- (void)type; 
- (void)block; 
- (void)stat; 
- (void)forStat; 
- (void)assignStat; 
- (void)expr; 
- (void)condExpr; 
- (void)aexpr; 
- (void)atom; 


@end /* end of SimpleCParser interface */
