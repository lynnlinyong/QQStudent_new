//
//  CustomDatePicker.h
//  DatePicker
//
//  Created by lynn on 14-3-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDJCalendar.h"
@interface CustomDatePicker : UIView <UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *datePickerView;
    IDJCalendar *cal;
    
    NSMutableArray *years;
    NSMutableArray *months;
    NSMutableArray *days;
    NSMutableArray *apls;
    
    NSString *curYear;
    NSString *curMonth;
    NSString *curDay;
    NSString *curApl;
}

- (NSString *) getCurValueRows;

- (void) setValueRows:(NSString *) date;
@end
