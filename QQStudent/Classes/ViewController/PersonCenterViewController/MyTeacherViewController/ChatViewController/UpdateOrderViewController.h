//
//  UpdateOrderViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-12.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateOrderViewController : UIViewController<
                                                    ServerRequestDelegate,
                                                    UITableViewDelegate,
                                                    UITableViewDataSource>
{
    UITableView  *upTab;
    UILabel      *dateValLab;
    UILabel      *salaryValLab;
    UILabel      *timeValueLab;
    UILabel      *posValLab;
    
    UILabel      *totalMoneyLab;
}

@property (nonatomic, copy) Order *order;
@end
