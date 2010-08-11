//
//  ANTLRLookaheadStream.m
//  ANTLR
//
//  Created by Ian Michell on 26/04/2010.
// [The "BSD licence"]
// Copyright (c) 2010 Ian Michell 2010 Alan Condit
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

#import "ANTLRLookaheadStream.h"
#import "ANTLRError.h"
#import "ANTLRRecognitionException.h"
#import "ANTLRCommonToken.h"

@implementation ANTLRLookaheadStream

@synthesize eof;
@synthesize eofElementIndex;
@synthesize lastMarker;
@synthesize markDepth;

-(id) init
{
	if ((self = [super init]) != nil) {
        eof = [ANTLRCommonToken eofToken];
		eofElementIndex = UNITIALIZED_EOF_ELEMENT_INDEX;
		markDepth = 0;
	}
	return self;
}

-(id) initWithEOF:(id) obj
{
	if ((self = [super init]) != nil) {
		self.eof = obj;
	}
	return self;
}

- (void) reset
{
	eofElementIndex = UNITIALIZED_EOF_ELEMENT_INDEX;
	[super reset];
}

-(id) nextElement
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(void) consume
{
	[self sync:1];
	[self remove];
}

-(void) sync:(NSInteger) need
{
	NSInteger n = (p + need - 1) - [data count] + 1;
	if (n > 0)
	{
		[self fill:n];
	}
}

-(void) fill:(NSInteger) n
{
	for (NSInteger i = 0; i <= n; i++) {
		id o = [self nextElement];
		if (o == eof) {
			[data addObject:self.eof];
			eofElementIndex = [data count] - 1;
		}
		else {
			[data addObject:o];
		}
	}
}

-(NSInteger) size
{
	@throw [NSException exceptionWithName:@"ANTLRUnsupportedOperationException" reason:@"Streams have no defined size" userInfo:nil];
}

-(id) LT:(NSInteger) i
{
	if (i == 0) {
		return nil;
	}
	if (i < 0) {
		return [self LB:-i];
	}
	if ((p + i - 1) >= eofElementIndex) {
		return self.eof;
	}
	[self sync:i];
	return [self objectAtIndex:(i - 1)];
}

-(id) LB:(NSInteger) i
{
	if (i == 0)
	{
		return nil;
	}
	if ((p - i) < 0)
	{
		return nil;
	}
	return [self objectAtIndex:-i];
}

-(id) currentSymbol
{
	return [self LT:1];
}

-(NSInteger) getIndex
{
	return p;
}

-(NSInteger) mark
{
	markDepth++;
	lastMarker = [self getIndex];
	return lastMarker;
}

-(void) release:(NSInteger) marker
{
	// no resources to release
}

-(void) rewind:(NSInteger) marker
{
	markDepth--;
	[self seek:marker];
}

-(void) rewind
{
	[self seek:lastMarker];
}

-(void) seek:(NSInteger) i
{
	p = i;
}

- (id) getEof
{
    return eof;
}

- (void) setEof:(id) anID
{
    eof = anID;
}

- (NSInteger) getEofElementIndex
{
    return eofElementIndex;
}

- (void) setEofElementIndex:(NSInteger) anInt
{
    eofElementIndex = anInt;
}

- (NSInteger) getLastMarker
{
    return lastMarker;
}

- (void) setLastMarker:(NSInteger) anInt
{
    lastMarker = anInt;
}

- (NSInteger) getMarkDepthlastMarker
{
    return markDepth;
}

- (void) setMarkDepth:(NSInteger) anInt
{
    markDepth = anInt;
}

@end
