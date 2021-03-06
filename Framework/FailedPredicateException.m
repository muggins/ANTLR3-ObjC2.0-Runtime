// [The "BSD licence"]
// Copyright (c) 2006-2007 Kay Roepke 20110 Alan Condit
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "FailedPredicateException.h"


@implementation FailedPredicateException

@synthesize predicate;
@synthesize ruleName;

+ (FailedPredicateException *) newException:(NSString *)theRuleName predicate:(NSString *)thePredicate stream:(id<IntStream>)theStream
{
	return [[FailedPredicateException alloc] initWithRuleName:theRuleName predicate:thePredicate stream:theStream];
}

- (FailedPredicateException *) initWithRuleName:(NSString *)theRuleName predicate:(NSString *)thePredicate stream:(id<IntStream>)theStream
{
	if ((self = [super initWithStream:theStream])) {
		[self setPredicate:thePredicate];
		[self setRuleName:theRuleName];
	}
	return self;
}

- (void) dealloc
{
#ifdef DEBUG_DEALLOC
    NSLog( @"called dealloc in FailedPredicateException" );
#endif
	[self setPredicate:nil];
	[self setRuleName:nil];
    //	[super dealloc];
}

- (NSString *) description
{
	NSMutableString *desc = (NSMutableString *)[super description];
	[desc appendFormat:@" rule: %@ predicate failed: %@", ruleName, predicate];
	return desc;
}

#ifdef DONTUSEYET
- (NSString *) getPredicate
{
	return predicate;
}

- (void) setPredicate:(NSString *)thePredicate
{
	predicate = thePredicate;
}

- (NSString *) getRuleName
{
	return ruleName;
}

- (void) setRuleName:(NSString *)theRuleName
{
	ruleName = theRuleName;
}
#endif

@end
