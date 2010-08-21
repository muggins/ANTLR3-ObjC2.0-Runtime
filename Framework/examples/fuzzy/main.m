#import <Cocoa/Cocoa.h>
#import "FuzzyLexer.h"
#import "antlr3.h"

int main(int argc, const char * argv[])
{
    NSError *error;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *string = [NSString stringWithContentsOfFile:@"../../examples/fuzzy/input"  encoding:NSASCIIStringEncoding error:&error];
	NSLog(@"%@", string);
	ANTLRStringStream *stream = [[ANTLRStringStream alloc] initWithStringNoCopy:string];
	Fuzzy *lexer = [Fuzzy newFuzzy:stream];
	id<ANTLRToken> currentToken;
	while ((currentToken = [lexer nextToken]) && [currentToken getType] != ANTLRTokenTypeEOF) {
		NSLog(@"%@", currentToken);
	}
	[lexer release];
	[stream release];
	
	[pool release];
	return 0;
}