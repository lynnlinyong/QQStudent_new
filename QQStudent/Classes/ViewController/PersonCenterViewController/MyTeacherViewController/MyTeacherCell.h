//
//  MyTeacherCell.h
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyTeacherCellDelegate <NSObject>
- (void) tableViewCell:(UITableViewCell *)cell ClickedButton:(int) index;
@end

@class Teacher;
@class UIStartsImageView;
@interface MyTeacherCell : UITableViewCell
{
    UIButton            *headBtn;
    UILabel             *introduceLab;
    UIButton            *commBtn;
    UIButton            *compBtn;
    UIButton            *recommBtn;
    UIStartsImageView   *starImageView;
}

@property (nonatomic, retain) Teacher  *teacher;
@property (nonatomic, assign) id<MyTeacherCellDelegate> delegate;


@end
