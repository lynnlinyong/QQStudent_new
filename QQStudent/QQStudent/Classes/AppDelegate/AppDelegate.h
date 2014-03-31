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

- (void) initMQTTServer;
+ (BOOL) isInView:(NSString *) vctrName;
+ (BOOL) isConnectionAvailable:(BOOL) animated withGesture:(BOOL) isCan;
+ (void) popToMainViewController;
+ (void) dealWithMessage:(NSDictionary *)msgDic isPlayVoice:(BOOL) isPlay;
@end
