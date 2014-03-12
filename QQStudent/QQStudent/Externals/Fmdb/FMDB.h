//
//  FMDB.h
//  LivAllRadar
//
//  Created by Lynn on 12-11-22.
//  Copyright (c) 2012年 WiMi. All rights reserved.
//
#import "FMDatabase.h"
#import <Foundation/Foundation.h>

@interface FMDB : NSObject

@property (nonatomic, retain) FMDatabase  *db;

+ (FMDB *)sharedFMDB;

//拷贝数据库到Doc目录
+ (BOOL) copyDBDocDir;

//打开数据库
+ (id) openFmdb;

@end
