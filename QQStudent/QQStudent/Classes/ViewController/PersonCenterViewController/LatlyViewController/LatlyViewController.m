//
//  LatlyViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "LatlyViewController.h"

@interface LatlyViewController ()

@end

@implementation LatlyViewController
@synthesize msgArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"最近";
        self.tabBarItem.image = [UIImage imageNamed:@"user_5_1"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    msgArray = [[NSMutableArray alloc]init];
    
    //初始化UI
    [self initUI];
    
    //获得新消息
    [self getMessageNewNumber];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getMessageFromTeacher:)
                                                 name:@"MessageComing"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidDisappear:(BOOL)animated
{   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void) viewDidUnload
{
    latlyTab.delegate   = nil;
    latlyTab.dataSource = nil;
    
    latlyTab = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [sysDic release];
    [msgArray release];
    [latlyTab release];
    [bgImgView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action

- (void) initUI
{
    latlyTab = [[UITableView alloc]init];
    if ([latlyTab respondsToSelector:@selector(setSeparatorInset:)]) {
        [latlyTab setSeparatorInset:UIEdgeInsetsZero];
    }
    latlyTab.delegate   = self;
    latlyTab.dataSource = self;
    latlyTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            latlyTab.frame = [UIView fitCGRect:CGRectMake(0, 44, 320, 480-44-44-44)
                                    isBackView:YES];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            latlyTab.frame = [UIView fitCGRect:CGRectMake(0, 60, 320, 460-44-44-44)
                                    isBackView:YES];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            latlyTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480-44-44)
                                    isBackView:YES];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            latlyTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480)
                                          isBackView:YES];
        }
    }
    [self.view addSubview:latlyTab];
    
    
    UIImage *bgImg = [UIImage imageNamed:@"pp_nodata_bg"];
    bgImgView      = [[UIImageView alloc]initWithImage:bgImg];
    bgImgView.frame= [UIView fitCGRect:CGRectMake(160-50,
                                                  280/2-40+44,
                                                  100,
                                                  80)
                            isBackView:NO];
    [self.view addSubview:bgImgView];
    
    //初始化上拉刷新
    [self initPullView];
    
    latlyTab.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
}

- (void) initPullView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - latlyTab.bounds.size.height, self.view.frame.size.width, latlyTab.bounds.size.height)];
		view.delegate = self;
		[latlyTab addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void) getMessageFromTeacher:(NSNotification *)notice
{
    
}

- (void) getMessageNewNumber
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    if ([AppDelegate isInView:@"LatlyViewController"])
    {
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
    }
    
    [self.msgArray removeAllObjects];
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action", @"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getMessageNewNumber", ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    if (!webAddress)
    {
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:nav.view
                                                  withText:@"服务器地址不可用"
                                                  animated:YES
                                                  delegate:NULL];
        [hud hide:YES afterDelay:3];
        return;
    }
    NSString *url  = [NSString stringWithFormat:@"%@%@", webAddress,STUDENT];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate = self;
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

