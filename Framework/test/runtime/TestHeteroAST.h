#import "Test.h"

/**
 * Test hetero trees in parsers and tree parsers
 */

@interface TestHeteroAST : BaseTest {
  BOOL debug;
}

- (void) init;
- (void) testToken;
- (void) testTokenCommonTree;
- (void) testTokenWithQualifiedType;
- (void) testNamedType;
- (void) testTokenWithLabel;
- (void) testTokenWithListLabel;
- (void) testTokenRoot;
- (void) testTokenRootWithListLabel;
- (void) testString;
- (void) testStringRoot;
- (void) testRewriteToken;
- (void) testRewriteTokenWithArgs;
- (void) testRewriteTokenRoot;
- (void) testRewriteString;
- (void) testRewriteStringRoot;
- (void) testRewriteRuleResults;
- (void) testCopySemanticsWithHetero;
- (void) testTreeParserRewriteFlatList;
- (void) testTreeParserRewriteTree;
- (void) testTreeParserRewriteImaginary;
- (void) testTreeParserRewriteImaginaryWithArgs;
- (void) testTreeParserRewriteImaginaryRoot;
- (void) testTreeParserRewriteImaginaryFromReal;
- (void) testTreeParserAutoHeteroAST;
@end
