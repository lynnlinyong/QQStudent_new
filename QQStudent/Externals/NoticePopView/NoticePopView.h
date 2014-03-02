//
//  NoticePopView.h
//  QQStudent
//
//  Created by lynn on 14-2-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareData.h"

@interface NoticePopView : UIView
{
    UILabel   *titleLab;
    UILabel   *contentLab;
    UIButton  *okBtn;
    
    LBorderView *bgView;
}

@property (nonatomic, assign) NoticeType  noticeType;
@property (nonatomic, copy)   NSDictionary *contentDic;
@property (nonatomic, retain) UILabel *titleLab;
@property (nonatomic, retain) UILabel *contentLab;

- (void) popView;
+(id)shareInstance;
@end
