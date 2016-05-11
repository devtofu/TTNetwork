//
//  TTNetworkConfig.m
//  TTDemo
//
//  Created by tofu on 15/12/15.
//  Copyright © 2015年 iOS Tofu. All rights reserved.
//

#import "TTNetworkConfig.h"

@implementation TTNetworkConfig

+ (instancetype)sharedInstance {
    static TTNetworkConfig *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//- (NSString *)baseUrl {
//    return @"http://www.baidu.com";
//}

/*
- (NSDictionary *)responseJSONStruct {
    return @{@"result":@{@"success":[NSNumber class],
                          @"kResponseCodeKey":[NSNumber class],
                          @"msg":[NSString class],
                          @"data":[NSDictionary class]}};
}
*/

- (AFSecurityPolicy *)securityPolicy {
    /*
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

    securityPolicy.allowInvalidCertificates = YES;
    
    return securityPolicy;
     */
    return nil;
}

@end
