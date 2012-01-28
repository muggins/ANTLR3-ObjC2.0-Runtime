#import "TestTreeNodeStream.h"

@implementation TestTreeNodeStream


/**
 * Build new stream; let's us override to test other streams.
 */
- (TreeNodeStream *) newStream:(NSObject *)t {
  return [[[CommonTreeNodeStream alloc] init:t] autorelease];
}

- (NSString *) toTokenTypeString:(TreeNodeStream *)stream {
  return [((CommonTreeNodeStream *)stream) toTokenTypeString];
}

- (void) testSingleNode {
  Tree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
  TreeNodeStream * stream = [self newStream:t];
  NSString * expecting = @" 101";
  NSString * found = [self toNodesOnlyString:stream];
  [self assertEquals:expecting param1:found];
  expecting = @" 101";
  found = [self toTokenTypeString:stream];
  [self assertEquals:expecting param1:found];
}

- (void) test4Nodes {
  Tree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
  [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
  [[t getChild:0] addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
  [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:104] autorelease]] autorelease]];
  TreeNodeStream * stream = [self newStream:t];
  NSString * expecting = @" 101 102 103 104";
  NSString * found = [self toNodesOnlyString:stream];
  [self assertEquals:expecting param1:found];
  expecting = @" 101 2 102 2 103 3 104 3";
  found = [self toTokenTypeString:stream];
  [self assertEquals:expecting param1:found];
}

- (void) testList {
  Tree * root = [[[CommonTree alloc] init:(Token *)nil] autorelease];
  Tree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
  [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
  [[t getChild:0] addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
  [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:104] autorelease]] autorelease]];
  Tree * u = [[[CommonTree alloc] init:[[[CommonToken alloc] init:105] autorelease]] autorelease];
  [root addChild:t];
  [root addChild:u];
  TreeNodeStream * stream = [self newStream:root];
  NSString * expecting = @" 101 102 103 104 105";
  NSString * found = [self toNodesOnlyString:stream];
  [self assertEquals:expecting param1:found];
  expecting = @" 101 2 102 2 103 3 104 3 105";
  found = [self toTokenTypeString:stream];
  [self assertEquals:expecting param1:found];
}

- (void) testFlatList {
  Tree * root = [[[CommonTree alloc] init:(Token *)nil] autorelease];
  [root addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease]];
  [root addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
  [root addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
  TreeNodeStream * stream = [self newStream:root];
  NSString * expecting = @" 101 102 103";
  NSString * found = [self toNodesOnlyString:stream];
  [self assertEquals:expecting param1:found];
  expecting = @" 101 102 103";
  found = [self toTokenTypeString:stream];
  [self assertEquals:expecting param1:found];
}

- (void) testListWithOneNode {
  Tree * root = [[[CommonTree alloc] init:(Token *)nil] autorelease];
  [root addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease]];
  TreeNodeStream * stream = [self newStream:root];
  NSString * expecting = @" 101";
  NSString * found = [self toNodesOnlyString:stream];
  [self assertEquals:expecting param1:found];
  expecting = @" 101";
  found = [self toTokenTypeString:stream];
  [self assertEquals:expecting param1:found];
}

- (void) testAoverB {
  Tree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
  [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
  TreeNodeStream * stream = [self newStream:t];
  NSString * expecting = @" 101 102";
  NSString * found = [self toNodesOnlyString:stream];
  [self assertEquals:expecting param1:found];
  expecting = @" 101 2 102 3";
  found = [self toTokenTypeString:stream];
  [self assertEquals:expecting param1:found];
}

- (void) testLT {
  Tree * t = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
  [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease]];
  [[t getChild:0] addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
  [t addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:104] autorelease]] autorelease]];
  TreeNodeStream * stream = [self newStream:t];
  [self assertEquals:101 param1:[((Tree *)[stream LT:1]) type]];
  [self assertEquals:Token.DOWN param1:[((Tree *)[stream LT:2]) type]];
  [self assertEquals:102 param1:[((Tree *)[stream LT:3]) type]];
  [self assertEquals:Token.DOWN param1:[((Tree *)[stream LT:4]) type]];
  [self assertEquals:103 param1:[((Tree *)[stream LT:5]) type]];
  [self assertEquals:Token.UP param1:[((Tree *)[stream LT:6]) type]];
  [self assertEquals:104 param1:[((Tree *)[stream LT:7]) type]];
  [self assertEquals:Token.UP param1:[((Tree *)[stream LT:8]) type]];
  [self assertEquals:Token.EOF param1:[((Tree *)[stream LT:9]) type]];
  [self assertEquals:Token.EOF param1:[((Tree *)[stream LT:100]) type]];
}

