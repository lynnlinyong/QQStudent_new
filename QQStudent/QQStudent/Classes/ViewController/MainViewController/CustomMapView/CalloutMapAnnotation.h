//
//  CalloutMapAnnotation.h
//  QQStudent
//
//  Created by lynn on 14-2-7.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalloutMapAnnotation : NSObject<MAAnnotation>
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, copy) Site *site;
@property (copy, nonatomic) Teacher *teacherObj; 
- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;
@end
