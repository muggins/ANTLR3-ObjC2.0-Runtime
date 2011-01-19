#import <Cocoa/Cocoa.h>
#import <antlr3.h>
#import "TLexer.h"
#import "TParser.h"

int main() {
    NSError *error;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *string = [NSString stringWithContentsOfFile:@"../../examples/hoistedPredicates/input" encoding:NSASCIIStringEncoding error:&error];
	NSLog(@"input is : %@", string);
	ANTLRStringStream *stream = [ANTLRStringStream newANTLRStringStream:string];
	TLexer *lexer = [TLexer newTLexerWithCharStream:stream];
	
//	ANTLRCommonToken *currentToken;
//	while ((currentToken = [lexer nextToken]) && [currentToken getType] != ANTLRTokenTypeEOF) {
//		NSLog(@"%@", [currentToken toString]);
//	}
	
	ANTLRCommonTokenStream *tokens = [ANTLRCommonTokenStream newANTLRCommonTokenStreamWithTokenSource:lexer];
	TParser *parser = [[TParser alloc] initWithTokenStream:tokens];
	[parser stat];
	[lexer release];
	[stream release];
	[tokens release];
	[parser release];
	
	[pool release];
	return 0;
}