//
//  SetSexViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-4.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIGridView;
@class QRadioButton;
@interface SetSexViewController : UIViewController<
                                                UIGridViewDelegate,
                                                QRadioButtonDelegate>
{
    UIGridView  *gdView;
    int         selectRadioIndex;
}
@end
