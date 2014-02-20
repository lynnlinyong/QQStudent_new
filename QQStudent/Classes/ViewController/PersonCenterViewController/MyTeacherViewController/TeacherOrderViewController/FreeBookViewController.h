//
//  FreeBookViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-14.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeBookViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *webView;
}
@property (nonatomic, retain) NSString *orderId;
@end
