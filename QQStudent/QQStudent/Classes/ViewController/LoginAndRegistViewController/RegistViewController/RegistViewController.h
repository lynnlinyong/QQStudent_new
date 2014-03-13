//
//  RegistViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController<
                                                MBProgressHUDDelegate,
                                                UIAlertViewDelegate,
                                                UITextFieldDelegate,
                                                ServerRequestDelegate>
{
    UITextField *userNameFld;
    UITextField *phoneFld;
    UIButton    *registBtn;
    
    UIImageView *emailImgView;
    UIImageView *phoneImgView;
    
    MBProgressHUD *HUD;
}
@end
