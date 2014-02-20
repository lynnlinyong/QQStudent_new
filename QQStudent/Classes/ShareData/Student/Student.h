//
//  Student.h
//  QQStudent
//
//  Created by lynn on 14-2-2.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject<NSCopying,NSMutableCopying,NSCoding>
{
    NSString  *email;
    NSString  *nickName;
    NSString  *phoneNumber;
    NSString  *grade;
    NSString  *gender;
    NSString  *lltime;
    NSString  *longltude;
    NSString  *latltude;
    NSString  *status;
    NSString  *icon;
    NSString  *phoneStars;
    NSString  *locStars;
}

@property (nonatomic, retain)  NSString  *icon;
@property (nonatomic, retain)  NSString  *email;
@property (nonatomic, retain)  NSString  *nickName;
@property (nonatomic, retain)  NSString  *phoneNumber;
@property (nonatomic, retain)  NSString  *grade;
@property (nonatomic, retain)  NSString  *gender;
@property (nonatomic, retain)  NSString  *lltime;
@property (nonatomic, retain)  NSString  *longltude;
@property (nonatomic, retain)  NSString  *latltude;
@property (nonatomic, retain)  NSString  *status;
@property (nonatomic, retain)  NSString  *phoneStars;
@property (nonatomic, retain)  NSString  *locStars;

//根据性别ID,查询性别
+ (NSString *) searchGenderName:(NSString *) genderId;

//根据性别, 查询ID
+ (NSString *) searchGenderID:(NSString *) genderName;

//根据年级列表,名字查询年级ID
+ (NSString *) searchGradeID:(NSString *)gradeName;

//根据年级列表,年级ID查询名字
+ (NSString *) searchGradeName:(NSString *) gradeID;
@end
