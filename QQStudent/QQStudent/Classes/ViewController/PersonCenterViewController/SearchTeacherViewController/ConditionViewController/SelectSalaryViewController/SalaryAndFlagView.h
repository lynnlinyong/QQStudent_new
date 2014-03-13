//
//  SalaryAndFlagView.h
//  QQStudent
//
//  Created by lynn on 14-2-20.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SalaryAndFlagView;
@protocol SalaryAndFlagViewDelegate <NSObject>

- (void) salaryView:(SalaryAndFlagView *) view tag:(int) tag;

@end

@interface SalaryAndFlagView : UIView
{
    UIImageView *potImgView;
    UIImageView *flagImgView;
    UILabel *infoRightLab;
    UILabel *infoLeftLab;
    
    UIImageView *leftBgImgView;
    UILabel     *leftBgLab;
    
    UIImageView *rightBgImgView;
    UILabel    *rightBgLab;
}

@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, retain) UILabel  *leftMoneyLab;
@property (nonatomic, retain) UILabel  *rightMoneyLab;
@property (nonatomic, assign) id<SalaryAndFlagViewDelegate> delegate;
@property (nonatomic, assign) CGRect       orginLeftRect;
@property (nonatomic, assign) CGRect       orginRightRect;
@property (nonatomic, retain) UIImageView *leftImgView;
@property (nonatomic, retain) UIImageView *rightImgView;


- (void) setLeft:(BOOL)left money:(NSString *) valName;

- (void) repickView;
@end
