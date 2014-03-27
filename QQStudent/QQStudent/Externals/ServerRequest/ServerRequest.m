//
//  ServerRequest.m
//  PHPApiTestProj
//
//  Created by Lynn on 12-11-13.
//  Copyright (c) 2012年 WiMi. All rights reserved.
//

#import "ServerRequest.h"
#import "ASIFormDataRequest.h"

@implementation ServerRequest
@synthesize delegate = _delegate;

static ServerRequest *sharedServerRequest = nil; 

+ (ServerRequest *)sharedServerRequest
{ 
	@synchronized(self) 
	{ 
		if (sharedServerRequest == nil)
		{ 
			sharedServerRequest = [[self alloc] init];
		} 
	} 
    
	return sharedServerRequest; 
} 

+ (id)allocWithZone:(NSZone *)zone 
{ 
	@synchronized(self) 
	{ 
		if (sharedServerRequest == nil) 
		{ 
			sharedServerRequest = [super allocWithZone:zone]; 
			return sharedServerRequest; 
		} 
	} 
    
	return nil;
} 

- (id)copyWithZone:(NSZone *)zone 
{ 
	return self; 
} 

- (id)retain 
{
	return self; 
} 

- (NSUInteger)retainCount 
{ 
	return NSUIntegerMax; 
} 

- (oneway void)release
{ 
} 

- (id)autorelease 
{ 
	return self;
}


//同步请求
- (NSData *) requestSyncWith:(ServReqMethod)  kReqMethod
                    paramDic:(NSDictionary *) pDic
                      urlStr:(NSString *)     pUrlStr
{
    NSURL *pUrl = nil;
    assert(pUrlStr);
    
    switch (kReqMethod)
    {
        case kServerPostRequest:        //post
        {
            assert(pDic);
            NSArray *paramsArr = [pDic allKeys];
            NSArray *valuesArr = [pDic allValues];
            
            pUrl = [NSURL URLWithString:pUrlStr];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:pUrl];
            for (int i=0; i<paramsArr.count; i++)
            {
                CLog(@"value:%@", [valuesArr objectAtIndex:i]);
                CLog(@"param:%@", [paramsArr objectAtIndex:i]);
                
                if ([[paramsArr objectAtIndex:i] isEqual:UPLOAD_FILE])
                {
                    NSDictionary *fileDic = [valuesArr objectAtIndex:i];
                    NSString *fileParam   = [[fileDic allKeys] objectAtIndex:0];
                    NSString *filePath    = [[fileDic allValues]objectAtIndex:0];
                    [request setFile:filePath forKey:fileParam];
                    continue;
                }

                [request setPostValue:[valuesArr objectAtIndex:i] 
                               forKey:[paramsArr objectAtIndex:i]];
                //                [request setTimeOutSeconds:10];
            }
            [request setTimeOutSeconds:15];
            [request setRequestMethod:@"POST"];
            [request setDefaultResponseEncoding:NSUTF8StringEncoding];
            [request addRequestHeader:@"Content-Type"
                                value:@"text/xml; charset=utf-8"];
            [request startSynchronous];
            [request setDelegate:self];
            return [request responseData];
            break;
        }
        case kServerGetRequest:         //get
        {
//            assert(pDic);
            if (pDic)
            {
                NSArray *paramsArr = [pDic allKeys];
                NSArray *valuesArr = [pDic allValues];
                
                for (int i=0; i<paramsArr.count; i++)
                {
                    if (i == 0)
                    {
                        [pUrlStr stringByAppendingFormat:@"?%@=%@", [paramsArr objectAtIndex:i],
                         [valuesArr objectAtIndex:i]];
                    }
                    else 
                    {
                        [pUrlStr stringByAppendingFormat:@"&%@=%@", [paramsArr objectAtIndex:i],
                         [valuesArr objectAtIndex:i]];
                    }
                }
            }
            
            pUrl = [NSURL URLWithString:pUrlStr];
            CLog(@"URL=%@", pUrl);
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:pUrl];
            [request setTimeOutSeconds:15];
            [request setRequestMethod:@"GET"];
            [request startSynchronous];
            return [request responseData];
            break;
        }
        default:
            break;
    }
    
    return nil;
}

//异步请求
- (void) requestASyncWith:(ServReqMethod)  kReqMethod
                 paramDic:(NSDictionary *) pDic
                   urlStr:(NSString *)     pUrlStr
{
    
    NSURL *pUrl = nil;
    assert(pUrlStr);

    switch (kReqMethod)
    {
        case kServerPostRequest:        //post
        {
            assert(pDic);
            NSArray *paramsArr = [pDic allKeys];
            NSArray *valuesArr = [pDic allValues];
            
            pUrl = [NSURL URLWithString:pUrlStr];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:pUrl];
            [request setDelegate:self];
            [request setDidFinishSelector:@selector(requestAsyncSuccessed:)];
            [request setDidFailSelector:@selector(requestAsyncFailed:)];
            for (int i=0; i<paramsArr.count; i++)
            {
                if ([[paramsArr objectAtIndex:i] isEqual:UPLOAD_FILE])
                {
                    NSDictionary *fileDic = [valuesArr objectAtIndex:i];
                    NSString *fileParam   = [[fileDic allKeys] objectAtIndex:0];
                    NSString *filePath    = [[fileDic allValues]objectAtIndex:0];
                    [request setFile:filePath forKey:fileParam];
                    continue;
                }
                
                [request setPostValue:[valuesArr objectAtIndex:i] 
                               forKey:[paramsArr objectAtIndex:i]];
            }
            [request setTimeOutSeconds:15];
            [request setDefaultResponseEncoding:NSUTF8StringEncoding];
            [request addRequestHeader:@"Content-Type"
                                value:@"text/xml; charset=utf-8"];
            [request startAsynchronous];
            break;
        }
        case kServerGetRequest:         //get
        {
//            assert(pDic);
            if (pDic)
            {
                NSArray *paramsArr = [pDic allKeys];
                NSArray *valuesArr = [pDic allValues];
                for (int i=0; i<paramsArr.count; i++)
                {
                    if (i == 0)
                    {
                        [pUrlStr stringByAppendingFormat:@"?%@=%@", [paramsArr objectAtIndex:i],
                                                                    [valuesArr objectAtIndex:i]];
                    }
                    else 
                    {
                        [pUrlStr stringByAppendingFormat:@"&%@=%@", [paramsArr objectAtIndex:i],
                                                                    [valuesArr objectAtIndex:i]];
                    }
                }
            }
            
            pUrl = [NSURL URLWithString:pUrlStr];
            CLog(@"URL=%@", pUrl);
    
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:pUrl];
            [request setTimeOutSeconds:15];
            [request setDidFinishSelector:@selector(requestAsyncSuccessed:)];
            [request setDidFailSelector:@selector(requestAsyncFailed:)];
            [request startAsynchronous];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark ASIHTTPRequest Delegate
- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{   
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(requestAsyncSuccessed:)])
        {
            [_delegate requestAsyncSuccessed:request];
        }
    }
}

- (void) requestASyncFailed:(ASIHTTPRequest *)request
{
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(requestAsyncFailed:)])
        {
            [_delegate requestAsyncFailed:request];
        }
    }
}
@end
