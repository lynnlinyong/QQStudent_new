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
                         withText:@"加载图书中..."
                         animated:YES];
    
    NSString *ssid   = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *urlStr = [NSString stringWithFormat:@"%@book/?orderid=%@&sessid=%@", webAdd,orderId,ssid];
    CLog(@"urlStr:%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
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
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
}

//显示Dialog,能主动点击
- (void) Dialog
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD showHUDAddedTo:nav.view
                         withText:@"发送抢书…………"
                         animated:YES];
    
    //调用getToken & getOrderid
}

- (void) showAlert
{
    
}

- (void) getToken
{
    
}

- (void) getOrderid
{
    //调用js函数
    NSString *func = [NSString stringWithFormat:@"%@(\"%@\")", @"getOrderid", orderId];
    CLog(@"func:%@", func);
    [webView stringByEvaluatingJavaScriptFromString:@"getOrderid(772)"];
}

#pragma mark -
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    CLog(@"URL:%@", request.mainDocumentURL.relativePath);
    if([request.mainDocumentURL.relativePath isEqualToString:@"/function/closeDialog"])
    {
        [self closeDialog];
        return FALSE;
    }
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/function/Dialog"])
    {
        [self Dialog];
    }
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/function/alert"])
    {
        [self showAlert];
    }
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/call/getToken"])
    {
        [self getToken];
    }
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/call/getOrderid"])
    {
        [self getOrderid];
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
