//
//  Order.m
//  QQStudent
//
//  Created by lynn on 14-2-13.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "Order.h"

@implementation Order
@synthesize orderId;
@synthesize orderAddTimes;
@synthesize orderStudyPos;
@synthesize orderStudyTimes;
@synthesize everyTimesMoney;
@synthesize totalMoney;
@synthesize comment;
@synthesize orderStatus;
@synthesize orderProvice;
@synthesize orderCity;
@synthesize orderDist;
@synthesize payMoney;
@synthesize backMoney;
@synthesize teacher;

- (id) init
{
    self = [super init];
    if (self)
    {
        orderId         = [[NSString alloc]init];
        orderAddTimes   = [[NSString alloc]init];
        orderStudyPos   = [[NSString alloc]init];
        orderStudyTimes = [[NSString alloc]init];
        everyTimesMoney = [[NSString alloc]init];
        totalMoney  = [[NSString alloc]init];
        comment     = [[NSString alloc]init];
        orderStatus = NO_CONFIRM;
        orderProvice= [[NSString alloc]init];
        orderCity   = [[NSString alloc]init];
        orderDist   = [[NSString alloc]init];
        
        payMoney  = [[NSString alloc]init];
        backMoney = [[NSString alloc]init];
        
        teacher   = [[Teacher alloc]init];
    }
    
    return self;
}

- (void) dealloc
{
    [teacher         release];
    [payMoney        release];
    [backMoney       release];
    [orderDist       release];
    [orderCity       release];
    [orderProvice    release];
    [orderId         release];
    [orderAddTimes   release];
    [orderStudyPos   release];
    [orderStudyTimes release];
    [everyTimesMoney release];
    [totalMoney      release];
    [comment         release];
    [super dealloc];
}

- (id) copyWithZone:(NSZone *)zone
{
    Order *order = NSCopyObject(self, 0, zone);
    if (order)
    {
        order.orderId         = [orderId copy];
        order.orderAddTimes   = [orderAddTimes copy];
        order.orderStudyPos   = [orderStudyPos copy];
        order.orderStudyTimes = [orderStudyTimes copy];
        order.everyTimesMoney = [everyTimesMoney copy];
        order.totalMoney      = [totalMoney copy];
        order.comment         = [comment copy];
        order.orderStatus     = orderStatus;
        order.orderProvice    = [orderProvice copy];
        order.orderCity       = [orderCity copy];
        order.orderDist       = [orderDist copy];
        
        order.payMoney        = [payMoney copy];
        order.backMoney       = [backMoney copy];
        order.teacher         = [teacher copy];
    }
    
    return order;
}

- (id) mutableCopyWithZone:(NSZone *)zone
{
    Order *order = NSCopyObject(self, 0, zone);
    if (order)
    {
        order.orderId = [orderId copy];
        order.orderAddTimes   = [orderAddTimes copy];
        order.orderStudyPos   = [orderStudyPos copy];
        order.orderStudyTimes = [orderStudyTimes copy];
        order.everyTimesMoney = [everyTimesMoney copy];
        order.totalMoney      = [totalMoney copy];
        order.comment         = [comment copy];
        order.orderStatus     = orderStatus;
        
        order.orderProvice = [orderProvice copy];
        order.orderCity    = [orderCity copy];
        order.orderDist    = [orderDist copy];
        
        order.payMoney        = [payMoney copy];
        order.backMoney       = [backMoney copy];
        
        order.teacher      = [teacher copy];
    }
    
    return order;
}

+ (Order *) setOrderProperty:(NSDictionary *) dic
{
    Order *order  = [[[Order alloc]init]autorelease];
    int oid = ((NSNumber *)[dic objectForKey:@"oid"]).intValue;
    order.orderId = [NSString stringWithFormat:@"%d", oid];
    order.orderAddTimes   = [[dic objectForKey:@"order_addtime"]  copy];
    order.orderStudyPos   = [[dic objectForKey:@"order_iaddress"] copy];
    int times = ((NSNumber *)[dic objectForKey:@"order_jyfdnum"]).intValue;
    order.orderStudyTimes = [NSString stringWithFormat:@"%d", times];
    int money = ((NSNumber *)[dic objectForKey:@"order_kcbz"]).intValue;
    order.everyTimesMoney = [NSString stringWithFormat:@"%d", money];
    int status = ((NSNumber *) [dic objectForKey:@"order_stars"]).intValue;
    order.orderStatus = status;
    
    NSDictionary *addressDic = [dic objectForKey:@"order_iaddress_data"];
    if (addressDic)
    {
        if ([dic objectForKey:@"provinceName"])
            order.orderProvice = [dic objectForKey:@"provinceName"];
        if ([dic objectForKey:@"cityName"])
            order.orderCity = [dic objectForKey:@"cityName"];
        if ([dic objectForKey:@"districtName"])
            order.orderDist = [dic objectForKey:@"districtName"];
    }
    
    order.totalMoney = [[dic objectForKey:@"order_tamount"]  copy];
    order.backMoney  = [[dic objectForKey:@"order_tfamount"] copy];
    order.payMoney   = [[dic objectForKey:@"order_xfamount"] copy];
    
    return order;
}

//根据科目ID,查询科目名称
+ (NSString *) searchSubjectName:(NSString *) subjectId
{
    NSString *result = @"";
    
    NSArray *subList = [[NSUserDefaults standardUserDefaults] objectForKey:SUBJECT_LIST];
    if (subList)
    {
        for (NSDictionary *item in subList)
        {
            NSString *subId = [item objectForKey:@"id"];
            if ([subId isEqualToString:subjectId])
                return [[item objectForKey:@"name"] retain];
        }
    }
    
    return result;
}

//根据科目名称,查询科目ID
+ (NSString *) searchSubjectID:(NSString *) subjectName
{
    NSString *result = @"";
    
    NSArray *subList = [[NSUserDefaults standardUserDefaults] objectForKey:SUBJECT_LIST];
    if (subList)
    {
        for (NSDictionary *item in subList)
        {
            NSString *subName = [item objectForKey:@"name"];
            if ([subjectName isEqualToString:subName])
                return [[item objectForKey:@"id"] retain];
        }
    }
    
    return result;
}
@end
