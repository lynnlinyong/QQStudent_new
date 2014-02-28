//
//  SelectSexViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectSexViewController : UIViewController<
                                                    UITableViewDelegate,
                                                    UITableViewDataSource,
                                                    QRadioButtonDelegate>
{
    UITableView *gdView;
    int         selectRadioIndex;
}

@property (nonatomic, assign) BOOL isSetSex;
@end