- (void) testMarkRewindEntire {
  Tree * r0 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
  Tree * r1 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease];
  [r0 addChild:r1];
  [r1 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
  Tree * r2 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:106] autorelease]] autorelease];
  [r2 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:107] autorelease]] autorelease]];
  [r1 addChild:r2];
  [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:104] autorelease]] autorelease]];
  [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:105] autorelease]] autorelease]];
  TreeNodeStream * stream = [self newStream:r0];
  int m = [stream mark];

  for (int k = 1; k <= 13; k++) {
    [stream LT:1];
    [stream consume];
  }

  [self assertEquals:Token.EOF param1:[((Tree *)[stream LT:1]) type]];
  [stream rewind:m];

  for (int k = 1; k <= 13; k++) {
    [stream LT:1];
    [stream consume];
  }

  [self assertEquals:Token.EOF param1:[((Tree *)[stream LT:1]) type]];
}

- (void) testMarkRewindInMiddle {
  Tree * r0 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
  Tree * r1 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease];
  [r0 addChild:r1];
  [r1 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
  Tree * r2 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:106] autorelease]] autorelease];
  [r2 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:107] autorelease]] autorelease]];
  [r1 addChild:r2];
  [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:104] autorelease]] autorelease]];
  [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:105] autorelease]] autorelease]];
  TreeNodeStream * stream = [self newStream:r0];

  for (int k = 1; k <= 7; k++) {
    [stream consume];
  }

  [self assertEquals:107 param1:[((Tree *)[stream LT:1]) type]];
  [stream mark];
  [stream consume];
  [stream consume];
  [stream consume];
  [stream consume];
  [stream rewind];
  [stream mark];
  [self assertEquals:107 param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [self assertEquals:Token.UP param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [self assertEquals:Token.UP param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [self assertEquals:104 param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [self assertEquals:105 param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [self assertEquals:Token.UP param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [self assertEquals:Token.EOF param1:[((Tree *)[stream LT:1]) type]];
  [self assertEquals:Token.UP param1:[((Tree *)[stream LT:-1]) type]];
}

- (void) testMarkRewindNested {
  Tree * r0 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
  Tree * r1 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease];
  [r0 addChild:r1];
  [r1 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
  Tree * r2 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:106] autorelease]] autorelease];
  [r2 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:107] autorelease]] autorelease]];
  [r1 addChild:r2];
  [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:104] autorelease]] autorelease]];
  [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:105] autorelease]] autorelease]];
  TreeNodeStream * stream = [self newStream:r0];
  int m = [stream mark];
  [stream consume];
  [stream consume];
  int m2 = [stream mark];
  [stream consume];
  [stream consume];
  [stream consume];
  [stream consume];
  [stream rewind:m2];
  [self assertEquals:102 param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [self assertEquals:Token.DOWN param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [stream rewind:m];
  [self assertEquals:101 param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [self assertEquals:Token.DOWN param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [self assertEquals:102 param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [self assertEquals:Token.DOWN param1:[((Tree *)[stream LT:1]) type]];
}

- (void) testSeekFromStart {
  Tree * r0 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
  Tree * r1 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease];
  [r0 addChild:r1];
  [r1 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
  Tree * r2 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:106] autorelease]] autorelease];
  [r2 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:107] autorelease]] autorelease]];
  [r1 addChild:r2];
  [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:104] autorelease]] autorelease]];
  [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:105] autorelease]] autorelease]];
  TreeNodeStream * stream = [self newStream:r0];
  [stream seek:7];
  [self assertEquals:107 param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [stream consume];
  [stream consume];
  [self assertEquals:104 param1:[((Tree *)[stream LT:1]) type]];
}

- (void) testReset {
  Tree * r0 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:101] autorelease]] autorelease];
  Tree * r1 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:102] autorelease]] autorelease];
  [r0 addChild:r1];
  [r1 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:103] autorelease]] autorelease]];
  Tree * r2 = [[[CommonTree alloc] init:[[[CommonToken alloc] init:106] autorelease]] autorelease];
  [r2 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:107] autorelease]] autorelease]];
  [r1 addChild:r2];
  [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:104] autorelease]] autorelease]];
  [r0 addChild:[[[CommonTree alloc] init:[[[CommonToken alloc] init:105] autorelease]] autorelease]];
  TreeNodeStream * stream = [self newStream:r0];
  NSString * v = [self toNodesOnlyString:stream];
  [stream reset];
  NSString * v2 = [self toNodesOnlyString:stream];
  [self assertEquals:v param1:v2];
}

- (NSString *) toNodesOnlyString:(TreeNodeStream *)nodes {
  TreeAdaptor * adaptor = [nodes treeAdaptor];
  StringBuffer * buf = [[[StringBuffer alloc] init] autorelease];
  NSObject * o = [nodes LT:1];
  int type = [adaptor getType:o];

  while (o != nil && type != Token.EOF) {
    if (!(type == Token.DOWN || type == Token.UP)) {
      [buf append:@" "];
      [buf append:type];
    }
    [nodes consume];
    o = [nodes LT:1];
    type = [adaptor getType:o];
  }

  return [buf description];
}

@end
