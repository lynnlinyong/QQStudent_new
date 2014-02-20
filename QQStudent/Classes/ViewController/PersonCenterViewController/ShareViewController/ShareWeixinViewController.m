//
//  ShareWeixinViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-18.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ShareWeixinViewController.h"

@interface ShareWeixinViewController ()

@end

@implementation ShareWeixinViewController

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
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 240, 240)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    shareTab = [[UITableView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(0, 0, 240, 240) isBackView:NO]
                                           style:UITableViewStyleGrouped];
    shareTab.delegate   = self;
    shareTab.dataSource = self;
    shareTab.scrollEnabled = NO;
    [self.view addSubview:shareTab];
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableDataScource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 3;
            break;
        }
        case 1:
        {
            return 1;
            break;
        }
        default:
            break;
    }
    
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idString = @"idString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString];
    }
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UILabel *titleLab = [[UILabel alloc]init];
                    titleLab.text  = @"分享到微信";
                    titleLab.backgroundColor = [UIColor clearColor];
                    titleLab.frame = CGRectMake(0, 0,240, 44);
                    titleLab.textAlignment = NSTextAlignmentCenter;
                    [cell addSubview:titleLab];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [titleLab release];
                    break;
                }
                case 1:
                {
                    UILabel *titleLab = [[UILabel alloc]init];
                    titleLab.text  = @"分享给好友";
                    titleLab.backgroundColor = [UIColor clearColor];
                    titleLab.frame = CGRectMake(0, 0,240, 44);
                    titleLab.textAlignment = NSTextAlignmentCenter;
                    [cell addSubview:titleLab];
                    [titleLab release];
                    break;
                }
                case 2:
                {
                    UILabel *titleLab = [[UILabel alloc]init];
                    titleLab.text  = @"分享到朋友圈";
                    titleLab.backgroundColor = [UIColor clearColor];
                    titleLab.frame = CGRectMake(0, 0,240, 44);
                    titleLab.textAlignment = NSTextAlignmentCenter;
                    [cell addSubview:titleLab];
                    [titleLab release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            UILabel *cancelLab = [[UILabel alloc]init];
            cancelLab.text  = @"取消";
            cancelLab.backgroundColor = [UIColor clearColor];
            cancelLab.frame = CGRectMake(0, 0,240, 44);
            cancelLab.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:cancelLab];
            [cancelLab release];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 1:    //分享给好友
                {
                    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
                    req.text  = @"轻轻家教非常不错,马上去下载吧!";
                    req.bText = YES;
                    req.scene = WXSceneSession;
                    [WXApi sendReq:req];
                    break;
                }
                case 2:    //分享到朋友圈
                {
                    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
                    req.text  = @"轻轻家教非常不错,马上去下载吧!";
                    req.bText = YES;
                    req.scene = WXSceneTimeline;
                    [WXApi sendReq:req];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissView"
                                                                object:nil];
            break;
        }
        default:
            break;
    }
}
@end
