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
    
    //获得订单列表
    [self getOrderTeachers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _refreshHeaderView    = nil;
    [teacherArray removeAllObjects];
    [super viewDidUnload];
}

- (void) dealloc
{
    _refreshHeaderView = nil;
    [teacherArray release];
    [super dealloc];
}


#pragma mark -
#pragma mark - Notice
- (void) dismissComplainNotice:(NSNotification *) notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
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
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
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
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:section];
    return sectionController.numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    MyTeacherCell *cell = nil;
    if (indexPath.row == 0)
    {
        cell = (MyTeacherCell *)[sectionController cellForRow:indexPath.row];
        cell.delegate = self;
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
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
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
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav    = (UINavigationController *)app.window.rootViewController;
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
            ComplainViewController *cpVctr = [[ComplainViewController alloc]init];
            cpVctr.tObj = cell.teacher;
            [self presentPopupViewController:cpVctr
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
}


//(
// {
//     orders =         (
//                       {
//                           oid = 137;
//                           "order_addtime" = "2014/01/15";
//                           "order_gender_id" = 1;
//                           "order_gender_text" = "\U7537";
//                           "order_grade_id" = 8;
//                           "order_grade_text" = "\U521d\U4e09";
//                           "order_iaddress" = "\U5e7f\U4e1c\U7701 \U60e0\U5dde\U5e02 \U60e0\U9633\U533a \U4eba\U6c11\U56db\U8def \U9760\U8fd1\U798f\U5229\U8def\U53e3";
//                           "order_iaddress_data" =                 {
//                               cityCode = "\U60e0\U5dde\U5e02";
//                               cityName = "\U60e0\U5dde\U5e02";
//                               districtName = "\U60e0\U9633\U533a";
//                               latitude = "22.793873";
//                               longitude = "114.458013";
//                               name = "\U5e7f\U4e1c\U7701 \U60e0\U5dde\U5e02 \U60e0\U9633\U533a \U4eba\U6c11\U56db\U8def \U9760\U8fd1\U798f\U5229\U8def\U53e3";
//                               provinceName = "\U5e7f\U4e1c\U7701";
//                               type = InputAddress;
//                           };
//                           "order_ismfjfu" = 0;
//                           "order_jyfdnum" = 20;
//                           "order_kcbz" = 180;
//                           "order_pj_addtime" = 1389800475;
//                           "order_pj_data" = "";
//                           "order_pj_stars" = 1;
//                           "order_pushcc" = 0;
//                           "order_sd" = "2014/01/15 \U4e0a\U5348";
//                           "order_stars" = 5;
//                           "order_subject_data" =                 {
//                               subjectId = 24;
//                               subjectIndex = 2;
//                               subjectText = "\U6570\U5b66";
//                           };
//                           "order_subject_text" = "\U6570\U5b66";
//                           "order_tamount" = "3600.00";
//                           "order_tfamount" = "0.00";
//                           "order_updatetime" = 1389800475;
//                           "order_xfamount" = "3600.00";
//                           tid = 1462;
//                           uid = 933;
//                       },
//                       {
//                           oid = 136;
//                           "order_addtime" = "2014/01/15";
//                           "order_gender_id" = 1;
//                           "order_gender_text" = "\U7537";
//                           "order_grade_id" = 8;
//                           "order_grade_text" = "\U521d\U4e09";
//                           "order_iaddress" = "\U5e7f\U4e1c\U7701 \U60e0\U5dde\U5e02 \U60e0\U9633\U533a \U4eba\U6c11\U56db\U8def \U9760\U8fd1\U798f\U5229\U8def\U53e3";
//                           "order_iaddress_data" =                 {
//                               cityCode = "\U60e0\U5dde\U5e02";
//                               cityName = "\U60e0\U5dde\U5e02";
//                               districtName = "\U60e0\U9633\U533a";
//                               latitude = "22.793873";
//                               longitude = "114.458013";
//                               name = "\U5e7f\U4e1c\U7701 \U60e0\U5dde\U5e02 \U60e0\U9633\U533a \U4eba\U6c11\U56db\U8def \U9760\U8fd1\U798f\U5229\U8def\U53e3";
//                               provinceName = "\U5e7f\U4e1c\U7701";
//                               type = InputAddress;
//                           };
//                           "order_ismfjfu" = 0;
//                           "order_jyfdnum" = 20;
//                           "order_kcbz" = 180;
//                           "order_pj_addtime" = 0;
//                           "order_pj_data" = "<null>";
//                           "order_pj_stars" = 0;
//                           "order_pushcc" = 0;
//                           "order_sd" = "2014/01/15 \U4e0a\U5348";
//                           "order_stars" = 1;
//                           "order_subject_data" =                 {
//                               subjectId = 24;
//                               subjectIndex = 2;
//                               subjectText = "\U6570\U5b66";
//                           };
//                           "order_subject_text" = "\U6570\U5b66";
//                           "order_tamount" = "3600.00";
//                           "order_tfamount" = "0.00";
//                           "order_updatetime" = 1389799321;
//                           "order_xfamount" = "0.00";
//                           tid = 1462;
//                           uid = 933;
//                       }
//                       );
//     teacher =         {
//         acode = 0755;
//         address = "\U5e7f\U4e1c\U7701 \U6df1\U5733\U5e02 \U9f99\U5c97\U533a \U6c5f\U5cad\U8def \U9760\U8fd1\U6bd4\U4e9a\U8fea\U6c7d\U8f66\U576a\U5c71\U552e\U540e\U670d\U52a1\U603b\U5e97";
//         deviceId = t354316039702636;
//         deviceToken = "";
//         gender = 1;
//         genderText = "\U7537";
//         ios = 0;
//         latitude = "22.67559100";
//         lltime = 1392052814;
//         "location_stars" = 1;
//         longitude = "114.35715000";
//         online = 1;
//         "phone_stars" = 1;
//         "pre_listening" = 1;
//         regtime = 1389625936;
//         searchCode = tcgqobled;
//         "teacher_certificates" = "<null>";
//         "teacher_expense" = 13;
//         "teacher_icon" = "uploadfile/file/18610674146/image/20140113231657_49416.jpg";
//         "teacher_idnumber" = 510521198904074359;
//         "teacher_info" = lynn;
//         "teacher_name" = lynn;
//         "teacher_phone" = 18610674146;
//         "teacher_stars" = 1;
//         "teacher_subject" = 24;
//         "teacher_subjectText" = "\U6570\U5b66";
//         "teacher_type" = 0;
//     };
// }
// )
@end
