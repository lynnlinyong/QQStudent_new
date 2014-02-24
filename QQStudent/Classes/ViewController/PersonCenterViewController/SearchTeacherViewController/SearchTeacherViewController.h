//
//  SearchTeacherViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTeacherViewController : UIViewController<
                                                        ServerRequestDelegate,
                                                        UITextFieldDelegate,
                                                        UITableViewDelegate,
                                                        UITableViewDataSource>
{
    UILabel     *searchLab;
    UITextField *searchFld;
    
    UITableView    *searchTab;
    NSMutableArray *searchArray;
    
    UIImageView    *bgImgView;
    UILabel        *bgInfoLab;
}
@end
