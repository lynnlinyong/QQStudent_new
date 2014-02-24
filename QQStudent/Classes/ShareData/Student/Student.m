//
//  Student.m
//  QQStudent
//
//  Created by lynn on 14-2-2.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "Student.h"

@implementation Student
@synthesize icon;
@synthesize email;
@synthesize nickName;
@synthesize phoneNumber;
@synthesize grade;
@synthesize gender;
@synthesize lltime;
@synthesize longltude;
@synthesize latltude;
@synthesize status;
@synthesize phoneStars;
@synthesize locStars;

- (id) init
{
    self = [super init];
    if (self)
    {
        icon        = [[NSString alloc]init];
        email       = [[NSString alloc]init];
        nickName    = [[NSString alloc]init];
        phoneNumber = [[NSString alloc]init];
        grade       = [[NSString alloc]init];
        gender      = [[NSString alloc]init];
        lltime      = [[NSString alloc]init];
        longltude   = [[NSString alloc]init];
        latltude    = [[NSString alloc]init];
        status      = [[NSString alloc]init];
        phoneStars  = [[NSString alloc]init];
        locStars    = [[NSString alloc]init];
    }
    
    return self;
}

- (void) dealloc
{
    [icon           release];
    [email          release];
    [nickName       release];
    [phoneNumber    release];
    [grade          release];
    [gender         release];
    [lltime         release];
    [longltude      release];
    [latltude       release];
    [status         release];
    [phoneStars     release];
    [locStars       release];
    [super dealloc];
}

- (id) copyWithZone:(NSZone *)zone
{
    Student *sObj = NSCopyObject(self, 0, zone);
    if (sObj)
    {
        sObj.email       = [email copy];
        sObj.nickName    = [nickName copy];
        sObj.phoneNumber = [phoneNumber copy];
        sObj.grade       = [grade copy];
        sObj.gender      = [gender copy];
        sObj.lltime      = [lltime copy];
        sObj.longltude   = [longltude copy];
        sObj.latltude    = [latltude copy];
        sObj.status      = [status copy];
        sObj.phoneStars  = [phoneStars copy];
        sObj.locStars    = [locStars copy];
        sObj.icon        = [icon copy];
    }
    
    return sObj;
}

- (id) mutableCopyWithZone:(NSZone *)zone
{
    Student *sObj = NSCopyObject(self, 0, zone);
    if (sObj)
    {
        sObj.email       = [email mutableCopy];
        sObj.nickName    = [nickName mutableCopy];
        sObj.phoneNumber = [phoneNumber mutableCopy];
        sObj.grade       = [grade mutableCopy];
        sObj.gender      = [gender mutableCopy];
        sObj.lltime      = [lltime mutableCopy];
        sObj.longltude   = [longltude mutableCopy];
        sObj.latltude    = [latltude mutableCopy];
        sObj.status      = [status mutableCopy];
        sObj.phoneStars  = [phoneStars mutableCopy];
        sObj.locStars    = [locStars mutableCopy];
        sObj.icon        = [icon copy];
    }
    
    return sObj;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.email
                  forKey:@"email"];
    [aCoder encodeObject:self.nickName
                  forKey:@"nickName"];
    [aCoder encodeObject:self.phoneNumber
                  forKey:@"phoneNumber"];
    [aCoder encodeObject:self.grade
                  forKey:@"grade"];
    [aCoder encodeObject:self.gender
                  forKey:@"gender"];
    [aCoder encodeObject:self.lltime
                  forKey:@"lltime"];
    [aCoder encodeObject:self.longltude
                  forKey:@"longltude"];
    [aCoder encodeObject:self.latltude
                  forKey:@"latltude"];
    [aCoder encodeObject:self.status
                  forKey:@"status"];
    [aCoder encodeObject:self.phoneStars
                  forKey:@"phoneStars"];
    [aCoder encodeObject:self.locStars
                  forKey:@"locStars"];
    [aCoder encodeObject:self.icon
                  forKey:@"icon"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        email       = [[aDecoder decodeObjectForKey:@"email"] copy];
        nickName    = [[aDecoder decodeObjectForKey:@"nickName"] copy];
        phoneNumber = [[aDecoder decodeObjectForKey:@"phoneNumber"] copy];
        grade       = [[aDecoder decodeObjectForKey:@"grade"] copy];
        gender      = [[aDecoder decodeObjectForKey:@"gender"] copy];
        lltime      = [[aDecoder decodeObjectForKey:@"lltime"] copy];
        longltude   = [[aDecoder decodeObjectForKey:@"longltude"] copy];
        latltude    = [[aDecoder decodeObjectForKey:@"latltude"] copy];
        status      = [[aDecoder decodeObjectForKey:@"status"] copy];
        phoneStars  = [[aDecoder decodeObjectForKey:@"phoneStars"] copy];
        locStars    = [[aDecoder decodeObjectForKey:@"locStars"] copy];
        icon        = [[aDecoder decodeObjectForKey:@"icon"] copy];
    }
    
    return self;
}

