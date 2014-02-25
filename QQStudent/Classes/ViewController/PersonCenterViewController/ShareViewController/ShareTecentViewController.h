//
//  ShareTecentViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareTecentViewController : UIViewController<
                                                    UITextFieldDelegate,
                                                    WeiboRequestDelegate>
{
    TTImageView  *shareImgView;
    UITextField  *shareContentFld;
}
@end
