//
//  AppDelegate.h
//  QQStudent
//
//  Created by lynn on 14-1-23.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTTSession.h"

@interface AppDelegate : UIResponder <
                                    UIApplicationDelegate,
                                    WXApiDelegate,
                                    ServerRequestDelegate>
@property (strong, nonatomic) UIWindow *window;

+ (BOOL) isInView:(NSString *) vctrName;
+(void) dealWithMessage:(NSDictionary *)msgDic isPlayVoice:(BOOL) isPlay;
@end
