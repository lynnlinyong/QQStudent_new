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
@synthesize goodCount;
@synthesize badCount;
@synthesize certArray;
@synthesize idOrgName;
@synthesize isId;
@synthesize searchCode;

+ (Teacher *) setTeacherProperty:(NSDictionary *) resDic
{
    Teacher *teacherObj = [[[Teacher alloc]init] autorelease];
    
    NSString *stuCount  = [[resDic objectForKey:@"TS"] copy];
    if (stuCount)
        teacherObj.studentCount = stuCount.intValue;
    else
        teacherObj.studentCount = 0;
    
    if (!stuCount)
    {
        stuCount = [[resDic objectForKey:@"students"] copy];
        if (stuCount)
            teacherObj.studentCount = stuCount.intValue;
        else
            teacherObj.studentCount = 0;
    }
    
    NSString *deviceId   = [[resDic objectForKey:@"deviceId"] copy];
    if (deviceId)
        teacherObj.deviceId = deviceId;
    else
        teacherObj.deviceId = @"";
    
    NSString *expense      = [[resDic objectForKey:@"expense"] copy];
    if (expense)
        teacherObj.expense = expense.intValue;
    else
        teacherObj.expense = 0;
    
    NSString *sex = [[resDic objectForKey:@"gender"] copy];
    if (sex)
        teacherObj.sex = sex.intValue;
    else
        teacherObj.sex = 0;
    
    NSString *url = [[resDic objectForKey:@"icon"] copy];
    if (!url)
        teacherObj.headUrl = @"";
    else
        teacherObj.headUrl = url;
    
    NSString *idNums = [[resDic objectForKey:@"idnumber"] copy];
    if (!idNums)
        teacherObj.idNums = @"";
    else
        teacherObj.idNums = idNums;
    
    NSString *isIos = [[resDic objectForKey:@"ios"] copy];
    if (isIos.intValue==1)
        teacherObj.isIos = YES;
    else
        teacherObj.isIos = NO;
    
    NSString *latitude = [[resDic objectForKey:@"latitude"] copy];
    if (!latitude)
        teacherObj.latitude = @"";
    else
        teacherObj.latitude = latitude;
    
    NSString *longitude  = [[resDic objectForKey:@"longitude"] copy];
    if (!longitude)
        teacherObj.longitude = @"";
    else
        teacherObj.longitude = longitude;
    
    NSString *tmpName    = [[resDic objectForKey:@"name"] copy];
    if (tmpName)
        teacherObj.name  = tmpName;
    else
        teacherObj.name  = @"";
    if (!tmpName)
    {
        NSString *name   = [[resDic objectForKey:@"nickname"] copy];
        if (!name)
            teacherObj.name = @"";
        else
            teacherObj.name = name;
    }
    
    NSString *isOnline = [[resDic objectForKey:@"online"] copy];
    if (isOnline)
    {
        if (isOnline.intValue==1)
            teacherObj.isOnline = YES;
        else
            teacherObj.isOnline = NO;
    }
    else
    {
        teacherObj.isOnline = NO;
    }
    
    NSString *phone = [[resDic objectForKey:@"phone"] copy];
    if (!phone)
        teacherObj.phoneNums = @"";
    else
        teacherObj.phoneNums = phone;
    
    NSString *sub  = [[resDic objectForKey:@"subject"] copy];
    if (sub)
        teacherObj.pfId  = sub.intValue;
    else
        teacherObj.pfId  = 0;
    
    NSString *subject    = [[resDic objectForKey:@"subjectText"] copy];
    if (subject)
        teacherObj.pf    = subject;
    else
        teacherObj.pf    = @"";
    
    NSString *starCnt    = [[[resDic objectForKey:@"tstars"] retain] copy];
    if (starCnt)
        teacherObj.comment   = starCnt.intValue;
    else
        teacherObj.comment   = ((NSString *) [resDic objectForKey:@"teacher_stars"]).intValue;
    
    
    NSString *info      = [[resDic objectForKey:@"info"] copy];
    if (!info)
        teacherObj.info  = @"";
    else
        teacherObj.info = info;
    
    NSString *comment    = [[resDic objectForKey:@"xunNum"] copy];
    if (comment)
        teacherObj.badCount = comment.intValue;
    else
        teacherObj.badCount = 0;
    
    comment    = [[resDic objectForKey:@"zanNum"] copy];
    if (comment)
        teacherObj.goodCount = comment.intValue;
    else
        teacherObj.goodCount = 0;
    
    teacherObj.certArray = [[resDic objectForKey:@"certificates"] copy];
    
    NSString *isId       = [[resDic objectForKey:@"type_stars"] copy];
    if (isId.intValue == 1)
        teacherObj.isId  = YES;
    else
        teacherObj.isId  = NO;
    
    NSString *idOrgName  = [[resDic objectForKey:@"teacher_type_text"] copy];
    if (idOrgName)
        teacherObj.idOrgName = idOrgName;
    else
        teacherObj.idOrgName = @"";
    
    NSString *searchcCode = [[resDic objectForKey:@"searchCode"] copy];
    if (searchcCode)
        teacherObj.searchCode = searchcCode;
    else
        teacherObj.searchCode = @"";
    
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
        
        certArray = [[NSArray alloc]init];
        isId      = NO;
        idOrgName = [[NSString alloc]init];
        searchCode = [[NSString alloc]init];
    }
    
    return self;
}

- (void) dealloc
{
    [idOrgName release];
    [searchCode release];
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
    [certArray release];
    [super dealloc];
}

- (id) copyWithZone:(NSZone *)zone
{
    Teacher *tObj = NSCopyObject(self, 0, zone);
    if (tObj)
    {
        tObj.name      = [name copy];
        tObj.sex       = sex;
        tObj.pf        = [pf copy];
        tObj.pfId      = pfId;
        tObj.idNums    = [idNums copy];
        tObj.mood      = [mood copy];
        tObj.headUrl   = [headUrl copy];
        tObj.comment   = comment;
        tObj.studentCount = studentCount;
        tObj.deviceId  = [deviceId copy];
        tObj.expense   = expense;
        tObj.isIos     = isIos;
        tObj.isOnline  = isOnline;
        tObj.latitude  = [latitude copy];
        tObj.longitude = [longitude copy];
        tObj.phoneNums = [phoneNums copy];
        tObj.info      = [info copy];
        tObj.goodCount = goodCount;
        tObj.badCount  = badCount;
        tObj.certArray = [certArray copy];
        
        tObj.isId      = isId;
        tObj.idOrgName = [idOrgName copy];
        tObj.searchCode = [searchCode copy];
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
        tObj.goodCount = goodCount;
        tObj.badCount  = badCount;
        tObj.certArray = [certArray copy];
        
        tObj.isId      = isId;
        tObj.idOrgName = [idOrgName copy];
        tObj.searchCode = [searchCode copy];
    }
    
    return tObj;
}
@end
