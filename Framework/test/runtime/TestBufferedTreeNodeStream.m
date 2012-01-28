#import "TestBufferedTreeNodeStream.h"

@implementation TestBufferedTreeNodeStream

- (TreeNodeStream *) newStream:(NSObject *)t {
  return [[[BufferedTreeNodeStream alloc] init:t] autorelease];
}

- (NSString *) toTokenTypeString:(TreeNodeStream *)stream {
  return [((BufferedTreeNodeStream *)stream) toTokenTypeString];
}

- (void) testSeek {
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
  [stream consume];
  [stream consume];
  [stream consume];
  [stream seek:7];
  [self assertEquals:107 param1:[((Tree *)[stream LT:1]) type]];
  [stream consume];
  [stream consume];
  [stream consume];
  [self assertEquals:104 param1:[((Tree *)[stream LT:1]) type]];
}

@end
