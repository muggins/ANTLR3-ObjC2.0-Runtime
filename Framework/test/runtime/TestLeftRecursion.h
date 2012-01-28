#import "Test.h"

/**
 * 
 */

@interface TestLeftRecursion : BaseTest {
  BOOL debug;
}

- (void) init;
- (void) testSimple;
- (void) testSemPred;
- (void) testTernaryExpr;
- (void) testDeclarationsUsingASTOperators;
- (void) testDeclarationsUsingRewriteOperators;
- (void) testExpressionsUsingASTOperators;
- (void) testExpressionsUsingRewriteOperators;
- (void) testExpressionAssociativity;
- (void) testJavaExpressions;
- (void) testReturnValueAndActions;
- (void) testReturnValueAndActionsAndASTs;
- (void) runTests:(NSString *)grammar tests:(NSArray *)tests startRule:(NSString *)startRule;
@end
