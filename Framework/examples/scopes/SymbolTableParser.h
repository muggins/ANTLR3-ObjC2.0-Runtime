// $ANTLR 3.2 Aug 17, 2010 17:18:07 SymbolTable.g 2010-08-18 08:13:03

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
#define T__12 12
#define T__11 11
#define T__14 14
#define T__13 13
#define T__10 10
#define INT 5
#define ID 4
#define EOF -1
#define T__9 9
#define T__8 8
#define T__7 7
#pragma mark Dynamic Global Scopes
@interface Symbols_Scope : ANTLRSymbolsScope {
NSMutableArray *names;
}
+ (Symbols_Scope *)newSymbols_Scope;
@end
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
#pragma mark Rule return scopes end
@interface SymbolTableParser : ANTLRParser { // line 529

    Symbols_Scope *Symbols_scope;
                            



    int level;

 }



- (void)prog; 
- (void)globals; 
- (void)method; 
- (void)block; 
- (void)stat; 
- (void)decl; 


@end // end of SymbolTableParser