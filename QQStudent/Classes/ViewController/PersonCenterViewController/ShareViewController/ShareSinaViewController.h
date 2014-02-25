//
//  ShareSinaViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareSinaViewController : UIViewController<
                                                    SinaWeiboDelegate,
                                                    UITextFieldDelegate,
                                                    SinaWeiboRequestDelegate>
{
    TTImageView  *shareImgView;
    UITextField  *shareContentFld;
}
@end
