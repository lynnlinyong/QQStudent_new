//
//  SiteOtherViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-20.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SiteOtherViewController.h"

@interface SiteOtherViewController ()

@end

@implementation SiteOtherViewController
@synthesize site;

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
    uiSView.delegate = nil;
    uiSView = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [site release];
    [uiSView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    uiSView = [[UIScrollView alloc]init];
    uiSView.delegate = self;
    uiSView.pagingEnabled = YES;
    uiSView.scrollEnabled = YES;
    CGRect rect   = [UIScreen getCurrentBounds];
    uiSView.frame = [UIView fitCGRect:CGRectMake(0, 0,
                                                 rect.size.width,
                                                 rect.size.height/2)
                           isBackView:NO];
    uiSView.contentSize = CGSizeMake(rect.size.width*site.imgArray.count,
                                     rect.size.height/2);
    [self.view addSubview:uiSView];
    
    //添加URL图片
    for (int i=0; i<site.imgArray.count; i++)
    {
        TTImageView *imgView = [[TTImageView alloc]init];
        imgView.URL   = [site.imgArray objectAtIndex:i];
        imgView.frame = CGRectMake(i*rect.size.width, 0,
                                   rect.size.width, rect.size.height/2);
        [uiSView addSubview:imgView];
        [imgView release];
    }
    
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.text  = site.name;
    nameLab.font  = [UIFont systemFontOfSize:14.f];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.frame = [UIView fitCGRect:CGRectMake(20, 250, 150, 20)
                           isBackView:NO];
    [self.view addSubview:nameLab];
    [nameLab release];
    
    UILabel *phoneLab = [[UILabel alloc]init];
    phoneLab.text = site.tel;
    phoneLab.textAlignment = NSTextAlignmentCenter;
    phoneLab.font = [UIFont systemFontOfSize:12.f];
    phoneLab.backgroundColor = [UIColor clearColor];
    phoneLab.frame= [UIView fitCGRect:CGRectMake(180, 250, 140, 20)
                           isBackView:NO];
    [self.view addSubview:phoneLab];
    [phoneLab release];
    
    UILabel *addLab = [[UILabel alloc]init];
    addLab.text = site.address;
    addLab.font = [UIFont systemFontOfSize:12.f];
    addLab.backgroundColor = [UIColor clearColor];
    addLab.frame= [UIView fitCGRect:CGRectMake(20, 280, 280, 20)
                         isBackView:NO];
    [self.view addSubview:addLab];
    [addLab release];
    
    UILabel *roomLab = [[UILabel alloc]init];
    if (site.emptyNumber==0)
        roomLab.text = @"目前教室情况: 满座";
    else
        roomLab.text = @"目前教室情况: 暂未满座";
    roomLab.font = [UIFont systemFontOfSize:12.f];
    roomLab.frame= [UIView fitCGRect:CGRectMake(20, 310, 280, 20)
                          isBackView:NO];
    roomLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:roomLab];
    [roomLab release];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text = @"因预定人数较多,建议您先致电查询";
    infoLab.font = [UIFont systemFontOfSize:12.f];
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.frame= [UIView fitCGRect:CGRectMake(20, 360, 200, 20)
                          isBackView:NO];
    [self.view addSubview:infoLab];
    [infoLab release];
    
    UIButton *calBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    calBtn.tag = 1;
    [calBtn setImage:[UIImage imageNamed:@"tel_s"]
            forState:UIControlStateNormal];
    [calBtn addTarget:self
               action:@selector(doButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    calBtn.frame = [UIView fitCGRect:CGRectMake(320-65, 350, 40, 40)
                          isBackView:NO];
    [self.view addSubview:calBtn];
}

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    NSString *phone = [NSString stringWithFormat:@"tel://%@", site.tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}
@end
