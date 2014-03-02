//
//  SelectPosViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopView : UIView
{
    UILabel  *info1Lab;
    UILabel  *info2Lab;
    
    UIImageView *imgView1;
    UIImageView *imgView2;
}
@end

@class BottomToolBar;
@protocol BottomToolBarDelegate <NSObject>
- (void) textViewReturnEditing:(UITextView *) textField;
- (void) textViewBegianEditing:(UITextView *) textField;
- (void) bottomToolBar:(BottomToolBar *) bar index:(int) clickedIndex;
@end

@interface BottomToolBar : UIView<UITextViewDelegate>
{
    UIButton        *areaBtn;
    UIButton        *okBtn;
    UITextView      *posFld;
}

@property (nonatomic, retain) UITextView *posFld;
@property (nonatomic, assign) id<BottomToolBarDelegate> delegate;
@end

@interface SelectPosViewController : UIViewController<
                                                    SiteOtherViewDelegate,
                                                    ServerRequestDelegate,
                                                    MAMapViewDelegate,
                                                    AMapSearchDelegate,
                                                    BottomToolBarDelegate,
                                                    HZAreaPickerDelegate>
{
    BottomToolBar          *toolBar;
    NSMutableDictionary    *posDic;
    CustomPointAnnotation  *selAnn;
    CalloutMapAnnotation   *_calloutMapAnnotation;
    CLLocationCoordinate2D loc;
}
@property (nonatomic, retain) MAMapView *mapView;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@end
