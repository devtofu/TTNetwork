//
//  TTNetworkManager.h
//  TJDemo
//
//  Created by tofu on 15/1/13.
//  Copyright (c) 2015年 tofu jelly. All rights reserved.
//
//
//  TTNetwork is a AFNetworking 2.x based on the package again, fully show the characteristics of high cohesion and low coupling
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const TT_HTTP_COOKIE_KEY;

@class TTBaseRequest;

typedef NS_ENUM(NSInteger, TTRequestReachabilityStatus) {
    TTRequestReachabilityStatusUnknow = AFNetworkReachabilityStatusUnknown,
    TTRequestReachabilityStatusNotReachable = AFNetworkReachabilityStatusNotReachable,
    TTRequestReachabilityStatusViaWWAN = AFNetworkReachabilityStatusReachableViaWWAN,
    TTRequestReachabilityStatusViaWiFi = AFNetworkReachabilityStatusReachableViaWiFi
};

/*!
 @brief TTNetwork 2.0
 */
@interface TTNetworkManager : NSObject

+ (instancetype)sharedManager;


@property (nonatomic, assign, readonly) TTRequestReachabilityStatus reachabilityStatus;

/**
 *  The session manager
 */
@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;

/**
 Creates a `TTBaseRequest` with the specified request.
 
 @param request TTBaseRequest 's subclass
 @param success success callback
 @param failure failure callback
 
 @return The current request
*/
- (TTBaseRequest *)startRequest:(nonnull TTBaseRequest *)request
                        success:(nullable void(^) (TTBaseRequest *request))success
                        failure:(nullable void(^) (TTBaseRequest *request))failure;

/**
 Creates a `TTBaseRequest` with the specified request.
 
 When uploading files, you need to call `TTBaseRequest` of `setConstructionBodyBlock:` multi-part data.
 When download a file , you need to set the cache path `TTBaseRequest` file , as detailed in ` resumeDownloadPath` function .
 
 @param request The HTTP/HTTPS request for the TTBaseRequest.
 @param success A block to be executed when a task finishes with success.
 @param failure A block to be executed when a task finishes with failure
 @param progress A progress object monitoring the current download/upload progress.

*/
- (TTBaseRequest *)startRequest:(nonnull TTBaseRequest *)request
                        success:(nullable void (^)(TTBaseRequest *))success
                        failure:(nullable void (^)(TTBaseRequest *))failure
                       progress:(nullable void(^)(NSProgress *progress))progress;

- (void)cancelRequest:(nonnull TTBaseRequest *)request;
- (void)cancelAllRequests;

/**
 Calling In application:didFinishLaunchingWithOptions , start listening to the network
 */
- (void)startMonitoringNetwork;

@end



NS_ASSUME_NONNULL_END
