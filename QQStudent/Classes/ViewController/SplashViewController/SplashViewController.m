//
//  SplashViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SplashViewController.h"
#import "ViewControllerHeader.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

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
    [self initView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    uiPctr  = nil;
    uiSView = nil;
}

- (void) dealloc
{
    [uiPctr  release];
    [uiSView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Custom Action
- (void) initView
{
    uiSView = [[UIScrollView alloc]init];
    uiSView.delegate = self;
    uiSView.pagingEnabled = YES;
    uiSView.scrollEnabled = YES;
    CGRect rect   = [UIScreen getCurrentBounds];
    uiSView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    uiSView.contentSize = CGSizeMake(rect.size.width*4, rect.size.height);
    
    UIImageView *img1 = [[UIImageView alloc]init];
    img1.image = [UIImage imageNamed:@"yd2"];
    img1.frame = CGRectMake(0, 0, 320, 460);
    [uiSView addSubview:img1];
    
    UIImageView *img2 = [[UIImageView alloc]init];
    img2.image = [UIImage imageNamed:@"yd3"];
    img2.frame = CGRectMake(320, 0, 320, 460);
    [uiSView addSubview:img2];
    
    UIImageView *img3 = [[UIImageView alloc]init];
    img3.image = [UIImage imageNamed:@"yd4"];
    img3.frame = CGRectMake(640, 0, 320, 460);
    [uiSView addSubview:img3];
    
    UIImageView *img4 = [[UIImageView alloc]init];
    img4.image = [UIImage imageNamed:@"yd6"];
    img4.frame = CGRectMake(960, 0, 320, 460);
    [uiSView addSubview:img4];
    [self.view addSubview:uiSView];
    [img1 release];
    [img2 release];
    [img3 release];
    [img4 release];
    
    uiPctr = [[UIPageControl alloc]init];
    uiPctr.currentPage   = 0;
    uiPctr.numberOfPages = 4;
    uiPctr.frame = [UIView fitCGRect:CGRectMake(110, 420, 100, 10)
                          isBackView:NO];
    [uiPctr addTarget:self
               action:@selector(doValueChanged:)
     forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:uiPctr];
}

- (void) doValueChanged:(id)sender
{
    int page = uiPctr.currentPage;
    [uiSView setContentOffset:CGPointMake(320*page, 0)];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    uiPctr.currentPage = page;
    
    //进入主界面
    CGFloat offset = scrollView.contentOffset.x-(uiPctr.numberOfPages-1)*pageWidth;
    if ((page == 3) && (offset > 20))
    {   
        MainViewController *mainVctr = [[MainViewController alloc]init];
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        app.window.rootViewController = mainVctr;
    }
}
@end
