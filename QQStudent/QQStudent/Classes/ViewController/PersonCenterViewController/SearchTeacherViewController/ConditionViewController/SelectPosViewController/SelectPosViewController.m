//
//  SelectPosViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SelectPosViewController.h"

@implementation TopView

- (id) init
{
    self = [super init];
    if (self)
    {
        self.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 460)
                            isBackView:NO];
        self.alpha = 0.7f;
        self.backgroundColor = [UIColor grayColor];
        
        info1Lab = [[UILabel alloc]init];
        info1Lab.frame = [UIView fitCGRect:CGRectMake(130, 60, 180, 40)
                                isBackView:NO];
        info1Lab.text = @"给您推荐身边的好地点好环境 好安心 好学习";
        info1Lab.backgroundColor = [UIColor clearColor];
        info1Lab.textColor     = [UIColor colorWithHexString:@"#00ffff"];
        info1Lab.lineBreakMode = NSLineBreakByWordWrapping;
        info1Lab.numberOfLines = 0;
        [self addSubview:info1Lab];
        
        info2Lab = [[UILabel alloc]init];
        info2Lab.frame = [UIView fitCGRect:CGRectMake(156, 300, 170, 40)
                                isBackView:NO];
        info2Lab.text = @"输入精确到门牌号哦如:长青路43弄22号";
        info2Lab.textColor     = [UIColor colorWithHexString:@"#00ffff"];
        info2Lab.backgroundColor = [UIColor clearColor];
        info2Lab.lineBreakMode = NSLineBreakByWordWrapping;
        info2Lab.numberOfLines = 0;
        [self addSubview:info2Lab];
        
        imgView1 = [[UIImageView alloc]init];
        imgView1.frame = [UIView fitCGRect:CGRectMake(201, 110, 60, 60)
                                isBackView:NO];
        imgView1.image = [UIImage imageNamed:@"arrow.png"];
        [self addSubview:imgView1];
        
        UIImage *locImg = [UIImage imageNamed:@"location_3"];
        UIImageView *imageView3 = [[UIImageView alloc]init];
        imageView3.frame = [UIView fitCGRect:CGRectMake(171, 170, locImg.size.width, locImg.size.height)
                                isBackView:NO];
        imageView3.image = locImg;
        [self addSubview:imageView3];
        [imageView3 release];
        
        imgView2 = [[UIImageView alloc]init];
        imgView2.frame = [UIView fitCGRect:CGRectMake(113, 350, 60, 60)
                                isBackView:NO];
        imgView2.image = [UIImage imageNamed:@"arrow.png"];
        [self addSubview:imgView2];
        
        //添加单击手势
        UITapGestureRecognizer *tapRg = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleSingleTapFrom:)];
        tapRg.numberOfTapsRequired = 1; 
        [self addGestureRecognizer:tapRg];
        [tapRg release];
    }
    
    return self;
}

- (void) dealloc
{
    [info1Lab release];
    [info2Lab release];
    
    [imgView1 release];
    [imgView2 release];
    [super dealloc];
}

- (void) handleSingleTapFrom:(UIGestureRecognizer *) recognizer
{
    self.hidden = YES;
    [self removeGestureRecognizer:recognizer];
}
@end

