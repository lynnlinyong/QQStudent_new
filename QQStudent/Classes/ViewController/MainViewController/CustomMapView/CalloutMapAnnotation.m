//
//  CalloutMapAnnotation.m
//  QQStudent
//
//  Created by lynn on 14-2-7.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation
@synthesize latitude;
@synthesize longitude;
@synthesize teacherObj;
@synthesize site;

- (id)initWithLatitude:(CLLocationDegrees)lat
          andLongitude:(CLLocationDegrees)lon
{
    if (self = [super init]) {
        self.latitude = lat;
        self.longitude = lon;
    }
    return self;
}


-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

@end
