//
//  CalloutMapAnnotation.m
//  QQStudent
//
//  Created by lynn on 14-2-7.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize teacherObj;
@synthesize site;

- (id)initWithLatitude:(CLLocationDegrees)lat
          andLongitude:(CLLocationDegrees)lon
{
    if (self = [super init]) {

        CLog(@"cur:%f,%f", lat,lon);
        _latitude  = lat;
        _longitude = lon;
        CLog(@"cur1:%f,%f", _latitude,_longitude);
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
