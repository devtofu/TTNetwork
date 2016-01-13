//
//  TTLoginRequest.h
//  TTDemo
//
//  Created by tofu on 12/22/15.
//  Copyright © 2015 iOS Tofu. All rights reserved.
//

#import "TTBaseRequest.h"

@interface TTLoginRequest : TTBaseRequest

- (instancetype)initWithUserName:(NSString *)userName password:(NSString *)password;

@end
