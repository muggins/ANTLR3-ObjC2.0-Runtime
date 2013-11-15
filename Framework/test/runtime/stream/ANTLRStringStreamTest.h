//
//  ANTLRStringStreamTest.h
//  ANTLR
//
//  Created by Ian Michell on 12/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface ANTLRStringStreamTest : SenTestCase {

}

-(void) test01InitWithInput;
-(void) test02ConsumeAndReset;
-(void) test03ConsumeWithNewLine;
-(void) test04Seek;
-(void) test05SeekMarkAndRewind;
-(void) test06LAEOF;
-(void) test07LTEOF; // same as LA

@end
