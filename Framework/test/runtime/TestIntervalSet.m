#import "TestIntervalSet.h"

@implementation TestIntervalSet


/**
 * Public default constructor used by TestRig
 */
- (id) init {
  if (self = [super init]) {
  }
  return self;
}

- (void) testSingleElement {
  IntervalSet * s = [IntervalSet of:99];
  NSString * expecting = @"99";
  [self assertEquals:[s description] param1:expecting];
}

- (void) testIsolatedElements {
  IntervalSet * s = [[[IntervalSet alloc] init] autorelease];
  [s add:1];
  [s add:'z'];
  [s add:'?'];
  NSString * expecting = @"{1, 122, 65520}";
  [self assertEquals:[s description] param1:expecting];
}

- (void) testMixedRangesAndElements {
  IntervalSet * s = [[[IntervalSet alloc] init] autorelease];
  [s add:1];
  [s add:'a' param1:'z'];
  [s add:'0' param1:'9'];
  NSString * expecting = @"{1, 48..57, 97..122}";
  [self assertEquals:[s description] param1:expecting];
}

- (void) testSimpleAnd {
  IntervalSet * s = [IntervalSet of:10 param1:20];
  IntervalSet * s2 = [IntervalSet of:13 param1:15];
  NSString * expecting = @"13..15";
  NSString * result = [([s and:s2]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testRangeAndIsolatedElement {
  IntervalSet * s = [IntervalSet of:'a' param1:'z'];
  IntervalSet * s2 = [IntervalSet of:'d'];
  NSString * expecting = @"100";
  NSString * result = [([s and:s2]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testEmptyIntersection {
  IntervalSet * s = [IntervalSet of:'a' param1:'z'];
  IntervalSet * s2 = [IntervalSet of:'0' param1:'9'];
  NSString * expecting = @"{}";
  NSString * result = [([s and:s2]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testEmptyIntersectionSingleElements {
  IntervalSet * s = [IntervalSet of:'a'];
  IntervalSet * s2 = [IntervalSet of:'d'];
  NSString * expecting = @"{}";
  NSString * result = [([s and:s2]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testNotSingleElement {
  IntervalSet * vocabulary = [IntervalSet of:1 param1:1000];
  [vocabulary add:2000 param1:3000];
  IntervalSet * s = [IntervalSet of:50 param1:50];
  NSString * expecting = @"{1..49, 51..1000, 2000..3000}";
  NSString * result = [([s complement:vocabulary]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testNotSet {
  IntervalSet * vocabulary = [IntervalSet of:1 param1:1000];
  IntervalSet * s = [IntervalSet of:50 param1:60];
  [s add:5];
  [s add:250 param1:300];
  NSString * expecting = @"{1..4, 6..49, 61..249, 301..1000}";
  NSString * result = [([s complement:vocabulary]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testNotEqualSet {
  IntervalSet * vocabulary = [IntervalSet of:1 param1:1000];
  IntervalSet * s = [IntervalSet of:1 param1:1000];
  NSString * expecting = @"{}";
  NSString * result = [([s complement:vocabulary]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testNotSetEdgeElement {
  IntervalSet * vocabulary = [IntervalSet of:1 param1:2];
  IntervalSet * s = [IntervalSet of:1];
  NSString * expecting = @"2";
  NSString * result = [([s complement:vocabulary]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testNotSetFragmentedVocabulary {
  IntervalSet * vocabulary = [IntervalSet of:1 param1:255];
  [vocabulary add:1000 param1:2000];
  [vocabulary add:9999];
  IntervalSet * s = [IntervalSet of:50 param1:60];
  [s add:3];
  [s add:250 param1:300];
  [s add:10000];
  NSString * expecting = @"{1..2, 4..49, 61..249, 1000..2000, 9999}";
  NSString * result = [([s complement:vocabulary]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testSubtractOfCompletelyContainedRange {
  IntervalSet * s = [IntervalSet of:10 param1:20];
  IntervalSet * s2 = [IntervalSet of:12 param1:15];
  NSString * expecting = @"{10..11, 16..20}";
  NSString * result = [([s subtract:s2]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testSubtractOfOverlappingRangeFromLeft {
  IntervalSet * s = [IntervalSet of:10 param1:20];
  IntervalSet * s2 = [IntervalSet of:5 param1:11];
  NSString * expecting = @"12..20";
  NSString * result = [([s subtract:s2]) description];
  [self assertEquals:result param1:expecting];
  IntervalSet * s3 = [IntervalSet of:5 param1:10];
  expecting = @"11..20";
  result = [([s subtract:s3]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testSubtractOfOverlappingRangeFromRight {
  IntervalSet * s = [IntervalSet of:10 param1:20];
  IntervalSet * s2 = [IntervalSet of:15 param1:25];
  NSString * expecting = @"10..14";
  NSString * result = [([s subtract:s2]) description];
  [self assertEquals:result param1:expecting];
  IntervalSet * s3 = [IntervalSet of:20 param1:25];
  expecting = @"10..19";
  result = [([s subtract:s3]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testSubtractOfCompletelyCoveredRange {
  IntervalSet * s = [IntervalSet of:10 param1:20];
  IntervalSet * s2 = [IntervalSet of:1 param1:25];
  NSString * expecting = @"{}";
  NSString * result = [([s subtract:s2]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testSubtractOfRangeSpanningMultipleRanges {
  IntervalSet * s = [IntervalSet of:10 param1:20];
  [s add:30 param1:40];
  [s add:50 param1:60];
  IntervalSet * s2 = [IntervalSet of:5 param1:55];
  NSString * expecting = @"56..60";
  NSString * result = [([s subtract:s2]) description];
  [self assertEquals:result param1:expecting];
  IntervalSet * s3 = [IntervalSet of:15 param1:55];
  expecting = @"{10..14, 56..60}";
  result = [([s subtract:s3]) description];
  [self assertEquals:result param1:expecting];
}


/**
 * The following was broken:
 * 	 	{0..113, 115..65534}-{0..115, 117..65534}=116..65534
 */
- (void) testSubtractOfWackyRange {
  IntervalSet * s = [IntervalSet of:0 param1:113];
  [s add:115 param1:200];
  IntervalSet * s2 = [IntervalSet of:0 param1:115];
  [s2 add:117 param1:200];
  NSString * expecting = @"116";
  NSString * result = [([s subtract:s2]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testSimpleEquals {
  IntervalSet * s = [IntervalSet of:10 param1:20];
  IntervalSet * s2 = [IntervalSet of:10 param1:20];
  NSNumber * expecting = [[[NSNumber alloc] init:YES] autorelease];
  NSNumber * result = [[[NSNumber alloc] init:[s isEqualTo:s2]] autorelease];
  [self assertEquals:result param1:expecting];
  IntervalSet * s3 = [IntervalSet of:15 param1:55];
  expecting = [[[NSNumber alloc] init:NO] autorelease];
  result = [[[NSNumber alloc] init:[s isEqualTo:s3]] autorelease];
  [self assertEquals:result param1:expecting];
}

- (void) testEquals {
  IntervalSet * s = [IntervalSet of:10 param1:20];
  [s add:2];
  [s add:499 param1:501];
  IntervalSet * s2 = [IntervalSet of:10 param1:20];
  [s2 add:2];
  [s2 add:499 param1:501];
  NSNumber * expecting = [[[NSNumber alloc] init:YES] autorelease];
  NSNumber * result = [[[NSNumber alloc] init:[s isEqualTo:s2]] autorelease];
  [self assertEquals:result param1:expecting];
  IntervalSet * s3 = [IntervalSet of:10 param1:20];
  [s3 add:2];
  expecting = [[[NSNumber alloc] init:NO] autorelease];
  result = [[[NSNumber alloc] init:[s isEqualTo:s3]] autorelease];
  [self assertEquals:result param1:expecting];
}

- (void) testSingleElementMinusDisjointSet {
  IntervalSet * s = [IntervalSet of:15 param1:15];
  IntervalSet * s2 = [IntervalSet of:1 param1:5];
  [s2 add:10 param1:20];
  NSString * expecting = @"{}";
  NSString * result = [[s subtract:s2] description];
  [self assertEquals:result param1:expecting];
}

- (void) testMembership {
  IntervalSet * s = [IntervalSet of:15 param1:15];
  [s add:50 param1:60];
  [self assertTrue:![s member:0]];
  [self assertTrue:![s member:20]];
  [self assertTrue:![s member:100]];
  [self assertTrue:[s member:15]];
  [self assertTrue:[s member:55]];
  [self assertTrue:[s member:50]];
  [self assertTrue:[s member:60]];
}

- (void) testIntersectionWithTwoContainedElements {
  IntervalSet * s = [IntervalSet of:10 param1:20];
  IntervalSet * s2 = [IntervalSet of:2 param1:2];
  [s2 add:15];
  [s2 add:18];
  NSString * expecting = @"{15, 18}";
  NSString * result = [([s and:s2]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testIntersectionWithTwoContainedElementsReversed {
  IntervalSet * s = [IntervalSet of:10 param1:20];
  IntervalSet * s2 = [IntervalSet of:2 param1:2];
  [s2 add:15];
  [s2 add:18];
  NSString * expecting = @"{15, 18}";
  NSString * result = [([s2 and:s]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testComplement {
  IntervalSet * s = [IntervalSet of:100 param1:100];
  [s add:101 param1:101];
  IntervalSet * s2 = [IntervalSet of:100 param1:102];
  NSString * expecting = @"102";
  NSString * result = [([s complement:s2]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testComplement2 {
  IntervalSet * s = [IntervalSet of:100 param1:101];
  IntervalSet * s2 = [IntervalSet of:100 param1:102];
  NSString * expecting = @"102";
  NSString * result = [([s complement:s2]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testComplement3 {
  IntervalSet * s = [IntervalSet of:1 param1:96];
  [s add:99 param1:Label.MAX_CHAR_VALUE];
  NSString * expecting = @"97..98";
  NSString * result = [([s complement:1 param1:Label.MAX_CHAR_VALUE]) description];
  [self assertEquals:result param1:expecting];
}

- (void) testMergeOfRangesAndSingleValues {
  IntervalSet * s = [IntervalSet of:0 param1:41];
  [s add:42];
  [s add:43 param1:65534];
  NSString * expecting = @"0..65534";
  NSString * result = [s description];
  [self assertEquals:result param1:expecting];
}

- (void) testMergeOfRangesAndSingleValuesReverse {
  IntervalSet * s = [IntervalSet of:43 param1:65534];
  [s add:42];
  [s add:0 param1:41];
  NSString * expecting = @"0..65534";
  NSString * result = [s description];
  [self assertEquals:result param1:expecting];
}

- (void) testMergeWhereAdditionMergesTwoExistingIntervals {
  IntervalSet * s = [IntervalSet of:42];
  [s add:10];
  [s add:0 param1:9];
  [s add:43 param1:65534];
  [s add:11 param1:41];
  NSString * expecting = @"0..65534";
  NSString * result = [s description];
  [self assertEquals:result param1:expecting];
}

- (void) testMergeWithDoubleOverlap {
  IntervalSet * s = [IntervalSet of:1 param1:10];
  [s add:20 param1:30];
  [s add:5 param1:25];
  NSString * expecting = @"1..30";
  NSString * result = [s description];
  [self assertEquals:result param1:expecting];
}

- (void) testSize {
  IntervalSet * s = [IntervalSet of:20 param1:30];
  [s add:50 param1:55];
  [s add:5 param1:19];
  NSString * expecting = @"32";
  NSString * result = [String valueOf:[s size]];
  [self assertEquals:result param1:expecting];
}

- (void) testToList {
  IntervalSet * s = [IntervalSet of:20 param1:25];
  [s add:50 param1:55];
  [s add:5 param1:5];
  NSString * expecting = @"[5, 20, 21, 22, 23, 24, 25, 50, 51, 52, 53, 54, 55]";
  NSMutableArray * foo = [[[NSMutableArray alloc] init] autorelease];
  NSString * result = [String valueOf:[s toList]];
  [self assertEquals:result param1:expecting];
}


/**
 * The following was broken:
 * 	    {' '..'s', 'u'..'?'} & {' '..'q', 's'..'?'}=
 * 	    {' '..'q', 's'}!!!! broken...
 * 	 	'q' is 113 ascii
 * 	 	'u' is 117
 */
- (void) testNotRIntersectionNotT {
  IntervalSet * s = [IntervalSet of:0 param1:'s'];
  [s add:'u' param1:200];
  IntervalSet * s2 = [IntervalSet of:0 param1:'q'];
  [s2 add:'s' param1:200];
  NSString * expecting = @"{0..113, 115, 117..200}";
  NSString * result = [([s and:s2]) description];
  [self assertEquals:result param1:expecting];
}

@end
