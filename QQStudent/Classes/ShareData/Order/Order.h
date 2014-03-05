//
//  Order.h
//  QQStudent
//
//  Created by lynn on 14-2-13.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _tagOrderStatus
{
    NO_EMPLOY = 0,          //未聘请
    NO_CONFIRM,             //未确认
    CONFIRMED,              //已确认
    NO_FINISH=4,            //未结单
    FINISH                  //已结单
}OrderStatus;

typedef enum _tagOrderCommentStatus
{
    NO_COMMENT=0,           //未评
    GOOD_COMMENT,
    BAD_COMMET
}OrderCommentStatus;

@class Teacher;
@interface Order : NSObject<NSCopying,NSMutableCopying>
{
    NSString  *orderId;            //订单号
    NSString  *orderAddTimes;      //订单创建时间
    NSString  *orderStudyPos;      //授课地址
    NSString  *orderStudyTimes;    //授课时间
    NSString  *everyTimesMoney;    //课酬标准
    NSString  *totalMoney;         //总金额
    NSString  *comment;            //评价
    OrderStatus orderStatus;       //订单状态
    OrderCommentStatus orderCommentStatus;  //订单评论状态
    
    NSString  *orderProvice;       //订单省份
    NSString  *orderCity;          //订单城市
    NSString  *orderDist;          //订单区域
    
    NSString  *payMoney;           //消费金额
    NSString  *backMoney;          //应退金额
    
    NSMutableDictionary *addressDataDic;    //订单详细地址
    
    Teacher   *teacher;            //订单的老师
}
@property (nonatomic, copy)   Teacher   *teacher;
@property (nonatomic, assign) NSString  *payMoney;
@property (nonatomic, assign) NSString  *backMoney;
@property (nonatomic, retain) NSString  *orderId;
@property (nonatomic, retain) NSString  *orderAddTimes;
@property (nonatomic, retain) NSString  *orderStudyPos;
@property (nonatomic, retain) NSString  *orderStudyTimes;
@property (nonatomic, retain) NSString  *everyTimesMoney;
@property (nonatomic, retain) NSString  *totalMoney;
@property (nonatomic, retain) NSString  *comment;
@property (nonatomic, assign) OrderStatus orderStatus;
@property (nonatomic, assign) OrderCommentStatus orderCommentStatus;
@property (nonatomic, retain) NSString  *orderProvice;
@property (nonatomic, retain) NSString  *orderCity;
@property (nonatomic, retain) NSString  *orderDist;
@property (nonatomic, retain) NSMutableDictionary *addressDataDic;

//封装订单对象
+ (Order *) setOrderProperty:(NSDictionary *) dic;

@end
