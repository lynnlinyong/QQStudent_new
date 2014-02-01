//
//  Teacher.m
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher
@synthesize name;
@synthesize sex;
@synthesize pf;
@synthesize comment;
@synthesize idNums;
@synthesize studentCount;
@synthesize mood;
@synthesize headUrl;

- (id) init
{
    self = [super init];
    if (self)
    {
        name = [[NSString alloc]init];
        sex  = [[NSString alloc]init];
        pf   = [[NSString alloc]init];
        comment = 0;
        idNums  = [[NSString alloc]init];
        studentCount = 0;
        mood    = [[NSString alloc]init];
        headUrl = [[NSString alloc]init];
    }
    
    return self;
}

- (void) dealloc
{
    [name    release];
    [sex     release];
    [pf      release];
    [idNums  release];
    [mood    release];
    [headUrl release];
    [super dealloc];
}

- (id) copyWithZone:(NSZone *)zone
{
    Teacher *tObj = NSCopyObject(self, 0, zone);
    if (tObj)
    {
        tObj.name    = [name copy];
        tObj.sex     = [sex copy];
        tObj.pf      = [pf copy];
        tObj.idNums  = [idNums copy];
        tObj.mood    = [mood copy];
        tObj.headUrl = [headUrl copy];
        
        tObj.comment = comment;
        tObj.studentCount = studentCount;
    }
    
    return tObj;
}

- (id) mutableCopyWithZone:(NSZone *)zone
{
    Teacher *tObj = NSCopyObject(self, 0, zone);
    if (tObj)
    {
        tObj.name    = [name copy];
        tObj.sex     = [sex copy];
        tObj.pf      = [pf copy];
        tObj.idNums  = [idNums copy];
        tObj.mood    = [mood copy];
        tObj.headUrl = [headUrl copy];
        
        tObj.comment = comment;
        tObj.studentCount = studentCount;
    }
    
    return tObj;
}
@end
