//
//  TeacherPropertyView.h
//  QQStudent
//
//  Created by lynn on 14-2-8.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeacherPropertyView;
@protocol TeacherPropertyViewDelegate <NSObject>

- (void) view:(TeacherPropertyView *) view clickedView:(id) clickView;

@end

@interface TeacherPropertyView : UIView<TTImageViewDelegate>
{
    UILabel           *introLab;
    UILabel           *tsLab;
    UIStartsImageView *sImgView;
    TTImageView       *headImgView;
    
    UIImageView       *goodImgView;
    UIImageView       *badImgView;
    UIImageView       *idImageView;
    UILabel *goodLab;
    UILabel *badLab;
    UILabel *orgNameLab;
}

@property (nonatomic, copy)   Teacher *tObj;
@property (nonatomic, retain) UILabel *introLab;
@property (nonatomic, retain) UILabel *tsLab;
@property (nonatomic, retain) UIStartsImageView *sImgView;
@property (nonatomic, retain) TTImageView *headImgView;
@property (nonatomic, assign) id<TeacherPropertyViewDelegate> delegate;

@property (nonatomic, retain) UIImageView *goodImgView;
@property (nonatomic, retain) UIImageView *badImgView;
@property (nonatomic, retain) UIImageView *idImageView;
@property (nonatomic, retain) UILabel     *goodLab;
@property (nonatomic, retain) UILabel     *badLab;
@property (nonatomic, retain) UILabel     *orgNameLab;

@end
