//
//  ShareWeixinViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-18.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareWeixinViewController : UIViewController<
                                                    UITableViewDelegate,
                                                    UITableViewDataSource>
{
    UITableView  *shareTab;
}

@end
