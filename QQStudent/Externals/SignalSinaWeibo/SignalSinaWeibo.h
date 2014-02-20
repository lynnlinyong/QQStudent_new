//
//  SignalSinaWeibo.h
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignalSinaWeibo : NSObject
@property (nonatomic, assign) SinaWeibo *sinaWeibo;
+(id)shareInstance:(id<SinaWeiboDelegate>) delegate;
@end