@implementation BottomToolBar
@synthesize delegate;
@synthesize posFld;
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
        
        UIImage *bgImg = [UIImage imageNamed:@"sd_ca_normal_btn"];
        areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        areaBtn.tag = 0;
        [areaBtn setImage:bgImg
                 forState:UIControlStateNormal];
        [areaBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:areaBtn];
        
        UIImage *okImg     = [UIImage imageNamed:@"sp_search_btn_normal"];
        UIImage *normalImg = [UIImage imageNamed:@"cp_input_bg"];
        UIImageView *emailImgView = [[UIImageView alloc]initWithImage:normalImg];
        posFld  = [[UITextView alloc]init];
        posFld.delegate    = self;
        posFld.backgroundColor = [UIColor clearColor];

        [self addSubview:emailImgView];
        [self addSubview:posFld];
        
        okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.tag = 1;
        [okBtn setTitle:@"确定"
               forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [okBtn setBackgroundImage:okImg
                         forState:UIControlStateNormal];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
        {
            if (iPhone5)
            {
                //ios7 iphone5
                CLog(@"It's is iphone5 IOS7");
                areaBtn.frame = CGRectMake(5, 7, bgImg.size.width,
                                           bgImg.size.height);
                posFld.frame = CGRectMake(areaBtn.frame.size.width+5,7,
                                          320-okImg.size.width-7-areaBtn.frame.size.width-5,
                                          areaBtn.frame.size.height);
                emailImgView.frame = CGRectMake(areaBtn.frame.size.width+5,7,
                                                320-okImg.size.width-7-areaBtn.frame.size.width-5,
                                                areaBtn.frame.size.height);
                okBtn.frame = [UIView fitCGRect:CGRectMake(320-okImg.size.width-7,
                                                           5,
                                                           okImg.size.width,
                                                           okImg.size.height+1)
                                     isBackView:NO];
            }
            else
            {
                CLog(@"It's is iphone4 IOS7");
                //ios 7 iphone 4
                areaBtn.frame = CGRectMake(5, 7, bgImg.size.width,
                                           bgImg.size.height);
                posFld.frame = CGRectMake(areaBtn.frame.size.width+5,7,
                                          320-okImg.size.width-7-areaBtn.frame.size.width-5,
                                          areaBtn.frame.size.height);
                emailImgView.frame = CGRectMake(areaBtn.frame.size.width+5,7,
                                                320-okImg.size.width-7-areaBtn.frame.size.width-5,
                                                areaBtn.frame.size.height);
                okBtn.frame = [UIView fitCGRect:CGRectMake(320-okImg.size.width-7,
                                                           6.3,
                                                           okImg.size.width,
                                                           okImg.size.height+1)
                                     isBackView:NO];
            }
        }
        else
        {
            if (!iPhone5)
            {
                // ios 6 iphone4
                CLog(@"It's is iphone4 IOS6");
                areaBtn.frame = CGRectMake(5, 4, bgImg.size.width,
                                           bgImg.size.height);
                posFld.frame = CGRectMake(areaBtn.frame.size.width+5,4,
                                          320-okImg.size.width-7-areaBtn.frame.size.width-5,
                                          areaBtn.frame.size.height);
                emailImgView.frame = CGRectMake(areaBtn.frame.size.width+5,4,
                                                320-okImg.size.width-7-areaBtn.frame.size.width-5,
                                                areaBtn.frame.size.height);
                okBtn.frame = [UIView fitCGRect:CGRectMake(320-okImg.size.width-7,
                                                           3.6,
                                                           okImg.size.width,
                                                           okImg.size.height+0.8)
                                     isBackView:NO];
            }
            else
            {
                //ios 6 iphone5
                CLog(@"It's is iphone5 IOS6");
                areaBtn.frame = CGRectMake(5, 4, bgImg.size.width,
                                           bgImg.size.height);
                posFld.frame = CGRectMake(areaBtn.frame.size.width+5,4,
                                          320-okImg.size.width-7-areaBtn.frame.size.width-5,
                                          areaBtn.frame.size.height);
                emailImgView.frame = CGRectMake(areaBtn.frame.size.width+5,4,
                                                320-okImg.size.width-7-areaBtn.frame.size.width-5,
                                                areaBtn.frame.size.height);
                okBtn.frame = [UIView fitCGRect:CGRectMake(320-okImg.size.width-7,
                                                           3.6,
                                                           okImg.size.width,
                                                           okImg.size.height+0.8)
                                     isBackView:NO];
            }
        }
        
        [okBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:okBtn];
    }
    
    return self;
}

- (void) dealloc
{
    posFld.delegate = nil;
    [posFld release];
    [super dealloc];
}

- (void) doButtonClicked:(id)sender
{
    UIButton *btn = sender;
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(bottomToolBar:index:)])
        {
            [delegate bottomToolBar:self index:btn.tag];
        }
    }
}

