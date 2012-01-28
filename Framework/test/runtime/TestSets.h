#import "Test.h"

/**
 * Test the set stuff in lexer and parser
 */

@interface TestSets : BaseTest {
  BOOL debug;
}

- (id) init;
- (void) testSeqDoesNotBecomeSet;
- (void) testParserSet;
- (void) testParserNotSet;
- (void) testParserNotToken;
- (void) testParserNotTokenWithLabel;
- (void) testRuleAsSet;
- (void) testRuleAsSetAST;
- (void) testNotChar;
- (void) testOptionalSingleElement;
- (void) testOptionalLexerSingleElement;
- (void) testStarLexerSingleElement;
- (void) testPlusLexerSingleElement;
- (void) testOptionalSet;
- (void) testStarSet;
- (void) testPlusSet;
- (void) testLexerOptionalSet;
- (void) testLexerStarSet;
- (void) testLexerPlusSet;
- (void) testNotCharSet;
- (void) testNotCharSetWithLabel;
- (void) testNotCharSetWithRuleRef;
- (void) testNotCharSetWithRuleRef2;
- (void) testNotCharSetWithRuleRef3;
- (void) testNotCharSetWithRuleRef4;
@end
