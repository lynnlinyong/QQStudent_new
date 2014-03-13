//
//  SelectSubjectViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectSubjectViewController : UIViewController<
                                                        ServerRequestDelegate,
                                                        UIGridViewDelegate,
                                                        QRadioButtonDelegate>
{
    UIGridView  *gdView;
    NSString    *radioTitle;
    
    NSMutableArray *subArr;
    int index;
}

@property (nonatomic, retain) NSString *subName;
@end
