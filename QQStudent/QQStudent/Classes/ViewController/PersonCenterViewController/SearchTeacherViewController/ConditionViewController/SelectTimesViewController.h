//
//  SelectTimesViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTimesViewController : UIViewController<
                                                    UIPickerViewDelegate,
                                                    UIPickerViewDataSource>
{
    UILabel  *infoLab;
    UIPickerView *timePickerView;
}

@property (nonatomic, retain) NSString *curValue;
@end
