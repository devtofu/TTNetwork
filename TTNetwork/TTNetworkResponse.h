//
//  TTNetworkResponse.h
//  TTDemo
//
//  Created by tofu on 12/24/15.
//  Copyright © 2015 iOS Tofu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface TTNetworkResponse : NSObject

//-----------------------------------------------\\
//                 Initialize
//-----------------------------------------------//
+ (instancetype)response;
//-----------------------------------------------\\
//                 response data
//-----------------------------------------------//
@property (nonnull, nonatomic, strong ) id       task;
@property (nullable, nonatomic, strong) id       responseObject;
@property (nullable, nonatomic, copy  ) NSString *message;
@property (nullable, nonatomic, copy  ) NSError  *error;


@end
NS_ASSUME_NONNULL_END
