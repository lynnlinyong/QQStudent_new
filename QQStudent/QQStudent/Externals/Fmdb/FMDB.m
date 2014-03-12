//
//  FMDB.m
//  LivAllRadar
//
//  Created by Lynn on 12-11-22.
//  Copyright (c) 2012年 WiMi. All rights reserved.
//

#import "FMDB.h"

static FMDB *sharedFmdbInstance = nil;
@implementation FMDB
@synthesize db;

+ (FMDB *)sharedFMDB
{
	@synchronized(self)
	{
		if (sharedFmdbInstance == nil)
		{
			sharedFmdbInstance = [[self alloc] init];
            
            //拷贝数据库到Doc目录
            [FMDB copyDBDocDir];
            
            //初始化DB
            NSArray  *paths         = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir        = [paths objectAtIndex:0];
            NSString *dbTargetPath  = [docDir stringByAppendingPathComponent:DATABASE];

            sharedFmdbInstance.db   = [FMDatabase databaseWithPath:dbTargetPath];
            if ([sharedFmdbInstance.db open])
            {
                CLog(@"open Success!");
            }
		}
	}
    
	return sharedFmdbInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (sharedFmdbInstance == nil)
		{
			sharedFmdbInstance = [super allocWithZone:zone];
            
            //拷贝数据库到Doc目录
            [FMDB copyDBDocDir];
            
            //初始化DB
            NSArray  *paths         = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir        = [paths objectAtIndex:0];
            NSString *dbTargetPath  = [docDir stringByAppendingPathComponent:DATABASE];
            
            sharedFmdbInstance.db   = [FMDatabase databaseWithPath:dbTargetPath];
            [sharedFmdbInstance.db open];
		}
	}
    
    return sharedFmdbInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (NSUInteger)retainCount
{
	return NSUIntegerMax;
}

- (oneway void)release
{
}

- (id)autorelease
{
	return self;
}

#pragma mark -
#pragma mark - Custom Action

+ (BOOL) copyDBDocDir;
{
    NSString *dbSourcePath  = [[NSBundle mainBundle]pathForResource:@"provinces"
                                                             ofType:@"db"];
    CLog(@"dbSourcePath:%@", dbSourcePath);
    
    NSArray  *paths         = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir        = [paths objectAtIndex:0];
    NSString *dbTargetPath  = [docDir stringByAppendingPathComponent:DATABASE];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbTargetPath])
    {
        CLog(@"The database is exsit in document direction!");
        return YES;
    }
    else
    {
        NSError *error = nil;
        BOOL isSuc     = [[NSFileManager defaultManager] copyItemAtPath:dbSourcePath
                                                                 toPath:dbTargetPath
                                                                  error:&error];
        if (!isSuc)
        {
            CLog(@"ERROR:File:%s, Line:%d", __FILE__, __LINE__);
            CLog(@"ERROR:%@", [error description]);
            return NO;
        }
        else
        {
            CLog(@"copy the database success!");
        }
    }
    
    return YES;
}
@end
