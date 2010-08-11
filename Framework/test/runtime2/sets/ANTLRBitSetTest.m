//
//  ANTLRBitSetTest.m
//  ANTLR
//
//  Created by Ian Michell on 13/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRBitSetTest.h"
#import "ANTLRBitSet.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFBitVector.h>

@implementation ANTLRBitSetTest

-(void) testWithBitData
{
	static const unsigned long long bitData[] = {3LL, 1LL};
	ANTLRBitSet *bitSet = [[ANTLRBitSet alloc] initWithBits:bitData count:2];
    CFIndex actual = (CFIndex)[bitSet numBits];
    CFIndex expected = 3;
	
    STAssertEquals(actual, expected, @"There should be three bits set in bitvector. But I have %d", actual);
	[bitSet release];
}

-(void) testWithBitArray
{
	NSMutableArray *bits = [NSMutableArray new];
	[bits addObject:[NSNumber numberWithBool:YES]];
	[bits addObject:[NSNumber numberWithBool:YES]];
	STAssertTrue([[bits objectAtIndex:0] boolValue], @"Value was not true");
	ANTLRBitSet *bitSet = [[ANTLRBitSet alloc] initWithArrayOfBits:bits];
	CFIndex actual = (CFIndex)[bitSet numBits];
	CFIndex expected = 2;
	STAssertEquals(actual, expected, @"There should be two bits set in bitvector. But I have %d", actual);
	[bitSet release];
}

-(void) testAdd
{

	ANTLRBitSet *bitSet = [[ANTLRBitSet alloc] init];
	[bitSet add:1];
	[bitSet add:2];
	[bitSet add:3];
	CFIndex actual = (CFIndex)[bitSet numBits];
	CFIndex expected = 3;
	STAssertEquals(actual, expected, @"There should be three bits set in bitvector. But I have %d", actual);
	[bitSet release];
}

-(void) testRemove
{
	ANTLRBitSet *bitSet = [[ANTLRBitSet alloc] init];
	[bitSet add:1];
	CFIndex actual = (CFIndex)[bitSet numBits];
	CFIndex expected = 1;
	STAssertTrue(actual == expected, @"Bitset was not of size 1");
	STAssertTrue([bitSet isMember:1], @"Bit at index 1 is not a member...");
	[bitSet remove:1];
	actual = [bitSet numBits];
	STAssertTrue(actual == 0, @"Bitset was not empty");
	STAssertFalse([bitSet isMember:1], @"Bit at index 1 is a member...");
	STAssertTrue([bitSet isNil], @"There was at least one bit on...");
}

-(void) testCopyBitSet
{
	static const unsigned long long bitData[] = {3LL, 1LL};
	ANTLRBitSet *bitSet = [[ANTLRBitSet alloc] initWithBits:bitData count:2];
	ANTLRBitSet *copy = [bitSet copy];
	CFIndex actual = (CFIndex)[copy numBits];
	STAssertEquals(actual, (CFIndex)[bitSet numBits], @"There should be three bits set in bitvector. But I have %d", [copy numBits]);
	[bitSet release];
}

-(void) testOr
{
	static const unsigned long long bitData[] = {3LL, 1LL};
	ANTLRBitSet *bitSet = [[ANTLRBitSet alloc] initWithBits:bitData count:2];
	
	static const unsigned long long otherData[] = {5LL, 3LL, 1LL};
	ANTLRBitSet *otherBitSet = [[ANTLRBitSet alloc] initWithBits:otherData count:3];
	
	ANTLRBitSet *c = [bitSet or:otherBitSet];
	STAssertTrue([c size] == [otherBitSet size], @"c should be the same as otherBitSet");
}

-(void) testDescription
{
	ANTLRBitSet *bitSet = [ANTLRBitSet new];
	[bitSet add:1];
	[bitSet add:2];
	NSString *description = [bitSet description];
	STAssertTrue([description isEqualToString:@"{1,2}"], @"Description was not right, expected '{1,2}' got: %@", description);
}

@end
