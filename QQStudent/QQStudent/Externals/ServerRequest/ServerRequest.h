//
//  ServerRequest.h
//  PHPApiTestProj
//
//  Created by Lynn on 12-11-13.
//  Copyright (c) 2012年 WiMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

typedef enum _tagServReqMethod
{
    kServerPostRequest = 0,     //post方法
    kServerGetRequest           //get方法
}ServReqMethod;

@protocol ServerRequestDelegate <NSObject>

@required
//异步请求成功
- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request;

//异步请求失败
- (void) requestAsyncFailed:(ASIHTTPRequest *)request;

@end

@interface ServerRequest : NSObject
{
    id<ServerRequestDelegate>       _delegate;
}

@property (nonatomic, assign) id<ServerRequestDelegate>  delegate;

//获得共享网络请求对象
+ (ServerRequest *)sharedServerRequest;

//同步请求
- (NSData *) requestSyncWith:(ServReqMethod)  kReqMethod
                    paramDic:(NSDictionary *) pDic
                      urlStr:(NSString *)     pUrlStr;


//异步请求
- (void) requestASyncWith:(ServReqMethod)  kReqMethod
                 paramDic:(NSDictionary *) pDic
                   urlStr:(NSString *)     pUrlStr;
@end
