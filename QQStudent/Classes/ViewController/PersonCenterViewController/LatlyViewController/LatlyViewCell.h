//
//  LatlyViewCell.h
//  QQStudent
//
//  Created by lynn on 14-3-1.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LatlyViewCell;
@protocol LatlyViewCellDelegate <NSObject>

- (void) view:(LatlyViewCell *) view clickedIndex:(int) index;

@end

@interface LatlyViewCell : UITableViewCell<TTImageViewDelegate>
{
    UIButton *headBtn;
    UILabel *timeLab;
    UILabel *msgLab;
    UILabel *infoLab;
    UILabel *nameLab;
}

@property (nonatomic, assign) id<LatlyViewCellDelegate> delegate;
@property (nonatomic, copy) NSDictionary *msgDic;
@end
