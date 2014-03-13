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
@synthesize addressDataDic;
@synthesize orderCommentStatus;

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
        
        addressDataDic = [[NSMutableDictionary alloc]init];
        
        teacher   = [[Teacher alloc]init];
        
        orderCommentStatus = NO_COMMENT;
    }
    
    return self;
}

- (void) dealloc
{
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
    [addressDataDic release];
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
        
        order.orderCommentStatus = orderCommentStatus;
        order.addressDataDic  = [addressDataDic mutableCopy];
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
        
        order.payMoney     = [payMoney copy];
        order.backMoney    = [backMoney copy];
        
        order.addressDataDic  = [addressDataDic mutableCopy];
        
        order.teacher      = [teacher copy];
        
        order.orderCommentStatus = orderCommentStatus;
    }
    
    return order;
}

+ (Order *) setOrderProperty:(NSDictionary *) dic
{
    Order *order  = [[Order alloc]init];
    NSString *orderId = [[dic objectForKey:@"oid"] copy];
    if (!orderId)
        order.orderId = @"";
    else
        order.orderId = orderId;
    
    NSString *orderAddTimes     = [[dic objectForKey:@"order_addtime"]  copy];
    if (!orderAddTimes)
        order.orderAddTimes = @"";
    else
        order.orderAddTimes = orderAddTimes;
    
    NSString *everyTimeSalary = [[dic objectForKey:@"order_ismfjfu"] copy];
    if (!everyTimeSalary)
        order.everyTimesMoney = @"0";
    else
        order.everyTimesMoney = [NSString stringWithFormat:@"%d",everyTimeSalary.intValue];
    
    NSString *orderStudyPos   = [[dic objectForKey:@"order_iaddress"] copy];
    if (!orderStudyPos)
        order.orderStudyPos = @"";
    else
        order.orderStudyPos = orderStudyPos;
    
    NSString *orderStudyTimes = [[dic objectForKey:@"order_jyfdnum"] copy];
    if (!orderStudyTimes)
        order.orderStudyTimes = @"";
    else
        order.orderStudyTimes = orderStudyTimes;

    NSString *everyTimesMoney = [[dic objectForKey:@"order_kcbz"] copy];
    if (!everyTimesMoney)
        order.everyTimesMoney = @"";
    else
        order.everyTimesMoney = everyTimesMoney;
    
    NSString *status = [[dic objectForKey:@"order_stars"] copy];
    if (status)
        order.orderStatus = status.intValue;
    else
        order.orderStatus = 0;
    
    order.addressDataDic = [[dic objectForKey:@"order_iaddress_data"] copy];
    
    NSString *totalMoney = [[dic objectForKey:@"order_tamount"]  copy];
    if (!totalMoney)
        order.totalMoney = @"";
    else
        order.totalMoney = totalMoney;
    
    NSString *backMoney  = [[dic objectForKey:@"order_tfamount"] copy];
    if (!backMoney)
        order.backMoney = @"";
    else
        order.backMoney = backMoney;
    
    NSString *payMoney   = [[dic objectForKey:@"order_xfamount"] copy];
    if (!payMoney)
        order.payMoney = @"";
    else
        order.payMoney = payMoney;
    
    NSDictionary *teacherDic = [dic objectForKey:@"teacher"];
    if (teacherDic)
        order.teacher = [Teacher setTeacherProperty:teacherDic];
    else
        order.teacher = nil;
    
    NSString *commentStatus = [dic objectForKey:@"order_pj_stars"];
    if (commentStatus)
        order.orderCommentStatus = commentStatus.intValue;
    else
        order.orderCommentStatus = NO_COMMENT;
    
    return order;
}
@end
