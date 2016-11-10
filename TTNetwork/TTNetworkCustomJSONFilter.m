//
//  TTNetworkPrivate.m
//  TTDemo
//
//  Created by tofu on 12/26/15.
//  Copyright © 2015 iOS Tofu. All rights reserved.
//

#import "TTNetworkCustomJSONFilter.h"
#import "TTNetworkManager.h"
#import "TTBaseRequest.h"
#import "TTErrors.h"


typedef NS_ENUM(NSInteger, TTResponseStatus) {
    TTResponseStatusFailure,
    TTResponseStatusSuccess
};

NSString *const kResultKey         = @"result";
NSString *const kSuccessKey        = @"success";
NSString *const kMessageKey        = @"msg";
NSString *const kResponseCodeKey   = @"respCode";
NSString *const kResponseDataKey   = @"data";

@implementation TTNetworkCustomJSONFilter



#pragma mark - Format Response
- (id)filterJSONObjectWithResponse:(id)responseObject error:(NSError *__autoreleasing  _Nullable *)error message:(NSString *__autoreleasing  _Nullable *)message {
    

    if (*error) {
        
        NSError *localEror = *error;
        NSError *underlyingError = localEror.userInfo[NSUnderlyingErrorKey];
        if (underlyingError.userInfo) {
            NSHTTPURLResponse *response = underlyingError.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            if (response) {
                [self httpErrorcode:response.statusCode error:error];
            } else {
                NSInteger code = [underlyingError code];
                [self urlErrorWithCode:code error:error];
            }
        } else {
            [self urlErrorWithCode:localEror.code error:error];
        }
        
        return responseObject;
    }
    
    id filterJSONObject = responseObject;
    
    if ([filterJSONObject isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *result = (NSDictionary *)filterJSONObject[kResultKey];
        
        if (result == nil) {
            return filterJSONObject;
        }
        
        NSError *filterError = nil;
        
        NSNumber *code = result[kSuccessKey];
        if (code.intValue == TTResponseStatusSuccess) {   //请求成功
            id filterData = result[kResponseDataKey];
            NSString *msg = result[kMessageKey];
            *message = msg;
            return filterData;
        } else {
            NSString *msg = result[kMessageKey];
            id filterData = result[kResponseDataKey];
            NSInteger errorCode = [result[kResponseCodeKey] integerValue];
            if (errorCode == TTURLResponseStatusSystemError) {
                filterError = [NSError errorWithDomain:TTCocoaErrorDomain code:errorCode userInfo:@{NSLocalizedFailureReasonErrorKey:@"服务器异常"}];
            } else {
                filterError = [NSError errorWithDomain:TTCocoaErrorDomain code:errorCode userInfo:@{NSLocalizedFailureReasonErrorKey:msg ?: @""}];
            }
            *error = filterError;
            *message = msg;
            return filterData;
        }
    } else {
#if DEBUG
        NSError *filterError = [NSError errorWithDomain:TTCocoaErrorDomain code:TTURLErrorJSONInvalid userInfo:@{NSLocalizedFailureReasonErrorKey:@"无效的 JSON 格式"}];
        *error = filterError;
        *message = filterError.localizedFailureReason;
#endif
        return filterJSONObject;
    }

}

/**
 *  统一处理返回数据，保证最后取到的只包含需要的部份
 *
 *  @param responseObject 服务器返回的 JsonObject
 *  @param request        当前请求
 *
 *  @return 格式化后的 object
 */
- (id)prettyPrintedForJSONObject:(id  _Nullable __autoreleasing *)responseObject request:(TTBaseRequest *)request {
    
    if (!*responseObject) {
        request.response.responseObject = nil;
        return nil;
    }
    id responseJSONObject = *responseObject;
    
    if ([responseJSONObject isKindOfClass:[NSDictionary class]]) {

        NSDictionary *result = (NSDictionary *)responseJSONObject[kResultKey] ?: responseJSONObject;
        NSError      *error = nil;
        
        NSNumber *code = result[kSuccessKey];
        if (code.intValue == TTResponseStatusSuccess) {   //请求成功
            NSString *msg = result[kMessageKey];
            
            id resultData = result[kResponseDataKey];
            request.response.responseObject = resultData;
            request.response.message = msg;
            *responseObject = resultData;
            return resultData;

        } else {
            NSString *msg = result[kMessageKey];
            id resultData = result[kResponseDataKey];
            NSInteger errorCode = [result[kResponseCodeKey] integerValue];
            if (errorCode == TTURLResponseStatusSystemError) {
                error = [NSError errorWithDomain:TTCocoaErrorDomain code:errorCode userInfo:@{NSLocalizedFailureReasonErrorKey:@"服务器异常"}];
            } else {
                error = [NSError errorWithDomain:TTCocoaErrorDomain code:errorCode userInfo:@{NSLocalizedFailureReasonErrorKey:msg ?: @""}];
            }
            request.response.error = error;
            request.response.message = error.localizedFailureReason;
            return resultData;
        }
    } else {
#if DEBUG
        NSError *error = [NSError errorWithDomain:TTCocoaErrorDomain code:TTURLErrorJSONInvalid userInfo:@{NSURLErrorFailingURLErrorKey:@"无效的 JSON 格式"}];
        request.response.error = error;
        request.response.message = error.localizedFailureReason;
#endif
        return nil;
    }
}


- (NSError *)prettyPrintedForError:(NSError *)error request:(TTBaseRequest *)request {
    
    if (request.error) {
        return request.error;
    }
    
    if (!error) {
        return nil;
    }
    
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
    request.response.error = finalError;
    request.response.message = finalError.localizedFailureReason;
    
    return finalError;
}

/**
 *  HTTP response status code
 *
 *  @param errorCode
 *  @param finalError
 */
- (void)httpErrorcode:(TTHTTPError)errorCode error:(NSError *__autoreleasing *)finalError {
    
    switch (errorCode) {
        case TTHTTPErrorBadRequest: {
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTHTTPErrorBadRequest userInfo:@{NSLocalizedFailureReasonErrorKey:@"无效的请求参数"}];
            break;
        }
        case TTHTTPErrorNotFound: {
             *finalError = [NSError errorWithDomain:TTErrorDomain code:TTHTTPErrorNotFound userInfo:@{NSLocalizedFailureReasonErrorKey:@"请求地址不存在"}];
            break;
        }
        case TTHTTPErrorRequestTimeout: {
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTHTTPErrorRequestTimeout userInfo:@{NSLocalizedFailureReasonErrorKey:@"请求超时"}];
            break;
        }
        case TTHTTPErrorInternalServerError: {
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTHTTPErrorInternalServerError userInfo:@{NSLocalizedFailureReasonErrorKey:@"服务器异常"}];
            break;
        }
        default:
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
        case TTURLErrorTimeout:
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTURLErrorTimeout userInfo:@{NSLocalizedFailureReasonErrorKey:@"请求超时"}];
            break;
        case TTURLErrorNetworkConnectinoLost:
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTURLErrorNetworkConnectinoLost userInfo:@{NSLocalizedFailureReasonErrorKey:@"网络似乎有点问题"}];
            break;
        case TTURLErrorNotConnectedToInternet:
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTURLErrorNotConnectedToInternet userInfo:@{NSLocalizedFailureReasonErrorKey:@"网络断开连接"}];
            break;
