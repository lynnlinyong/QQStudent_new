//
//  AboutSoftwareViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-30.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "AboutSoftwareViewController.h"

@interface AboutSoftwareViewController ()
@property (nonatomic, retain) UIWebView *webView;
@end

@implementation AboutSoftwareViewController

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

- (void) viewDidUnload
{
    self.webView = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [self.webView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    self.webView = [[UIWebView alloc]init];
    self.webView.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 400)
                                isBackView:NO];
    [self.view addSubview:self.webView];
    
    NSString *filePath   = [[NSBundle mainBundle]pathForResource:@"about"
                                                          ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    [self.webView loadHTMLString:htmlString
                         baseURL:[NSURL URLWithString:filePath]];
}
@end