- (void) textViewDidBeginEditing:(UITextView *)textField
{
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(textViewBegianEditing:)])
        {
            [delegate textViewBegianEditing:textField];
        }
    }
}

- (BOOL) textViewShouldReturn:(UITextView *)textField
{
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(textViewReturnEditing:)])
        {
            [delegate textViewReturnEditing:textField];
        }
    }
    return YES;
}
@end

@interface SelectPosViewController ()

@end

@implementation SelectPosViewController
@synthesize mapView;
@synthesize locatePicker;
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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"选择授课地点"];
}

- (void) viewDidUnload
{
    [self.locatePicker removeObserver:self
                           forKeyPath:@"posY"];
    
    self.mapView.delegate = nil;
    self.mapView = nil;
    
    toolBar.delegate = nil;
    toolBar = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void) dealloc
{
    [posDic release];
    [toolBar release];
    [self.mapView release];
    [_calloutMapAnnotation release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) packagePosDic:(NSString *) provice city:(NSString *)
city dist:(NSString *)dist address:(NSString *) address pos:(CLLocationCoordinate2D) lc
{
    [posDic setObject:provice forKey:@"PROVICE"];
    [posDic setObject:city forKey:@"CITY"];
    [posDic setObject:dist forKey:@"DIST"];
    [posDic setObject:address forKey:@"ADDRESS"];
    [posDic setObject:[NSString stringWithFormat:@"%f", lc.latitude]
               forKey:@"LATITUDE"];
    [posDic setObject:[NSString stringWithFormat:@"%f", lc.longitude]
               forKey:@"LONGTITUDE"];
}

- (void) initUI
{
    //显示地图
    self.mapView = [[MAMapView alloc] initWithFrame:[UIView fitCGRect:CGRectMake(0,
                                                                                 0,
                                                                                 320,
                                                                                 480)
                                                           isBackView:YES]];
    self.mapView.delegate   = self;
    [self.mapView setZoomLevel:13
                      animated:YES];
    [self.view addSubview:self.mapView];
    self.mapView.showsUserLocation = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addAnnotationForMap:)];
    [self.mapView addGestureRecognizer:longPress];
    [longPress release];
    
    keboarHeight = 0;

    toolBar = [[BottomToolBar alloc]initWithFrame:
               [UIView fitCGRect:CGRectMake(0,
                                            480-44-44,
                                            320,
                                            44)
                      isBackView:NO]];
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
    
    //显示顶层Layer
    TopView *topView =[[TopView alloc]init];
    topView.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 460)
                           isBackView:YES];
    [self.view addSubview:topView];
    
    posDic = [[NSMutableDictionary alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectPosAreaNotice:)
                                                 name:@"selectPosAreaNotice"
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void) addAnnotationForMap:(UILongPressGestureRecognizer*)press
{
    if (press.state == UIGestureRecognizerStateEnded)
    {
        return;
    }
    else if (press.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [press locationInView:self.view];
        
        CLLocationCoordinate2D coo = [self.mapView convertPoint:point
                                           toCoordinateFromView:self.mapView];
        
        CLog(@"经纬度:%lf, %lf", coo.longitude,  coo.latitude);
        loc = coo;
        
        //逆向地理编码
        [self searchReGeocode:coo];
        
        //添加地图标准
        selAnn.coordinate = coo;
        [self.mapView setCenterCoordinate:coo];
        
        //搜索第三方场地
        [self searchNearOtherPos];
    }
    
    return;
}

- (void) searchNearOtherPos
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    //获得选择区域坐标
    NSString *log = [NSString stringWithFormat:@"%f", selAnn.coordinate.longitude];
    NSString *la  = [NSString stringWithFormat:@"%f", selAnn.coordinate.latitude];
    NSString *ssid= [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"latitude",@"longitude",@"sessid", nil];
    NSArray *valusArr  = [NSArray arrayWithObjects:@"getsites",la,log,ssid,nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valusArr forKeys:paramsArr];
    CLog(@"siteDic:%@", pDic);
    
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    [request requestASyncWith:kServerPostRequest
                     paramDic:pDic
                       urlStr:url];
    
    _calloutMapAnnotation = [[CalloutMapAnnotation alloc]init];
}