#ifdef DEBUG
        case TTURLErrorBadRequest:
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTURLErrorBadRequest userInfo:@{NSLocalizedFailureReasonErrorKey:@"参数错误"}];
            break;
        case TTURLErrorUnsupportedURL:
        case TTURLErrorCannotFindHost:
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTURLErrorUnsupportedURL | TTURLErrorCannotFindHost userInfo:@{NSLocalizedFailureReasonErrorKey:@"无效的URL地址"}];
            break;
        case TTURLErrorCannotConnectToHost:
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTURLErrorCannotConnectToHost userInfo:@{NSLocalizedFailureReasonErrorKey:@"无法连接服务器"}];
            break;
        case TTURLErrorResourceUnavailable:
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTURLErrorResourceUnavailable userInfo:@{NSLocalizedFailureReasonErrorKey:@"资源不可用"}];
            break;
        case TTURLErrorBadServerResponse:
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTURLErrorBadServerResponse userInfo:@{NSLocalizedFailureReasonErrorKey:@"服务器出现异常"}];
            break;
        case TTURLErrorrTansportSecurityOlicyRequires:
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTURLErrorrTansportSecurityOlicyRequires userInfo:@{NSLocalizedFailureReasonErrorKey:@"为了数据安全，请使用 HTTPS 协议"}];
            break;
        case TTURLErrorUnknow:
            break;
        case TTURLErrorCancelled:
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTURLErrorCancelled userInfo:@{NSLocalizedFailureReasonErrorKey:@"用户取消操作"}];
            break;
        case TTURLErrorJSONInvalid:
            *finalError = [NSError errorWithDomain:TTErrorDomain code:TTURLErrorJSONInvalid userInfo:@{NSLocalizedFailureReasonErrorKey:@"无效的 JSON 数据"}];
            break;
#endif
        default:
            break;
    }
}


@end