//根据年级列表,名字查询年级ID
+ (NSString *) searchGradeID:(NSString *)gradeName
{
    NSString *result = nil;
    
    NSArray *gradList = [[NSUserDefaults standardUserDefaults] objectForKey:GRADE_LIST];
    if (gradList)
    {
        for (NSDictionary *item in gradList)
        {
            NSString *tGdName = [item objectForKey:@"name"];
            if ([gradeName isEqualToString:tGdName])
            {
                return [[item objectForKey:@"id"] retain];
            }
        }
    }
    
    return result;
}

//根据年级列表,年级ID查询名字
+ (NSString *) searchGradeName:(NSString *) gradeID
{
    NSString *result  = @"";
    NSArray *gradList = [[NSUserDefaults standardUserDefaults] objectForKey:GRADE_LIST];
    if (gradList)
    {
        for (NSDictionary *item in gradList)
        {
            NSString *tGdID = [item objectForKey:@"id"];
            if ([gradeID isEqualToString:tGdID])
            {
                return [[item objectForKey:@"name"] retain];
            }
        }
    }
    else
    {
        NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"getgrade",ssid, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
        ServerRequest *request = [ServerRequest sharedServerRequest];
        NSData *resVal = [request requestSyncWith:kServerPostRequest
                                         paramDic:pDic
                                           urlStr:url];
        NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                 encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *resDic   = [resStr JSONValue];
        NSArray      *keysArr  = [resDic allKeys];
        NSArray      *valsArr  = [resDic allValues];
        CLog(@"***********Result****************");
        for (int i=0; i<keysArr.count; i++)
        {
            CLog(@"%@=%@", [keysArr objectAtIndex:i], [valsArr objectAtIndex:i]);
        }
        CLog(@"***********Result****************");
        
        
        NSNumber *errorid = [resDic objectForKey:@"errorid"];
        if (errorid.intValue == 0)
        {
            gradList = [[resDic objectForKey:@"grades"] copy];
        }
        
        for (NSDictionary *item in gradList)
        {
            NSString *tGdID = [item objectForKey:@"id"];
            if ([gradeID isEqualToString:tGdID])
            {
                CLog(@"[item name]:%@", [[item objectForKey:@"name"] retain]);
                return [[item objectForKey:@"name"] retain];
            }
        }

    }
    
    return result;
}

//根据性别ID,查询性别
+ (NSString *) searchGenderName:(NSString *) genderId
{
    NSString *result = @"";
    
    if ([genderId isEqualToString:@"1"])
        result = @"男";
    else
        result = @"女";
    
    return result;
}

//根据性别, 查询ID
+ (NSString *) searchGenderID:(NSString *) genderName
{
    NSString *result = @"";
    
    if ([genderName isEqualToString:@"男"])
        result = @"1";
    else if ([genderName isEqualToString:@"不限"])
        result = @"0";
    else
        result = @"2";
    
    
    return result;
}
@end
