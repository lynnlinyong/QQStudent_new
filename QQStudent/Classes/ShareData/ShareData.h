//
//  ShareData.g.h
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#ifndef QQStudent_ShareData_h
#define QQStudent_ShareData_h

//测试前缀
#define DEBUG_PREFIX    @"****DEBUG****:"

//第一次启动变量
#define LAUNCHERED      @"LAUNCHERED"

//Web服务器地址变量
#define WEBADDRESS      @"WEBADDRESS"

//Push服务器地址变量
#define PUSHADDRESS     @"PUSHADDRESS"

//Push服务器端口
#define PORT            @"PORT"

//学生接口标识
#define STUDENT         @"student/?"

//手机系统表示
#define IOS             @"1"

#define SSID            @"SSID"

//帮助电话
#define HELP_PHONE      @"HELP_PHONE"

//软件版本
#define APP_VERSION     @"APP_VERSION"

#define LOGINE_SUCCESS  @"LOGIN_SUCCESS"

//年级列表
#define GRADE_LIST      @"GRADE_LIST"

//科目列表
#define SUBJECT_LIST    @"SUBJECT_LIST"

//数据库名
#define DATABASE        @"provinces.db"

//录音名
#define VOICE_NAME      @"/voice.amr"

//上传文件标识
#define UPLOAD_FILE     @"UPLOAD_FILE"

//发送邀请等待时间
static int waitTimeInvite = 20;

//策略服务器地址
#define ServerAddress   @"http://app.changingedu.com:8085/Interfaces/app/"

#define     MAP_API_KEY  @"513e60ac02ea80ee24943c1d383dc56c"

#define     QQ_STUDENT   @"QQ_STUDENT"

typedef enum _tagMsgType
{
    PUSH_TYPE_PUSH = 0,
    PUSH_TYPE_APPLY,
    PUSH_TYPE_CONFIRM,
    PUSH_TYPE_TEXT,
    PUSH_TYPE_IMAGE,
    PUSH_TYPE_AUDIO,
    PUSH_TYPE_ORDER_EDIT,
    PUSH_TYPE_ORDER_CONFIRM,
    PUSH_TYPE_ORDER_EDIT_SUCCESS,
    PUSH_TYPE_ORDER_CONFIRM_SUCCESS,
    PUSH_TYPE_LISTENING_CHANG
}MsgType;

//腾讯微博
#define WiressSDKDemoAppKey     @"801443616"
#define WiressSDKDemoAppSecret  @"ed6625d85bac645b213207a67dfb6b31"
#define REDIRECTURI             @"http://app.changingedu.com/"

//sina微博
#define kAppKey                 @"2935532134"
#define kAppSecret              @"60229dfc252750a2ea2955fa14f0865d"
#define kAppRedirectURL         @"https://api.weibo.com/oauth2/default.html"

//微信
#define WeiXinAppID             @"wx6b649532e1431a06"
#define WeiXinAppKey            @"868323d2e1985c15e6c19d5e5eab85b8"

#endif