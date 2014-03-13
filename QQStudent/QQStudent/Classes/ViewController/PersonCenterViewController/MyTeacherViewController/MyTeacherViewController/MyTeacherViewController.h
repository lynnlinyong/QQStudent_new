//
//  MyTeacherViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTeacherViewController : UITableViewController<
                                                    MBProgressHUDDelegate,
                                                    UIGestureRecognizerDelegate,
                                                    ServerRequestDelegate,
                                                    MyTeacherCellDelegate,
                                                    EGORefreshTableHeaderDelegate,
                                                    MFMessageComposeViewControllerDelegate>
{
    NSMutableArray      *teacherArray;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    UIImageView *bgImgView;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
