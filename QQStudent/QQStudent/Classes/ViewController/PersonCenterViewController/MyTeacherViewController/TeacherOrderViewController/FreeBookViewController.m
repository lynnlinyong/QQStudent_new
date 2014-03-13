//
//  FreeBookViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-14.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "FreeBookViewController.h"

@interface FreeBookViewController ()

@end

@implementation FreeBookViewController
@synthesize orderId;
@synthesize adURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [webView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action

- (void) initUI
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD showHUDAddedTo:nav.view
                         animated:YES];
    
    NSURLRequest *request = nil;
    if (orderId)
    {
        NSString *ssid   = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *urlStr = [NSString stringWithFormat:@"%@book/?orderid=%@&sessid=%@", webAdd,orderId,ssid];
        NSURL *url = [NSURL URLWithString:urlStr];
        request = [NSURLRequest requestWithURL:url];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:adURL];
        request = [NSURLRequest requestWithURL:url];
    }
    
    webView = [[UIWebView alloc]init];
    webView.delegate = self;
    webView.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 460)
                           isBackView:NO];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void) closeDialog
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view
                         animated:YES];
}

//显示Dialog,能主动点击
- (void) Dialog:(NSString *) title
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD showHUDAddedTo:nav.view
                         withText:title
                         animated:YES
                         delegate:self];
}

- (void) showAlert:(NSString *) title
{   
    //显示3秒，自动消失
    __block LBorderView *alertView = [[LBorderView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-140, self.view.frame.size.height/2-25,
                                                             280, 50)];
    alertView.borderType   = BorderTypeSolid;
    alertView.dashPattern  = 8;
    alertView.spacePattern = 8;
    alertView.borderWidth  = 1;
    alertView.cornerRadius = 5;
    alertView.alpha = 0.7;
    alertView.borderColor     = [UIColor whiteColor];
    alertView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:alertView];
    
    alertView.alpha   = 1.0f;
    alertView.backgroundColor = [UIColor grayColor];
    alertView.frame = CGRectMake(self.view.frame.size.width/2-140, self.view.frame.size.height/2-25,
                                 280, 50);
    [self.view addSubview:alertView];
    
    UILabel *contentLab = [[UILabel alloc]init];
    contentLab.text = title;
    contentLab.font = [UIFont systemFontOfSize:14.f];
    contentLab.textColor = [UIColor whiteColor];
    contentLab.backgroundColor = [UIColor clearColor];
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.frame = CGRectMake(0, 0, alertView.frame.size.width-10, 40);
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    contentLab.numberOfLines = 0;
    [alertView addSubview:contentLab];
    [contentLab release];
    
    [UIView animateWithDuration:1 animations:^{
        alertView.alpha = 1.0f;
    }];
    
    [UIView animateWithDuration:4.0f animations:^{
        alertView.alpha = 0.0f;
    } completion:^(BOOL finished) {
       //alertView消失
        alertView.hidden = YES;
        [alertView removeFromSuperview];
        [alertView release];
        alertView = nil;
    }];
}

#pragma mark -
#pragma mark - Clicked Response
- (void) tapGestureResponse:(UIGestureRecognizer *) gesture
{
    MBProgressHUD *hud = (MBProgressHUD *)[gesture view];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES];
}

- (void) getToken
{
    //调用js函数
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSString *func = [NSString stringWithFormat:@"%@(\'%@\')", @"getToken", ssid];
    CLog(@"func:%@", func);
    [webView stringByEvaluatingJavaScriptFromString:func];
}

- (void) getOrderid
{
    //调用js函数
    NSString *func = [NSString stringWithFormat:@"%@(%@)", @"getOrderid", orderId];
    CLog(@"func:%@", func);
    [webView stringByEvaluatingJavaScriptFromString:func];
}

#pragma mark -
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    CLog(@"URL:%@", request.mainDocumentURL.relativePath);
    NSString *url = request.mainDocumentURL.relativePath;
    
    NSString *closeDialog = @"/function/closeDialog";
    NSString *dialog      = @"/function/Dialog";
    NSString *alert       = @"/function/alert";
    NSString *getToken    = @"/call/getToken";
    NSString *getOrderid  = @"/call/getOrderid";
    
    NSRange range = [url rangeOfString:closeDialog];
    if (range.location != NSNotFound)
    {
        [self closeDialog];
        return NO;
    }
    
    range = [url rangeOfString:dialog];
    if (range.location != NSNotFound)
    {
        NSString *params = [url substringFromIndex:range.length+range.location+1];
        CLog(@"prams:%@", params);
        [self Dialog:params];
        return NO;
    }
    
    range = [url rangeOfString:alert];
    if (range.location != NSNotFound)
    {
        NSString *params = [url substringFromIndex:range.length+range.location+1];
        CLog(@"prams:%@,%d,%d", params, range.length,range.location+1);
        [self showAlert:params];
        return NO;
    }
    
    range = [url rangeOfString:getToken];
    if (range.location != NSNotFound)
    {
        [self getToken];
        return NO;
    }
    
    range = [url rangeOfString:getOrderid];
    if (range.location != NSNotFound)
    {
        [self getOrderid];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CLog(@"Finish upLoad Success!");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    CLog(@"Finish upLoad Failed!");    
}
@end
