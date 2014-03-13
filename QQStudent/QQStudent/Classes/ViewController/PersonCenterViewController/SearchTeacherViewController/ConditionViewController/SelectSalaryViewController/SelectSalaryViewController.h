//
//  SelectSalaryViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectSalaryViewController : UIViewController<
                                            ServerRequestDelegate,
                                            SalaryAndFlagViewDelegate>
{
    UIScrollView *scrollView;
    NSArray      *potMoney;
    
    int          selIndex;
}

@property (nonatomic, retain) NSString *money;
@end
