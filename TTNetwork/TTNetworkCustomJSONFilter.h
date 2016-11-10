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

@interface TTNetworkCustomJSONFilter : NSObject<TTNetworkResponseProtocol>


@end

FOUNDATION_EXTERN NSString *const TT_HTTP_COOKIE_KEY;

FOUNDATION_EXTERN NSString *const kResultKey;
FOUNDATION_EXTERN NSString *const kSuccessKey;
FOUNDATION_EXTERN NSString *const kMessageKey;
FOUNDATION_EXTERN NSString *const kResponseCodeKey;
FOUNDATION_EXTERN NSString *const kResponseDataKey;

NS_ASSUME_NONNULL_END


