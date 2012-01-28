#import "Label.h"
#import "IntervalSet.h"
#import "Test.h"
#import "NSMutableArray.h"
#import "NSMutableArray.h"

@interface TestIntervalSet : BaseTest {
}

- (id) init;
- (void) testSingleElement;
- (void) testIsolatedElements;
- (void) testMixedRangesAndElements;
- (void) testSimpleAnd;
- (void) testRangeAndIsolatedElement;
- (void) testEmptyIntersection;
- (void) testEmptyIntersectionSingleElements;
- (void) testNotSingleElement;
- (void) testNotSet;
- (void) testNotEqualSet;
- (void) testNotSetEdgeElement;
- (void) testNotSetFragmentedVocabulary;
- (void) testSubtractOfCompletelyContainedRange;
- (void) testSubtractOfOverlappingRangeFromLeft;
- (void) testSubtractOfOverlappingRangeFromRight;
- (void) testSubtractOfCompletelyCoveredRange;
- (void) testSubtractOfRangeSpanningMultipleRanges;
- (void) testSubtractOfWackyRange;
- (void) testSimpleEquals;
- (void) testEquals;
- (void) testSingleElementMinusDisjointSet;
- (void) testMembership;
- (void) testIntersectionWithTwoContainedElements;
- (void) testIntersectionWithTwoContainedElementsReversed;
- (void) testComplement;
- (void) testComplement2;
- (void) testComplement3;
- (void) testMergeOfRangesAndSingleValues;
- (void) testMergeOfRangesAndSingleValuesReverse;
- (void) testMergeWhereAdditionMergesTwoExistingIntervals;
- (void) testMergeWithDoubleOverlap;
- (void) testSize;
- (void) testToList;
- (void) testNotRIntersectionNotT;
@end
