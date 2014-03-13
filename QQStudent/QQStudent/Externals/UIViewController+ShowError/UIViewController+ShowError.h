//
//  UIViewController+ShowError.h
//  LivAllRadar
//
//  Created by Lynn on 12-11-22.
//  Copyright (c) 2012年 WiMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ShowError)

- (void) showAlertWithTitle:(NSString *)     title
                        tag:(int)            tag
                    message:(NSString *)     message
                   delegate:(id)             delegate
          otherButtonTitles:(id)             btnTitleObj, ...;
@end
