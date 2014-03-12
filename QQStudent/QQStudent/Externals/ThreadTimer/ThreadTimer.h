//
//  ThreadTimer.h
//  QQStudent
//
//  Created by lynn on 14-3-2.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ThreadTimer;
@protocol ThreadTimerDelegate <NSObject>
- (void) secondResponse:(ThreadTimer *) timer;
@end

@interface ThreadTimer : NSObject
{
    NSTimer *_timer;
}
 
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, assign) NSInteger totalSeconds;

@property (nonatomic, copy)   NSString  *strHour;
@property (nonatomic, copy)   NSString  *strMinute;
@property (nonatomic, copy)   NSString  *strSecond;

@property (nonatomic, assign) id<ThreadTimerDelegate> delegate;

- (void) setMinutesNum:(NSInteger)second;
@end
