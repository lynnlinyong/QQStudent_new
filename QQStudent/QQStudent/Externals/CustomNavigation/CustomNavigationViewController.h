//
//  CustomNavigationViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-26.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomNavigationDataSource <NSObject>

- (UIBarButtonItem *) backBarButtomItem;

@end

@interface CustomNavigationViewController : UINavigationController
@property (nonatomic, assign) id<CustomNavigationDataSource> dataSource;
@end
