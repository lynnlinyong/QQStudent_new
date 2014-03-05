//
//  ThreadTimer.m
//  QQStudent
//
//  Created by lynn on 14-3-2.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ThreadTimer.h"

@implementation ThreadTimer
@synthesize hour   = _hour;
@synthesize minute = _minute;
@synthesize second = _second;
@synthesize totalSeconds = _totalSeconds;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_strHour release];
    [_strMinute release];
    [_strSecond release];
    [super dealloc];
}

- (void) setMinutesNum:(NSInteger)second
{
    self.totalSeconds = second;
    
    //多线程启动定时器
    [NSThread detachNewThreadSelector:@selector(startTimer)
                             toTarget:self
                           withObject:nil];
    
}

- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(timerFire)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

- (void)handleWithTotalSeconds
{
//    self.hour   = _totalSeconds/3600;
//    self.minute = _totalSeconds%3600/60;
//    self.second = _totalSeconds%3600%60;
//    self.second = 
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(secondResponse:)])
        {
            [_delegate secondResponse:self];
        }
    }
}

- (void)setTotalSeconds:(NSInteger)totalSeconds
{
    _totalSeconds = totalSeconds;
    [self performSelectorOnMainThread:@selector(handleWithTotalSeconds)
                           withObject:nil
                        waitUntilDone:YES];
}

- (void)timerFire
{
    if (_totalSeconds == 0)
    {
        [_timer invalidate];
        return;
    }
    
    self.totalSeconds -= 1;
}
@end