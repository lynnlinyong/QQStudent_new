//
//  SelectrAreaViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-20.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SelectAreaViewController.h"

#define iphone5_HEIGHT   30

#define iphone4_HEIGHT   20
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
    proviceValue   = @"";
    cityValue      = @"";
    distValue      = @"";
    
    UIImage *bgImg = [UIImage imageNamed:@"sd_sel_pos_bg_down"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];

    UIImage *okImg  = [UIImage imageNamed:@"normal_btn"];
    okBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag       = 103;
    okBtn.hidden    = NO;
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    okBtn.frame = [UIView fitCGRect:CGRectMake(160-okImg.size.width/2,
                                               330+44,
                                               okImg.size.width,
                                               okImg.size.height)
                         isBackView:NO];
    [okBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                forState:UIControlStateHighlighted];
    [okBtn setBackgroundImage:okImg
                     forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                     forState:UIControlStateHighlighted];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    valueArray = [[NSMutableArray alloc]init];
    cellArray  = [[NSMutableArray alloc]init];
    gdView = [[UIGridView alloc]init];
    gdView.uiGridViewDelegate = self;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            gdView.frame = [UIView fitCGRect:CGRectMake(7, 50.3+44, 307, 400)
                                  isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            gdView.frame = [UIView fitCGRect:CGRectMake(7, 54.6+44, 307, 400)
                                  isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            gdView.frame = [UIView fitCGRect:CGRectMake(7, 57.3+44, 307, 400)
                                  isBackView:NO];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            gdView.frame = [UIView fitCGRect:CGRectMake(7, 52.7+44, 307, 400)
                                  isBackView:NO];
        }
    }
    gdView.userInteractionEnabled = YES;
    [self.view addSubview:gdView];
    
    NSString *provice = [[NSUserDefaults standardUserDefaults] objectForKey:@"SELECT_PROVICE"];
    proviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [proviceBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                forState:UIControlStateNormal];
    cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                     forState:UIControlStateNormal];
    distBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [distBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                  forState:UIControlStateNormal];
    proviceBtn.tag = 100;
    cityBtn.tag    = 101;
    distBtn.tag    = 102;
    [proviceBtn setBackgroundImage:bgImg
                          forState:UIControlStateNormal];
    proviceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    if (provice)
    {
        [proviceBtn setTitle:provice
                    forState:UIControlStateNormal];
        [self searchCity:provice];
        [self setGrideView];
        [self setButtonBgUp:cityBtn];
    }
    else
        [proviceBtn setTitle:@"省份"
                    forState:UIControlStateNormal];
    proviceBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    proviceBtn.frame = [UIView fitCGRect:CGRectMake(5, 30+44, bgImg.size.width-10, bgImg.size.height)
                              isBackView:NO];
    [proviceBtn addTarget:self
                   action:@selector(doButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:proviceBtn];
    
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"SELECT_CITY"];
    cityBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    if (city)
    {
        [cityBtn setTitle:city
                 forState:UIControlStateNormal];
        [self searchDist:city];
        [self setGrideView];
        [self setButtonBgUp:distBtn];
    }
    else
    {
        [cityBtn setTitle:@"城市"
                 forState:UIControlStateNormal];
        [cityBtn setBackgroundImage:bgImg
                           forState:UIControlStateNormal];
        [distBtn setBackgroundImage:bgImg
                           forState:UIControlStateNormal];
        
    }
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    cityBtn.frame = [UIView fitCGRect:CGRectMake(15+bgImg.size.width, 30+44,
                                                 bgImg.size.width-10, bgImg.size.height)
                           isBackView:NO];
    [cityBtn addTarget:self
                action:@selector(doButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cityBtn];
    
    
    [distBtn setTitle:@"区县"
             forState:UIControlStateNormal];
    distBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    distBtn.frame  = [UIView fitCGRect:CGRectMake(25+2*bgImg.size.width, 30+44,
                                                  bgImg.size.width-10,
                                                  bgImg.size.height)
                            isBackView:NO];
    [distBtn addTarget:self
                action:@selector(doButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:distBtn];
    
    //如果没有默认值,显示省份列表
    if (!provice&&!city)
    {
        [self setButtonBgUp:proviceBtn];
        [self searchProvice];
        [self setGrideView];
    }
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
    [gdView reloadData];
    
    for (UIView *subView in cellArray)
    {
        [subView removeFromSuperview];
        subView = nil;
    }
    
    float heightRow = 0;
    if (iPhone5)
        heightRow = iphone5_HEIGHT;
    else
        heightRow = iphone4_HEIGHT;
    
    //设置GridView数据
    int row;
    if ((valueArray.count/3!=0) || (valueArray.count<3))
        row = valueArray.count/3+1;
    else
        row = valueArray.count/3;
    int height = heightRow * row;
    
    CLog(@"Y:%f", gdView.frame.origin.y);
    gdView.frame = CGRectMake(gdView.frame.origin.x,
                                                gdView.frame.origin.y,
                                                gdView.frame.size.width, height);
    gdView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [gdView reloadData];
    
    okBtn.hidden = NO;
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
            [self searchProvice];
            [self setGrideView];
            [proviceBtn setTitle:@"省份"
                        forState:UIControlStateNormal];
            [cityBtn setTitle:@"城市"
                     forState:UIControlStateNormal];
            return;
            break;
        }
        case 101:      //城市
        {
            [cityBtn setTitle:@"城市"
                     forState:UIControlStateNormal];
            
            //查询保存当前省份
            NSString *provice = [[NSUserDefaults standardUserDefaults] objectForKey:@"SELECT_PROVICE"];
            [self searchCity:provice];
            [self setGrideView];
            return;
            break;
        }
        case 102:      //区
        {
            return;
            break;
        }
        case 103:      //确定
        {
            distValue     = [[NSUserDefaults standardUserDefaults] objectForKey:@"SELECT_DIST"];
            if (!distValue)
                distValue = @"";
            
            proviceValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"SELECT_PROVICE"];
            if (!proviceValue)
                proviceValue = @"";

            cityValue    = [[NSUserDefaults standardUserDefaults] objectForKey:@"SELECT_CITY"];
            if (!cityValue)
                cityValue = @"";
            
            CLog(@"provice:%@, city:%@, dist:%@", proviceValue,cityValue,distValue);
            NSDictionary *posDic = [NSDictionary dictionaryWithObjectsAndKeys:proviceValue,@"PROVICE",
                                    cityValue,@"CITY",
                                    distValue,@"DIST", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPosAreaNotice"
                                                                object:self
                                                              userInfo:posDic];
            [self.navigationController popViewControllerAnimated:YES];
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
            CLog(@"Enter City");
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
    if (iPhone5)
        return iphone5_HEIGHT;
    else
        return iphone4_HEIGHT;
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
        
        UIImageView *txtBgView = [[UIImageView alloc]init];
        txtBgView.image = [UIImage imageNamed:@"sd_sel_pos_bg"];
        float height = 0;
        if (iPhone5)
            height = iphone5_HEIGHT;
        else
            height = iphone4_HEIGHT;
        txtBgView.frame = CGRectMake(5, height/2-12.5, 100, 25);
        [cell addSubview:txtBgView];
        [txtBgView release];
        
        UILabel *contentLab = [[UILabel alloc]init];
        contentLab.font  = [UIFont systemFontOfSize:12.f];
        contentLab.text  = [valueArray objectAtIndex:index];
        contentLab.textColor = [UIColor colorWithHexString:@"#999999"];
        contentLab.backgroundColor = [UIColor clearColor];
        contentLab.frame = CGRectMake(10, height/2-12.5, 95, 25);
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
            [proviceBtn setTitle:proviceValue
                        forState:UIControlStateNormal];
            [self searchCity:proviceValue];
            
            //保存当前值
            [[NSUserDefaults standardUserDefaults] setObject:proviceValue
                                                      forKey:@"SELECT_PROVICE"];
            break;
        }
        case 1:     //城市
        {
            [self setButtonBgUp:distBtn];
            cityValue = [[valueArray objectAtIndex:index] copy];
            [cityBtn setTitle:cityValue
                     forState:UIControlStateNormal];
            [self searchDist:cityValue];
            
            //保存当前值
            [[NSUserDefaults standardUserDefaults] setObject:cityValue
                                                      forKey:@"SELECT_CITY"];
            break;
        }
        case 2:     //区
        {
            //选择完成
            distValue = [[valueArray objectAtIndex:index] copy];
            
            [[NSUserDefaults standardUserDefaults] setObject:distValue
                                                      forKey:@"SELECT_DIST"];
            
            CLog(@"provice:%@, city:%@, dist:%@", proviceValue,cityValue,distValue);
            
            proviceValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"SELECT_PROVICE"];
            cityValue    = [[NSUserDefaults standardUserDefaults] objectForKey:@"SELECT_CITY"];
            NSDictionary *posDic = [NSDictionary dictionaryWithObjectsAndKeys:proviceValue,@"PROVICE",
                                                                              cityValue,@"CITY",
                                                                              distValue,@"DIST", nil];
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
