//
//  MyTeacherViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerHeader.h"

@interface MyTeacherViewController : UIViewController<
                                                    MyTeacherCellDelegate,
                                                    EGORefreshTableHeaderDelegate,
                                                    UITableViewDelegate,
                                                    UITableViewDataSource>
{
    UITableView         *teacherTab;
    NSMutableArray      *teacherArray;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
