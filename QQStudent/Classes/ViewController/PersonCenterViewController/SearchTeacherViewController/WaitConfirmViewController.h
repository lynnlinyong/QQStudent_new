//
//  WaitConfirmViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-9.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitConfirmViewController : UIViewController<
                                                    MAMapViewDelegate,
                                                    ServerRequestDelegate,
                                                    CustomNavigationDataSource>
{
    SingleMQTT *session;
    NSTimer    *timer;
    UILabel    *timeLab;
    UIButton   *showBtn;
    UIButton   *reBtn;
    
    int        curPage;
    int        timeTicker;
    int        waitTimeInvite;
    BOOL       isLast;
    NSMutableArray *teacherArray;
}

@property (nonatomic, copy)   Teacher        *tObj;
@property (nonatomic, copy)   NSDictionary   *valueDic;
@property (nonatomic, retain) MAMapView      *mapView;
@end
