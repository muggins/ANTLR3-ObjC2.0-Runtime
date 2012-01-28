#import "CommonTree.h"
#import "CommonTreeAdaptor.h"
#import "TreeAdaptor.h"
#import "TreeWizard.h"
#import "Test.h"
#import "NSMutableArray.h"
#import "NSMutableDictionary.h"
#import "NSMutableArray.h"
#import "NSMutableDictionary.h"

@interface TestTreeWizard_Anon1 : NSObject <Visitor> {
}

- (void) visit:(NSObject *)t;
@end

@interface TestTreeWizard_Anon2 : NSObject <Visitor> {
}

- (void) visit:(NSObject *)t;
@end

@interface TestTreeWizard_Anon3 : NSObject <Visitor> {
}

- (void) visit:(NSObject *)t;
@end

@interface TestTreeWizard_Anon4 : NSObject <Visitor> {
}

- (void) visit:(NSObject *)t;
@end

@interface TestTreeWizard_Anon5 : NSObject <ContextVisitor> {
}

- (void) visit:(NSObject *)t parent:(NSObject *)parent childIndex:(int)childIndex labels:(NSMutableDictionary *)labels;
@end

@interface TestTreeWizard_Anon6 : NSObject <ContextVisitor> {
}

- (void) visit:(NSObject *)t parent:(NSObject *)parent childIndex:(int)childIndex labels:(NSMutableDictionary *)labels;
@end

@interface TestTreeWizard_Anon7 : NSObject <Visitor> {
}

- (void) visit:(NSObject *)t;
@end

@interface TestTreeWizard_Anon8 : NSObject <ContextVisitor> {
}

- (void) visit:(NSObject *)t parent:(NSObject *)parent childIndex:(int)childIndex labels:(NSMutableDictionary *)labels;
@end

@interface TestTreeWizard_Anon9 : NSObject <ContextVisitor> {
}

- (void) visit:(NSObject *)t parent:(NSObject *)parent childIndex:(int)childIndex labels:(NSMutableDictionary *)labels;
@end

@interface TestTreeWizard : BaseTest {
}

- (void) testSingleNode;
- (void) testSingleNodeWithArg;
- (void) testSingleNodeTree;
- (void) testSingleLevelTree;
- (void) testListTree;
- (void) testInvalidListTree;
- (void) testDoubleLevelTree;
- (void) testSingleNodeIndex;
- (void) testNoRepeatsIndex;
- (void) testRepeatsIndex;
- (void) testNoRepeatsVisit;
- (void) testNoRepeatsVisit2;
- (void) testRepeatsVisit;
- (void) testRepeatsVisit2;
- (void) testRepeatsVisitWithContext;
- (void) testRepeatsVisitWithNullParentAndContext;
- (void) testVisitPattern;
- (void) testVisitPatternMultiple;
- (void) testVisitPatternMultipleWithLabels;
- (void) testParse;
- (void) testParseSingleNode;
- (void) testParseFlatTree;
- (void) testWildcard;
- (void) testParseWithText;
- (void) testParseWithText2;
- (void) testParseWithTextFails;
- (void) testParseLabels;
- (void) testParseWithWildcardLabels;
- (void) testParseLabelsAndTestText;
- (void) testParseLabelsInNestedTree;
- (void) testEquals;
- (void) testEqualsWithText;
- (void) testEqualsWithMismatchedText;
- (void) testFindPattern;
@end
