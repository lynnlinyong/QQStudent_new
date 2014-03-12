//
//  SingleTCWeibo.h
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleTCWeibo : NSObject
@property (nonatomic, assign) WeiboApi *tcWeiboApi;
+(id)shareInstance;
@end
