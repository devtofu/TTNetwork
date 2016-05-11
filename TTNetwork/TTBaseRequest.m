//
//  TTBaseRequest.m
//  TTDemo
//
//  Created by tofu on 15/12/15.
//  Copyright © 2015年 iOS Tofu. All rights reserved.
//

#import "TTBaseRequest.h"
#import "TTNetworkManager.h"

@interface TTBaseRequest () {
    int64_t didReceiveUnintCount;
}

@property (nonatomic, assign, readwrite) BOOL useCookies;
@property (nonatomic, strong) TTNetworkResponse *response;
@property (nonatomic, strong) NSProgress *progress;

@end

@implementation TTBaseRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.useCookies = NO;
        self.requestSerializer = TTHTTPRequestSerializer;
        self.responseSerializer = TTJSONResponseSerializer;
        self.response = [TTNetworkResponse response];
        self.constructionBodyBlock = nil;
        self.completionProgress = nil;
    }
    return self;
}

- (BOOL)useCookies {
    return NO;
}

- (NSString *)baseUrl {
    return @"";
}

- (NSString *)requestUrl {
    return @"";
}

- (id)requestParemeters {
    return nil;
}

- (TTRequestMethod)requestMethod {
    return TTRequestMethodGet;
}


- (NSTimeInterval)requestTimeoutInterval {
    return 20;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    
    NSMutableDictionary *requestHeader = [NSMutableDictionary dictionary];
    requestHeader[@"client-type"] = @"mobile-iphone";
    return requestHeader;
}

- (NSString *)resumeDownloadPath {
    return nil;
}

- (id)responseObject {
    return self.response.responseObject;
}

- (NSString *)message {
    return self.response.message;
}

- (NSError *)error {
    return self.response.error;
}

- (void)start {
    [[TTNetworkManager sharedManager] startRequest:self];
}

- (void)stop {
    [[TTNetworkManager sharedManager] cancelRequest:self];
}

- (void)suspend {
    id task = self.response.task;
    if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
        NSURLSessionDownloadTask *downloadTask = (NSURLSessionDownloadTask *)task;
        if ([downloadTask state] == NSURLSessionTaskStateRunning) {
            [downloadTask suspend];
        } else if([downloadTask state] == NSURLSessionTaskStateSuspended) {
            [downloadTask resume];
        }
        return;
    }
    
    if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
        NSURLSessionUploadTask *uploadTask = (NSURLSessionUploadTask *)task;
        if (uploadTask.state == NSURLSessionTaskStateRunning) {
            [task suspend];
        } else if(uploadTask.state == NSURLSessionTaskStateSuspended) {
            [task resume];
        }
        return;
    }
}

- (void)resume {
    id task = self.response.task;
    if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
        NSURLSessionDownloadTask *downloadTask = task;
        if(downloadTask.state == NSURLSessionTaskStateSuspended) {
            [task resume];
        }
        return;
    }
    
    if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
        NSURLSessionUploadTask *uploadTask = task;
        if(uploadTask.state == NSURLSessionTaskStateSuspended) {
            [task resume];
        }
        return;
    }
}

- (void)setCompletionBlockWithSuccess:(void (^)(TTBaseRequest *))success failure:(void (^)(TTBaseRequest *))failure {
    self.requestSuccessHandler = success;
    self.requestFailureHandler = failure;
}

- (void)setCompletionProgress:(void (^)(NSProgress * _Nonnull))completionProgress {
    _completionProgress = completionProgress;
}

- (void)setConstructionBodyBlock:(void (^)(id<AFMultipartFormData> _Nonnull))constructionBodyBlock {
    _constructionBodyBlock = constructionBodyBlock;
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(TTBaseRequest * _Nonnull))success failure:(void (^)(TTBaseRequest * _Nonnull))failure {
    self.requestSuccessHandler = success;
    self.requestFailureHandler = failure;
    [self start];
}

- (void)startWithConstructionBodyBlock:(void (^)(id<AFMultipartFormData> _Nonnull))constructionBodyBlock success:(void (^)(TTBaseRequest * _Nonnull))success failure:(void (^)(TTBaseRequest * _Nonnull))failure {
    self.constructionBodyBlock = constructionBodyBlock;
    self.requestSuccessHandler = success;
    self.requestFailureHandler = failure;
    [self start];
}

- (void)clearComplition {
    self.requestSuccessHandler = nil;
    self.requestFailureHandler = nil;
    didReceiveUnintCount = 0;
}



- (void)requestCompliteSuccess {
    
}

- (void)requestCompliteFailure {
    
}

/**
 *  At AFNetworking 2.x,  to get the Progress need to use observe NSProgress 's `fractionCompleted`
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        if (self.resumeDownloadPath) {
            progress.kind = NSProgressKindFile;
            [progress setUserInfoObject:NSProgressFileOperationKindDownloading forKey:NSProgressFileOperationKindKey];
            int64_t speed = progress.completedUnitCount - didReceiveUnintCount;
            [progress setUserInfoObject:@(speed) forKey:NSProgressThroughputKey];
            didReceiveUnintCount = progress.completedUnitCount;
        }
        if (self.completionProgress) {
            self.completionProgress(progress);
        }
        self.progress = progress;
    }
}

- (void)dealloc {
    if (self.progress) {
        [self.progress removeObserver:self forKeyPath:@"fractionCompleted"];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[<%@: %p> ,URL: %@]",NSStringFromClass([self class]),self,[self requestUrl]];
}

@end
