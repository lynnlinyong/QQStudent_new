//
//  UIViewController+ShowError.m
//  LivAllRadar
//
//  Created by Lynn on 12-11-22.
//  Copyright (c) 2012年 WiMi. All rights reserved.
//

#import "UIViewController+ShowError.h"

@implementation UIViewController (ShowError)

- (void) showAlertWithTitle:(NSString *)     title
                        tag:(int)            tag
                    message:(NSString *)     message 
                   delegate:(id)             delegate 
          otherButtonTitles:(id)             btnTitleObj, ...
{   
    UIAlertView *alertView = [[UIAlertView alloc]init];
    [alertView setTag:tag];
    [alertView setTitle:title];
    [alertView setMessage:message];
    [alertView setDelegate:delegate];
    
    va_list args;  
    va_start(args, btnTitleObj);  
    if (btnTitleObj != nil) 
    {  
        [alertView addButtonWithTitle:btnTitleObj];
        id nextTitle = nil;  
        while ((nextTitle = va_arg(args, id)) != nil) 
        {  
            [alertView addButtonWithTitle:nextTitle];
        }
    }  
    [alertView setCancelButtonIndex:0];
    [alertView show];
    [alertView release];
}

@end
