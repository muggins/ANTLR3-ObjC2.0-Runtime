#import "DFA.h"
#import "NFA.h"
#import "ANTLRStringStream.h"
#import "Grammar.h"
#import "Test.h"

@interface TestDFAMatching : BaseTest {
}

- (id) init;
- (void) testSimpleAltCharTest;
- (void) testSets;
- (void) testFiniteCommonLeftPrefixes;
- (void) testSimpleLoops;
- (void) checkPrediction:(DFA *)dfa input:(NSString *)input expected:(int)expected;
@end
