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
        info1Lab.frame = [UIView fitCGRect:CGRectMake(130, 60, 160, 40)
                                isBackView:NO];
        info1Lab.text = @"给您推荐身边的好地点好环境 好安心 好学习";
        info1Lab.backgroundColor = [UIColor clearColor];
        info1Lab.lineBreakMode = NSLineBreakByWordWrapping;
        info1Lab.numberOfLines = 0;
        [self addSubview:info1Lab];
        
        info2Lab = [[UILabel alloc]init];
        info2Lab.frame = [UIView fitCGRect:CGRectMake(156, 300, 150, 40)
                                isBackView:NO];
        info2Lab.text = @"输入精确到门牌号哦如:长青路43弄22号";
        info2Lab.backgroundColor = [UIColor clearColor];
        info2Lab.lineBreakMode = NSLineBreakByWordWrapping;
        info2Lab.numberOfLines = 0;
        [self addSubview:info2Lab];
        
        imgView1 = [[UIImageView alloc]init];
        imgView1.frame = [UIView fitCGRect:CGRectMake(201, 110, 60, 60)
                                isBackView:NO];
        imgView1.image = [UIImage imageNamed:@"arrow.png"];
        [self addSubview:imgView1];
        
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
        float height = frame.size.height;
        float width  = frame.size.width;
        
        self.backgroundColor = [UIColor whiteColor];
        
        areaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        areaBtn.tag = 0;
        [areaBtn setTitle:@"切换区域"
                 forState:UIControlStateNormal];
        [areaBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        areaBtn.frame = CGRectMake(5, 5, 60, height-10);
        [self addSubview:areaBtn];
        
        posFld = [[UITextView alloc]init];
        posFld.delegate = self;
//        posFld.borderStyle = UITextBorderStyleLine;
        posFld.frame = CGRectMake(65, 0, width-110, height-10);
        posFld.scrollEnabled = NO;
        [self addSubview:posFld];
        
        okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        okBtn.tag = 1;
        [okBtn setTitle:@"确定"
                 forState:UIControlStateNormal];
        [okBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
        okBtn.frame = CGRectMake(width-45, 5, 40, height-10);
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
- (void) initUI
{    
    //显示地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               320,
                                                               460)];
    self.mapView.delegate   = self;
    self.mapView.showsScale = NO;
    [self.mapView setZoomLevel:13
                      animated:YES];
    [self.view addSubview:self.mapView];
    self.mapView.showsUserLocation = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addAnnotationForMap:)];
    [self.mapView addGestureRecognizer:longPress];
    [longPress release];
    
    toolBar = [[BottomToolBar alloc]initWithFrame:
                                    [UIView fitCGRect:CGRectMake(0,
                                                                 460-44-44,
                                                                 320,
                                                                 44)
                                           isBackView:NO]];
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
    
    //显示顶层Layer
    TopView *topView =[[TopView alloc]init];
    topView.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 460)
                           isBackView:NO];
    [self.view addSubview:topView];
    
    posDic = [[NSMutableDictionary alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectPosAreaNotice:) name:@"selectPosAreaNotice"
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
    NSString *posAddress = [NSString stringWithFormat:@"%@%@%@", [notice.userInfo objectForKey:@"PROVICE"],[notice.userInfo objectForKey:@"CITY"],[notice.userInfo objectForKey:@"DIST"]];
    CLog(@"posAddress:%@", posAddress);
    [self searchGeocode:posAddress];
}

#pragma mark -
#pragma mark - AMapSearchDelegate
- (void)searchReGeocode:(CLLocationCoordinate2D) loc
{
    AMapSearchAPI *search = [[AMapSearchAPI alloc]initWithSearchKey:(NSString *)MAP_API_KEY
                                                            Delegate:self];
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:loc.latitude
                                                     longitude:loc.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    [search AMapReGoecodeSearch:regeoRequest];
}

- (void)searchGeocode:(NSString *) address
{
    AMapSearchAPI *search = [[AMapSearchAPI alloc]initWithSearchKey:(NSString *)MAP_API_KEY
                                                            Delegate:self];
    AMapGeocodeSearchRequest *geoRequest = [[AMapGeocodeSearchRequest alloc] init]; geoRequest.searchType = AMapSearchType_Geocode;
    geoRequest.address = address;
    [search AMapGeocodeSearch: geoRequest];
}

