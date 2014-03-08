//
//  ChatViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : JSMessagesViewController<
                                                        RecordAudioDelegate,
                                                        ServerRequestDelegate,
                                                        EGORefreshTableHeaderDelegate,
                                                        JSMessagesViewDelegate,
                                                        JSMessagesViewDataSource,CustomNavigationDataSource>
{
    UIButton   *listenBtn;
    UIButton   *employBtn;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    RecordAudio *recordAudio;
    
    LBorderView *infoView;
    UIView      *employInfoView;
}
@property (nonatomic, assign) BOOL    isFromSearchCondition;
@property (nonatomic, copy)   Order   *order;
@property (nonatomic, copy)   Teacher *tObj;
@property (nonatomic, retain) UIButton *listenBtn;
@property (nonatomic, retain) UIButton *employBtn;
@property (retain, nonatomic) NSMutableArray   *messages;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
