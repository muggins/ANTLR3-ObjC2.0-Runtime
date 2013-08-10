//
//  ACBtree.h
//  ST4
//
//  Created by Alan Condit on 4/18/11.
//  Copyright 2011 Alan Condit. All rights reserved.
//

typedef enum {
    BTNODE,
    LEAF
} NodeType;

#import <Foundation/Foundation.h>

@class AMutableDictionary;

#define BTNODESIZE 11
#define BTHNODESIZE ((BTNODESIZE-1)/2)
#define BTKeySize  38
#if defined FAILURE
#undef FAILURE
#endif
#define FAILURE -1
#if defined SUCCESS
#undef SUCCESS
#endif
#define SUCCESS 0

@interface ACBKey : NSObject {
    NSInteger recnum;               /*  record number                   */
    __strong NSString *key;         /*  key pointer id                  */
    char      kstr[BTKeySize];      /*  key entry                       */
}

@property (assign) NSInteger recnum;
@property (retain) NSString *key;

+ (ACBKey *)newKey;
+ (ACBKey *)newKeyWithKStr:(NSString *)aKey;
- (id) init;
- (id) initWithKStr:(NSString *)aKey;
- (void)dealloc;
- (NSString *) description;
@end

@interface ACBTree : NSObject {
    __strong AMutableDictionary *dict;  /* The dictionary that this node belongs to */
    __strong ACBTree *lnode;            /* pointer to left node            */
    __strong ACBTree *rnode;            /* pointer to right node           */
    __strong ACBKey  *keyArray[BTNODESIZE];
    __strong ACBTree *btNodeArray[BTNODESIZE];
    NSInteger lnodeid;                  /* nodeid of left node             */
    NSInteger rnodeid;                  /* nodeid of right node            */
    NSInteger nodeid;                   /* node id                         */
    NSInteger nodeType;                 /* 1 = node, 2 = leaf, -1 = unused */
    NSInteger numkeys;                  /* number of active entries        */
    NSInteger numrecs;                  /* number of records               */
    NSInteger updtd;                    /* modified since update flag      */
    NSInteger keylen;                   /* length of key                   */
    NSInteger kidx;
}

@property (retain) AMutableDictionary *dict;
@property (retain) ACBTree  *lnode;
@property (retain) ACBTree  *rnode;
@property (assign) NSInteger lnodeid;
@property (assign) NSInteger rnodeid;
@property (assign) NSInteger nodeid;
@property (assign) NSInteger nodeType;
@property (assign) NSInteger numkeys;
@property (assign) NSInteger numrecs;
@property (assign) NSInteger updtd;
@property (assign) NSInteger keylen;
@property (assign) NSInteger kidx;

+ (__strong ACBTree *) newNodeWithDictionary:(__strong AMutableDictionary *)theDict;

- (__strong id)initWithDictionary:(__strong AMutableDictionary *)theDict;
- (void)dealloc;

- (__strong ACBKey *) getKey:(NSInteger)idx;
- (void) setKey:(NSInteger)idx with:(ACBKey *)k;
- (__strong ACBTree *) getNode:(NSInteger)idx;
- (void) setNode:(NSInteger)idx with:(ACBTree *)t;
- (__strong ACBTree *)createnode:(__strong ACBKey *)kp0;
- (__strong ACBTree *)deletekey:(NSString *)dkey;
- (__strong ACBTree *)insertkey:(__strong ACBKey *)ikp value:(__strong id)value;
- (__strong ACBKey *)internaldelete:(__strong ACBKey *)dkp;
- (__strong ACBTree *) internalinsert:(ACBKey *)key value:(__strong id)value split:(NSInteger *)h;
- (__strong ACBTree *) insert:(__strong ACBKey *)key value:(__strong id)value index:(NSInteger)hi split:(NSInteger *)h;
- (NSInteger)delfrmnode:(__strong ACBKey *)ikp;
- (NSInteger)insinnode:(__strong ACBKey *)key value:(id)value;
- (void)mergenode:(NSInteger)i;
- (__strong ACBTree *)splitnode:(NSInteger)idx;
- (__strong ACBTree *)search:(__strong id)key;
- (NSInteger)searchnode:(__strong id)key match:(BOOL)match;
- (void)borrowleft:(NSInteger)i;
- (void)borrowright:(NSInteger)i;
- (void)rotateleft:(NSInteger)j;
- (void)rotateright:(NSInteger)j;
- (NSInteger) keyWalkLeaves;
- (NSInteger) objectWalkLeaves;
- (NSString *) description;
@end
