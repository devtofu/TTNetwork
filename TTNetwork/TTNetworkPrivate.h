//
//  TTNetworkPrivate.h
//  TTDemo
//
//  Created by tofu on 12/26/15.
//  Copyright © 2015 iOS Tofu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTNetworkResponseProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class TTBaseRequest;

@interface TTNetworkPrivate : NSObject<TTNetworkResponseProtocol>

/**
  Construction of URL
 */
+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString
                          appendParameters:(NSDictionary *)parameters;


@end

FOUNDATION_EXTERN NSString *const TTErrorDomain;
FOUNDATION_EXTERN NSString *const TTCocoaErrorDomain;

NS_ASSUME_NONNULL_END


