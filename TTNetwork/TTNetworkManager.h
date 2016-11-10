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
@protocol TTNetworkResponseProtocol;

typedef NS_ENUM(NSInteger, TTRequestReachabilityStatus) {
    TTRequestReachabilityStatusUnknow = AFNetworkReachabilityStatusUnknown,
    TTRequestReachabilityStatusNotReachable = AFNetworkReachabilityStatusNotReachable,
    TTRequestReachabilityStatusViaWWAN = AFNetworkReachabilityStatusReachableViaWWAN,
    TTRequestReachabilityStatusViaWiFi = AFNetworkReachabilityStatusReachableViaWiFi
};

/*!
 @brief TTNetwork 0.2
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
*/
- (TTBaseRequest *)startRequest:(nonnull TTBaseRequest *)request;
- (void)cancelRequest:(nonnull TTBaseRequest *)request;
- (void)cancelAllRequests;

/**
 Calling In application:didFinishLaunchingWithOptions , start listening to the network
 */
- (void)startMonitoringNetwork;

@end



@interface TTNetworkUtil : NSObject

+ (BOOL)checkJson:(id)json withValidator:(id)validatorJson;

/**
 Construction of URL
 */
+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString
                          appendParameters:(NSDictionary *)parameters;


@end


FOUNDATION_EXTERN NSString *const TTErrorDomain;
FOUNDATION_EXTERN NSString *const TTCocoaErrorDomain;

NS_ASSUME_NONNULL_END
