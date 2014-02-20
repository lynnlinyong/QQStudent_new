//
//  Site.h
//  QQStudent
//
//  Created by lynn on 14-2-20.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Site : NSObject<NSCopying,NSMutableCopying>
{
    NSString *address;          //第三方场地地址
    NSString *cityCode;         //城市代码
    NSString *cityName;         //城市
    NSString *districtName;     //街道
    NSString *emptyNumber;      //空位数
    NSString *expense;          //租金
    NSString *icon;             //主图
    NSArray  *imgArray;         //附图
    NSString *latitude;         //经度
    NSString *longitude;        //纬度
    NSString *name;             //地点名称
    NSString *proviceName;      //城市地址
    NSString *sid;              //场地号
    NSString *tel;              //电话
}

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *districtName;
@property (nonatomic, copy) NSString *emptyNumber;
@property (nonatomic, copy) NSString *expense;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSArray  *imgArray;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *proviceName;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *tel;

+ (Site *) setSiteProperty:(NSDictionary *) item;
@end
