//
//  TTNetworkResponse+Format.m
//  TTNetworkDemo
//
//  Created by tofu on 1/11/16.
//  Copyright © 2016 iOS Tofu. All rights reserved.
//

#import "TTNetworkResponse+Format.h"
#import "TTErrors.h"
#import <AFNetworking.h>
#import <objc/runtime.h>

NSString *const kResultKey         = @"result";
NSString *const kSuccessKey        = @"success";
NSString *const kMessageKey        = @"msg";
NSString *const kResponseCodeKey   = @"respCode";
NSString *const kResponseDataKey   = @"data";

@implementation TTNetworkResponse (Format)


- (void)setError:(NSError *)error {
    NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
    NSError *finalError = nil;
    if (underlyingError.userInfo) {
        NSHTTPURLResponse *response = underlyingError.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        if (response) {
            [self httpErrorcode:response.statusCode error:&finalError];
        } else {
            NSInteger code = [underlyingError code];
            [self urlErrorWithCode:code error:&finalError];
        }
    } else {
        [self urlErrorWithCode:error.code error:&finalError];
    }
    
    if (finalError) {
        objc_setAssociatedObject(self, @selector(error), finalError, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, @selector(error), error, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (NSError *)error {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setResponseObject:(id)responseObject {
    
    if ([responseObject isKindOfClass:[NSString class]] ||
        [responseObject isKindOfClass:[NSURL class]]) {
        objc_setAssociatedObject(self, @selector(responseObject), responseObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        NSDictionary *result = (NSDictionary *)responseObject[kResultKey] ?: responseObject;
        NSError      *error = nil;
        //判断状态码
        NSNumber *code = result[kSuccessKey];
        if (code.intValue == 1) {   //请求成功
            NSString *msg = result[kMessageKey];
            
            id result = result[kResponseDataKey];
            self.message = msg ?: @"";
            objc_setAssociatedObject(self, @selector(responseObject), result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else{
            NSString *msg = result[kMessageKey];
            NSInteger errorCode = [result[kResponseCodeKey] integerValue];
            error = [NSError errorWithDomain:msg ?: @"" code:errorCode userInfo:nil];
            self.error = error;
        }
    }
    

}

- (id)responseObject {
    return objc_getAssociatedObject(self, _cmd);
}


/**
 *  http response status code
 *
 *  @param errorCode
 *  @param finalError
 */
- (void)httpErrorcode:(TTHTTPError)errorCode error:(NSError *__autoreleasing *)finalError {
    
    switch (errorCode) {
        case TTHTTPErrorBadRequest:
            *finalError = [NSError errorWithDomain:@"无效的请求参数" code:TTHTTPErrorBadRequest userInfo:nil];
            break;
        case TTHTTPErrorNotFound:
            *finalError = [NSError errorWithDomain:@"请求地址不存在" code:TTHTTPErrorNotFound userInfo:nil];
            break;
        default:
            *finalError = [NSError errorWithDomain:@"未知错误" code:00000 userInfo:nil];
            break;
    }
}

/**
 *  NURLError status code
 *
 *  @param errorCode
 *  @param finalError
 */
- (void)urlErrorWithCode:(TTURLError)errorCode error:(NSError *__autoreleasing *)finalError {
    switch (errorCode) {
        case TTURLErrorBadRequest:
            *finalError = [NSError errorWithDomain:@"参数错误" code:TTURLErrorBadRequest userInfo:nil];
            break;
        case TTURLErrorTimeout:
            *finalError = [NSError errorWithDomain:@"请求超时" code:TTURLErrorTimeout userInfo:nil];
            break;
        case TTURLErrorUnsupportedURL:
        case TTURLErrorCannotFindHost:
            *finalError = [NSError errorWithDomain:@"无效的URL地址" code:TTURLErrorUnsupportedURL | TTURLErrorCannotFindHost userInfo:nil];
            break;
        case TTURLErrorCannotConnectToHost:
            *finalError = [NSError errorWithDomain:@"无法连接服务器" code:TTURLErrorCannotConnectToHost userInfo:nil];
            break;
        case TTURLErrorNetworkConnectinoLost:
            *finalError = [NSError errorWithDomain:@"网络似乎有点问题" code:TTURLErrorNetworkConnectinoLost userInfo:nil];
            break;
        case TTURLErrorResourceUnavailable:
            *finalError = [NSError errorWithDomain:@"数据格式不正确" code:TTURLErrorResourceUnavailable userInfo:nil];
            break;
        case TTURLErrorNoInternet:
            *finalError = [NSError errorWithDomain:@"无网络" code:TTURLErrorNoInternet userInfo:nil];
            break;
        case TTURLErrorBadServerResponse:
            *finalError = [NSError errorWithDomain:@"服务器出现异常" code:TTURLErrorBadServerResponse userInfo:nil];
            break;
        case TTURLErrorrTansportSecurityOlicyRequires:
            *finalError = [NSError errorWithDomain:@"为了数据安全，请使用 HTTPS 协议" code:TTURLErrorrTansportSecurityOlicyRequires userInfo:nil];
            break;
        case TTURLErrorUnknow:
        case TTURLErrorCancelled:
            break;
        case TTURLErrorJSONInvalid:
            *finalError = [NSError errorWithDomain:@"无效的 JSON 数据" code:TTURLErrorJSONInvalid userInfo:nil];
            break;
        default:
            break;
    }
}


@end
