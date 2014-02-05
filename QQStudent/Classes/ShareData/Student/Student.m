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
    }
    
    return self;
}
@end
