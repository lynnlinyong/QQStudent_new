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
@synthesize pfId;
@synthesize comment;
@synthesize idNums;
@synthesize studentCount;
@synthesize mood;
@synthesize headUrl;
@synthesize deviceId;
@synthesize expense;
@synthesize isIos;
@synthesize isOnline;
@synthesize latitude;
@synthesize longitude;
@synthesize phoneNums;
@synthesize info;
@synthesize teacherId;

+ (Teacher *) setTeacherProperty:(NSDictionary *) resDic
{
    Teacher *teacherObj = [[[Teacher alloc]init]autorelease];
    teacherObj.studentCount = ((NSNumber *)[resDic objectForKey:@"TS"]).intValue;
    teacherObj.deviceId  = [[resDic objectForKey:@"deviceId"] copy];
    teacherObj.expense   = ((NSNumber *)[resDic objectForKey:@"expense"]).intValue;
    teacherObj.sex       = ((NSNumber *)[resDic objectForKey:@"gender"]).intValue;
    teacherObj.headUrl   = [[resDic objectForKey:@"icon"] copy];
    teacherObj.idNums    = [[resDic objectForKey:@"idnumber"] copy];
    teacherObj.isIos     = (BOOL) [resDic objectForKey:@"ios"];
    teacherObj.latitude  = [[resDic objectForKey:@"latitude"] copy];
    teacherObj.longitude = [[resDic objectForKey:@"longitude"] copy];
    teacherObj.name = [[resDic objectForKey:@"name"] copy];
    teacherObj.isOnline   = (BOOL) [resDic objectForKey:@"online"];
    teacherObj.phoneNums  = [resDic objectForKey:@"phone"];
    teacherObj.pfId    = ((NSNumber *) [resDic objectForKey:@"subject"]).intValue;
    teacherObj.pf      = [[resDic objectForKey:@"subject"] copy];
    teacherObj.comment = ((NSNumber *) [resDic objectForKey:@"tstars"]).intValue;
    teacherObj.info    = [resDic objectForKey:@"info"];
    
    return teacherObj;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        name = [[NSString alloc]init];
        sex  = 0;
        pf   = [[NSString alloc]init];
        pfId = 0;
        comment = 0;
        idNums  = [[NSString alloc]init];
        studentCount = 0;
        mood     = [[NSString alloc]init];
        headUrl  = [[NSString alloc]init];
        deviceId = [[NSString alloc]init];
        expense  = 0;
        isIos    = NO;
        isOnline = NO;
        latitude = [[NSString alloc]init];
        longitude= [[NSString alloc]init];
        phoneNums= [[NSString alloc]init];
        info     = [[NSString alloc]init];
    }
    
    return self;
}

- (void) dealloc
{
    [info    release];
    [name    release];
    [pf      release];
    [idNums  release];
    [mood    release];
    [headUrl release];
    [deviceId release];
    [latitude  release];
    [longitude release];
    [phoneNums release];
    [super dealloc];
}

- (id) copyWithZone:(NSZone *)zone
{
    Teacher *tObj = NSCopyObject(self, 0, zone);
    if (tObj)
    {
        tObj.name    = [name copy];
        tObj.sex     = sex;
        tObj.pf      = [pf copy];
        tObj.pfId    = pfId;
        tObj.idNums  = [idNums copy];
        tObj.mood    = [mood copy];
        tObj.headUrl = [headUrl copy];
        tObj.comment = comment;
        tObj.studentCount = studentCount;
        tObj.deviceId = [deviceId copy];
        tObj.expense  = expense;
        tObj.isIos    = isIos;
        tObj.isOnline = isOnline;
        tObj.latitude = [latitude copy];
        tObj.longitude = [longitude copy];
        tObj.phoneNums = [phoneNums copy];
        tObj.info      = [info copy];
    }
    
    return tObj;
}

- (id) mutableCopyWithZone:(NSZone *)zone
{
    Teacher *tObj = NSCopyObject(self, 0, zone);
    if (tObj)
    {
        tObj.name    = [name copy];
        tObj.sex     = sex;
        tObj.pf      = [pf copy];
        tObj.pfId    = pfId;
        tObj.idNums  = [idNums copy];
        tObj.mood    = [mood copy];
        tObj.headUrl = [headUrl copy];
        tObj.comment = comment;
        tObj.studentCount = studentCount;
        tObj.deviceId = [deviceId copy];
        tObj.expense  = expense;
        tObj.isIos    = isIos;
        tObj.isOnline = isOnline;
        tObj.latitude = [latitude copy];
        tObj.longitude = [longitude copy];
        tObj.phoneNums = [phoneNums copy];
        tObj.info = [info copy];
    }
    
    return tObj;
}
@end