//#pragma mark - HZAreaPicker delegate
//- (void) pickerDidChaneStatus:(HZAreaPickerView *)picker
//{
//    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
//    {
//         CLog(@"ChangStatus:%@",[NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district]);
//         posDic = [[NSDictionary alloc] initWithObjectsAndKeys:picker.locate.state,@"PROVICE",picker.locate.city, @"CITY",picker.locate.district, @"DIST", nil];
//    }
//    else
//    {
////        self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
//    }
//}
//
//- (void) cancelLocatePicker
//{
//    [self.locatePicker cancelPicker];
//    self.locatePicker.delegate = nil;
//    self.locatePicker = nil;
//}

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
- (void) textViewReturnEditing:(UITextView *) textField
{
    [textField resignFirstResponder];
    [self repickView:self.view];
}

- (void) textViewBegianEditing:(UITextView *) textField
{
    [self.locatePicker cancelPicker];
    [self moveViewWhenViewHidden:toolBar parent:self.view];
}

- (void) bottomToolBar:(id)bar index:(int)clickedIndex
{
    switch (clickedIndex)
    {
        case 0:     //切换区域
        {
//            if ([toolBar.posFld isEditable])
//            {
//                [toolBar.posFld resignFirstResponder];
//                [self repickView:self.view];
//            }
//            
//            self.locatePicker = [[[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self] autorelease];
//            [self.locatePicker addObserver:self
//                                forKeyPath:@"posY"
//                                   options:NSKeyValueObservingOptionNew
//                                   context:nil];
//            [self.locatePicker showInView:self.view];
            
            SelectAreaViewController *saVctr = [[SelectAreaViewController alloc]init];
            [self.navigationController pushViewController:saVctr
                                                 animated:YES];
            [saVctr release];
            break;
        }
        case 1:     //确定
        {
////            if ([toolBar.posFld isEditable])
////            {
////                [toolBar.posFld resignFirstResponder];
////            }
////            else
////            {
////                [self.locatePicker cancelPicker];
////            }
//            [self.locatePicker cancelPicker];
//            [self repickView:self.view];

            //获得地理编码
//            NSString *posAddress = [NSString stringWithFormat:@"%@%@%@", [posDic objectForKey:@"PROVICE"],[posDic objectForKey:@"CITY"],[posDic objectForKey:@"DIST"]];
//            CLog(@"posAddress:%@", posAddress);
//            [self searchGeocode:posAddress];
            
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
    NSString *city = response.regeocode.addressComponent.city;
    NSString *dist = response.regeocode.addressComponent.district;
    
    [posDic setObject:provice forKey:@"PROVICE"];
    [posDic setObject:city forKey:@"CITY"];
    [posDic setObject:dist forKey:@"DIST"];
    [posDic setObject:posName forKey:@"ADDRESS"];
    
    toolBar.posFld.text = posName;
    toolBar.posFld.font = [UIFont systemFontOfSize:10.f];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request
                   response:(AMapGeocodeSearchResponse *)response
{
    AMapGeocode *p = [response.geocodes objectAtIndex:0];
    selAnn.coordinate = CLLocationCoordinate2DMake(p.location.latitude,
                                                   p.location.longitude);
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
        self.mapView.showsUserLocation = NO;
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
        [self searchReGeocode:self.mapView.userLocation.coordinate];
        
        //搜索第三方场地
        [self searchNearOtherPos];
    }
}

- (void) mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
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

        //显示地址
        toolBar.posFld.text = annn.siteObj.address;
        [posDic setObject:annn.siteObj.proviceName
                   forKey:@"PROVICE"];
        [posDic setObject:annn.siteObj.cityName
                   forKey:@"CITY"];
        [posDic setObject:annn.siteObj.districtName
                   forKey:@"DIST"];
        [posDic setObject:annn.siteObj.address
                   forKey:@"ADDRESS"];
        
        [self.mapView addAnnotation:_calloutMapAnnotation];
        [self.mapView setCenterCoordinate:view.annotation.coordinate
                                 animated:YES];
    }
}

- (void) mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if (_calloutMapAnnotation && ![view isKindOfClass:[CallOutAnnotationView class]]) {
        CLog(@"Deselect");
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
}
@end
