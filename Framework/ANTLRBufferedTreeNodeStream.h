//
//  ANTLRBufferedTreeNodeStream.h
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

#import <Cocoa/Cocoa.h>
#import "ANTLRTree.h"
#import "ANTLRCommonTreeAdaptor.h"
#import "ANTLRTokenStream.h"
#import "ANTLRCommonTreeNodeStream.h"
#import "ANTLRLookaheadStream.h"
#import "ANTLRTreeIterator.h"
#import "ANTLRIntArray.h"

#define ANTLR_BUFFERED_TREE_NODE_STREAM_BUFFER_SIZE 100
#define ANTLR_BUFFERED_TREE_NODE_STREAM_CALL_STACK_SIZE 10

@interface ANTLRBufferedTreeNodeStream : NSObject <ANTLRTreeNodeStream> 
{
	id<ANTLRTree> up;
	id<ANTLRTree> down;
	id<ANTLRTree> eof;
	
	NSMutableArray *nodes;
	
	id<ANTLRTree> root; // root
	
	id<ANTLRTokenStream> tokens;
	ANTLRCommonTreeAdaptor *adaptor;
	
	BOOL uniqueNavigationNodes;
	NSInteger p;
	NSInteger lastMarker;
	ANTLRIntArray *calls;
	
	NSEnumerator *e;
    id currentSymbol;
	
}

@property (retain, getter=getUp, setter=setUp:) id<ANTLRTree> up;
@property (retain, getter=getDown, setter=setDown:) id<ANTLRTree> down;
@property (retain, getter=getEof, setter=setEof:) id<ANTLRTree> eof;
@property (retain, getter=getNodes, setter=setNodes:) NSMutableArray *nodes;
@property (retain, getter=getTreeSource, setter=setTreeSource:) id<ANTLRTree> root;
@property (retain, getter=getTokenStream, setter=setTokenStream:) id<ANTLRTokenStream> tokens;
@property (retain, getter=getAdaptor, setter=setAdaptor:) ANTLRCommonTreeAdaptor *adaptor;
@property (assign, getter=getUniqueNavigationNodes, setter=setUniqueNavigationNodes:) BOOL uniqueNavigationNodes;
@property (assign, getter=getIndex, setter=setIndex:) NSInteger p;
@property (assign, getter=getLastMarker, setter=setLastMarker:) NSInteger lastMarker;
@property (retain, getter=getCalls, setter=setCalls:) ANTLRIntArray *calls;
@property (retain, getter=getEnum, setter=setEnum:) NSEnumerator *e;
@property(readonly) id currentSymbol;

+ (ANTLRBufferedTreeNodeStream *) newANTLRBufferedTreeNodeStream:(id<ANTLRTree>)tree;
+ (ANTLRBufferedTreeNodeStream *) newANTLRBufferedTreeNodeStream:(id<ANTLRTreeAdaptor>)adaptor Tree:(id<ANTLRTree>)tree;
+ (ANTLRBufferedTreeNodeStream *) newANTLRBufferedTreeNodeStream:(id<ANTLRTreeAdaptor>)adaptor Tree:(id<ANTLRTree>)tree withBufferSize:(NSInteger)initialBufferSize;

#pragma mark Constructor
-(id) initWithTree:(id<ANTLRTree>)tree;
-(id) initWithTreeAdaptor:(ANTLRCommonTreeAdaptor *)anAdaptor Tree:(id<ANTLRTree>)tree;
-(id) initWithTreeAdaptor:(ANTLRCommonTreeAdaptor *)anAdaptor Tree:(id<ANTLRTree>)tree WithBufferSize:(NSInteger)bufferSize;

- (id) copyWithZone:(NSZone *)aZone;

#pragma mark General Methods
-(id) currentSymbol;
-(id) LB:(NSInteger) i;
-(NSString *) getSourceName;
-(NSEnumerator *) objectEnumerator;

-(void) push:(NSInteger) i;
-(NSInteger) pop;

-(NSString *) toTokenTypeString;
-(NSString *) toTokenString:(NSInteger)aStart ToEnd:(NSInteger)aStop;
-(NSString *) toStringFromNode:(id)aStart ToNode:(id)aStop;

// protected methods. DO NOT USE
#pragma mark Protected Methods
-(void) _fillBuffer;
-(void) _fillBufferWithTree:(id<ANTLRTree>) tree;
-(NSInteger) getNodeIndex:(id<ANTLRTree>) node;
-(void) _addNavigationNode:(NSInteger) type;

- (BOOL)getUniqueNavigationNodes;
- (void) setUniqueNavigationNodes:(BOOL)aVal;

@end
