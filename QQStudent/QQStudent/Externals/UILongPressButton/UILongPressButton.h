//
//  UILongPressButton.h
//  QQStudent
//
//  Created by lynn on 14-2-22.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _tagButtonStatus
{
    LONG_PRESS_BUTTON_DOWN=0,
    LONG_PRESS_BUTTON_UP,
    LONG_PRESS_BUTTON_SHORT,
    LONG_PRESS_BUTTON_LONG
}ButtonStatus;

@class UILongPressButton;
@protocol UILongPressButtonDelegate <NSObject>
- (void) longPressButton:(UILongPressButton *) btn status:(ButtonStatus) status;
@end

@interface UILongPressButton : UIView
{
    UIButton *pressButton;
    double startRecordTime;
    double endRecordTime;
}
@property (nonatomic, assign) BOOL isRecord;
@property (nonatomic, assign) id<UILongPressButtonDelegate> delegate;

- (int) getVoiceTimes;
@end
