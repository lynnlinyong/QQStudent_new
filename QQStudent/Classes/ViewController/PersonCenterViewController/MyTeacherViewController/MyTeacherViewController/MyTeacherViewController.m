//
//  MyTeacherViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "MyTeacherViewController.h"

@interface MyTeacherViewController ()
@property (nonatomic, retain) NSMutableArray *retractableControllers;
@end

@implementation MyTeacherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"家教";
        self.tabBarItem.image = [UIImage imageNamed:@"user_1_1"];
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MainViewController setNavTitle:@"个人中心"];
    self.navigationController.navigationBarHidden = YES;
    
    //获得订单列表
    [self getOrderTeachers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doCommentOrderNotice:)
                                                 name:@"commentOrderNotice"
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化上拉刷新
    [self initPullView];
    
    UIImage *bgImg = [UIImage imageNamed:@"pp_nodata_bg"];
    bgImgView      = [[UIImageView alloc]initWithImage:bgImg];
    bgImgView.frame= [UIView fitCGRect:CGRectMake(160-50,
                                                  280/2-40,
                                                  100,
                                                  80)
                            isBackView:NO];
    [self.view addSubview:bgImgView];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _refreshHeaderView    = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [bgImgView release];
    _refreshHeaderView = nil;
    [teacherArray release];
    [super dealloc];
}


#pragma mark -
#pragma mark - Notice
- (void) dismissComplainNotice:(NSNotification *) notice
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) doCommentOrderNotice:(NSNotification *) notice
{
    NSNumber *index    = [notice.userInfo objectForKey:@"Index"];
    NSString *orderId  = [notice.userInfo objectForKey:@"OrderID"];
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"orderid",@"value",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"setEvaluate", orderId, index, ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate   = self;
    [request requestASyncWith:kServerPostRequest
                     paramDic:pDic
                       urlStr:url];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initPullView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void) initUI
{
    self.retractableControllers = [[NSMutableArray alloc]init];
    
    for (NSDictionary *item in teacherArray)
    {
        TeacherOrderSectionController *sVctr = [[TeacherOrderSectionController alloc] initWithViewController:self];
        sVctr.parentView = self.view;
        sVctr.teacherOrderDic = [item copy];
        [self.retractableControllers addObject:sVctr];
        [sVctr release];
    }
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissComplainNotice:)
                                                 name:@"dismissComplainNotice"
                                               object:nil];
}

- (void) getOrderTeachers
{    
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"caches_time",@"sessid",nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getOrders",@"", ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate   = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.retractableControllers.count;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
        return 80;
    
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:section];
    int count = sectionController.numberOfRow;
    if (count>0)
        bgImgView.hidden = YES;
    else
        bgImgView.hidden = NO;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    MyTeacherCell *cell = nil;
    if (indexPath.row == 0)
    {
        cell = (MyTeacherCell *)[sectionController cellForRow:indexPath.row];
        cell.delegate = self;
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mtp_tcell_bg"]];
        return cell;
    }

    return [sectionController cellForRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    return [sectionController didSelectCellAtRow:indexPath.row];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    
    //刷新订单数据
    [self getOrderTeachers];
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark - EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark - MFMessageComposeViewDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:NO];
    
    switch ( result )
    {
        case MessageComposeResultCancelled:
        {
            break;
        }
        case MessageComposeResultFailed:
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"发送取消"
                            delegate:self
                   otherButtonTitles:@"确定", nil];
            break;
        }
        case MessageComposeResultSent:
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"发送失败"
                            delegate:self
                   otherButtonTitles:@"确定", nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - MyTeacherCellDelegate
- (void) tableViewCell:(MyTeacherCell *)cell ClickedButton:(int)index
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    switch (index)
    {
        case 0:     //教师详情
        {
            TeacherDetailViewController *tdVctr = [[TeacherDetailViewController alloc]init];
            tdVctr.tObj = cell.teacher;
            [nav pushViewController:tdVctr animated:YES];
            [tdVctr release];
            break;
        }
        case 1:     //沟通
        {
            ChatViewController *cVctr = [[ChatViewController alloc]init];
            cVctr.tObj    = cell.teacher;
            [nav pushViewController:cVctr animated:YES];
            [cVctr release];
            break;
        }
        case 2:     //投诉
        {
            CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
            ComplainViewController *cpVctr = [[ComplainViewController alloc]init];
            cpVctr.tObj = cell.teacher;
            [nav presentPopupViewController:cpVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 3:     //推荐给同学
        {
            //调用短信
            if( [MFMessageComposeViewController canSendText] )
            {
                MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
                controller.body = @"轻轻家教赶快去下载哦!!!www.baidu.com";
                controller.messageComposeDelegate = self;
                [nav presentModalViewController:controller animated:YES];
                [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];//修改短信界面标题
            }else
            {
                [self showAlertWithTitle:@"提示"
                                     tag:0
                                 message:@"设备没有短信功能"
                                delegate:self
                       otherButtonTitles:@"确定", nil];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark ServerRequest Delegate
- (void) requestAsyncFailed:(ASIHTTPRequest *)request
{
    [self showAlertWithTitle:@"提示"
                         tag:1
                     message:@"网络繁忙"
                    delegate:self
           otherButtonTitles:@"确定",nil];
    
    CLog(@"***********Result****************");
    CLog(@"ERROR");
    CLog(@"***********Result****************");
    
    [self doneLoadingTableViewData];
}

- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{
    NSData   *resVal = [request responseData];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic   = [resStr JSONFragmentValue];
    NSArray      *keysArr  = [resDic allKeys];
    NSArray      *valsArr  = [resDic allValues];
    CLog(@"***********Result****************");
    for (int i=0; i<keysArr.count; i++)
    {
        CLog(@"%@=%@", [keysArr objectAtIndex:i], [valsArr objectAtIndex:i]);
    }
    CLog(@"***********Result****************");
    
    NSNumber *errorid = [resDic objectForKey:@"errorid"];
    if (errorid.intValue == 0)
    {
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"getOrders"])
        {
            teacherArray = [[resDic objectForKey:@"teachers"] copy];
            
            //初始化UI
            [self initUI];
        }
        else if ([action isEqualToString:@"setEvaluate"])
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"评价成功!"
                            delegate:self
                   otherButtonTitles:@"确定",nil];
        }
    }
    else
    {
        NSString *errorMsg = [resDic objectForKey:@"message"];
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:[NSString stringWithFormat:@"错误码%@,%@",errorid,errorMsg]
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
    
    [self doneLoadingTableViewData];
}
@end
