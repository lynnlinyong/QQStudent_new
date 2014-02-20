//
//  ChatViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : JSMessagesViewController<
                                                        ServerRequestDelegate,
                                                        EGORefreshTableHeaderDelegate,
                                                        JSMessagesViewDelegate,
                                                        JSMessagesViewDataSource>
{
    UIButton   *listenBtn;
    UIButton   *employBtn;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

@property (nonatomic, copy)   Order *order;
@property (retain, nonatomic) NSMutableArray   *messages;
@property (nonatomic, copy)   Teacher *tObj;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
