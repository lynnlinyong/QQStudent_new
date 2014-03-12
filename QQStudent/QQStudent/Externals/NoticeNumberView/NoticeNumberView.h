//
//  NoticeNumberView.h
//  QQStudent
//
//  Created by lynn on 14-2-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeNumberView : UIView
{
    UIImageView *bgImgView;
    UILabel     *contentLab;
}

- (void) setTitle:(NSString *) title;
@end
