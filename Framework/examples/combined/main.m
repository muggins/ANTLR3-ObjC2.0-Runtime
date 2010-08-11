#import <Cocoa/Cocoa.h>
#import "CombinedLexer.h"
#import "antlr3.h"

int main(int argc, const char * argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *string = @"xyyyyaxyyyyb";
	NSLog(@"%@", string);
	ANTLRStringStream *stream = [[ANTLRStringStream alloc] initWithStringNoCopy:string];
	CombinedLexer *lexer = [[CombinedLexer alloc] initWithCharStream:stream];
	id<ANTLRToken> currentToken;
	while ((currentToken = [lexer nextToken]) && [currentToken type] != ANTLRTokenTypeEOF) {
		NSLog(@"%@", currentToken);
	}
	[lexer release];
	[stream release];
	
	[pool release];
	return 0;
}