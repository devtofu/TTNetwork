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
 Creates an `TTBaseRequest` with the specified request.
 
 @param request The request object to be loaded asynchronously during execution of the task.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the created request operation and the object created from the response data of request.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request task and the `NSError` object describing the network or parsing error that occurred.
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
