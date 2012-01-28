#import "Test.h"
#import "Assert.h"

@interface TestTreeIterator : NSObject {
}

- (void) testNode;
- (void) testFlatAB;
- (void) testAB;
- (void) testABC;
- (void) testVerticalList;
- (void) testComplex;
- (void) testReset;
+ (StringBuffer *) description:(TreeIterator *)it;
@end
