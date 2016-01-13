//
//  TTDownloadRequest.h
//  TTDemo
//
//  Created by tofu on 12/27/15.
//  Copyright © 2015 iOS Tofu. All rights reserved.
//

#import "TTBaseRequest.h"

/**
 下载请求类
 
 每个下载请求都是独立的，把不重要的参数用工厂方法封装起来。
 */
@interface TTDownloadRequest : TTBaseRequest

- (instancetype)initWithURL:(NSString *)urlString;

@end
