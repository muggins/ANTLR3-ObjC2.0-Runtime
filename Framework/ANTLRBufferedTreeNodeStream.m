//
//  ANTLRBufferedTreeNodeStream.m
//  ANTLR
//
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

#import "ANTLRBufferedTreeNodeStream.h"
#import "ANTLRStreamEnumerator.h"
#import "ANTLRCommonTreeAdaptor.h"

@implementation ANTLRBufferedTreeNodeStream

@synthesize up;
@synthesize down;
@synthesize eof;
@synthesize nodes;
@synthesize root;
@synthesize tokens;
@synthesize adaptor;
@synthesize uniqueNavigationNodes;
@synthesize p;
@synthesize lastMarker;
@synthesize calls;
@synthesize e;

+ (ANTLRBufferedTreeNodeStream *) newANTLRBufferedTreeNodeStream:(id<ANTLRTree>) aTree
{
    return [((ANTLRBufferedTreeNodeStream *)[ANTLRBufferedTreeNodeStream alloc]) initWithTree:(id<ANTLRTree>)aTree];
}

+ (ANTLRBufferedTreeNodeStream *) newANTLRBufferedTreeNodeStream:(id<ANTLRTreeAdaptor>)adaptor Tree:(ANTLRCommonTree *)aTree
{
    return [[ANTLRBufferedTreeNodeStream alloc] initWithTreeAdaptor:adaptor Tree:(id<ANTLRTree>)aTree];
}

+ (ANTLRBufferedTreeNodeStream *) newANTLRBufferedTreeNodeStream:(id<ANTLRTreeAdaptor>)adaptor Tree:(id<ANTLRTree>)aTree withBufferSize:(NSInteger)initialBufferSize
{
    return [[ANTLRBufferedTreeNodeStream alloc] initWithTreeAdaptor:adaptor Tree:(id<ANTLRTree>)aTree WithBufferSize:initialBufferSize];
}

-(ANTLRBufferedTreeNodeStream *) init
{
	self = [super init];
	if (self) {
		p = -1;
		uniqueNavigationNodes = NO;
        root = [[ANTLRCommonTree alloc] init];
        //		tokens = tree;
        adaptor = [[ANTLRCommonTreeAdaptor alloc] init];
        nodes = [NSMutableArray arrayWithCapacity:ANTLR_BUFFERED_TREE_NODE_STREAM_BUFFER_SIZE];
        down = [adaptor createTree:ANTLRTokenTypeDOWN Text:@"DOWN"];
        up = [adaptor createTree:ANTLRTokenTypeUP Text:@"UP"];
        eof = [adaptor createTree:ANTLRTokenTypeEOF Text:@"EOF"];
    }
	return self;
}

- (ANTLRBufferedTreeNodeStream *)initWithTree:(id<ANTLRTree>) aTree
{
	self = [super init];
	if (self) {
		p = -1;
		uniqueNavigationNodes = NO;
        root = aTree;
        //		tokens = aTree;
        adaptor = [[ANTLRCommonTreeAdaptor alloc] init];
        nodes = [NSMutableArray arrayWithCapacity:ANTLR_BUFFERED_TREE_NODE_STREAM_BUFFER_SIZE];
        down = [adaptor createTree:ANTLRTokenTypeDOWN Text:@"DOWN"];
        up = [adaptor createTree:ANTLRTokenTypeUP Text:@"UP"];
        eof = [adaptor createTree:ANTLRTokenTypeEOF Text:@"EOF"];
    }
	return self;
}

-(ANTLRBufferedTreeNodeStream *) initWithTreeAdaptor:(ANTLRCommonTreeAdaptor *)anAdaptor Tree:(id<ANTLRTree>)aTree
{
	self = [super init];
	if (self) {
		p = -1;
		uniqueNavigationNodes = NO;
        root = aTree;
        //		tokens = aTree;
        adaptor = anAdaptor;
        nodes = [NSMutableArray arrayWithCapacity:ANTLR_BUFFERED_TREE_NODE_STREAM_BUFFER_SIZE];
        down = [adaptor createTree:ANTLRTokenTypeDOWN Text:@"DOWN"];
        up = [adaptor createTree:ANTLRTokenTypeUP Text:@"UP"];
        eof = [adaptor createTree:ANTLRTokenTypeEOF Text:@"EOF"];
    }
	return self;
}

