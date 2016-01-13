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

- (id)requestArgument {
    return nil;
}

- (TTRequestMethod)requestMethod {
    return TTRequestMethodGet;
}


- (NSTimeInterval)requestTimeoutInterval {
    return 20;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
//    return @{@"client-type":@"mobile-iphone",
//             @"kidId":@"2",
//             @"userId":@"1",
//             @"authToken":@"0mS2Oh2Vv1fgkwvo6lyF7gnNucrbQP/aB3cOw43Z6PVVmI1zH8FNCaJo/bEHtooNmFVLwsEFwfNXucq21I5b6Q=="};
    return nil;
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
    [[TTNetworkManager sharedManager] startRequest:self
                                           success:self.requestSuccessHandler
                                           failure:self.requestFailureHandler];
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
    }
}


- (NSString *)description {
    return [NSString stringWithFormat:@"[<%@: %p> ,URL: %@]",NSStringFromClass([self class]),self,[self requestUrl]];
}

@end
