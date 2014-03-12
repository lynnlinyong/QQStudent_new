//
//  SettingViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _tagUpdateType
{
    EmailUpdate=0,
    PhoneUpdate,
    OtherUpdate
}UpdateType;

@interface SettingViewController : UIViewController<
                                                    ServerRequestDelegate,
                                                    UITableViewDataSource,
                                                    UITableViewDelegate>
{
    UITableView   *setTab;
    
    UISwitch      *phoneSw;
    UISwitch      *locSw;
    
    UILabel       *emailValLab;
    UILabel       *phoneValLab;
    UILabel       *gradeValLab;
    UILabel       *accountValLab;
    
    Student       *student;
    
    UpdateType    updateType;
}

@end
