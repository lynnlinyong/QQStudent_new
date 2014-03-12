//
//  PersonCenterViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCenterViewController : LeveyTabBarController<CustomNavigationDataSource>
{
//    UITabBarController    *pTabBarCtr;
}
@property (nonatomic,copy) Order *order;
@end
