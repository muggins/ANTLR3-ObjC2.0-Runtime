//
//  ANTLRCommonTreeTest.h
//  ANTLR
//
//  Created by Ian Michell on 26/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface ANTLRCommonTreeTest : SenTestCase 
{
}

#ifdef DONTUSENOMO
-(void) test01InitAndRelease;
#endif
-(void) test02InitWithTree;
#ifdef DONTUSENOMO
-(void) test03InvalidTreeNode;
-(void) test04InitWithCommonTreeNode;
-(void) test05CopyTree;
-(void) test06Description;
-(void) test07Text;
-(void) test08AddChild;
-(void) test09AddChildren;
-(void) test10AddSelfAsChild;
-(void) test11AddEmptyChildWithNoChildren;
-(void) test12AddEmptyChildWithChildren;
-(void) test13ChildAtIndex;
-(void) test14SetChildAtIndex;
-(void) test15GetAncestor;
-(void) test16FirstChildWithType;
-(void) test17SanityCheckParentAndChildIndexesForParentTree;
-(void) test18DeleteChild;
-(void) test19TreeDescriptions;
-(void) test20ReplaceChildrenAtIndexWithNoChildren;
-(void) test21ReplaceChildrenAtIndex;
-(void) test22ReplaceChildrenAtIndexWithChild;
-(void) test23ReplacechildrenAtIndexWithLessChildren;
#endif
-(void) test24ReplacechildrenAtIndexWithMoreChildren;

@end