- (void) initOtherSitesAnnotation:(NSArray *) sites
{
    NSMutableArray *annArray = [[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary *item in sites)
    {
        Site *site = [Site setSiteProperty:item];
        
        //添加第三方地方标注
        CustomPointAnnotation *ann = [[[CustomPointAnnotation alloc] init]autorelease];
        ann.tag = 1002;
        ann.coordinate = CLLocationCoordinate2DMake(site.latitude.floatValue, site.longitude.floatValue);
        ann.siteObj = site;
        [annArray addObject:ann];
    }
    [self.mapView addAnnotations:annArray];
}

- (void) selectPosAreaNotice:(NSNotification *) notice
{
    NSString *posAddress = [NSString stringWithFormat:@"%@%@%@", [notice.userInfo objectForKey:@"PROVICE"],
                                                                 [notice.userInfo objectForKey:@"CITY"],
                                                                 [notice.userInfo objectForKey:@"DIST"]];
    CLog(@"posAddress:%@", posAddress);
    if (posAddress.length>0)
    {
        toolBar.posFld.text = posAddress;
        
        [self searchGeocode:posAddress];
    }
}

#pragma mark -
#pragma mark - AMapSearchDelegate
- (void)searchReGeocode:(CLLocationCoordinate2D) tmpLoc
{
    AMapSearchAPI *search = [[AMapSearchAPI alloc]initWithSearchKey:(NSString *)MAP_API_KEY
                                                            Delegate:self];
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:tmpLoc.latitude
                                                     longitude:tmpLoc.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    [search AMapReGoecodeSearch:regeoRequest];
}

- (void)searchGeocode:(NSString *) address
{
    AMapSearchAPI *search = [[AMapSearchAPI alloc]initWithSearchKey:(NSString *)MAP_API_KEY
                                                            Delegate:self];
    AMapGeocodeSearchRequest *geoRequest = [[AMapGeocodeSearchRequest alloc] init];
    geoRequest.searchType = AMapSearchType_Geocode;
    geoRequest.address = address;
    [search AMapGeocodeSearch: geoRequest];
}

#pragma mark -
#pragma mark - SiteOtherViewDelegate
- (void) view:(SiteOtherView *)view clickedTag:(int)tag
{
    switch (tag)
    {
        case 0:    //点击头像
        {
            SiteOtherViewController *sVctr = [[SiteOtherViewController alloc]init];
            sVctr.site = view.site;
            [self.navigationController pushViewController:sVctr
                                                 animated:YES];
            [sVctr release];
            break;
        }
        case 1:    //点击打电话 
        {
            NSString *phone = [NSString stringWithFormat:@"tel://%@",view.site.tel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - BottomToolBarDelegate
#pragma mark -
#pragma mark - UIViewController Custom Methods
- (void) repickView:(UIView *)parent
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    CGRect rect  = CGRectMake(parent.frame.origin.x,
                              parent.frame.origin.y+keboarHeight,
                              parent.frame.size.width,
                              parent.frame.size.height);
    parent.frame = rect;
    
    [UIView commitAnimations];
}

- (void) keyboardWillChange:(NSNotification *) notice
{
    NSValue *aValue     = [notice.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    float offset = keyboardRect.size.height - keboarHeight;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"
                    context:nil];
    [UIView setAnimationDuration:animationDuration];

    int width  = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    CGRect rect= CGRectMake(self.view.frame.origin.x,
                            self.view.frame.origin.y-offset,width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    keboarHeight = keyboardRect.size.height;
}

- (void) textViewReturnEditing:(UITextView *) textField
{
    [textField resignFirstResponder];
    [self repickView:self.view];
}

- (void) bottomToolBar:(id)bar index:(int)clickedIndex
{
    switch (clickedIndex)
    {
        case 0:     //切换区域
        {
            SelectAreaViewController *saVctr = [[SelectAreaViewController alloc]init];
            [self.navigationController pushViewController:saVctr
                                                 animated:YES];
            [saVctr release];
            break;
        }
        case 1:     //确定
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setPosNotice"
                                                                object:nil
                                                              userInfo:posDic];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - Key Value Oberver
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"posY"])
    {
        CLog(@"newValue:%f", ((NSNumber *)[self.locatePicker valueForKey:@"posY"]).floatValue);
        float posY = ((NSNumber *)[self.locatePicker valueForKey:@"posY"]).floatValue;
        toolBar.frame = CGRectMake(0,
                                   posY-44,
                                   toolBar.frame.size.width,
                                   toolBar.frame.size.height);
    }
}

#pragma mark -
#pragma mark - AMapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request
                     response:(AMapReGeocodeSearchResponse *)response;
{
    NSString *posName   = response.regeocode.formattedAddress;
    CLog(@"Postation:%@ %@ %@ %@", response.regeocode.addressComponent.province, response.regeocode.addressComponent.city,response.regeocode.addressComponent.district,response.regeocode.addressComponent.neighborhood);
    
    NSString *provice = response.regeocode.addressComponent.province;
    if (!provice)
        provice = @"";
    
    NSString *city    = response.regeocode.addressComponent.city;
    if (!city)
        city = @"";
    
    NSString *dist    = response.regeocode.addressComponent.district;
    if (!dist)
        dist = @"";
    
    if (!posName)
        posName = @"";
    
//    [posDic setObject:provice forKey:@"PROVICE"];
//    [posDic setObject:city forKey:@"CITY"];
//    [posDic setObject:dist forKey:@"DIST"];
//    [posDic setObject:posName forKey:@"ADDRESS"];
    
    [self packagePosDic:provice
                   city:city
                   dist:dist
                address:posName
                    pos:loc];
    
    toolBar.posFld.text = posName;
    toolBar.posFld.font = [UIFont systemFontOfSize:10.f];
    
    //删除我的位置标注
    if (self.mapView.overlays.count>0)
    {
        [self.mapView removeAnnotation:self.mapView.userLocation];
        [self.mapView removeOverlay:self.mapView.overlays[0]];
    }
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request
                   response:(AMapGeocodeSearchResponse *)response
{
    AMapGeocode *p = [response.geocodes objectAtIndex:0];
    selAnn.coordinate = CLLocationCoordinate2DMake(p.location.latitude,
                                                   p.location.longitude);
    loc = selAnn.coordinate;
    [self.mapView setCenterCoordinate:selAnn.coordinate];
    //搜索第三方场地
    [self searchNearOtherPos];
}

#pragma mark -
#pragma mark - MAMapViewDelegate
- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (self.mapView.showsUserLocation)
    {
        [self.mapView setCenterCoordinate:userLocation.coordinate];
        
        //添加个人位置标注,选择地点标注
        CustomPointAnnotation *ann = [[[CustomPointAnnotation alloc] init]autorelease];
        ann.tag = 1000;
        ann.coordinate = userLocation.location.coordinate;
        [self.mapView addAnnotation:ann];
        
        selAnn = [[[CustomPointAnnotation alloc] init]autorelease];
        selAnn.tag = 1001;
        selAnn.coordinate = userLocation.location.coordinate;
        [self.mapView addAnnotation:selAnn];
        
        //逆向地理编码获得地址
        loc = self.mapView.userLocation.coordinate;
        [self searchReGeocode:self.mapView.userLocation.coordinate];

        //搜索第三方场地
        [self searchNearOtherPos];
    }
    self.mapView.showsUserLocation = NO;
}

- (void) mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

- (MAOverlayView *) mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    return nil;
}

- (MAAnnotationView *) mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        CustomPointAnnotation *cpAnn = (CustomPointAnnotation *)annotation;
        
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAAnnotationView *annView = (MAAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annView == nil)
        {
            annView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                   reuseIdentifier:pointReuseIndetifier];
            //            annView.canShowCallout = YES;    //设置气泡可以弹出,默认为NO
            //            annView.draggable      = YES;    //设置标注可以拖动,默认为NO
        }
        
        //设置个人位置标注,选择地点标准
        if (cpAnn.tag==1000)
            annView.image = [UIImage imageNamed:@"my_location_icon"];
        else if (cpAnn.tag==1001)
            annView.image = [UIImage imageNamed:@"iaddress_icon1"];
        else if (cpAnn.tag==1002)
            annView.image = [UIImage imageNamed:@"location_3"];
        return annView;
    }
    else if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        //此时annotation就是我们calloutview的annotation
        CalloutMapAnnotation *ann = (CalloutMapAnnotation*)annotation;
        
        //如果可以重用
        CallOutAnnotationView *outAnnView = (CallOutAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
        
        //否则创建新的calloutView
        if (!outAnnView)
        {
            outAnnView = [[[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"] autorelease];
            outAnnView.frame = CGRectMake(0, 0, 320, 190);
            outAnnView.contentView.frame = CGRectMake(outAnnView.contentView.frame.origin.x,
                                                      outAnnView.contentView.frame.origin.y,
                                                      320,
                                                      190);
            outAnnView.centerOffset      = CGPointMake(0, -120);
            
            
            SiteOtherView *soView = [[SiteOtherView alloc]initWithFrame:CGRectMake(0,
                                                                                   0,
                                                                                   320,
                                                                                   190)];
            soView.site     = [ann.site copy];
            soView.delegate = self;
            [outAnnView.contentView addSubview:soView];
            
            return outAnnView;
        }
    }
    
    return nil;
}

- (void) mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    CustomPointAnnotation *annn = (CustomPointAnnotation*)view.annotation;
    if ([view.annotation isKindOfClass:[CustomPointAnnotation class]] || [view.annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        
        //如果点到了这个marker点，什么也不做
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        
        //如果当前显示着calloutview，又触发了select方法，删除这个calloutview annotation
        if (_calloutMapAnnotation) {
            [self.mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation = nil;
        }
        
        //创建搭载自定义calloutview的annotation
        _calloutMapAnnotation = [[[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude]autorelease];
        _calloutMapAnnotation.site =annn.siteObj;

        NSString *provice = annn.siteObj.proviceName;
        if (!provice)
            provice = @"";
        
        NSString *city    = annn.siteObj.cityName;
        if (!city)
            city = @"";
        
        NSString *dist    = annn.siteObj.districtName;
        if (!dist)
            dist = @"";
        
        NSString *address = annn.siteObj.address;
        if (!address)
            address = @"";
        
        //显示地址
        toolBar.posFld.text = address;
//        [posDic setObject:provice
//                   forKey:@"PROVICE"];
//        [posDic setObject:city
//                   forKey:@"CITY"];
//        [posDic setObject:dist
//                   forKey:@"DIST"];
//        [posDic setObject:address
//                   forKey:@"ADDRESS"];
        
        [self packagePosDic:provice
                       city:city
                       dist:dist
                    address:address
                        pos:loc];
        
        [self.mapView addAnnotation:_calloutMapAnnotation];
        [self.mapView setCenterCoordinate:view.annotation.coordinate
                                 animated:YES];
    }
}

- (void) mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if (_calloutMapAnnotation && ![view isKindOfClass:[CallOutAnnotationView class]]) {
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [self.mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation = nil;
        }
    }
}

#pragma mark -
#pragma mark - ServerRequestDelegate
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
    NSString *resStr = [[NSString alloc]initWithData:resVal
                                            encoding:NSUTF8StringEncoding];
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
        if ([action isEqualToString:@"getsites"])
        {
            NSArray *sites = [resDic objectForKey:@"sites"];
            
            //显示第三方场地
            [self initOtherSitesAnnotation:sites];
        }
    }
    else if (errorid.intValue==2)
        {
            //清除sessid,清除登录状态,回到地图页
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SSID];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGINE_SUCCESS];
            [AppDelegate popToMainViewController];
        }
}
@end
