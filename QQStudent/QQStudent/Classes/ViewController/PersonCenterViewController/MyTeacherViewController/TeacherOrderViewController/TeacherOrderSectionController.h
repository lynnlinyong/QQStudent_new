//
//  TeacherOrderSectionController.h
//  QQStudent
//
//  Created by lynn on 14-2-12.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherOrderSectionController : GCRetractableSectionController<
                                                                        TeacherOrderCellDelegate>
@property (nonatomic, retain) NSDictionary *teacherOrderDic;
@property (nonatomic, retain) NSArray *ordersArr;
@end
