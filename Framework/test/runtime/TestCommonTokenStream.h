#import "Grammar.h"
#import "Interpreter.h"
#import "Test.h"

@interface TestCommonTokenStream_Anon1 : NSObject <TokenSource> {
  int i;
  NSArray * tokens;
}

@property(nonatomic, retain, readonly) NSString * sourceName;
- (void) init;
- (Token *) nextToken;
@end

/**
 * This actually tests new (12/4/09) buffered but on-demand fetching stream
 */

@interface TestCommonTokenStream : BaseTest {
}

- (void) testFirstToken;
- (void) test2ndToken;
- (void) testCompleteBuffer;
- (void) testCompleteBufferAfterConsuming;
- (void) testLookback;
- (void) testOffChannel;
@end
