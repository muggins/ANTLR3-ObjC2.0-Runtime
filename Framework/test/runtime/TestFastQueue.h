#import "FastQueue.h"
#import "Test.h"
#import "NoSuchElementException.h"
#import "Assert.h"

@interface TestFastQueue : NSObject {
}

- (void) testQueueNoRemove;
- (void) testQueueThenRemoveAll;
- (void) testQueueThenRemoveOneByOne;
- (void) testGetFromEmptyQueue;
- (void) testGetFromEmptyQueueAfterSomeAdds;
- (void) testGetFromEmptyQueueAfterClear;
@end
