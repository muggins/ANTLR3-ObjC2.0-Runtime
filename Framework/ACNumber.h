//
//  ACNumber.h
//  ST4
//
//  Created by Alan Condit on 3/19/12.
//  Copyright 2012 Alan Condit. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ACNumber : NSNumber {
    
    union {
        BOOL b;
        char c;
        double d;
        float f;
        NSInteger i;
    } u;
    
    BOOL fBOOL   :  1;
    BOOL fChar   :  1;
    BOOL fDouble :  1;
    BOOL fFloat  :  1;
    BOOL fInt    :  1;
    BOOL fNSInt  :  1;
    char type_ar[15];
    char *type;
}

+ (ACNumber *)numberWithBool:(BOOL)aBool;
+ (ACNumber *)numberWithChar:(char)aChar;
+ (ACNumber *)numberWithFloat:(float)aFloat;
+ (ACNumber *)numberWithDouble:(double)aDouble;
+ (ACNumber *)numberWithInt:(NSInteger)anInt;
+ (ACNumber *)numberWithInteger:(NSInteger)anInt;

- (id)initWithBool:(BOOL)aBool;
- (id)initWithChar:(char)aChar;
- (id)initWithDouble:(double)aDouble;
- (id)initWithFloat:(float)aFloat;
- (id)initWithInt:(NSInteger)anInt;
- (id)initWithInteger:(NSInteger)anInt;

- (id)initWithCoder:(NSCoder *)decoder;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)copyWithZone:(NSZone *)zone;
- (BOOL)boolValue;
- (char)charValue;
- (double)doubleValue;
- (NSInteger)intValue;
- (NSInteger)integerValue;
- (NSInteger)inc;
- (NSInteger)add:(NSInteger)anInt;

- (BOOL)isEqualToValue:(NSValue *)value;
- (const char *)objCType;
- (NSComparisonResult)compare:(NSNumber *)aNumber;
- (NSString *)description;
- (NSString *)descriptionWithFormat:(NSString *)fmt locale:(NSLocale *)aLocale;
- (NSString *)descriptionWithLocale:(id)aLocale;
- (NSString *)stringValue;
- (NSNumber *)getNSNum;

@end
