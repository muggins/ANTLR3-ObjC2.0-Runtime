#import "ANTLRStringStream.h"
#import "CharStream.h"
#import "ParseTree.h"
#import "Grammar.h"
#import "Interpreter.h"
#import "Test.h"

@interface TestInterpretedParsing : BaseTest {
}

- (id) init;
- (void) testSimpleParse;
- (void) testMismatchedTokenError;
- (void) testMismatchedSetError;
- (void) testNoViableAltError;
@end
