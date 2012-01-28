#import "TestTopologicalSort.h"

@implementation TestTopologicalSort

- (void) testFairlyLargeGraph {
  Graph * g = [[[Graph alloc] init] autorelease];
  [g addEdge:@"C" param1:@"F"];
  [g addEdge:@"C" param1:@"G"];
  [g addEdge:@"C" param1:@"A"];
  [g addEdge:@"C" param1:@"B"];
  [g addEdge:@"A" param1:@"D"];
  [g addEdge:@"A" param1:@"E"];
  [g addEdge:@"B" param1:@"E"];
  [g addEdge:@"D" param1:@"E"];
  [g addEdge:@"D" param1:@"F"];
  [g addEdge:@"F" param1:@"H"];
  [g addEdge:@"E" param1:@"F"];
  NSString * expecting = @"[H, F, E, D, G, A, B, C]";
  NSMutableArray * nodes = [g sort];
  NSString * result = [nodes description];
  [self assertEquals:expecting param1:result];
}

- (void) testCyclicGraph {
  Graph * g = [[[Graph alloc] init] autorelease];
  [g addEdge:@"A" param1:@"B"];
  [g addEdge:@"B" param1:@"C"];
  [g addEdge:@"C" param1:@"A"];
  [g addEdge:@"C" param1:@"D"];
  NSString * expecting = @"[D, C, B, A]";
  NSMutableArray * nodes = [g sort];
  NSString * result = [nodes description];
  [self assertEquals:expecting param1:result];
}

- (void) testRepeatedEdges {
  Graph * g = [[[Graph alloc] init] autorelease];
  [g addEdge:@"A" param1:@"B"];
  [g addEdge:@"B" param1:@"C"];
  [g addEdge:@"A" param1:@"B"];
  [g addEdge:@"C" param1:@"D"];
  NSString * expecting = @"[D, C, B, A]";
  NSMutableArray * nodes = [g sort];
  NSString * result = [nodes description];
  [self assertEquals:expecting param1:result];
}

- (void) testSimpleTokenDependence {
  Graph * g = [[[Graph alloc] init] autorelease];
  [g addEdge:@"Java.g" param1:@"MyJava.tokens"];
  [g addEdge:@"Java.tokens" param1:@"Java.g"];
  [g addEdge:@"Def.g" param1:@"Java.tokens"];
  [g addEdge:@"Ref.g" param1:@"Java.tokens"];
  NSString * expecting = @"[MyJava.tokens, Java.g, Java.tokens, Ref.g, Def.g]";
  NSMutableArray * nodes = [g sort];
  NSString * result = [nodes description];
  [self assertEquals:expecting param1:result];
}

- (void) testParserLexerCombo {
  Graph * g = [[[Graph alloc] init] autorelease];
  [g addEdge:@"JavaLexer.tokens" param1:@"JavaLexer.g"];
  [g addEdge:@"JavaParser.g" param1:@"JavaLexer.tokens"];
  [g addEdge:@"Def.g" param1:@"JavaLexer.tokens"];
  [g addEdge:@"Ref.g" param1:@"JavaLexer.tokens"];
  NSString * expecting = @"[JavaLexer.g, JavaLexer.tokens, JavaParser.g, Ref.g, Def.g]";
  NSMutableArray * nodes = [g sort];
  NSString * result = [nodes description];
  [self assertEquals:expecting param1:result];
}

@end
