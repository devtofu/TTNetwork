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
#import "TTNetworkConst.h"

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
 Creates a `TTBaseRequest` with the specified request.
 
 @param request The HTTP/HTTPS request for the TTBaseRequest.

*/
- (TTBaseRequest *)startRequest:(nonnull TTBaseRequest *)request;

- (void)cancelRequest:(nonnull TTBaseRequest *)request;
- (void)cancelAllRequests;

/**
 Calling In application:didFinishLaunchingWithOptions , start listening to the network
 */
- (void)startMonitoringNetwork;

/**
 Get TTNetwork current's version
  @return current's version
 */
- (NSString *)ttNetworkVersion;

@end


NS_ASSUME_NONNULL_END
