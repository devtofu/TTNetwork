//
//  TTNetworkPrivate.h
//  TTDemo
//
//  Created by tofu on 12/26/15.
//  Copyright © 2015 iOS Tofu. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define TTLog(format, ...) NSLog( @"😶 %@ 🙄",[NSString stringWithFormat: format, ##__VA_ARGS__])
#else

#define TTLog(format, ...)

#endif


@interface TTNetworkPrivate : NSObject

/**
  Construction of URL
 */
+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString
                          appendParameters:(NSDictionary *)parameters;

@end
