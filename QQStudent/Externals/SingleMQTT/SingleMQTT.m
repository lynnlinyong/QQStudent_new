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
    NSString    *macAddressString = NULL;
    int         mgmtInfoBase[6];
    char        *msgBuffer = NULL;
    size_t      length = 0;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        NSLog(@"if_nametoindex failure");
    // Get the size of the data available (store in len)
    else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
        NSLog(@"sysctl mgmtInfoBase failure");
    // Alloc memory based on above call
    else if ((msgBuffer = malloc(length)) == NULL)
        NSLog(@"buffer allocation failure");
    // Get system information, store in buffer
    else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
    {
        free(msgBuffer);
        NSLog(@"sysctl msgBuffer failure");
    }
    else
    {
        // Map msgbuffer to interface message structure
        struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        struct sockaddr_dl *socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        unsigned char macAddress[6];
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        macAddressString = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
							macAddress[0], macAddress[1], macAddress[2],
							macAddress[3], macAddress[4], macAddress[5]];
        
        // Release the buffer memory
        free(msgBuffer);
    }
//    macAddressString = [NSString stringWithFormat:@"x_%@", macAddressString];
    return macAddressString;
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
