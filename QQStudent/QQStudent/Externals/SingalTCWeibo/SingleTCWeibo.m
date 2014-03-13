//
//  SingleTCWeibo.m
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SingleTCWeibo.h"

static SingleTCWeibo *sessionInstance = nil;
@implementation SingleTCWeibo
@synthesize tcWeiboApi;

+(id)shareInstance
{
    if(sessionInstance == nil)
    {
        @synchronized(self)
        {
            if(sessionInstance==nil)
            {
                sessionInstance = [[[self class] alloc] init];
                sessionInstance.tcWeiboApi = [[WeiboApi alloc]initWithAppKey:WiressSDKDemoAppKey
                                                                    andSecret:WiressSDKDemoAppSecret
                                                               andRedirectUri:REDIRECTURI];
            }
        }
    }
    return sessionInstance;
}

+ (id) allocWithZone:(NSZone *)zone;
{
    if(sessionInstance==nil)
    {
        sessionInstance = [super allocWithZone:zone];
    }
    return sessionInstance;
}

-(id)copyWithZone:(NSZone *)zone
{
    return sessionInstance;
}
-(id)retain
{
    return sessionInstance;
}
- (oneway void)release

{
}
- (id)autorelease
{
    return sessionInstance;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;
}
@end
