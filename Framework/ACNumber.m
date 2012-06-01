//
//  ACNumber.m
//  ST4
//
//  Created by Alan Condit on 3/19/12.
//  Copyright 2012 Alan Condit. All rights reserved.
//

#import "ACNumber.h"


@implementation ACNumber

+ (ACNumber *)numberWithBool:(BOOL)aBool
{
    return [[ACNumber alloc] initWithBool:aBool];
}

+ (ACNumber *)numberWithChar:(char)aChar
{
    return [[ACNumber alloc] initWithChar:aChar];
}

+ (ACNumber *)numberWithFloat:(float)aFloat
{
    return [[ACNumber alloc] initWithFloat:aFloat];
}

+ (ACNumber *)numberWithDouble:(double)aDouble
{
    return [[ACNumber alloc] initWithDouble:aDouble];
}

+ (ACNumber *)numberWithInt:(int)anInt
{
    return [[ACNumber alloc] initWithInt:anInt];
}

+ (ACNumber *)numberWithInteger:(NSInteger)anInt
{
    return [[ACNumber alloc] initWithInteger:anInt];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithBool:(BOOL)aBool
{
    self = [super init];
    if ( self != nil ) {
        fBOOL = YES;
        fChar = NO;
        fDouble = NO;
        fFloat = NO;
        fInt = NO;
        fNSInt = NO;
        u.b = aBool;
        strcpy( type_ar, "BOOL" );
        type = type_ar;
    }
    return self;
}

- (id)initWithChar:(char)aChar
{
    self = [super init];
    if ( self != nil ) {
        fBOOL = NO;
        fChar = YES;
        fDouble = NO;
        fFloat = NO;
        fInt = NO;
        fNSInt = NO;
        u.c = aChar;
        strcpy( type_ar, "char" );
        type = type_ar;
    }
    return self;
}

- (id)initWithDouble:(double)aDouble
{
    self = [super init];
    if ( self != nil ) {
        fBOOL = NO;
        fChar = NO;
        fDouble = YES;
        fFloat = NO;
        fInt = NO;
        fNSInt = NO;
        u.d = aDouble;
        strcpy( type_ar, "double" );
        type = type_ar;
    }
    return self;
}

- (id)initWithFloat:(float)aFloat
{
    self = [super init];
    if ( self != nil ) {
        fBOOL = NO;
        fChar = NO;
        fDouble = NO;
        fFloat = YES;
        fInt = NO;
        fNSInt = NO;
        u.f = aFloat;
        strcpy( type_ar, "float" );
        type = type_ar;
    }
    return self;
}

- (id)initWithInt:(int)anInt
{
    self = [super init];
    if ( self != nil ) {
        fBOOL = NO;
        fChar = NO;
        fDouble = NO;
        fFloat = NO;
        fInt = YES;
        fNSInt = NO;
        u.i = (NSInteger) anInt;
        strcpy( type_ar, "int" );
        type = type_ar;
    }
    return self;
}

- (id)initWithInteger:(NSInteger)anInt
{
    self = [super init];
    if ( self != nil ) {
        fBOOL = NO;
        fChar = NO;
        fDouble = NO;
        fFloat = NO;
        fInt = NO;
        fNSInt = YES;
        u.i = anInt;
        strcpy( type_ar, "NSInteger" );
        type = type_ar;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if ( self ) {
        // Initialization code here.
        fBOOL = NO;
        fChar = NO;
        fDouble = NO;
        fInt = NO;
        fNSInt = NO;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    // Initialization code here.
    fBOOL = NO;
    fChar = NO;
    fDouble = NO;
    fInt = NO;
    fNSInt = NO;
    if ( fBOOL ) {
        [encoder encodeBool:u.b forKey:[NSString stringWithCString:type encoding:NSASCIIStringEncoding]];;
    } else if ( fChar ) {
        [encoder encodeBytes:(const uint8_t *)&u.c length:1 forKey:[NSString stringWithCString:type encoding:NSASCIIStringEncoding]];;
    } else if ( fDouble ) {
        [encoder encodeBool:u.d forKey:[NSString stringWithCString:type encoding:NSASCIIStringEncoding]];;
    } else if ( fFloat ) {
        [encoder encodeBool:u.f forKey:[NSString stringWithCString:type encoding:NSASCIIStringEncoding]];;
    } else if ( fInt ) {
        [encoder encodeInt:(int)u.i forKey:[NSString stringWithCString:type encoding:NSASCIIStringEncoding]];;
    } else if ( fNSInt ) {
        [encoder encodeInteger:u.i forKey:[NSString stringWithCString:type encoding:NSASCIIStringEncoding]];;
    } else {
        NSLog( @"Attempted to create an unsupported type \"%s\"\n", type );
        type_ar[0] = '\0';
    }
    return;
}

- (id)copyWithZone:(NSZone *)zone
{
    return nil;
}

- (BOOL)boolValue
{
    if (fBOOL)
        return u.b;
    else if ( fChar )
        return (BOOL) u.c;
    else if ( fDouble )
        return (BOOL) u.d;
    else if ( fFloat )
        return (BOOL) u.f;
    else if ( fInt || fNSInt )
        return (BOOL) u.i;
    return NO;
}

- (char)charValue
{
    if (fChar)
        return u.c;
    else if ( fBOOL ) 
        return (char) u.b;
    else if ( fDouble )
        return (char) u.d;
    else if ( fFloat )
        return (char) u.f;
    else if ( fInt || fNSInt )
        return (char) u.i;
    return (char)0;
}

- (double)doubleValue
{
    if (fDouble)
        return u.d;
    else if ( fBOOL )
        return (double) u.b;
    else if ( fChar )
        return (double) u.c;
    else if ( fFloat )
        return (double) u.f;
    else if ( fInt || fNSInt )
        return (double) u.i;
    return (double)0.0;
}

- (float)floatValue
{
    if (fFloat)
        return u.f;
    else if ( fBOOL )
        return (float) u.b;
    else if ( fChar )
        return (float) u.c;
    else if ( fDouble )
        return (float) u.d;
    else if ( fInt || fNSInt )
        return (float) u.i;
    return (float)0.0;
}

- (int)intValue
{
    if (fInt)
        return (int)u.i;
    else if ( fChar )
        return (int) u.c;
    else if ( fDouble )
        return (int) u.d;
    else if ( fFloat )
        return (int) u.f;
    else if ( fNSInt )
        return (int) u.i;
    return (int)0;
}

- (NSInteger)integerValue
{
    if (fNSInt)
        return u.i;
    else if ( fBOOL )
        return (NSInteger) u.b;
    else if ( fChar ) {
        return (NSInteger) u.c;
    } else if ( fDouble ) {
        return (NSInteger) u.d;
    } else if ( fFloat ) {
        return (NSInteger) u.f;
    } else if ( fInt || fNSInt ) {
        return (NSInteger) u.i;
    }
    return (NSInteger)0;
}

- (NSInteger)inc
{
    return (u.i+=1);
}

- (NSInteger)add:(NSInteger)anInt
{
    return (u.i+=anInt);
}

- (BOOL)isEqualToValue:(NSValue *)value
{
    char val[16];
    if ( strcmp( [value objCType], type ) == 0 ) {
        [value getValue:val];
        if ( fBOOL ) {
            BOOL *bp = (BOOL *) val;
            return (*bp == u.b) ? YES : NO;
        } else if ( fChar ) {
            char *cp = (char *) val;
            return (*cp == u.c) ? YES : NO;
        } else if ( fDouble ) {
            double *dp = (double *) val;
            return (*dp == u.d) ? YES : NO;
        } else if ( fInt ) {
            int *ip = (int *) val;
            return (*ip == (int) u.i) ? YES : NO;
        } else if ( fNSInt ) {
            NSInteger *np = (NSInteger *) val;
            return (*np == u.i) ? YES : NO;
        }
    }
    return NO;
}

- (const char *)objCType
{
    return type;
}

- (void)getValue:(void *)buffer
{
    if ( fBOOL ) {
        BOOL *bp = (BOOL *) buffer;
        *bp = u.b;
    } else if ( fChar ) {
        char *cp = (char *) buffer;
        *cp = u.c;
    } else if ( fDouble ) {
        double *dp = (double *) buffer;
        *dp = u.d;
    } else if ( fInt ) {
        int *ip = (int *) buffer;
        *ip = (int) u.i;
    } else if ( fNSInt ) {
        NSInteger *np = (NSInteger *) buffer;
        *np = u.i;
    }
}

- (NSComparisonResult)compare:(NSNumber *)aNumber
{
    if (fBOOL)
        return ([self boolValue] - [aNumber boolValue]); 
    else if (fChar)
        return u.c - [aNumber charValue];
    else if (fInt)
        return u.i - [aNumber intValue];
    else if (fNSInt)
        return u.i - [aNumber integerValue];
    else if (fDouble)
        return u.d - [aNumber doubleValue];
    return -1;
}

- (NSNumber *)getNSNum
{
    if (fBOOL)
        return [NSNumber numberWithBool:u.b]; 
    else if (fChar)
        return [NSNumber numberWithInt:u.c];
    else if (fInt)
        return [NSNumber numberWithInt:u.i];
    else if (fNSInt)
        return [NSNumber numberWithInteger:u.i];
    else if (fDouble)
        return [NSNumber numberWithDouble:u.d];
    return nil;
}


- (NSString *)description
{
    return [self descriptionWithLocale:nil];
}

- (NSString *)descriptionWithFormat:(NSString *)fmt locale:(NSLocale *)aLocale
{
    if (fBOOL)
        return (u.b == YES) ? @"true" : @"false"; 
    else if (fChar)
        return [NSString stringWithFormat:fmt, u.c];
    else if (fInt)
        return [NSString stringWithFormat:fmt, (int)u.i];
    else if (fNSInt)
        return [NSString stringWithFormat:fmt, u.i];
    else if (fDouble)
        return [NSString stringWithFormat:fmt, u.d];
    return @"ACNumber not valid";
}

- (NSString *)descriptionWithLocale:(id)aLocale
{
    if (fBOOL)
        return (u.b == YES) ? @"true" : @"false"; 
    else if (fChar)
        return [[NSString alloc] initWithFormat:@"%c" locale:aLocale, u.c];
    else if (fInt)
        return [[NSString alloc] initWithFormat:@"%i" locale:aLocale, (int)u.i];
    else if (fNSInt)
        return [[NSString alloc] initWithFormat:@"%Li" locale:aLocale, u.i];
    else if (fFloat)
        return [[NSString alloc] initWithFormat:@"%0.7g" locale:aLocale, (int)u.f];
    else if (fDouble)
        return [[NSString alloc] initWithFormat:@"%0.16g" locale:aLocale, u.d];
    return @"ACNumber not valid";
}

- (NSString *)stringValue
{
    return [self descriptionWithLocale:nil];
}

@end
