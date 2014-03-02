//
//  SelectSexViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SelectSexViewController.h"

@interface SelectSexViewController ()

@end

@implementation SelectSexViewController
@synthesize isSetSex;
@synthesize sexName;

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
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UIImage *bottomImg  = [UIImage imageNamed:@"dialog_bottom"];
    UIImage *titleImg   = [UIImage imageNamed:@"dialog_title"];
    self.view.frame = CGRectMake(0, 0,
                                 titleImg.size.width,150+bottomImg.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.frame = CGRectMake(-2, -titleImg.size.height,
                                    self.view.frame.size.width+5,
                                    titleImg.size.height);
    titleImgView.image = titleImg;
    [self.view addSubview:titleImgView];
    [titleImgView release];
    
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text  = @"选择性别";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame= CGRectMake(-2, -titleImg.size.height,
                               self.view.frame.size.width+5, titleImg.size.height);
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    [titleLab release];
    
    gdView = [[UITableView alloc]init];
    gdView.delegate   = self;
    gdView.dataSource = self;
    gdView.frame = CGRectMake(titleImg.size.width/2-120, 20, 240, 120);
    gdView.userInteractionEnabled = YES;
    gdView.scrollEnabled = NO;
    [self.view addSubview:gdView];
    

    UIImageView *bottomImgView = [[UIImageView alloc]init];
    bottomImgView.image = bottomImg;
    bottomImgView.frame = CGRectMake(-2,
                                     self.view.frame.size.height-bottomImg.size.height+5,
                                     self.view.frame.size.width+4, bottomImg.size.height);
    [self.view addSubview:bottomImgView];
    [bottomImgView release];
    
    UIImage *okBtnImg = [UIImage imageNamed:@"dialog_ok_normal_btn"];
    UIButton *okBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag   = 0;
    [okBtn setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    okBtn.frame = CGRectMake(self.view.frame.size.width/2-okBtnImg.size.width-10,
                             self.view.frame.size.height-bottomImg.size.height+11,
                             okBtnImg.size.width,
                             okBtnImg.size.height);
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"dialog_ok_normal_btn"]
                     forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"dialog_ok_hlight_btn"]
                     forState:UIControlStateHighlighted];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIImage *cancelImg  = [UIImage imageNamed:@"dialog_cancel_normal_btn"];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.tag = 1;
    [cancelBtn setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    cancelBtn.frame = CGRectMake(self.view.frame.size.width/2+10,
                                 self.view.frame.size.height-bottomImg.size.height+11,
                                 cancelImg.size.width,
                                 cancelImg.size.height);
    [cancelBtn setTitle:@"取消"
               forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"dialog_cancel_normal_btn"]
                         forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"dialog_cancel_hlight_btn"]
                         forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

- (void) doButtonClicked:(id)sender
{
    UIButton *button = sender;
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:button.tag],@"TAG",[NSNumber numberWithInt:selectRadioIndex],@"Index", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setSexNotice"
                                                        object:self
                                                      userInfo:userInfoDic];
}

#pragma mark -
#pragma mark - QRadioButtonDelegate
- (void) didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    selectRadioIndex = radio.tag;
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSetSex)
        return 2;
    return 3;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString   = @"idString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idString]autorelease];
        switch (indexPath.row)
        {
            case 0:
            {
                QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                    groupId:@"sex"];
                qrBtn.tag = 1;
                if ([sexName isEqualToString:@"男"])
                    [qrBtn setChecked:YES];
                [qrBtn setTitle:@"男"
                       forState:UIControlStateNormal];
                [qrBtn setTitleColor:[UIColor grayColor]
                            forState:UIControlStateNormal];
                qrBtn.frame = CGRectMake(100, 7, 80, 30);
                [qrBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [qrBtn setChecked:YES];
                [cell addSubview:qrBtn];
                qrBtn.exclusiveTouch = YES;
                qrBtn.userInteractionEnabled = YES;
                [qrBtn release];
                break;
            }
            case 1:
            {
                QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                    groupId:@"sex"];
                qrBtn.tag = 2;
                if ([sexName isEqualToString:@"女"])
                    [qrBtn setChecked:YES];
                [qrBtn setTitle:@"女"
                       forState:UIControlStateNormal];
                [qrBtn setTitleColor:[UIColor grayColor]
                            forState:UIControlStateNormal];
                qrBtn.frame = CGRectMake(100, 7, 80, 30);
                [qrBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [cell addSubview:qrBtn];
                qrBtn.exclusiveTouch = YES;
                qrBtn.userInteractionEnabled = YES;
                [qrBtn release];
                break;
            }
            case 2:
            {
                QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                    groupId:@"sex"];
                qrBtn.tag = 3;
                if ([sexName isEqualToString:@"不限"])
                    [qrBtn setChecked:YES];
                [qrBtn setTitle:@"不限"
                       forState:UIControlStateNormal];
                [qrBtn setTitleColor:[UIColor grayColor]
                            forState:UIControlStateNormal];
                qrBtn.frame = CGRectMake(100, 7, 80, 30);
                [qrBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [cell addSubview:qrBtn];
                qrBtn.exclusiveTouch = YES;
                qrBtn.userInteractionEnabled = YES;
                [qrBtn release];
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}
@end
