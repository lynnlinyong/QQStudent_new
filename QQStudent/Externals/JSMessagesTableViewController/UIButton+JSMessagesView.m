//
//  UIButton+JSMessagesView.m
//  MessagesDemo
//
//  Created by Jesse Squires on 3/24/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//

#import "UIButton+JSMessagesView.h"

@implementation UIButton (JSMessagesView)

+ (UIButton *)defaultSendButton
{
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
    UIImage *sendBack = [[UIImage imageNamed:@"send"] resizableImageWithCapInsets:insets];
    UIImage *sendBackHighLighted = [[UIImage imageNamed:@"send-highlighted"] resizableImageWithCapInsets:insets];
    [sendButton setBackgroundImage:sendBack forState:UIControlStateNormal];
    [sendButton setBackgroundImage:sendBack forState:UIControlStateDisabled];
    [sendButton setBackgroundImage:sendBackHighLighted forState:UIControlStateHighlighted];
    
    NSString *title = NSLocalizedString(@"Send", nil);
    [sendButton setTitle:title forState:UIControlStateNormal];
    [sendButton setTitle:title forState:UIControlStateHighlighted];
    [sendButton setTitle:title forState:UIControlStateDisabled];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    UIColor *titleShadow = [UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
    [sendButton setTitleShadowColor:titleShadow forState:UIControlStateNormal];
    [sendButton setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
    sendButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
    
    return sendButton;
}

+ (UIButton *)defaultComplainButton
{
    UIButton *complainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [complainBtn setImage:[UIImage imageNamed:@"cp_complain_normal_btn"]
                 forState:UIControlStateNormal];
    [complainBtn setImage:[UIImage imageNamed:@"cp_complain_hlight_btn"]
                 forState:UIControlStateHighlighted];
    return complainBtn;
}

+ (UIButton *)defaultVoiceButton
{
    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceBtn setImage:[UIImage imageNamed:@"cp_mic_btn"]
                 forState:UIControlStateNormal];
    return voiceBtn;
}

+ (UIButton *)defaultKeyBoardButton
{
    UIButton *keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [keyBoardBtn setImage:[UIImage imageNamed:@"cp_input_btn"]
              forState:UIControlStateNormal];
    return keyBoardBtn;
}

+ (UIButton *)defaultPhoneButton
{
    UIImage *img = [UIImage imageNamed:@"cp_phone_normal_btn"];
    CLog(@"sdfs%f,%f", img.size.width, img.size.height);
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn setImage:[UIImage imageNamed:@"cp_phone_normal_btn"]
                 forState:UIControlStateNormal];
    [phoneBtn setImage:[UIImage imageNamed:@"cp_phone_hlight_btn"]
                 forState:UIControlStateHighlighted];
    return phoneBtn;
}

+ (UILongPressButton *) defaultLongPressButton:(CGRect) rect
{
    UILongPressButton *lpBtn = [[UILongPressButton alloc]initWithFrame:rect];
    return lpBtn;
}
@end