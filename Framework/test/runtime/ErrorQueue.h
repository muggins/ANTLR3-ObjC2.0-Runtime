#import "ANTLRErrorListener.h"
#import "Message.h"
#import "ToolMessage.h"
#import "NSMutableArray.h"
#import "NSMutableArray.h"

@interface ErrorQueue : NSObject <ANTLRErrorListener> {
  NSMutableArray * infos;
  NSMutableArray * errors;
  NSMutableArray * warnings;
}

- (void) init;
- (void) info:(NSString *)msg;
- (void) error:(Message *)msg;
- (void) warning:(Message *)msg;
- (void) error:(ToolMessage *)msg;
- (int) size;
- (NSString *) description;
@end
