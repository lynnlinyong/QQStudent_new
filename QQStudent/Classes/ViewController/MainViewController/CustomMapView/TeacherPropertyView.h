//
//  TeacherPropertyView.h
//  QQStudent
//
//  Created by lynn on 14-2-8.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherPropertyView : UIView<TTImageViewDelegate>
{
    UILabel           *introLab;
    UILabel           *tsLab;
    UIStartsImageView *sImgView;
    TTImageView       *headImgView;
}

@property (nonatomic, retain) UILabel *introLab;
@property (nonatomic, retain) UILabel *tsLab;
@property (nonatomic, retain) UIStartsImageView *sImgView;
@property (nonatomic, retain) TTImageView *headImgView;
@end
