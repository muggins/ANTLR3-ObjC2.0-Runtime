#import "ANTLRErrorListener.h"
// #import "Message.h"
// #import "ToolMessage.h"
#import "AMutableArray.h"

@interface ErrorQueue : NSObject <ANTLRErrorListener> {
  AMutableArray *infos;
  AMutableArray *errors;
  AMutableArray *warnings;
}

@property (retain) AMutableArray *infos;
@property (retain) AMutableArray *errors;
@property (retain) AMutableArray *warnings;

- (id) init;
- (void) info:(NSString *)msg;
- (void) error:(id)msg;
- (void) warning:(id)msg;
- (NSInteger) size;
- (NSString *) description;
@end
