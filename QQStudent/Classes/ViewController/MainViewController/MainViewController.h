//
//  MainViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTTSession.h"

@interface MainViewController : UIViewController<ServerRequestDelegate,
                                                AMapSearchDelegate,
                                                MAMapViewDelegate>
{
    NSString        *appurl;
    NSMutableArray  *teacherArray;
    NSMutableArray  *annArray;
    AMapSearchAPI   *search;
    CalloutMapAnnotation *_calloutMapAnnotation;
}
@property (nonatomic, retain) MAMapView *mapView;

+ (void) getWebServerAddress;
+ (NSString *) getPort:(NSString *) str;
+ (NSString *) getPushAddress:(NSString *) str;
@end
