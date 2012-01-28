#import "Test.h"

/**
 * General code generation testing; compilation and/or execution.
 * These tests are more about avoiding duplicate var definitions
 * etc... than testing a particular ANTLR feature.
 */

@interface TestJavaCodeGeneration : BaseTest {
}

- (void) testDupVarDefForPinchedState;
- (void) testLabeledNotSetsInLexer;
- (void) testLabeledSetsInLexer;
- (void) testLabeledRangeInLexer;
- (void) testLabeledWildcardInLexer;
- (void) testSynpredWithPlusLoop;
- (void) testDoubleQuoteEscape;
@end