-(ANTLRBufferedTreeNodeStream *) initWithTreeAdaptor:(ANTLRCommonTreeAdaptor *)anAdaptor Tree:(id<ANTLRTree>)aTree WithBufferSize:(NSInteger)bufferSize
{
	self = [super init];
	if (self) {
        //		down = [adaptor createToken:ANTLRTokenTypeDOWN withText:@"DOWN"];
        //		up = [adaptor createToken:ANTLRTokenTypeDOWN withText:@"UP"];
        //		eof = [adaptor createToken:ANTLRTokenTypeDOWN withText:@"EOF"];
		p = -1;
		uniqueNavigationNodes = NO;
        root = aTree;
        //		tokens = aTree;
        adaptor = anAdaptor;
        nodes = [NSMutableArray arrayWithCapacity:bufferSize];
        down = [adaptor createTree:ANTLRTokenTypeDOWN Text:@"DOWN"];
        up = [adaptor createTree:ANTLRTokenTypeUP Text:@"UP"];
        eof = [adaptor createTree:ANTLRTokenTypeEOF Text:@"EOF"];
	}
	return self;
}

- (id) copyWithZone:(NSZone *)aZone
{
    ANTLRBufferedTreeNodeStream *copy;
    
    copy = [[[self class] allocWithZone:aZone] init];
    if ( up )
        copy.up = [up copyWithZone:aZone];
    if ( down )
        copy.down = [down copyWithZone:aZone];
    if ( eof )
        copy.eof = [eof copyWithZone:aZone];
    if ( nodes )
        copy.nodes = [nodes copyWithZone:aZone];
    if ( root )
        copy.root = [root copyWithZone:aZone];
    if ( tokens )
        copy.tokens = [tokens copyWithZone:aZone];
    if ( adaptor )
        copy.adaptor = [adaptor copyWithZone:aZone];
    copy.uniqueNavigationNodes = self.uniqueNavigationNodes;
    copy.p = self.p;
    copy.lastMarker = self.lastMarker;
    if ( calls )
        copy.calls = [calls copyWithZone:aZone];
    return copy;
}

// protected methods. DO NOT USE
#pragma mark Protected Methods
-(void) _fillBuffer
{
	[self _fillBufferWithTree:root];
	p = 0;
}

-(void) _fillBufferWithTree:(id<ANTLRTree>) aTree
{
	BOOL empty = [adaptor isNil:aTree];
	if (!empty) {
		[nodes addObject:aTree];
	}
	NSInteger n = [adaptor getChildCount:aTree];
	if (!empty && n > 0) {
		[self _addNavigationNode:ANTLRTokenTypeDOWN];
	}
	for (NSInteger i = 0; i < n; i++) {
		id child = [adaptor getChild:aTree At:i];
		[self _fillBufferWithTree:child];
	}
	if (!empty && n > 0) {
		[self _addNavigationNode:ANTLRTokenTypeUP];
	}
}

-(NSInteger) getNodeIndex:(id<ANTLRTree>) node
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	for (NSInteger i = 0; i < [nodes count]; i++)
	{
		id t = [nodes objectAtIndex:i];
		if (t == node)
		{
			return i;
		}
	}
	return -1;
}

-(void) _addNavigationNode:(NSInteger) type
{
	id navNode = nil;
	if (type == ANTLRTokenTypeDOWN)
	{
		if (self.uniqueNavigationNodes)
		{
			navNode = [adaptor createToken:ANTLRTokenTypeDOWN Text:@"DOWN"];
		}
		else 
		{
			navNode = down;
		}

	}
	else 
	{
		if (self.uniqueNavigationNodes)
		{
			navNode = [adaptor createToken:ANTLRTokenTypeUP Text:@"UP"];
		}
		else 
		{
			navNode = up;
		}
	}
	[nodes addObject:navNode];
}

-(id) getNode:(NSInteger) i
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	return [nodes objectAtIndex:i];
}

-(id) LT:(NSInteger) i
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	if (i == 0)
	{
		return nil;
	}
	if (i < 0)
	{
		return [self LB:i];
	}
	if ((p + i - 1) >= [nodes count])
	{
		return eof;
	}
	return [nodes objectAtIndex:(p + i - 1)];
}

@dynamic currentSymbol;
-(id) currentSymbol
{
	return [self LT:1];
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
	return [nodes objectAtIndex:(p - i)];
}

- (id<ANTLRTree>)getTreeSource
{
    return root;
}

-(NSString *)getSourceName
{
	return [[self getTokenStream] getSourceName];
}

- (id<ANTLRTokenStream>)getTokenStream
{
    return tokens;
}

- (void) setTokenStream:(id<ANTLRTokenStream>)newtokens
{
    tokens = newtokens;
}

- (id<ANTLRTreeAdaptor>)getTreeAdaptor
{
    return adaptor;
}

- (void) setTreeAdaptor:(id<ANTLRTreeAdaptor>)anAdaptor
{
    adaptor = anAdaptor;
}

- (BOOL)getUniqueNavigationNodes
{
    return uniqueNavigationNodes;
}

