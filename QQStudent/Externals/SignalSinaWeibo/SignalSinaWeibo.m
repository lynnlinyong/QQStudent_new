//
//  SignalSinaWeibo.m
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SignalSinaWeibo.h"

static SignalSinaWeibo *sessionInstance = nil;
@implementation SignalSinaWeibo
@synthesize sinaWeibo;

+(id)shareInstance:(id<SinaWeiboDelegate>) delegate
{
    if(sessionInstance == nil)
    {
        @synchronized(self)
        {
            if(sessionInstance==nil)
            {
                sessionInstance = [[[self class] alloc] init];
                sessionInstance.sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey
                                                                    appSecret:kAppSecret
                                                               appRedirectURI:kAppRedirectURL
                                                                  andDelegate:delegate];
            }
        }
    }
    sessionInstance.sinaWeibo.delegate = delegate;
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
