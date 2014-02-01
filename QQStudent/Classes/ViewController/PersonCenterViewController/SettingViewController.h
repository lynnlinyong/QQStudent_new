//
//  SettingViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<
                                                    UITableViewDataSource,
                                                    UITableViewDelegate>
{
    UITableView   *setTab;
}

@end
