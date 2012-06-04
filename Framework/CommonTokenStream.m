// [The "BSD licence"]
// Copyright (c) 2006-2007 Kay Roepke 2010 Alan Condit
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

#import "Token.h"
#import "CommonTokenStream.h"


@implementation CommonTokenStream

@synthesize channelOverride;
@synthesize channel;

#pragma mark Initialization

+ (CommonTokenStream *)newCommonTokenStream
{
    return [[CommonTokenStream alloc] init];
}

+ (CommonTokenStream *)newCommonTokenStreamWithTokenSource:(id<TokenSource>)theTokenSource
{
    return [[CommonTokenStream alloc] initWithTokenSource:(id<TokenSource>)theTokenSource];
}

+ (CommonTokenStream *)newCommonTokenStreamWithTokenSource:(id<TokenSource>)theTokenSource Channel:(NSUInteger)aChannel
{
    return [[CommonTokenStream alloc] initWithTokenSource:(id<TokenSource>)theTokenSource Channel:aChannel];
}

- (id) init
{
	if ((self = [super init]) != nil) {
		channelOverride = [[AMutableDictionary dictionaryWithCapacity:100] retain];
		channel = TokenChannelDefault;
	}
	return self;
}

- (id) initWithTokenSource:(id<TokenSource>)theTokenSource
{
	if ((self = [super initWithTokenSource:theTokenSource]) != nil) {
		channelOverride = [[AMutableDictionary dictionaryWithCapacity:100] retain];
		channel = TokenChannelDefault;
	}
	return self;
}

- (id) initWithTokenSource:(id<TokenSource>)theTokenSource Channel:(NSUInteger)aChannel
{
	if ((self = [super initWithTokenSource:theTokenSource]) != nil) {
		channelOverride = [[AMutableDictionary dictionaryWithCapacity:100] retain];
		channel = aChannel;
	}
	return self;
}

- (void) dealloc
{
#ifdef DEBUG_DEALLOC
    NSLog( @"called dealloc in CommonTokenStream" );
#endif
	if ( channelOverride ) [channelOverride release];
	if ( tokens ) [tokens release];
	[self setTokenSource:nil];
	[super dealloc];
}

/** Always leave index on an on-channel token. */
- (void) consume
{
    if (index == -1) [self setup];
    index++;
    [self sync:index];
    while ( ((CommonToken *)[tokens objectAtIndex:index]).channel != channel ) {
		index++;
		[self sync:index];
	}
}

#pragma mark Lookahead

- (id<Token>) LB:(NSInteger)k
{
	if ( k == 0 || (index-k) < 0 ) {
		return nil;
	}
	int i = index;
	int n = 1;
    // find k good tokens looking backwards
	while ( n <= k ) {
		i = [self skipOffTokenChannelsReverse:i-1];
		n++;
	}
	if ( i < 0 ) {
		return nil;
	}
	return [tokens objectAtIndex:i];
}

- (id<Token>) LT:(NSInteger)k
{
	if ( index == -1 ) [self setup];
	if ( k == 0 ) return nil;
	if ( k < 0 ) return [self LB:-k];
	int i = index;
	int n = 1;
	while ( n < k ) {
		i = [self skipOffTokenChannels:i+1];
		n++;
	}
//	if ( i >= (NSInteger)[tokens count] ) {
//		return [CommonToken eofToken];
//	}
    if ( i > range ) range = i;
	return [tokens objectAtIndex:i];
}

#pragma mark Channels & Skipping

- (NSInteger) skipOffTokenChannels:(NSInteger) idx
{
    [self sync:idx];
	while ( ((CommonToken *)[tokens objectAtIndex:idx]).channel != channel ) {
		idx++;
        [self sync:idx];
	}
	return idx;
}

- (NSInteger) skipOffTokenChannelsReverse:(NSInteger) i
{
	while ( i >= 0 && ((CommonToken *)[tokens objectAtIndex:i]).channel != channel ) {
		i--;
	}
	return i;
}

- (void) reset
{
    [super reset];
    index = [self skipOffTokenChannels:0];
}

- (void) setup
{
    index = 0;
    [self sync:0];
    int i = 0;
    while ( ((CommonToken *)[tokens objectAtIndex:i]).channel != channel ) {
        i++;
        [self sync:i];
    }
	// leave index pointing at first token on channel
    index = i;
}

- (NSInteger) getNumberOfOnChannelTokens
{
    NSInteger n = 0;
    [self fill];
    for( int i = 0; i < [tokens count]; i++ ) {
        CommonToken *t = [tokens objectAtIndex:i];
        if ( t.channel == channel )
            n++;
        if ( t.type == TokenTypeEOF )
            break;
    }
    return n;
}

/** Reset this token stream by setting its token source. */
- (void) setTokenSource:(id<TokenSource>)aTokenSource
{
    [super setTokenSource:aTokenSource];
    channel = TokenChannelDefault;
}

- (id) copyWithZone:(NSZone *)aZone
{
    CommonTokenStream *copy;
	
    //    copy = [[[self class] allocWithZone:aZone] init];
    copy = [super copyWithZone:aZone]; // allocation occurs in BaseTree
    if ( self.channelOverride )
        copy.channelOverride = [channelOverride copyWithZone:aZone];
    copy.channel = channel;
    return copy;
}

- (NSUInteger)channel
{
    return channel;
}

- (void)setChannel:(NSUInteger)aChannel
{
    channel = aChannel;
}

- (AMutableDictionary *)channelOverride
{
    return channelOverride;
}

/*  // not needed -- synthesized
- (void)setChannelOverride:(AMutableDictionary *)anOverride
{
    channelOverride = anOverride;
}
*/
@end
