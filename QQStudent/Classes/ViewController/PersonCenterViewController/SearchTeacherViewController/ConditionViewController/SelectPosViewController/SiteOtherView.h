//
//  SiteOtherView.h
//  QQStudent
//
//  Created by lynn on 14-2-20.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SiteOtherView;
@protocol SiteOtherViewDelegate <NSObject>

- (void) view:(SiteOtherView *) view clickedTag:(int) tag;

@end

@interface SiteOtherView : UIView
{
    UILabel *siteNameLab;
    UILabel *infoLab;
    UILabel *expenseLab;
    UILabel *posLab;
    UILabel *telLab;
    
    UIButton *calBtn;
    
    TTImageView *mainImgView;
}

@property (nonatomic, retain) UILabel *siteNameLab;
@property (nonatomic, retain) UILabel *infoLab;
@property (nonatomic, retain) UILabel *expenseLab;
@property (nonatomic, retain) UILabel *posLab;
@property (nonatomic, retain) UILabel *telLab;
@property (nonatomic, copy)   Site    *site;
@property (nonatomic, retain) TTImageView *mainImgView;
@property (nonatomic, assign) id<SiteOtherViewDelegate> delegate;
@end
