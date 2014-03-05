//
//  SingleMQTT.m
//  QQStudent
//
//  Created by lynn on 14-2-9.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SingleMQTT.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

static SingleMQTT *sessionInstance = nil;
@implementation SingleMQTT
@synthesize session;
+(id)shareInstance
{
    if(sessionInstance == nil)
    {
        @synchronized(self)
        {
            if(sessionInstance==nil)
            {
                sessionInstance=[[[self class] alloc] init];
                
                NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
                NSMutableString *client = [NSMutableString stringWithCapacity:5];
                for (NSUInteger i = 0; i < 5; i++) {
                    u_int32_t r = arc4random() % [alphabet length];
                    unichar c = [alphabet characterAtIndex:r];
                    [client appendFormat:@"%C", c];
                }
                
                //初始化MQTTSession
                sessionInstance.session = [[MQTTSession alloc]initWithClientId:client];
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

+(NSString *) getCurrentDevTopic
{
        
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    if (uuid)
        return uuid;
    else
    {
        NSDate *dateNow  = [NSDate date];
        uuid = [NSString stringWithFormat:@"x%ld", (long)[dateNow timeIntervalSince1970]];
        CLog(@"timeSp:%@", uuid);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:uuid forKey:UUID];
    }
    
    CLog(@"timeSp:%@", uuid);
    
    return uuid;
}

+ (void) connectServer
{
    NSString *pushAddress = [[NSUserDefaults standardUserDefaults] objectForKey:PUSHADDRESS];
    NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:PORT];
    if (pushAddress && port)
    {
        CLog(@"push:%@", pushAddress);
        CLog(@"push:%@", port);
        SingleMQTT *session = [SingleMQTT shareInstance];
        [session.session connectToHost:pushAddress
                                  port:port.intValue];
        [session.session subscribeTopic:[SingleMQTT getCurrentDevTopic]];
        [session.session subscribeTopic:@"adtopic"];
        [session.session subscribeTopic:@"ggtopic"];
        CLog(@"Topic:%@", [SingleMQTT getCurrentDevTopic]);
    }
    else
    {
        //异步获取重新连接
        [MainViewController getWebServerAddress];
        [SingleMQTT connectServer];
    }
}
@end
