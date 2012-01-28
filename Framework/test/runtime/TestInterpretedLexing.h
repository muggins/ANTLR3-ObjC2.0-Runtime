#import "ANTLRStringStream.h"
#import "CharStream.h"
#import "CommonTokenStream.h"
#import "Token.h"
#import "Grammar.h"
#import "Interpreter.h"
#import "Test.h"

@interface TestInterpretedLexing : BaseTest {
}

- (id) init;
- (void) testSimpleAltCharTest;
- (void) testSingleRuleRef;
- (void) testSimpleLoop;
- (void) testMultAltLoop;
- (void) testSimpleLoops;
- (void) testTokensRules;
@end
