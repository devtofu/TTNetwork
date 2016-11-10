//
//  TTDownloadRequest.m
//  TTDemo
//
//  Created by tofu on 12/27/15.
//  Copyright © 2015 iOS Tofu. All rights reserved.
//

#import "TTDownloadRequest.h"
#import "NSString+MD5.h"

@interface TTDownloadRequest () {
    NSString *_urlString;
    NSString *fileUrl;
}

@end

@implementation TTDownloadRequest

- (instancetype)initWithURL:(NSString *)urlString {
    self = [super init];
    if (self) {
        _urlString = urlString;
    }
    return self;
}
/**
 *  必须实现。
 *
 *  @return 请求的URL地址
 */
- (NSString *)requestUrl {
    return _urlString;
}

/**
 *  实现文件存放地址
 *
 *  如果是下载，必须实现
 */
- (NSString *)resumeDownloadPath {
    
    if (fileUrl) {
        return fileUrl;
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/Library/appdata/download/",NSHomeDirectory()];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", [[self requestUrl] md5Encrypt],[[self requestUrl] pathExtension]];
    NSString *recordPath = [NSString stringWithFormat:@"%@%@", filePath,fileName];
    
    fileUrl = recordPath;
    return recordPath;
}


@end
