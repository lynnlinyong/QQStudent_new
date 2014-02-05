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
}

@property (nonatomic, retain) NSDictionary *teacherItem;
@end
