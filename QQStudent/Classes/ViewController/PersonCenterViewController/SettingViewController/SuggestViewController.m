//
//  SuggestViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-16.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SuggestViewController.h"

@interface SuggestViewController ()
@property (nonatomic, retain) UITextView  *contentView;
@end

@implementation SuggestViewController

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
    
    //初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [self.contentView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UIImage *titleImg         = [UIImage imageNamed:@"dialog_title"];
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0,
                                                   titleImg.size.width,
                                                   250)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];

    originY = self.view.frame.origin.y+460/2-250/2;
    
    LBorderView *groupView = [[LBorderView alloc]initWithFrame:CGRectMake(-10, -5,
                                                                          self.view.frame.size.width+20,
                                                                          self.view.frame.size.height+10)];
    groupView.borderType   = BorderTypeSolid;
    groupView.dashPattern  = 8;
    groupView.spacePattern = 8;
    groupView.borderWidth  = 1;
    groupView.cornerRadius = 5;
    groupView.borderColor  = [UIColor whiteColor];
    groupView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:groupView];
    
    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.frame = [UIView fitCGRect:CGRectMake(-2.5, -2,
                                                      groupView.frame.size.width+5, titleImg.size.height)
                                isBackView:NO];
    titleImgView.image = titleImg;
    [groupView addSubview:titleImgView];
    [titleImgView release];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text     = @"建议反馈";
    titleLab.textColor= [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame= [UIView fitCGRect:CGRectMake(-2.5, -2,
                                                 groupView.frame.size.width+5, titleImg.size.height)
                           isBackView:NO];
    titleLab.backgroundColor = [UIColor clearColor];
    [groupView addSubview:titleLab];
    [titleLab release];
        
    UIImage *bottomImg= [UIImage imageNamed:@"dialog_bottom"];
    UIImageView *bottomImgView = [[UIImageView alloc]init];
    bottomImgView.image = bottomImg;
    bottomImgView.frame = [UIView fitCGRect:CGRectMake(-11,
                                                       self.view.frame.size.height-bottomImg.size.height+6,
                                                       self.view.frame.size.width+23, bottomImg.size.height)
                                 isBackView:NO];
    [self.view addSubview:bottomImgView];
    [bottomImgView release];
    
    self.contentView = [[UITextView alloc]init];
    self.contentView.delegate    = self;
    self.contentView.text = @"140字以内建议反馈";
//    self.contentView.borderStyle = UITextBorderStyleLine;
    self.contentView.frame = [UIView fitCGRect:CGRectMake(0,
                                                          25,
                                                          self.view.frame.size.width, 100)
                                    isBackView:NO];
    [self.view addSubview:self.contentView];
    
    UIImage *okBtnImg = [UIImage imageNamed:@"dialog_ok_normal_btn"];
    okBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag = 0;
    [okBtn setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    okBtn.frame = CGRectMake(self.view.frame.size.width/2-okBtnImg.size.width-10,
                             self.view.frame.size.height-okBtnImg.size.height+3,
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
                                 self.view.frame.size.height-cancelImg.size.height+3,
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
    [self.contentView resignFirstResponder];
    [self repickView:self.view];
    
    UIButton *btn      = sender;
    NSNumber *tagNum   = [NSNumber numberWithInt:btn.tag];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:tagNum,@"TAG",
                          self.contentView.text,@"CONTENT",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"suggestNotice"
                                                        object:nil
                                                      userInfo:pDic];
}

#pragma mark -
#pragma mark - UIViewController Custom Methods
- (void) repickView:(UIView *)parent
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    CGRect rect  = CGRectMake(parent.frame.origin.x,
                              originY,
                              parent.frame.size.width,
                              parent.frame.size.height);
    parent.frame = rect;
    
    [UIView commitAnimations];
}

- (void) moveViewWhenViewHidden:(UIView *)view parent:(UIView *) parentView
{
    //键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    int width  = parentView.frame.size.width;
    int height = parentView.frame.size.height;
    originY    = parentView.frame.origin.y;
    CGRect rect= CGRectMake(parentView.frame.origin.x,
                            originY-100,width, height);
    parentView.frame = rect;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark - UITextViewDelegate
- (BOOL) textViewShouldReturn:(UITextView *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [self moveViewWhenViewHidden:okBtn
                          parent:self.view];
}
@end
