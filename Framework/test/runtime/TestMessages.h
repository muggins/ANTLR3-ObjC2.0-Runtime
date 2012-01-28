#import "Tool.h"
#import "CodeGenerator.h"
#import "ANTLRParser.h"
#import "ActionTranslator.h"
#import "ErrorManager.h"
#import "Grammar.h"
#import "GrammarSemanticsMessage.h"
#import "Test.h"

@interface TestMessages : BaseTest {
}

- (id) init;
- (void) testMessageStringificationIsConsistent;
@end
