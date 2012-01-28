#import "ANTLRStringStream.h"
#import "CharStream.h"
#import "TokenRewriteStream.h"
#import "Grammar.h"
#import "Interpreter.h"
#import "Test.h"

@interface TestTokenRewriteStream : BaseTest {
}

- (id) init;
- (void) testInsertBeforeIndex0;
- (void) testInsertAfterLastIndex;
- (void) test2InsertBeforeAfterMiddleIndex;
- (void) testReplaceIndex0;
- (void) testReplaceLastIndex;
- (void) testReplaceMiddleIndex;
- (void) testToStringStartStop;
- (void) testToStringStartStop2;
- (void) test2ReplaceMiddleIndex;
- (void) test2ReplaceMiddleIndex1InsertBefore;
- (void) testReplaceThenDeleteMiddleIndex;
- (void) testInsertInPriorReplace;
- (void) testInsertThenReplaceSameIndex;
- (void) test2InsertMiddleIndex;
- (void) test2InsertThenReplaceIndex0;
- (void) testReplaceThenInsertBeforeLastIndex;
- (void) testInsertThenReplaceLastIndex;
- (void) testReplaceThenInsertAfterLastIndex;
- (void) testReplaceRangeThenInsertAtLeftEdge;
- (void) testReplaceRangeThenInsertAtRightEdge;
- (void) testReplaceRangeThenInsertAfterRightEdge;
- (void) testReplaceAll;
- (void) testReplaceSubsetThenFetch;
- (void) testReplaceThenReplaceSuperset;
- (void) testReplaceThenReplaceLowerIndexedSuperset;
- (void) testReplaceSingleMiddleThenOverlappingSuperset;
- (void) testCombineInserts;
- (void) testCombine3Inserts;
- (void) testCombineInsertOnLeftWithReplace;
- (void) testCombineInsertOnLeftWithDelete;
- (void) testDisjointInserts;
- (void) testOverlappingReplace;
- (void) testOverlappingReplace2;
- (void) testOverlappingReplace3;
- (void) testOverlappingReplace4;
- (void) testDropIdenticalReplace;
- (void) testDropPrevCoveredInsert;
- (void) testLeaveAloneDisjointInsert;
- (void) testLeaveAloneDisjointInsert2;
- (void) testInsertBeforeTokenThenDeleteThatToken;
@end
