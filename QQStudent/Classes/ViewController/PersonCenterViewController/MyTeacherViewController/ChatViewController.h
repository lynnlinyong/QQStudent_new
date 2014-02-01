//
//  ChatViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerHeader.h"

@interface ChatViewController : UIViewController<UIBubbleTableViewDataSource>
{
    NSMutableArray     *bubbleData;
    UIBubbleTableView  *bubbleTable;
}
@end
