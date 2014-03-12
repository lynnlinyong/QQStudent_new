//
//  TeacherDetailViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherDetailViewController : UIViewController<ServerRequestDelegate,TTImageViewDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>
{
    UIImageView *headImageView;
    UIImageView *bgImgView;
    UIScrollView *bgScroll;
    
    MBProgressHUD *HUD;
}
@property (nonatomic, copy) Teacher  *tObj;
@end
