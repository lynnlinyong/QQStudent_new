//
//  SystemMessageViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-15.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SystemMessageViewController.h"

@interface SystemMessageViewController ()

@end

@implementation SystemMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"轻轻足迹"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化UI
    [self initUI];
    
    [self getSystemMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    [systemMsgArray removeAllObjects];
    
    systemMsgTab.delegate   = nil;
    systemMsgTab.dataSource = nil;
    
    systemMsgTab = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [systemMsgArray release];
    [systemMsgTab release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action

- (void) initUI
{
    systemMsgArray = [[NSMutableArray alloc]init];
    
    systemMsgTab = [[UITableView alloc]init];
    systemMsgTab.delegate   = self;
    systemMsgTab.dataSource = self;
    systemMsgTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 420) isBackView:NO];
    [self.view addSubview:systemMsgTab];
}

- (void) getSystemMessage
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action", @"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getSystemMessage", ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url  = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate = self;
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

- (void) deleteSystemMessage:(NSString *) msgId
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"messageId",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"deleteSystemMessage",msgId,ssid, nil];
    NSDictionary *dic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@", webAdd,STUDENT];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    [request requestASyncWith:kServerPostRequest
                     paramDic:dic
                       urlStr:url];
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return systemMsgArray.count;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idString = @"idString";
    
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString]autorelease];
    NSDictionary *msgDic = [systemMsgArray objectAtIndex:indexPath.row];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(10, 10, 40, 40);
    imgView.image = [UIImage imageNamed:@"flag_bg.png"];
    [cell addSubview:imgView];
    [imgView release];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font     = [UIFont systemFontOfSize:14.f];
    titleLab.text     = @"\"轻轻教育提醒您:\"";
    titleLab.frame    = CGRectMake(60, 5, 120, 20);
    titleLab.backgroundColor = [UIColor clearColor];
    [cell addSubview:titleLab];
    [titleLab release];
    
    UILabel *contentLab = [[UILabel alloc]init];
    contentLab.font     = [UIFont systemFontOfSize:12.f];
    contentLab.text     = [msgDic objectForKey:@"message"];
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    contentLab.numberOfLines =0;
    contentLab.frame    = CGRectMake(60, 25, 200, 40);
    contentLab.backgroundColor = [UIColor clearColor];
    [cell addSubview:contentLab];
    [contentLab release];
    
    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.font  = [UIFont systemFontOfSize:12.f];
    timeLab.text  = [msgDic objectForKey:@"time"];
    timeLab.backgroundColor = [UIColor clearColor];
    timeLab.frame = CGRectMake(320-60-10, 30, 60, 20);
    [cell addSubview:timeLab];
    [timeLab release];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *dic = [systemMsgArray objectAtIndex:indexPath.row];
        [self deleteSystemMessage:[(NSString *)[dic objectForKey:@"messageId"] copy]];
        [systemMsgArray removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
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
        if ([action isEqualToString:@"getSystemMessage"])
        {
            NSArray *array = [resDic objectForKey:@"messages"];
            for (NSDictionary *dic in array)
            {
                [systemMsgArray addObject:dic];
            }
            [systemMsgTab reloadData];
        }
        else if ([action isEqualToString:@"deleteSystemMessage"])
        {
            CLog(@"Delete System Message!");
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
}
@end
