//
//  UpdateEmailViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-16.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateEmailViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *txtFld;
    UIButton    *okBtn;
}
@property (nonatomic, retain) NSString *email;
@end
