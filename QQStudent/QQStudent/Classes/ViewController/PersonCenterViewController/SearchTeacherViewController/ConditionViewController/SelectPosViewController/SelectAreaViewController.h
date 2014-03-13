//
//  SelectrAreaViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-20.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAreaViewController : UIViewController<UIGridViewDelegate>
{
    UIGridView *gdView;
    NSMutableArray *valueArray;
    NSMutableArray *cellArray;
    
    int  curSelIndex;
    
    NSString *proviceValue;
    NSString *cityValue;
    NSString *distValue;
    
    UIButton *distBtn;
    UIButton *cityBtn;
    UIButton *proviceBtn;
    UIButton *okBtn;
}
@end
