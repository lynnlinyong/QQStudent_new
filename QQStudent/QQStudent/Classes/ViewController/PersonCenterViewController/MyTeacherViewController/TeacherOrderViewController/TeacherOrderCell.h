//
//  TeacherOrderCell.h
//  QQStudent
//
//  Created by lynn on 14-2-12.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeacherOrderCell;
@protocol TeacherOrderCellDelegate <NSObject>
- (void) cell:(TeacherOrderCell *) cell buttonTag:(int) tag;
@end

@class CommentView;
@interface TeacherOrderCell : UITableViewCell
{
    UILabel  *studyPosLab;
    UILabel  *orderDateLab;
    UILabel  *orderInfoLab;
    UILabel  *noConfirmLab;
    UILabel  *finishLab;
    
    UIButton *freeBtn;
    UIButton *finishBtn;
    UIButton *updateBtn;
    
    NSMutableArray  *buttonArray;
    UIView *parentView;
    UIImageView *bgLabImageView;
}
@property (nonatomic, retain) CommentView *commView;
@property (nonatomic, copy)   Order *order;
@property (nonatomic, retain) UIButton *commentBtn;
@property (nonatomic, assign) id<TeacherOrderCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withParent:(UIView *) pView;
@end
