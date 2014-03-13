//
//  UIStartsImageView.h
//  QQStudent
//
//  Created by lynn on 14-1-30.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStartsImageView : UIView
{
    UIImageView  *star1ImgView;
    UIImageView  *star2ImgView;
    UIImageView  *star3ImgView;
    UIImageView  *star4ImgView;
    UIImageView  *star5ImgView;
    UIImageView  *star6ImgView;
}

- (void) setHlightStar:(int) count;
@end