- (void) setUniqueNavigationNodes:(BOOL)aVal
{
    uniqueNavigationNodes = aVal;
}

-(void) consume
{
	if (p == -1) {
		[self _fillBuffer];
	}
	p++;
}

-(NSInteger) LA:(NSInteger) i
{
	return [adaptor getType:[self LT:i]];
}

-(NSInteger) mark
{
	if (p == -1) {
		[self _fillBuffer];
	}
	lastMarker = [self getIndex];
	return lastMarker;
}

-(void) release:(NSInteger) marker
{
	// do nothing
}

-(NSInteger) index
{
	return p;
}

-(void) rewind:(NSInteger) marker
{
	[self seek:marker];
}

-(void) rewind
{
	[self seek:lastMarker];
}

-(void) seek:(NSInteger) i
{
	if (p == -1) {
		[self _fillBuffer];
	}
	p = i;
}

-(void) push:(NSInteger) i
{
	if (calls == nil) {
		calls = [ANTLRIntArray newANTLRIntArrayWithLen:ANTLR_BUFFERED_TREE_NODE_STREAM_CALL_STACK_SIZE];
	}
	[calls push:p];
	[self seek:i];
}

-(NSInteger) pop
{
	NSInteger ret = [calls pop];
	[self seek:ret];
	return ret;
}

-(void) reset
{
	p = 0;
	lastMarker = 0;
	if (calls != nil) {
		[calls reset];
	}
}

-(NSUInteger) size
{
	if (p == -1) {
		[self _fillBuffer];
	}
	return [nodes count];
}

-(NSEnumerator *) objectEnumerator
{
	if (e == nil)
	{
		e = [[ANTLRStreamEnumerator alloc] initWithNodes:nodes andEOF:eof];
	}
	return e;
}

-(void) replaceChildren:(id<ANTLRTree>) parent From:(NSInteger)startIdx To:(NSInteger)stopIdx With:(id<ANTLRTree>)aTree
{
	if (parent != nil)
	{
		[adaptor replaceChildren:parent From:startIdx To:stopIdx With:aTree];
	}
}

-(NSString *) toTokenTypeString
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	NSMutableString *buf = [NSMutableString stringWithCapacity:10];
	for (NSInteger i= 0; i < [nodes count]; i++)
	{
		id<ANTLRTree> aTree = (id<ANTLRTree>)[nodes objectAtIndex:i];
		[buf appendFormat:@" %d", [adaptor getType:aTree]];
	}
	return buf;
}

-(NSString *) toTokenString:(NSInteger)aStart ToEnd:(NSInteger)aStop
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	NSMutableString *buf = [NSMutableString stringWithCapacity:10];
	for (NSInteger i = aStart; i < [nodes count] && i <= aStop; i++)
	{
		id<ANTLRTree> t = (id<ANTLRTree>)[nodes objectAtIndex:i];
		[buf appendFormat:@" %d", [adaptor getType:t]];
	}
	return buf;
}

-(NSString *) toStringFromNode:(id)aStart ToNode:(id)aStop
{
	if (aStart == nil || aStop == nil) {
		return nil;
	}
	if (p == -1) {
		[self _fillBuffer];
	}
	
	// if we have a token stream, use that to dump text in order
	if ([self getTokenStream] != nil) {
		NSInteger beginTokenIndex = [adaptor getTokenStartIndex:aStart];
		NSInteger endTokenIndex = [adaptor getTokenStopIndex:aStop];
		
		if ([adaptor getType:aStop] == ANTLRTokenTypeUP) {
			endTokenIndex = [adaptor getTokenStopIndex:aStart];
		}
		else if ([adaptor getType:aStop] == ANTLRTokenTypeEOF) {
			endTokenIndex = [self size] - 2; //don't use EOF
		}
        [tokens toStringFromStart:beginTokenIndex ToEnd:endTokenIndex];
	}
	// walk nodes looking for aStart
	id<ANTLRTree> aTree = nil;
	NSInteger i = 0;
	for (; i < [nodes count]; i++) {
		aTree = [nodes objectAtIndex:i];
		if (aTree == aStart) {
			break;
		}
	}
	NSMutableString *buf = [NSMutableString stringWithCapacity:10];
	aTree = [nodes objectAtIndex:i]; // why?
	while (aTree != aStop) {
		NSString *text = [adaptor getText:aTree];
		if (text == nil) {
			text = [NSString stringWithFormat:@" %d", [adaptor getType:aTree]];
		}
		[buf appendString:text];
		i++;
		aTree = [nodes objectAtIndex:i];
	}
	NSString *text = [adaptor getText:aStop];
	if (text == nil) {
		text = [NSString stringWithFormat:@" %d", [adaptor getType:aStop]];
	}
	[buf appendString:text];
	return buf;
}

@end
