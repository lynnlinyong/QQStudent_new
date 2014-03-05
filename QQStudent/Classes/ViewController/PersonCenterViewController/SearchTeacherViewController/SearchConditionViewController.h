//
//  SearchConditionViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-30.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchConditionViewController : UIViewController<
                                                        CustomNavigationDataSource,
                                                        CustomButtonViewDelegate,
                                                        ServerRequestDelegate,
                                                        UILongPressButtonDelegate,
                                                        RecordAudioDelegate,
                                                        UIGestureRecognizerDelegate,
                                                        UITextFieldDelegate,
                                                        UITableViewDelegate,
                                                        UITableViewDataSource>
{
    UILabel     *timeValueLab;
    UITableView *orderTab;
    
    UILabel *dateValLab;
    UILabel *subValLab;
    UILabel *sexValLab;
    UILabel *salaryValLab;
    UILabel *posValLab;
    
    NSDictionary *salaryDic;
    
    UIButton *orderBtn;
    UIButton *recordBtn;
    UIButton *keyBoardBtn;
    
    CustomButtonView  *reCustomBtnView;
    CustomButtonView  *clrBtnView;
    UIImageView       *soundImageView;
    
    UILongPressButton *recordLongPressBtn;
    UIButton          *recordSuccessBtn;
    
    UITextField *messageField;
    
    RecordAudio *recordAudio;
    BOOL        isRecord;
    Order       *curOrder;
}

@property (nonatomic, retain) Teacher         *tObj;
@property (nonatomic, copy)   NSDictionary    *posDic;
@end
