//
//  Teacher.h
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Teacher : NSObject<
                            NSCopying,
                            NSMutableCopying>
{
    NSString   *name;
    NSString   *sex;
    NSString   *pf;
    int        comment;
    NSString   *idNums;
    int        studentCount;
    NSString   *mood;
    NSString   *headUrl;
}

@property (nonatomic, retain) NSString     *name;
@property (nonatomic, retain) NSString     *sex;
@property (nonatomic, retain) NSString     *pf;
@property (nonatomic, assign) int          comment;
@property (nonatomic, retain) NSString     *idNums;
@property (nonatomic, assign) int          studentCount;
@property (nonatomic, retain) NSString     *mood;
@property (nonatomic, retain) NSString     *headUrl;
@end