- (void) deleteTeacherFormChat:(NSString *) teacherId
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"teacherId",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"deleteNewMember",teacherId,ssid, nil];
    NSDictionary *dic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    if (!webAdd)
    {
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:nav.view
                                                  withText:@"服务器地址不可用"
                                                  animated:YES
                                                  delegate:NULL];
        [hud hide:YES afterDelay:3];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", webAdd,STUDENT];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    [request requestASyncWith:kServerPostRequest
                     paramDic:dic
                       urlStr:url];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
    [self getMessageNewNumber];
} 

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:latlyTab];
	
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
#pragma mark - UITableViewDelegate and UITableViewDatasource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = msgArray.count;
    if (count>0)
        bgImgView.hidden = YES;
    else
        bgImgView.hidden = NO;
    
    return msgArray.count+1;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 44;
    }
    
    return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString    = @"idString";
    if (indexPath.row == 0)  //显示系统消息
    {
        UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:idString]autorelease];
        if (sysDic)
        {
            UIImageView *flgImgView = [[UIImageView alloc]init];
            flgImgView.image = [UIImage imageNamed:@"lp_sys_cell_title"];
            flgImgView.frame = CGRectMake(5, 0, 40, 40);
            [cell addSubview:flgImgView];
            [flgImgView release];
            
            int num = ((NSNumber *)[sysDic objectForKey:@"allNumber"]).intValue;
            if (num!=0)
            {
                NoticeNumberView *numView = [[NoticeNumberView alloc]initWithFrame:CGRectMake(flgImgView.frame.size.width-3, 5, 40, 40)];
                [numView setTitle:[NSString stringWithFormat:@"%d", num]];
                [flgImgView addSubview:numView];
                [numView release];
            }
            
            UILabel *titleLab  = [[UILabel alloc]init];
            titleLab.text  = [sysDic objectForKey:@"name"];
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.font = [UIFont systemFontOfSize:14.f];
            titleLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
            titleLab.frame = CGRectMake(50, 3, 100, 20);
            [cell addSubview:titleLab];
            [titleLab release];
            
            UILabel *sysMsgLab = [[UILabel alloc]init];
            sysMsgLab.font = [UIFont systemFontOfSize:12.f];
            sysMsgLab.text = [sysDic objectForKey:@"message"];
            sysMsgLab.backgroundColor = [UIColor clearColor];
            sysMsgLab.frame = CGRectMake(50, 20, 200, 20);
            [cell addSubview:sysMsgLab];
            [sysMsgLab release];
            
            UILabel *timeLab = [[UILabel alloc]init];
            timeLab.textAlignment = NSTextAlignmentRight;
            timeLab.font  = [UIFont systemFontOfSize:12.f];
            timeLab.text  = [sysDic objectForKey:@"time"];
            timeLab.backgroundColor = [UIColor clearColor];
            timeLab.frame = CGRectMake(320-60-10, 12, 60, 20);
            [cell addSubview:timeLab];
            [timeLab release];
            
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lp_sys_cell_bg"]];
        }
        return cell;
    }
    else                     //显示聊天信息
    {
        LatlyViewCell *cell = [[LatlyViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idString"];
        cell.delegate = self;
        cell.tag = indexPath.row-1;
        
        if (msgArray.count>0)
        {
            [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lt_list_bg"]]];
            NSDictionary *teacherDic = [msgArray objectAtIndex:indexPath.row-1];
            cell.msgDic = teacherDic;
        }
        
        return cell;
    }
    
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomNavigationViewController *nav    = [MainViewController getNavigationViewController];
    if (indexPath.row == 0)
    {
        SystemMessageViewController *smVctr= [[SystemMessageViewController alloc]init];
        [nav pushViewController:smVctr animated:YES];
        [smVctr release];
    }
    else
    {
        NSDictionary *teacherDic = [msgArray objectAtIndex:indexPath.row-1];
        Teacher *tObj = [[Teacher alloc]init];
        tObj.deviceId = [[teacherDic objectForKey:@"deviceId"] copy];
        tObj.sex = ((NSNumber *)[teacherDic objectForKey:@"gender"]).intValue;
        NSString *webAdd = [[NSUserDefaults standardUserDefaults]objectForKey:WEBADDRESS];
        tObj.headUrl = [NSString stringWithFormat:@"%@%@",webAdd,[teacherDic objectForKey:@"icon"]];
        tObj.name      = [[teacherDic objectForKey:@"nickname"] copy];
        tObj.phoneNums = [[teacherDic objectForKey:@"phone"] copy];
        tObj.pf = [[teacherDic objectForKey:@"subjectText"] copy];

        ChatViewController *cVctr = [[ChatViewController alloc]init];
        cVctr.tObj = tObj;
        [nav pushViewController:cVctr animated:YES];
        [cVctr release];
        [tObj  release];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
        return NO;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *dic = [msgArray objectAtIndex:indexPath.row-1];
        [self deleteTeacherFormChat:[(NSString *)[dic objectForKey:@"teacherId"] copy]];
        [msgArray removeObjectAtIndex:indexPath.row-1];
        
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void) imageView:(TTImageView *)imageView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark -
#pragma mark - LatlyViewCellDelegate
- (void) view:(LatlyViewCell *) view clickedIndex:(int)index
{
    NSDictionary *item = [msgArray objectAtIndex:view.tag];
    Teacher *tObj = [Teacher setTeacherProperty:item];
    
    //教师详细信息
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    TeacherDetailViewController *tdVctr = [[TeacherDetailViewController alloc]init];
    tdVctr.tObj = tObj;
    [nav pushViewController:tdVctr animated:YES];
    [tdVctr release];
}

#pragma mark -
#pragma mark - ServerRequest Delegate
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
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
}

- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
    
    NSData   *resVal = [request responseData];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic   = [resStr JSONValue];
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
        if ([action isEqualToString:@"getMessageNewNumber"])
        {
            sysDic   = [[resDic objectForKey:@"sys_message"] copy];
            
            //添加老师沟通消息
            NSArray *msgs = [[resDic objectForKey:@"teachers"] copy];
            for (id item in msgs)
            {
                [msgArray addObject:item];
            }
            
            [headArray removeAllObjects];
            headArray = nil;
            headArray = [[NSMutableArray alloc]init];
            
            [latlyTab reloadData];
        }
        else if ([action isEqualToString:@"deleteNewMember"])
        {
            CLog(@"delete Teacher From Chat Success!");
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
        //重复登录
        if (errorid.intValue==2)
        {
            //清除sessid,清除登录状态,回到地图页
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SSID];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGINE_SUCCESS];
            [AppDelegate popToMainViewController];
        }
    }
    
    [latlyTab reloadData];
    
    [self doneLoadingTableViewData];
}
@end
