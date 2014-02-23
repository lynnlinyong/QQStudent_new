//
//  UILongPressButton.m
//  QQStudent
//
//  Created by lynn on 14-2-22.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "UILongPressButton.h"

@implementation UILongPressButton
@synthesize delegate;
@synthesize isRecord;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isRecord    = NO;
        pressButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        pressButton.frame = CGRectMake(0,
                                       0,
                                       frame.size.width,
                                       frame.size.height);
        [pressButton setTitle:@"长按 说话"
                     forState:UIControlStateNormal];
        [pressButton addTarget:self
                        action:@selector(longPressDown:)
              forControlEvents:UIControlEventTouchDown];
        
        [pressButton addTarget:self
                        action:@selector(longPressUp:)
              forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [self addSubview:pressButton];
    }
    return self;
}

- (int) getVoiceTimes
{
    return endRecordTime;
}

#pragma mark -
#pragma makr - Control Event
- (void) longPressDown:(id)sender
{
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(longPressButton:status:)])
        {
            startRecordTime = [NSDate timeIntervalSinceReferenceDate];
            [delegate longPressButton:self status:LONG_PRESS_BUTTON_DOWN];
        }
    }
}

- (void) longPressUp:(id)sender
{
    endRecordTime = [NSDate timeIntervalSinceReferenceDate];
    endRecordTime -= startRecordTime;
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(longPressButton:status:)])
        {
            if (endRecordTime<2.f)
            {
                [delegate longPressButton:self
                                   status:LONG_PRESS_BUTTON_SHORT];
            }
            else if (endRecordTime>60.f)
            {
                [delegate longPressButton:self
                                   status:LONG_PRESS_BUTTON_LONG];
            }
            else
            {
                isRecord    = YES;
                [delegate longPressButton:self
                                   status:LONG_PRESS_BUTTON_UP];
            }
        }
    }
}
@end
