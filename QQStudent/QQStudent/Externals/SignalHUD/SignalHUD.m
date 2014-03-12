//
//  SignalHUD.m
//  QQStudent
//
//  Created by lynn on 14-3-2.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SignalHUD.h"

static SignalHUD *sessionInstance = nil;

@implementation SignalHUD
@synthesize hud;

+(id)shareInstance
{
    if(sessionInstance == nil)
    {
        @synchronized(self)
        {
            if(sessionInstance==nil)
            {
                sessionInstance = [[[self class] alloc] init];
                
                CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
                sessionInstance.hud = [[[MBProgressHUD alloc] initWithView:nav.view]autorelease];
                [nav.view addSubview:sessionInstance.hud];
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
