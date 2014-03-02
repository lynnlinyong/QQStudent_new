//
//  WaitConfirmViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-9.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitConfirmViewController : UIViewController<
                                                    ThreadTimerDelegate,
                                                    MAMapViewDelegate,
                                                    ServerRequestDelegate,
                                                    CustomNavigationDataSource>
{
    SingleMQTT *session;
    UIButton   *showBtn;
    UIButton   *reBtn;
    
    int        curPage;
    int        timeTicker;
    int        waitTimeInvite;
    BOOL       isLast;
    NSMutableArray *teacherArray;
    
    LBorderView *borderView;
    
    LBorderView *infoView;
    
    CustomPointAnnotation *distAnn;
    
    int cnt;
    UILabel *cntLab;
    UILabel     *inviteCountLab;
    UIImageView *cntTimeImageView;
    
    ThreadTimer *timer;
}

@property (nonatomic, copy)   Teacher        *tObj;
@property (nonatomic, copy)   NSDictionary   *valueDic;
@property (nonatomic, retain) MAMapView      *mapView;
@end
