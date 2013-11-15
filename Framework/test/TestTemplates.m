#import "TestTemplates.h"

NSString *const LINE_SEP = [System getProperty:@"line.separator"];

@implementation TestTemplates

- (void) testTemplateConstructor
{
    NSString *action = @"x = %foo(name={$ID.text});";
    NSString *expecting = [[@"x = templateLib.getInstanceOf(\"foo\")" stringByAppendingString:LINE_SEP] stringByAppendingString:@"  .add(\"name\", (ID1!=null?ID1.getText():null));"];
    ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
    [ErrorManager setErrorListener:equeue];
    Grammar *g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"options {\n    output=template;\n}\n\n"]
        stringByAppendingString:@"a : ID {"]
        stringByAppendingString:action]
        stringByAppendingString:@"}\n"]
        stringByAppendingString:@"  ;\n\n"]
        stringByAppendingString:@"ID : 'a';\n"]] autorelease];
    Tool *antlr = [self newTool];
    CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
    [g setCodeGenerator:generator];
    [generator genRecognizer];
    ActionTranslator *translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
    NSString *rawTranslation = [translator translate];
    StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
    StringTemplate *actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
    NSString *found = [actionST description];
    [self assertNoErrors:equeue];
    [self assertEquals:expecting param1:found];
}

- (void) testTemplateConstructorNoArgs
{
    NSString *action = @"x = %foo();";
    NSString *expecting = [[@"x = templateLib.getInstanceOf(\"foo\")" stringByAppendingString:LINE_SEP] stringByAppendingString:@";"];
    ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
    [ErrorManager setErrorListener:equeue];
    Grammar *g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"options {\n    output=template;\n}\n\n"]
        stringByAppendingString:@"a : ID {"]
        stringByAppendingString:action]
        stringByAppendingString:@"}\n"]
        stringByAppendingString:@"  ;\n\n"]
        stringByAppendingString:@"ID : 'a';\n"]] autorelease];
    Tool *antlr = [self newTool];
    CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
    [g setCodeGenerator:generator];
    [generator genRecognizer];
    ActionTranslator *translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
    NSString *rawTranslation = [translator translate];
    StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
    StringTemplate *actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
    NSString *found = [actionST description];
    [self assertNoErrors:equeue];
    [self assertEquals:expecting param1:found];
}

- (void) testIndirectTemplateConstructor {
    NSString *action = @"x = %({\"foo\"})(name={$ID.text});";
    NSString *expecting = [[@"x = templateLib.getInstanceOf(\"foo\")" stringByAppendingString:LINE_SEP]
        stringByAppendingString:@"  .add(\"name\", (ID1!=null?ID1.getText():null));"];
    ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
    [ErrorManager setErrorListener:equeue];
    Grammar *g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"options {\n    output=template;\n}\n\n"]
        stringByAppendingString:@"a : ID {"]
        stringByAppendingString:action]
        stringByAppendingString:@"}\n"]
        stringByAppendingString:@"  ;\n\n"]
        stringByAppendingString:@"ID : 'a';\n"]] autorelease];
    Tool *antlr = [self newTool];
    CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
    [g setCodeGenerator:generator];
    [generator genRecognizer];
    ActionTranslator *translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
    NSString *rawTranslation = [translator translate];
    StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
    StringTemplate *actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
    NSString *found = [actionST description];
    [self assertNoErrors:equeue];
    [self assertEquals:expecting param1:found];
}

- (void) testStringConstructor {
    NSString *action = @"x = %{$ID.text};";
    NSString *expecting = @"x = new ST(templateLib,(ID1!=null?ID1.getText():null));";
    ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
    [ErrorManager setErrorListener:equeue];
    Grammar *g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"options {\n    output=template;\n}\n\n"] stringByAppendingString:@"a : ID {"]
        stringByAppendingString:action]
        stringByAppendingString:@"}\n"]
        stringByAppendingString:@"  ;\n\n"]
        stringByAppendingString:@"ID : 'a';\n"]] autorelease];
    Tool *antlr = [self newTool];
    CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
    [g setCodeGenerator:generator];
    [generator genRecognizer];
    ActionTranslator *translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
    NSString *rawTranslation = [translator translate];
    StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
    StringTemplate *actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
    NSString *found = [actionST description];
    [self assertNoErrors:equeue];
    [self assertEquals:expecting param1:found];
}

- (void) testSetAttr {
    NSString *action = @"%x.y = z;";
    NSString *expecting = @"(x).setAttribute(\"y\", z);";
    ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
    [ErrorManager setErrorListener:equeue];
    Grammar *g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"options {\n    output=template;\n}\n\n"]
        stringByAppendingString:@"a : ID {"]
        stringByAppendingString:action]
        stringByAppendingString:@"}\n"]
        stringByAppendingString:@"  ;\n\n"]
        stringByAppendingString:@"ID : 'a';\n"]] autorelease];
    Tool *antlr = [self newTool];
    CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
    [g setCodeGenerator:generator];
    [generator genRecognizer];
    ActionTranslator *translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
    NSString *rawTranslation = [translator translate];
    StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
    StringTemplate *actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
    NSString *found = [actionST description];
    [self assertNoErrors:equeue];
    [self assertEquals:expecting param1:found];
}

