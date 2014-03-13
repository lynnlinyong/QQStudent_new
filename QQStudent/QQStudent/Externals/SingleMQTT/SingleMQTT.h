//
//  SingleMQTT.h
//  QQStudent
//
//  Created by lynn on 14-2-9.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MQTTSession;
@interface SingleMQTT : NSObject
@property (nonatomic, assign) MQTTSession *session;
+(id)shareInstance;
+(NSString *) getCurrentDevTopic;
+ (void) connectServer;
@end
