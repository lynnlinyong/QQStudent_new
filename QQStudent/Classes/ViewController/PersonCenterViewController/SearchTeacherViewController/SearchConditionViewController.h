//
//  SearchConditionViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-30.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchConditionViewController : UIViewController<
                                                        UITableViewDelegate,
                                                        UITableViewDataSource>
{
    UILabel *timeValueLab;
    UITableView *orderTab;
    
    UILabel *dateValLab;
    UILabel *subValLab;
    UILabel *sexValLab;
    UILabel *salaryValLab;
    UILabel *posValLab;
    
    NSDictionary *salaryDic;
}

@property (nonatomic, retain) Teacher *tObj;
@property (nonatomic, copy) NSDictionary    *posDic;
@property (nonatomic, copy) NSMutableArray  *teacherArray;
@end
