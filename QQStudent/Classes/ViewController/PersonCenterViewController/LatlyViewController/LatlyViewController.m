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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"最近";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self initPullView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    latlyTab = [[UITableView alloc]init];
    latlyTab.delegate   = self;
    latlyTab.dataSource = self;
    latlyTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 420)
                            isBackView:NO];
    [self.view addSubview:latlyTab];
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

- (void) getSystemRecord
{
    NSArray *paramsArr = [NSArray arrayWithObjects:@"",@"", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"",@"", nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate = self;
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
#pragma mark - UITableViewDelegate and UITableViewDatasource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString    = @"idString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString];
    }
    
    return cell;
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
}

- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{
    NSData   *resVal = [request responseData];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic   = [resStr JSONValue];
    //    NSArray      *keysArr  = [resDic allKeys];
    //    NSArray      *valsArr  = [resDic allValues];
    //    CLog(@"***********Result****************");
    //    for (int i=0; i<keysArr.count; i++)
    //    {
    //        CLog(@"%@=%@", [keysArr objectAtIndex:i], [valsArr objectAtIndex:i]);
    //    }
    //    CLog(@"***********Result****************");
    
    NSNumber *errorid = [resDic objectForKey:@"errorid"];
    if (errorid.intValue == 0)
    {
        NSArray *tearchArray = [resDic objectForKey:@"teachers"];
        for (NSDictionary *item in tearchArray)
        {
//            [searchArray addObject:item];
        }
//        [searchTab reloadData];
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
@end
