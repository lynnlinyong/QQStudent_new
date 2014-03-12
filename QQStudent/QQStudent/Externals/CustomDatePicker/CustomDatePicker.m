//
//  CustomDatePicker.m
//  DatePicker
//
//  Created by lynn on 14-3-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "CustomDatePicker.h"


#define YEAR_START 1970//滚轮显示的起始年份
#define YEAR_END 2049//滚轮显示的结束年份

@implementation CustomDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        datePickerView = [[UIPickerView alloc]init];
        datePickerView.delegate   = self;
        datePickerView.dataSource = self;
        datePickerView.frame      = CGRectMake(0, 0, frame.size.width, frame.size.height) ;
        [self addSubview:datePickerView];
        
        cal = [[IDJCalendar alloc]initWithYearStart:YEAR_START
                                                end:YEAR_END];
        
        years = [[NSMutableArray alloc]init];
        NSArray *tyears = [[cal yearsInRange] copy];
        int row = [tyears indexOfObject:cal.year];
        for (int i=row; i<tyears.count; i++)
        {
            [years insertObject:[tyears objectAtIndex:i]
                        atIndex:i-row];
        }
        [tyears release];
        
        curYear  = cal.year;
        
        months   = [[cal monthsInYear:cal.year.intValue]copy];
        curMonth = cal.month;
        
        days  = [[cal daysInMonth:cal.month year:cal.year.intValue] copy];
        curDay = cal.day;
        
        apls   = [[NSMutableArray alloc]initWithObjects:@"上午",@"下午",@"晚上", nil];
        curApl = @"上午";
        
        [datePickerView setShowsSelectionIndicator:YES];
    }
    return self;
}

- (void) dealloc
{
    [years release];
    [months release];
    [apls release];
    [datePickerView release];
    [super dealloc];
}


- (int) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (int) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:        //年
        {
            return years.count;
        }
        case 1:        //月
        {
            return months.count;
        }
        case 2:        //日
        {
            return days.count;
        }
        case 3:        //AM,PM
        {
            return apls.count;
            break;
        }
        default:
            break;
    }
    
    return 1;
}

- (float) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:        //年
        {
            return 70;
        }
        case 1:        //月
        {
            return 40;
            break;
        }
        case 2:        //日
        {
            return 40;
            break;
        }
        case 3:        //AM,PM
        {
            return 60;
            break;
        }
        default:
            break;
    }
    
    return 20.f;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:        //年
        {
            return [years objectAtIndex:row];
        }
        case 1:        //月
        {
            return [months objectAtIndex:row];
            break;
        }
        case 2:        //日
        {
            return [days objectAtIndex:row];
            break;
        }
        case 3:        //AM,PM
        {
            return [apls objectAtIndex:row];
            break;
        }
        default:
            break;
    }
    
    return @"";
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:        //年
        {
            curYear = [[years objectAtIndex:row] retain];
            break;
        }
        case 1:        //月
        {
            curMonth = [[months objectAtIndex:row] retain];
            break;
        }
        case 2:        //日
        {
            curDay = [[days objectAtIndex:row] retain];
            break;
        }
        case 3:        //AM,PM
        {
            curApl = [apls objectAtIndex:row];
            break;
        }
        default:
            break;
    }
    
    [self refreshData];
}

- (void) showRows
{
    int yearRow  = [years indexOfObject:curYear];
    int monthRow = [months indexOfObject:curMonth];
    int dayRow   = [days indexOfObject:curDay];
    int aplRow   = [apls indexOfObject:curApl];
    CLog(@"days:%@ %d", days, dayRow);
    [datePickerView selectRow:yearRow
                  inComponent:0
                     animated:NO];
    [datePickerView selectRow:monthRow
                  inComponent:1
                     animated:NO];
    [datePickerView selectRow:dayRow
                  inComponent:2
                     animated:NO];
    [datePickerView selectRow:aplRow
                  inComponent:3
                     animated:NO];
}

- (void) setValueRows:(NSString *) date
{
    if (!date||date.length==0)
    {
        [self showRows];
        return;
    }
    
    NSRange start  = [date rangeOfString:@"/"];
    curYear = [[date substringToIndex:start.location] copy];
    
    NSString *sub  = [date substringFromIndex:start.location+1];
    NSRange end  = [sub rangeOfString:@"/"];
    NSRange r;
    r.location   = 0;
    r.length     = end.location;
    curMonth = [[sub substringWithRange:r] copy];
    
    NSRange space = [sub rangeOfString:@" "];
    NSRange d;
    d.location = end.location+1;
    d.length   = space.location - end.location-1;
    curDay = [[sub substringWithRange:d] copy];

    curApl = [[sub substringFromIndex:space.location+1] copy];
    CLog(@"y,m,d,a:%@ %@ %@ %@", curYear, curMonth, curDay, curApl);
    
    [self refreshData];
    
    [self showRows];
}

- (NSString *) getCurValueRows
{
    return [NSString stringWithFormat:@"%@/%@/%@ %@", curYear,curMonth,curDay,curApl];
}

- (void) refreshData
{
    [months release];
    months = [[cal monthsInYear:curYear.intValue]retain];
    
    [days release];
    days   = [[cal daysInMonth:curMonth year:curYear.intValue] retain];
    
    [datePickerView reloadComponent:0];
    [datePickerView reloadComponent:1];
    [datePickerView reloadComponent:2];
}
@end
