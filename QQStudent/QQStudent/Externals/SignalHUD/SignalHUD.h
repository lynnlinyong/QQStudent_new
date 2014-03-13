//
//  SignalHUD.h
//  QQStudent
//
//  Created by lynn on 14-3-2.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignalHUD : NSObject
@property (nonatomic, assign) MBProgressHUD *hud;
+(id)shareInstance;
@end