- (void) testSetAttrOfExpr {
    NSString *action = @"%{foo($ID.text).getST()}.y = z;";
    NSString *expecting = @"(foo((ID1!=null?ID1.getText():null)).getST()).setAttribute(\"y\", z);";
    ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
    [ErrorManager setErrorListener:equeue];
    Grammar *g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"options {\n    output=template;\n}\n\n"]
        stringByAppendingString:@"a : ID {"]
        stringByAppendingString:action]
        stringByAppendingString:@"}\n"]
        stringByAppendingString:@"  ;\n\n"]
        stringByAppendingString:@"ID : 'a';\n"]] autorelease];
    Tool *antlr = [self newTool];
    CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
    [g setCodeGenerator:generator];
    [generator genRecognizer];
    ActionTranslator *translator = [[[ActionTranslator alloc] init:generator param1:@"a" param2:[[[CommonToken alloc] init:ANTLRParser.ACTION param1:action] autorelease] param3:1] autorelease];
    NSString *rawTranslation = [translator translate];
    StringTemplateGroup * templates = [[[StringTemplateGroup alloc] init:@"." param1:[AngleBracketTemplateLexer class]] autorelease];
    StringTemplate *actionST = [[[StringTemplate alloc] init:templates param1:rawTranslation] autorelease];
    NSString *found = [actionST description];
    [self assertNoErrors:equeue];
    [self assertEquals:expecting param1:found];
}

- (void) testSetAttrOfExprInMembers {
    ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
    [ErrorManager setErrorListener:equeue];
    Grammar *g = [[[Grammar alloc] init:[[[[[@"grammar t;\n" stringByAppendingString:@"options {\n    output=template;\n}\n"] stringByAppendingString:@"@members {\n%code.instr = o;}\n"]
        stringByAppendingString:@"a : ID\n"]
        stringByAppendingString:@"  ;\n\n"]
        stringByAppendingString:@"ID : 'a';\n"]] autorelease];
    Tool *antlr = [self newTool];
    CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
    [g setCodeGenerator:generator];
    [generator genRecognizer];
    [self assertNoErrors:equeue];
}

- (void) testCannotHaveSpaceBeforeDot {
    NSString *action = @"%x .y = z;";
    NSString *expecting = nil;
    ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
    [ErrorManager setErrorListener:equeue];
    Grammar *g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"options {\n    output=template;\n}\n\n"]
            stringByAppendingString:@"a : ID {"]
            stringByAppendingString:action]
            stringByAppendingString:@"}\n"]
            stringByAppendingString:@"  ;\n\n"]
            stringByAppendingString:@"ID : 'a';\n"]] autorelease];
    Tool *antlr = [self newTool];
    CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
    [g setCodeGenerator:generator];
    [generator genRecognizer];
    int expectedMsgID = ErrorManager.MSG_INVALID_TEMPLATE_ACTION;
    NSObject * expectedArg = @"%x";
    GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
    [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) testCannotHaveSpaceAfterDot {
    NSString *action = @"%x. y = z;";
    NSString *expecting = nil;
    ErrorQueue *equeue = [[[ErrorQueue alloc] init] autorelease];
    [ErrorManager setErrorListener:equeue];
    Grammar *g = [[[Grammar alloc] init:[[[[[[@"grammar t;\n" stringByAppendingString:@"options {\n    output=template;\n}\n\n"]
        stringByAppendingString:@"a : ID {"]
        stringByAppendingString:action]
        stringByAppendingString:@"}\n"]
        stringByAppendingString:@"  ;\n\n"]
        stringByAppendingString:@"ID : 'a';\n"]] autorelease];
    Tool *antlr = [self newTool];
    CodeGenerator * generator = [[[CodeGenerator alloc] init:antlr param1:g param2:@"Java"] autorelease];
    [g setCodeGenerator:generator];
    [generator genRecognizer];
    int expectedMsgID = ErrorManager.MSG_INVALID_TEMPLATE_ACTION;
    NSObject * expectedArg = @"%x.";
    GrammarSemanticsMessage * expectedMessage = [[[GrammarSemanticsMessage alloc] init:expectedMsgID param1:g param2:nil param3:expectedArg] autorelease];
    [self checkError:equeue expectedMessage:expectedMessage];
}

- (void) checkError:(ErrorQueue *)equeue expectedMessage:(GrammarSemanticsMessage *)expectedMessage {
    Message * foundMsg = nil;
    
    for (int i = 0; i < [equeue.errors size]; i++) {
        Message * m = (Message *)[equeue.errors get:i];
        if (m.msgID == expectedMessage.msgID) {
            foundMsg = m;
        }
    }
    
    [self assertTrue:[[@"no error; " stringByAppendingString:expectedMessage.msgID] stringByAppendingString:@" expected"] param1:[equeue.errors size] > 0];
    [self assertTrue:[@"too many errors; " stringByAppendingString:equeue.errors] param1:[equeue.errors size] <= 1];
    [self assertTrue:[@"couldn't find expected error: " stringByAppendingString:expectedMessage.msgID] param1:foundMsg != nil];
    [self assertTrue:@"error is not a GrammarSemanticsMessage" param1:[foundMsg conformsToProtocol:@protocol(GrammarSemanticsMessage)]];
    [self assertEquals:expectedMessage.arg param1:foundMsg.arg];
    [self assertEquals:expectedMessage.arg2 param1:foundMsg.arg2];
}

- (void) assertNoErrors:(ErrorQueue *)equeue {
    [self assertTrue:[@"unexpected errors: " stringByAppendingString:equeue] param1:[equeue.errors size] == 0];
}

@end
