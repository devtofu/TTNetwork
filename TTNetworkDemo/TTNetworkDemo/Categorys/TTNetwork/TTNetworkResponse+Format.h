//
//  TTNetworkResponse+Format.h
//  TTNetworkDemo
//
//  Created by tofu on 1/11/16.
//  Copyright © 2016 iOS Tofu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TTNetworkResponse.h"
#import "TTErrors.h"

FOUNDATION_EXTERN NSString *const kResultKey;
FOUNDATION_EXTERN NSString *const kSuccessKey;
FOUNDATION_EXTERN NSString *const kMessageKey;
FOUNDATION_EXTERN NSString *const kResponseCodeKey;
FOUNDATION_EXTERN NSString *const kResponseDataKey;

/**
 *  自定义解析返回的数据，保证传出的数据直接可以使用
 */
@interface TTNetworkResponse (Format)

@end
