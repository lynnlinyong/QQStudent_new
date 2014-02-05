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
@end
