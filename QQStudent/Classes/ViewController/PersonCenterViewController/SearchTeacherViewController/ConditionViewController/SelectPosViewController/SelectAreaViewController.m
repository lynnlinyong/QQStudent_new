//
//  SelectrAreaViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-20.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SelectAreaViewController.h"

@interface SelectAreaViewController ()

@end

@implementation SelectAreaViewController

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
    
    [self setButtonBgUp:proviceBtn];
    [self searchProvice];
    [self setGrideView];
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
    UIImage *bgImg = [UIImage imageNamed:@"sd_sel_pos_bg_down"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    
    proviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    proviceBtn.tag   = 100;
    [proviceBtn setBackgroundImage:bgImg
                          forState:UIControlStateNormal];
    proviceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [proviceBtn setTitle:@"省份"
                forState:UIControlStateNormal];
    [proviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    proviceBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    proviceBtn.frame = [UIView fitCGRect:CGRectMake(5, 30, bgImg.size.width-10, bgImg.size.height)
                              isBackView:NO];
    [proviceBtn addTarget:self
                   action:@selector(doButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:proviceBtn];
    
    cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.tag   = 101;
    cityBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cityBtn setTitle:@"城市"
             forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cityBtn setBackgroundImage:bgImg
                       forState:UIControlStateNormal];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    cityBtn.frame = [UIView fitCGRect:CGRectMake(15+bgImg.size.width, 30, bgImg.size.width-10, bgImg.size.height)
                           isBackView:NO];
    [cityBtn addTarget:self
                action:@selector(doButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cityBtn];
    
    distBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    distBtn.tag    = 102;
    [distBtn setTitle:@"区域"
             forState:UIControlStateNormal];
    [distBtn setTitleColor:[UIColor blackColor]
                  forState:UIControlStateNormal];
    distBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [distBtn setBackgroundImage:bgImg
                       forState:UIControlStateNormal];
    distBtn.frame  = [UIView fitCGRect:CGRectMake(25+2*bgImg.size.width, 30,
                                                  bgImg.size.width-10,
                                                  bgImg.size.height)
                            isBackView:NO];
    [distBtn addTarget:self
                action:@selector(doButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:distBtn];
    
    valueArray = [[NSMutableArray alloc]init];
    cellArray  = [[NSMutableArray alloc]init];
    
    gdView = [[UIGridView alloc]init];
    gdView.uiGridViewDelegate = self;
    gdView.frame = [UIView fitCGRect:CGRectMake(8, 52, 305, 400)
                          isBackView:NO];
    gdView.userInteractionEnabled = YES;
    [self.view addSubview:gdView];
    
    UIImage *okImg  = [UIImage imageNamed:@"normal_btn"];
    okBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag       = 103;
    okBtn.hidden    = YES;
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                forState:UIControlStateHighlighted];
    [okBtn setBackgroundImage:okImg
                     forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                     forState:UIControlStateHighlighted];
    okBtn.frame = [UIView fitCGRect:CGRectMake(160-okImg.size.width/2,
                                               330,
                                               okImg.size.width,
                                               okImg.size.height)
                         isBackView:NO];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
}

- (NSMutableArray *) searchProvice
{
    //设置选择索引
    curSelIndex = 0;
    [valueArray removeAllObjects];
    
    FMDB *fmdb = [FMDB sharedFMDB];
    NSString *querySql = @"select *from x_provinces where level=0";
    FMResultSet *rs    = [fmdb.db executeQuery:querySql];
    if (rs)
    {
        while ([rs next])
        {
            [valueArray addObject:[rs stringForColumn:@"district"]];
        }
    }
    CLog(@"valueArray:%d", valueArray.count);
    return valueArray;
}

- (void) searchCity:(NSString *) provice
{
    curSelIndex = 1;
    [valueArray removeAllObjects];
    
    NSString *word = @"市";
    NSString *sql  = @"";
    NSRange foundObj=[provice rangeOfString:word
                                    options:NSCaseInsensitiveSearch];
    //是否是直辖市
    if (foundObj.length>0)
    {
        NSString *tmp = [provice substringToIndex:foundObj.location];
        sql = [NSString stringWithFormat:@"select *from x_provinces where province='%@' and level=1", tmp];
        CLog(@"sql:%@", sql);
    }
    else
    {
        sql = [NSString stringWithFormat:@"select *from x_provinces where province='%@' and level=1", provice];
    }
    
    FMDB *fmdb = [FMDB sharedFMDB];
    FMResultSet *rs = [fmdb.db executeQuery:sql];
    if (rs)
    {
        while ([rs next])
        {
            [valueArray addObject:[rs stringForColumn:@"district"]];
        }
    }
}

- (void) searchDist:(NSString *) city
{
    curSelIndex = 2;
    [valueArray removeAllObjects];
    
    NSString *awd = @"辖区";
    NSString *bwd = @"辖县";
    NSString *sql = @"";
    NSRange af = [city rangeOfString:awd
                             options:NSCaseInsensitiveSearch];
    NSRange bf = [city rangeOfString:bwd
                             options:NSCaseInsensitiveSearch];
    //是否辖区或者辖县
    if (af.length>0)
    {
        NSString *tmp = [city substringToIndex:af.location];
        sql = [NSString stringWithFormat:@"select *from x_provinces where province='%@' and level=2 and district like '%@'", tmp, @"%区"];
        CLog(@"sql:%@", sql);
    }
    else if (bf.length>0)
    {
        NSString *tmp = [city substringToIndex:bf.location];
        sql = [NSString stringWithFormat:@"select *from x_provinces where province='%@' and level=2 and district like '%@'", tmp, @"%县"];
        CLog(@"sql:%@", sql);
    }
    else
    {
        sql = [NSString stringWithFormat:@"select *from x_provinces where city='%@' and level=2", city];
    }
    
    FMDB *fmdb = [FMDB sharedFMDB];
    FMResultSet *rs = [fmdb.db executeQuery:sql];
    if (rs)
    {
        while ([rs next])
        {
            [valueArray addObject:[rs stringForColumn:@"district"]];
        }
    }
}

- (void) setGrideView
{
    for (UIView *subView in cellArray)
    {
        [subView removeFromSuperview];
        subView = nil;
    }
    
    //设置GridView数据
    int row;
    if ((valueArray.count/3!=0) || (valueArray.count<3))
        row = valueArray.count/3+1;
    else
        row = valueArray.count/3;
    int height = 20 * row;
    
    CLog(@"Y:%f", gdView.frame.origin.y);
    gdView.frame = CGRectMake(gdView.frame.origin.x,
                                                gdView.frame.origin.y,
                                                gdView.frame.size.width, height);
    [gdView reloadData];
    
    okBtn.frame  = CGRectMake(okBtn.frame.origin.x, gdView.frame.origin.y+height+30,
                              okBtn.frame.size.width, okBtn.frame.size.height);
}

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    UIButton *btn = sender;
    [self setButtonBgUp:btn];
    switch (btn.tag)
    {
        case 100:      //省份
        {
            okBtn.hidden = YES;
            [self searchProvice];
            [self setGrideView];
            return;
            break;
        }
        case 101:      //城市
        {
            okBtn.hidden = NO;
            return;
            break;
        }
        case 102:      //区
        {
            okBtn.hidden = NO;
            return;
            break;
        }
        case 103:      //确定
        {
            break;
        }
        default:
            break;
    }
}

- (void) setButtonBgUp:(UIButton *) btn
{
    UIImage *bgUpImg   = [UIImage imageNamed:@"sd_sel_pos_bg_up"];
    UIImage *bgDownImg = [UIImage imageNamed:@"sd_sel_pos_bg_down"];
    switch (btn.tag)
    {
        case 100:      //省份
        {
            [proviceBtn setBackgroundImage:bgUpImg
                                  forState:UIControlStateNormal];
            [distBtn setBackgroundImage:bgDownImg
                               forState:UIControlStateNormal];
            [cityBtn setBackgroundImage:bgDownImg
                               forState:UIControlStateNormal];
            [self searchProvice];
            [self setGrideView];
            return;
            break;
        }
        case 101:      //城市
        {
            [distBtn setBackgroundImage:bgDownImg
                               forState:UIControlStateNormal];
            [cityBtn setBackgroundImage:bgUpImg
                               forState:UIControlStateNormal];
            [proviceBtn setBackgroundImage:bgDownImg
                                  forState:UIControlStateNormal];
            return;
            break;
        }
        case 102:      //区
        {
            [distBtn setBackgroundImage:bgUpImg
                               forState:UIControlStateNormal];
            [cityBtn setBackgroundImage:bgDownImg
                               forState:UIControlStateNormal];
            [proviceBtn setBackgroundImage:bgDownImg
                                  forState:UIControlStateNormal];
            return;
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - UIGridViewDelegate
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return 100;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    return 20;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 3;
}

- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return valueArray.count;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    UIGridViewCell *cell = [[UIGridViewCell alloc]init];
    if (cell)
    {
        int index = rowIndex*3+columnIndex;
        
        UILabel *contentLab = [[UILabel alloc]init];
        contentLab.font  = [UIFont systemFontOfSize:12.f];
        contentLab.text  = [valueArray objectAtIndex:index];
        contentLab.backgroundColor = [UIColor clearColor];
        contentLab.frame = CGRectMake(0, 0, 100, 20);
        [cellArray addObject:cell];
        [cell addSubview:contentLab];
        [contentLab release];
    }
    
    return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    CLog(@"rowIndex:%d columnIndex:%d", rowIndex, columnIndex);
    int index = rowIndex*3+columnIndex;
    switch (curSelIndex)
    {
        case 0:     //省份
        {
            [self setButtonBgUp:cityBtn];
            proviceValue = [[valueArray objectAtIndex:index] copy];
            [self searchCity:proviceValue];
            break;
        }
        case 1:     //城市
        {
            [self setButtonBgUp:distBtn];
            cityValue = [[valueArray objectAtIndex:index] copy];
            [self searchDist:cityValue];
            break;
        }
        case 2:     //区
        {
            //选择完成
            distValue = [[valueArray objectAtIndex:index] copy];
            CLog(@"provice:%@, city:%@, dist:%@", proviceValue,cityValue,distValue);

            NSDictionary *posDic = [NSDictionary dictionaryWithObjectsAndKeys:proviceValue,@"PROVICE",
                                    cityValue,@"CITY",distValue,@"DIST", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPosAreaNotice"
                                                                object:self
                                                              userInfo:posDic];
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
    [self setGrideView];
}
@end
