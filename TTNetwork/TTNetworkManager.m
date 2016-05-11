//
//  TTNetworkManager.m
//  TJDemo
//
//  Created by tofu on 15/1/13.
//  Copyright (c) 2015年 tofu jelly. All rights reserved.
//

#import "TTNetworkConfig.h"
#import "TTNetworkManager.h"
#import "TTBaseRequest.h"
#import "TTNetworkResponse.h"


NSString *const TT_HTTP_COOKIE_KEY = @"TTNetworkCookieKey";
NSString *const kRequestNoInternet = @"网络异常，请检查网络设置";
NSString *const TTErrorDomain      = @"com.tofu.network.error.domain";
NSString *const TTCocoaErrorDomain = @"com.tofu.network.cocoaError.domain";


@interface TTNetworkManager (TTNetworkURLBuild)

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters;

@end

@interface TTNetworkManager() {
    
    TTNetworkConfig      *_config;
    NSMutableDictionary *_requestsRecord;
}

@property (nonatomic, assign, readwrite) TTRequestReachabilityStatus reachabilityStatus;


@end

@implementation TTNetworkManager

- (NSString *)ttNetworkVersion {
    return @"v0.2";
}

+ (void)load {
    [[TTNetworkManager sharedManager] startMonitoringNetwork];
}

+ (instancetype)sharedManager {
    static TTNetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[TTNetworkManager alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        _config = [TTNetworkConfig sharedInstance];
        _requestsRecord = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)buildRequestUrl:(TTBaseRequest *)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    
    if ([detailUrl hasPrefix:@"https"]) {
        return detailUrl;
    }
    
    NSString *baseUrl;
    if ([request baseUrl].length > 0) {
        baseUrl = [request baseUrl];
    } else {
        baseUrl = [_config baseUrl];
    }
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

- (TTBaseRequest *)startRequest:(TTBaseRequest *)request {
    TTLog(@"Start Request: %@", NSStringFromClass([request class]));
    
    if (_manager.reachabilityManager.networkReachabilityStatus == TTRequestReachabilityStatusNotReachable) {
        NSError *error = [NSError errorWithDomain:TTErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:@{NSLocalizedFailureReasonErrorKey:kRequestNoInternet}];
        request.response.error = error;
        [self requestDidFinishTag:request];
        return request;
    }
    
    // 使用cookie
    if (request.useCookies) {
        [self loadCookies];
    }
    
    // config securityPolicy
    if ([_config securityPolicy]) {
        [_manager setSecurityPolicy:[_config securityPolicy]];
    }
    
    TTRequestMethod method = [request requestMethod];
    NSString *url = [self buildRequestUrl:request];
    id parameters = request.requestParemeters;
    
    // config serializer
    if (request.requestSerializer == TTHTTPRequestSerializer) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    if (request.responseSerializer == TTHTTPRequestSerializer) {
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    } else {
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    // if api need add custom value to HTTPHeaderField
    NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            } else {
                TTLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
    
    // config request timeout
    _manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    
    // set acceptable content types
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html", nil];
    
    __block NSURLSessionTask *task;
    __block TTBaseRequest *requestBlock = request;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    switch (method) {
        case TTRequestMethodGet:
        {
            if (request.resumeDownloadPath) {
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if(![fileManager fileExistsAtPath:[request.resumeDownloadPath stringByDeletingLastPathComponent]]){
                    [fileManager createDirectoryAtPath:[request.resumeDownloadPath stringByDeletingLastPathComponent]
                           withIntermediateDirectories:YES
                                            attributes:nil
                                                 error:nil];
                }
                
                if ([fileManager fileExistsAtPath:request.resumeDownloadPath]) {
                    TTLog(@"Download Finished : File already exists");
                    request.response.responseObject = @{@"success":@"1",
                                                        @"msg":@"File already exists"};
                    [self requestDidFinishTag:request];
                    return request;
                }
                
                NSString *filteredUrl = [TTNetworkManager urlStringWithOriginUrlString:url appendParameters:parameters];
                NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:filteredUrl]];
                
                task = [_manager downloadTaskWithRequest:requestURL progress:request.completionProgress ?: nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    NSURL *fileUrl = [NSURL fileURLWithPath:request.resumeDownloadPath];
                    return fileUrl;
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    if (error) {
                        [fileManager removeItemAtPath:filePath.absoluteString error:nil];
                        [self handleReponseResult:task response:nil error:error];
                    } else {
                        NSDictionary *responseDict = @{@"success":@"1",
                                                       @"msg":filePath};
                        [self handleReponseResult:task response:responseDict error:nil];
                    }
                }];
                
                [task resume];
                
            } else {
                task = [_manager GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    TTLog(@"url:%@, parameters:%@, responese:%@",requestBlock.requestUrl,parameters,responseObject);
                    [self handleReponseResult:task response:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    TTLog(@"param: %@, url :%@, \nerror: %@",parameters,requestBlock.requestUrl,error);
                    [self handleReponseResult:task response:nil error:error];
                }];
            }
        }
            break;
        case TTRequestMethodPost:
        {
            if (request.constructionBodyBlock) {
                
                NSError *serializationError = nil;
                NSMutableURLRequest *requestURL = [_manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:request.constructionBodyBlock error:&serializationError];
                if (serializationError) {
                    request.response.error = serializationError;
                    [self requestDidFinishTag:request];
                    return request;
                }
                
                task = [_manager uploadTaskWithStreamedRequest:requestURL progress:request.completionProgress ?: nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    TTLog(@"url:%@, parameters:%@, responese:%@",requestBlock.requestUrl,parameters,responseObject);
                    
                    [self handleReponseResult:task response:responseObject error:error];
                }];
                
                [task resume];
                
            } else {
                
                task = [_manager POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    TTLog(@"url:%@, parameters:%@, responese:%@",requestBlock.requestUrl,parameters,responseObject);
                    [self handleReponseResult:task response:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    TTLog(@"param: %@, url :%@, \nerror: %@",parameters,requestBlock.requestUrl,error);
                    [self handleReponseResult:task response:nil error:error];
                }];
            }
        }
            break;
        default:
            break;
    }
