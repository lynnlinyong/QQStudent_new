//
//  SearchTeacherViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTeacherViewController : UIViewController<
                                                        TTImageViewDelegate,
                                                        ServerRequestDelegate,
                                                        UITextFieldDelegate,
                                                        UITableViewDelegate,
                                                        UITableViewDataSource,
                                                        MBProgressHUDDelegate>
{
    UILabel        *searchLab;
    UITextField    *searchFld;
    
    UITableView    *searchTab;
    NSMutableArray *searchArray;
    
    UIImageView    *bgImgView;
    UILabel        *bgInfoLab;
    
    UIButton       *headBtn;
}
@end
