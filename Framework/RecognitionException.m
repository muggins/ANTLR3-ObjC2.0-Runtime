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

#import "Foundation/NSObjCRuntime.h"
#import "RecognitionException.h"
#import "TokenStream.h"
#import "TreeNodeStream.h"
#import "BufferedTokenStream.h"
#import "CharStream.h"

@implementation RecognitionException

@synthesize input;
@synthesize index;
@synthesize token;
@synthesize node;
@synthesize c;
@synthesize line;
@synthesize charPositionInLine;
@synthesize approximateLineInfo;

+ (id) newException
{
	return [[RecognitionException alloc] init];
}

+ (id) newException:(id<IntStream>) anInputStream
{
	return [[RecognitionException alloc] initWithStream:anInputStream];
}

+ (id) newException:(id<IntStream>) anInputStream reason:(NSString *)aReason
{
	return [[RecognitionException alloc] initWithStream:anInputStream reason:aReason];
}

- (id) init
{
	self = [super initWithName:@"Recognition Exception" reason:@"Recognition Exception" userInfo:nil];
	if ( self != nil ) {
	}
	return self;
}

- (id) initWithStream:(id<IntStream>)anInputStream reason:(NSString *)aReason
{
	self = [super initWithName:NSStringFromClass([self class]) reason:aReason userInfo:nil];
	if ( self != nil ) {
        self.input = anInputStream;
        self.index = input.index;
        if ( [anInputStream isKindOfClass:[BufferedTokenStream class]] ) {
            self.token = [(id<TokenStream>)anInputStream LT:1];
            self.line = [token line];
            self.charPositionInLine = [token charPositionInLine];
            if ( [input conformsToProtocol:@protocol(TreeNodeStream)] ) {
                [self extractInformationFromTreeNodeStream:anInputStream];
            }
            else {
                c = [anInputStream LA:1];
            }
        } else {
            if ( [input conformsToProtocol:@protocol(CharStream)] ) {
                id<CharStream>aCharStream = (id<CharStream>)anInputStream;
                self.line = [aCharStream getLine];
                self.charPositionInLine = [aCharStream getCharPositionInLine];
            }
            else {
                NSLog( @"I don't know how to deal with %@\n", [((NSObject *)anInputStream) className] );
/*
                if ( [[anInputStream class] instancesRespondToSelector:@selector(getLine)] )
                    self.line = (NSInteger) [anInputStream getLine];
                else if ( [[anInputStream class] instancesRespondToSelector:@selector(line)] )
                    self.line = (NSInteger) [anInputStream line];
                if ( [[anInputStream class] instancesRespondToSelector:@selector(getCharPositionInLine)] )
                    self.charPositionInLine = (NSInteger) [anInputStream getCharPositionInLine];
                else if ( [[anInputStream class] instancesRespondToSelector:@selector(charPositionInLine)] )
                    self.line = (NSInteger) [anInputStream charPositionInLine];
 */
            }
        }
	}
	return self;
}

- (id) initWithStream:(id<IntStream>)anInputStream
{
	return [self initWithStream:anInputStream reason:@"Runtime Exception"];
}

- (id) initWithName:(NSString *)aName reason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo
{
	self = [super initWithName:aName reason:aReason userInfo:aUserInfo];
    return self;
}

- (void) dealloc
{
#ifdef DEBUG_DEALLOC
    NSLog( @"called dealloc in RecognitionException" );
#endif
	input = nil;
	token = nil;
	node = nil;
}

- (void) extractInformationFromTreeNodeStream:(id<TreeNodeStream>)anInput
{
    id<TreeNodeStream> nodes = anInput;
    node = [nodes LT:1];
    id<TreeAdaptor> adaptor = [nodes getTreeAdaptor];
    id<Token> payload = [adaptor getToken:node];
    if ( payload != nil ) {
        token = payload;
        if ( payload.line <= 0 ) {
            // imaginary node; no line/pos info; scan backwards
            int i = -1;
            id priorNode = [nodes LT:i];
            while ( priorNode != nil ) {
                id<Token> priorPayload = [adaptor getToken:priorNode];
                if ( priorPayload!=nil && priorPayload.line > 0 ) {
                    // we found the most recent real line / pos info
                    line = priorPayload.line;
                    charPositionInLine = priorPayload.charPositionInLine;
                    approximateLineInfo = YES;
                    break;
                }
                --i;
                priorNode = [nodes LT:i];
            }
        }
        else { // node created from real token
            line = payload.line;
            charPositionInLine = payload.charPositionInLine;
        }
    }
    else if ( [self.node isKindOfClass:[CommonTree class]] ) {
        line = ((id<Tree>)node).line;
        charPositionInLine = ((id<Tree>)node).charPositionInLine;
        if ( [node isMemberOfClass:[CommonTree class]]) {
            token = ((CommonTree *)node).token;
        }
    }
    else {
        NSInteger type = [adaptor getType:node];
        NSString *text = [adaptor getText:node];
        self.token = [CommonToken newToken:type Text:text];
    }
}

- (NSInteger) unexpectedType
{
	if (token) {
		return token.type;
    } else if (node) {
        return [node type];
	} else {
		return c;
	}
}

- (id<Token>)getUnexpectedToken
{
    return token;
}

- (NSString *) description
{
	//NSMutableString *desc = [[NSMutableString alloc] initWithString:NSStringFromClass([self class])];
	NSMutableString *desc = [NSMutableString stringWithString:[self className]];
	if (token) {
		[desc appendFormat:@" token:%@", token];
	} else if (node) {
		[desc appendFormat:@" node:%@", node];
	} else {
		[desc appendFormat:@" char:%c", c];
	}
	[desc appendFormat:@" line:%ld position:%ld", line, charPositionInLine];
	return desc;
}

//---------------------------------------------------------- 
//  input 
//---------------------------------------------------------- 
- (id<IntStream>) getStream
{
    return input; 
}

- (void) setStream: (id<IntStream>) aStream
{
    input = aStream;
}

//---------------------------------------------------------- 
//  token 
//---------------------------------------------------------- 
- (id<Token>) getToken
{
    return token; 
}

- (void) setToken: (id<Token>) aToken
{
    token = aToken;
}

//---------------------------------------------------------- 
//  node 
//---------------------------------------------------------- 
- (id<BaseTree>) getNode
{
    return node; 
}

- (void) setNode: (id<BaseTree>) aNode
{
    node = aNode;
}

- (NSString *)getMessage
{
    return @"Fix getMessage in RecognitionException";
}

- (NSUInteger)charPositionInLine
{
    return charPositionInLine;
}

- (void)setCharPositionInLine:(NSUInteger)aPos
{
    charPositionInLine = aPos;
}

@end
