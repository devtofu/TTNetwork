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


NS_ASSUME_NONNULL_END


