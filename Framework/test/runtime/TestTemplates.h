#import "Tool.h"
#import "CodeGenerator.h"
#import "ANTLRParser.h"
#import "ActionTranslator.h"
#import "StringTemplate.h"
#import "StringTemplateGroup.h"
#import "AngleBracketTemplateLexer.h"
#import "ErrorManager.h"
#import "Grammar.h"
#import "GrammarSemanticsMessage.h"
#import "Message.h"
#import "Test.h"

/**
 * Test templates in actions; %... shorthands
 */

@interface TestTemplates : BaseTest {
}

- (void) testTemplateConstructor;
- (void) testTemplateConstructorNoArgs;
- (void) testIndirectTemplateConstructor;
- (void) testStringConstructor;
- (void) testSetAttr;
- (void) testSetAttrOfExpr;
- (void) testSetAttrOfExprInMembers;
- (void) testCannotHaveSpaceBeforeDot;
- (void) testCannotHaveSpaceAfterDot;
- (void) checkError:(ErrorQueue *)equeue expectedMessage:(GrammarSemanticsMessage *)expectedMessage;
@end
