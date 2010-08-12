// $ANTLR 3.2 Aug 11, 2010 15:04:17 /usr/local/ANTLR3-ObjC2.0-Runtime/Framework/examples/scopes/SymbolTable.g 2010-08-11 15:10:39

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
@interface Symbols_Scope : ANTLRSymbolStack {
    NSMutableArray *names;
}
// use KVC to access attributes!
@end
#pragma mark Dynamic Rule Scopes
#pragma mark Rule Return Scopes start
#pragma mark Rule return scopes end
@interface SymbolTableParser : ANTLRParser {

    Symbols_Scope *Symbols_Stack;
                            


    int level;

 }



- (void) prog; 
- (void) globals; 
- (void) method; 
- (void) block; 
- (void) stat; 
- (void) decl; 


@end // end of SymbolTableParser