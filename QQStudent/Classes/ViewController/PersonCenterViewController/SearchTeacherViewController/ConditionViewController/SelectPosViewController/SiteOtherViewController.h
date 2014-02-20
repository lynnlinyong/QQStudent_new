//
//  SiteOtherViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-20.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiteOtherViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView  *uiSView;
}

@property (nonatomic, copy) Site *site;
@end
