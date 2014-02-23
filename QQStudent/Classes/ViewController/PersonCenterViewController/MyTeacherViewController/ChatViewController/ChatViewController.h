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
                                                        JSMessagesViewDataSource>
{
    UIButton   *listenBtn;
    UIButton   *employBtn;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    RecordAudio *recordAudio;
}

@property (nonatomic, copy)   Order   *order;
@property (nonatomic, copy)   Teacher *tObj;
@property (retain, nonatomic) NSMutableArray   *messages;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
