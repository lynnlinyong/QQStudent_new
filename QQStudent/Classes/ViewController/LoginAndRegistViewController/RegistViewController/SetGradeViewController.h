//
//  SetGradeViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-4.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIGridView;
@class QRadioButton;
@interface SetGradeViewController : UIViewController<
                                                    MBProgressHUDDelegate,
                                                    ServerRequestDelegate,
                                                    UIGridViewDelegate,
                                                    QRadioButtonDelegate>
{
    UIGridView  *gdView;
    NSString    *radioTitle;
    
    NSMutableArray  *gradeArr;
    
    int index;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSString *gradeName;
@end
