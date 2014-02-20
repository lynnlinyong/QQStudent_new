//
//  SystemMessageViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-15.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMessageViewController : UIViewController<
UITableViewDelegate,UITableViewDataSource,ServerRequestDelegate>
{
    UITableView     *systemMsgTab;
    NSMutableArray  *systemMsgArray;
}
@end
