//
//  MyTeacherViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "MyTeacherViewController.h"

@interface MyTeacherViewController ()

@end

@implementation MyTeacherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"家教";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化UI
    [self initUI];
    
    //初始化上拉刷新
    [self initPullView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
    _refreshHeaderView    = nil;
    
    teacherTab.delegate   = nil;
    teacherTab.dataSource = nil;
    
    teacherTab = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    _refreshHeaderView = nil;
    
    [teacherTab   release];
    [teacherArray release];
    [super dealloc];
}

#pragma mark - 
#pragma mark - Custom Action
- (void) initPullView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - teacherTab.bounds.size.height, self.view.frame.size.width, teacherTab.bounds.size.height)];
		view.delegate = self;
		[teacherTab addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void) initUI
{
    teacherTab = [[UITableView alloc]init];
    teacherTab.delegate   = self;
    teacherTab.dataSource = self;
    teacherTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 420)
                              isBackView:NO];
    [self.view addSubview:teacherTab];
    
    Teacher *tObj1 = [[Teacher alloc]init];
    tObj1.name = @"lynn";
    tObj1.sex  = @"男";
    tObj1.pf   = @"数学";
    tObj1.comment = 2;
    tObj1.idNums  = @"51052218877122***";
    tObj1.studentCount = 2;
    tObj1.mood    = @"心情不错";
    tObj1.headUrl = @"http://image.baidu.com/i?ct=503316480&z=&tn=baiduimagedetail&ipn=d&word=星星png&step_word=&ie=utf-8&in=9919&cl=2&lm=-1&st=-1&pn=1&rn=1&di=904568390&ln=1926&fr=&&fmq=1391141182492_R&ic=0&s=&se=1&sme=0&tab=&width=&height=&face=0&is=&istype=2&ist=&jit=&objurl=http%3A%2F%2Fimg2.3lian.com%2Fimg2007%2F13%2F64%2F20080405155633689.png#pn1&-1&di904568390&objURLhttp%3A%2F%2Fimg2.3lian.com%2Fimg2007%2F13%2F64%2F20080405155633689.png&fromURLippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bnstwg_z%26e3Bv54AzdH3F2tuAzdH3FdaabAzdH3F9-8dAzdH3Fdndldl0bmdm_z%26e3Bip4s&W256&H256&T7138&S36&TPpng";
    
    teacherArray = [[NSMutableArray alloc]init];
    [teacherArray addObject:tObj1];
    [tObj1 release];
}

- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return teacherArray.count;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    MyTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[[MyTeacherCell alloc]initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:idString]autorelease];
        cell.delegate = self;
        Teacher *tObj = [teacherArray objectAtIndex:indexPath.row];
        cell.teacher  = tObj;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:teacherTab];
	
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
#pragma mark - MyTeacherCellDelegate
- (void) tableViewCell:(UITableViewCell *)cell ClickedButton:(int)index
{
    switch (index)
    {
        case 0:     //详情
        {
            TeacherDetailViewController *tdVctr = [[TeacherDetailViewController alloc]init];
            [self.navigationController pushViewController:tdVctr
                                                 animated:YES];
            [tdVctr release];
            break;
        }
        case 1:     //沟通
        {
            ChatViewController *cVctr = [[ChatViewController alloc]init];
            [self.navigationController pushViewController:cVctr
                                                 animated:YES];
            [cVctr release];
            break;
        }
        case 2:     //投诉
        {
            break;
        }
        case 3:     //推荐
        {
            break;
        }
        default:
            break;
    }
}
@end
