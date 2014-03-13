//
//  UIButton+JSMessagesView.h
//  MessagesDemo
//
//  Created by Jesse Squires on 3/24/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JSMessagesView)

+ (UIButton *)defaultSendButton;

+ (UIButton *)defaultComplainButton;

+ (UIButton *)defaultVoiceButton;

+ (UIButton *)defaultPhoneButton;

+ (UIButton *)defaultKeyBoardButton;

+ (UILongPressButton *) defaultLongPressButton:(CGRect) rect;
@end