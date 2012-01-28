#import "CommonToken.h"
#import "BufferedTreeNodeStream.h"
#import "CommonTree.h"
#import "Tree.h"
#import "TreeNodeStream.h"
#import "Test.h"

@interface TestBufferedTreeNodeStream : TestTreeNodeStream {
}

- (TreeNodeStream *) newStream:(NSObject *)t;
- (NSString *) toTokenTypeString:(TreeNodeStream *)stream;
- (void) testSeek;
@end
