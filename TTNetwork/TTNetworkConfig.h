//
//  TTNetworkConfig.h
//  TTDemo
//
//  Created by tofu on 15/12/15.
//  Copyright © 2015年 iOS Tofu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TTNetworkResponseProtocol;


@interface TTNetworkConfig : NSObject

+ (instancetype)sharedInstance;

/**
 *  The Reuqest BaseURL
 *
 *  This property is used to configure the BaseUrl of the API , eg. http://api.ttnetwork.com
 */
@property (nonatomic, strong, nullable) NSString *baseUrl;

/**
 *  If you use SSL/TLS 1.2 ,need configure the securityPolicy
 *
 *  @return AFSecurityPolicy
 */

@property (nonatomic, strong, nullable) AFSecurityPolicy *securityPolicy;

/*
- (NSDictionary *)responseJSONStruct;
 */

/**
 *  Custom json filter
 *
 *  @return An overried `TTNetworkResponseProtocol` 's object
 */
@property (nonatomic, strong, nullable) id<TTNetworkResponseProtocol> configureForJSONFilter;

@end

NS_ASSUME_NONNULL_END
