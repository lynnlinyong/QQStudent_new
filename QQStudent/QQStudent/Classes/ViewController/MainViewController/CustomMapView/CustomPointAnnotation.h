//
//  CustomPointAnnotation.h
//  QQStudent
//
//  Created by lynn on 14-2-8.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustomPointAnnotation : MAPointAnnotation
@property (nonatomic, assign) int tag;
@property (nonatomic, copy)   Site *siteObj;
@property (nonatomic, copy)   Teacher *teacherObj;
@end
