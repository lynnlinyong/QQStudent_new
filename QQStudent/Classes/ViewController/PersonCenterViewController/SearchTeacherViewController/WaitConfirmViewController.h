//
//  WaitConfirmViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-9.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitConfirmViewController : UIViewController<MAMapViewDelegate,ServerRequestDelegate>
{
    SingleMQTT *session;
    NSTimer    *timer;
    UILabel    *timeLab;
    UIButton   *showBtn;
    UIButton   *reBtn;
}

@property (nonatomic, copy)   Teacher        *tObj;
@property (nonatomic, copy)   NSDictionary   *valueDic;
@property (nonatomic, copy)   NSMutableArray *teacherArray;
@property (nonatomic, retain) MAMapView      *mapView;
@end
