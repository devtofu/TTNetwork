//
//  TTLoginRequest.m
//  TTDemo
//
//  Created by tofu on 12/22/15.
//  Copyright © 2015 iOS Tofu. All rights reserved.
//

#import "TTLoginRequest.h"

@interface TTLoginRequest ()
{
    NSString *_userName;
    NSString *_password;
}

@end

@implementation TTLoginRequest


- (instancetype)initWithUserName:(NSString *)userName password:(NSString *)password {
    self = [super init];
    if (self) {
        _userName = userName;
        _password = password;
    }
    return self;
}

- (TTRequestMethod)requestMethod {
    return TTRequestMethodPost;
}

- (TTRequestSerializer)requestSerializer {
    return TTJSONRequestSerializer;
}

- (NSString *)requestUrl {
    return @"/api/login";
}

- (id)requestParemeters {
    return @{@"username":_userName,
             @"password":_password};
}

@end
