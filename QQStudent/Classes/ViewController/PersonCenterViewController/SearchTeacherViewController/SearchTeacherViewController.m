//
//  SearchTeacherViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SearchTeacherViewController.h"

@interface SearchTeacherViewController ()

@end

@implementation SearchTeacherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"搜索";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    searchFld = nil;
    searchFld.delegate = nil;
    
    searchTab.delegate   = nil;
    searchTab.dataSource = nil;
    
    searchLab = nil;
    searchTab = nil;
    
    [searchArray  removeAllObjects];
    [super viewDidUnload];
}

- (void) dealloc
{
    [searchTab release];
    [searchArray release];
    
    [searchLab release];
    [searchFld release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    searchTab = [[UITableView alloc]init];
    searchTab.delegate   = self;
    searchTab.dataSource = self;
    searchTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 380)
                             isBackView:NO];
    [self.view addSubview:searchTab];
    
    searchArray = [[NSMutableArray alloc]init];
    
    searchLab = [[UILabel alloc]init];
    searchLab.text  = @"搜索:";
    searchLab.frame = [UIView fitCGRect:CGRectMake(0, 385, 40, 20)
                             isBackView:NO];
    [self.view addSubview:searchLab];
    
    searchFld = [[UITextField alloc]init];
    searchFld.delegate = self;
    searchFld.font = [UIFont systemFontOfSize:12];
    searchFld.placeholder = @"输入手机号/前14位身份证号/9位搜索码";
    searchFld.borderStyle = UITextBorderStyleLine;
    searchFld.frame = [UIView fitCGRect:CGRectMake(40, 385, 240, 20)
                             isBackView:NO];
    [self.view addSubview:searchFld];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    okBtn.frame = [UIView fitCGRect:CGRectMake(280, 385, 40, 30)
                         isBackView:NO];
    [okBtn addTarget:self
              action:@selector(doOkBtnClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
}

- (void) doOkBtnClicked:(id)sender
{
    if (searchFld.text.length == 0)
    {
        return;
    }
    
    if ((searchFld.text.length!=14) && (searchFld.text.length!=9)
                                    && (searchFld.text.length!=11))
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"输入手机号/前14位身份证号/9位搜索码"
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
    
    //搜索老师
    [self searchTeacherFromServer];
}

- (void) searchTeacherFromServer
{
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"text",@"sessid", nil];
    NSArray *valusArr  = [NSArray arrayWithObjects:@"findTeacher",
                                                   searchFld.text,ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valusArr
                                                     forKeys:paramsArr];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate       = self;
    NSString *webAddress     = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@/%@/", webAddress,STUDENT];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{ 
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - UITableViewDelegate And UITableViewDataSource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchArray.count;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString]autorelease];
        
        NSString *webAddress  = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSDictionary *itemDic = [searchArray objectAtIndex:indexPath.row];
        CLog(@"itemDic:%@", itemDic);
        NSString *imgUrl = [NSString stringWithFormat:@"%@/%@",webAddress,[itemDic objectForKey:@"icon"]];
        
        TTImageView *headImgView = [[TTImageView alloc]init];
        headImgView.URL   = imgUrl;
        headImgView.frame = CGRectMake(10, 10, 60, 60);
        [cell addSubview:headImgView];
        [headImgView release];
        
        CLog(@"gender:%@ %@", [itemDic objectForKey:@"gender"], [itemDic objectForKey:@"subject"]);
        
        UILabel *itrLab = [[UILabel alloc]init];
        itrLab.text = [NSString stringWithFormat:@"%@ %@ %@",[itemDic objectForKey:@"name"],[itemDic objectForKey:@"gender"],[itemDic objectForKey:@"subject"]];
        itrLab.backgroundColor = [UIColor clearColor];
        itrLab.frame = CGRectMake(80, 0, 200, 20);
        itrLab.font  = [UIFont systemFontOfSize:12.f];
        [cell addSubview:itrLab];
        [itrLab release];
        
        UILabel *cntLab = [[UILabel alloc]init];
        cntLab.text = [NSString stringWithFormat:@"辅导%d个学生",((NSNumber *)[itemDic objectForKey:@"TS"]).intValue];
        cntLab.backgroundColor = [UIColor clearColor];
        cntLab.frame = CGRectMake(80, 20, 200, 20);
        cntLab.font  = [UIFont systemFontOfSize:12.f];
        [cell addSubview:cntLab];
        [cntLab release];
        
        UILabel *idLab = [[UILabel alloc]init];
        idLab.text = [itemDic objectForKey:@"idnumber"];
        idLab.backgroundColor = [UIColor clearColor];
        idLab.frame = CGRectMake(80, 40, 200, 20);
        idLab.font  = [UIFont systemFontOfSize:12.f];
        [cell addSubview:idLab];
        [idLab release];
        
        UIStartsImageView *sImgView = [[UIStartsImageView alloc]initWithFrame:CGRectMake(80, 60, 100, 20)];
        [cell addSubview:sImgView];
        [sImgView release];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //订单编辑
    SearchConditionViewController *scVctr = [[SearchConditionViewController alloc]init];
    scVctr.teacherItem = [searchArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:scVctr
                                         animated:YES];
    [scVctr release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            [searchArray addObject:item];
        }
        [searchTab reloadData];
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
