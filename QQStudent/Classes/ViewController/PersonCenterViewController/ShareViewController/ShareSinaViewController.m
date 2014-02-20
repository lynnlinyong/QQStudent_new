//
//  ShareSinaViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ShareSinaViewController.h"

@interface ShareSinaViewController ()

@end

@implementation ShareSinaViewController

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

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, 0, 40, 20);
    [shareBtn addTarget:self
                 action:@selector(doShareBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    
    shareImgView = [[UIImageView alloc]init];
    shareImgView.image = [UIImage imageNamed:@"shareIcon.jpg"];
    shareImgView.frame = [UIView fitCGRect:CGRectMake(20, 20, 50, 50) isBackView:NO];
    [self.view addSubview:shareImgView];
    
    shareContentFld = [[UITextField alloc]init];
    shareContentFld.font        = [UIFont systemFontOfSize:12.f];
    shareContentFld.text        = @"轻轻家教学生版,快快去下载哦!";
    shareContentFld.delegate    = self;
    shareContentFld.borderStyle = UITextBorderStyleLine;
    shareContentFld.frame = [UIView fitCGRect:CGRectMake(70, 20, 230, 80) isBackView:NO];
    [self.view addSubview:shareContentFld];
}

#pragma mark -
#pragma mark - Control Event
- (void) doShareBtnClicked:(id)sender
{
    UIImage *picImg = [UIImage imageNamed:@"shareIcon.jpg"];
    SignalSinaWeibo *sgWeibo = [SignalSinaWeibo shareInstance:self];
    [sgWeibo.sinaWeibo requestWithURL:@"statuses/upload.json"
                               params:[NSMutableDictionary
                                       dictionaryWithObjectsAndKeys:shareContentFld.text,@"status",picImg,@"pic",nil] httpMethod:@"POST"
                             delegate:self];

}

#pragma mark -
#pragma mark - SinaWeiboRequestDelegate

- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
    
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    CLog(@"Send Message Success!");
}
@end