#pragma clang diagnostic pop
    request.response.task = task;
    [self addRequest:request];
    return request;

}

- (void)handleReponseResult:(id)task response:(id)responseObject error:(NSError *)error {
    
    NSString *key = [self taskHashKey:task];
    TTBaseRequest *request = _requestsRecord[key];
    if (error.code == NSURLErrorCancelled) {
        [request clearComplition];
        [self requestDidFinishTag:request];
        [self removeRequest:task];
        return;
    }
    if (request) {
        if (error) {
            request.response.error = error;
            request.response.message = error.localizedDescription;
        } else {
            request.response.responseObject = responseObject;
        }
    }
    [self requestDidFinishTag:request];
    [self removeRequest:task];
}

#pragma mark - Finished Request Handler
- (void)requestDidFinishTag:(TTBaseRequest *)request {
    
    TTLog(@"Finished Request: %@", NSStringFromClass([request class]));
    if (request.error) {
        if (request.requestFailureHandler) {
            request.requestFailureHandler(request);
        }
        //        [request requestCompleteFailure];
    } else {
        if (request.requestSuccessHandler) {
            request.requestSuccessHandler(request);
        }
        
        //        [request requestCompleteSuccess];
    }
    
    [request clearComplition];
}


/**
  Monitoring Network
 */
- (void)startMonitoringNetwork {
    [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                _reachabilityStatus = TTRequestReachabilityStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _reachabilityStatus = TTRequestReachabilityStatusViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _reachabilityStatus = TTRequestReachabilityStatusViaWiFi;
                break;
            default:
                _reachabilityStatus = TTRequestReachabilityStatusUnknow;
                break;
        }
    }];
    [_manager.reachabilityManager startMonitoring];
}



// 管理`request`的生命周期, 防止多线程处理同一key
- (void)addRequest:(TTBaseRequest *)request {
    if (request.response.task) {
        NSString *key = [self taskHashKey:request.response.task];
        @synchronized(self) {
            [_requestsRecord setValue:request forKey:key];
        }
    }
}

- (void)removeRequest:(id)task {
    NSString *key = [self taskHashKey:task];
    @synchronized(self) {
        [_requestsRecord removeObjectForKey:key];
    }
}

- (NSString *)taskHashKey:(id)task {
    return [NSString stringWithFormat:@"%lu", (unsigned long)[task hash]];
}

- (void)cancelRequest:(TTBaseRequest *)request {
    [request.response.task cancel];
    [self removeRequest:request.response.task];
}

- (void)cancelAllRequests {
    for (NSString *key in [_requestsRecord allKeys]) {
        TTBaseRequest *request = _requestsRecord[key];
        [self cancelRequest:request];
    }
}

#pragma mark - cookies
- (void)saveCookies {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    if (cookies.count > 0) {
        NSData *cookieData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        
        [[NSUserDefaults standardUserDefaults] setObject:cookieData forKey:TT_HTTP_COOKIE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)loadCookies {
    id cookieData = [[NSUserDefaults standardUserDefaults] objectForKey:TT_HTTP_COOKIE_KEY];
    if (!cookieData) {
        return;
    }

    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookieData];
    if ([cookies isKindOfClass:[NSArray class]] && cookies.count > 0) {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStorage setCookie:cookie];
        }
    }
}


@end


@implementation TTNetworkManager (TTNetworkURLBuild)


+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *filteredUrl = originUrlString;
    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
    if (paraUrlString && paraUrlString.length > 0) {
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        } else {
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
        return filteredUrl;
    } else {
        return originUrlString;
    }
}


+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
            value = [self urlEncode:value];
            [urlParametersString appendFormat:@"&%@=%@", key, value];
        }
    }
    return urlParametersString;
}

+ (NSString*)urlEncode:(NSString*)str {
    //different library use slightly different escaped and unescaped set.
    //below is copied from AFNetworking but still escaped [] as AF leave them for Rails array parameter which we don't use.
    //https://github.com/AFNetworking/AFNetworking/pull/555
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
}

@end

@implementation TTNetworkManager (TTNetworkDeprecated)

- (TTBaseRequest *)startRequest:(TTBaseRequest *)request success:(void(^) (TTBaseRequest *request))success failure:(void(^) (TTBaseRequest *request))failure {
    
    return [self startRequest:request success:success failure:failure progress:nil];
}

- (TTBaseRequest *)startRequest:(TTBaseRequest *)request success:(void (^)(TTBaseRequest * _Nonnull))success failure:(void (^)(TTBaseRequest * _Nonnull))failure progress:(void (^)(NSProgress * _Nonnull))progress {
    
    return [self startRequest:request];
}

@end