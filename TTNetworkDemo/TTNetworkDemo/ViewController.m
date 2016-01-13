//
//  ViewController.m
//  TTNetwork
//
//  Created by tofu on 1/5/16.
//  Copyright © 2016 iOS Tofu. All rights reserved.
//

#import "ViewController.h"
#import "TTNetwork.h"
#import "TTDownloadRequest.h"
#import "TTUploadRequest.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self downloadRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Requests
- (void)uploadRequest {
    // 上传
    TTUploadRequest *uploadRequest = [[TTUploadRequest alloc] init];
    
    [uploadRequest setConstructionBodyBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:[NSData data] name:@"avatarFile" fileName:@"avatar.jpg" mimeType:@"image/png"];
    }];
    
    
    [uploadRequest setCompletionProgress:^(NSProgress * _Nonnull progress) {
        
    }];
    
    [uploadRequest setCompletionBlockWithSuccess:^(TTBaseRequest * _Nonnull request) {
        
    } failure:^(TTBaseRequest * _Nonnull request) {
        
    }];
    
    [uploadRequest start];
}

- (void)downloadRequest {
    // 下载
    TTDownloadRequest *downloadRequest = [[TTDownloadRequest alloc] initWithURL:@"http://res.61read.com/resources/3/2014023/de810b9a165351cb0cebd44b9e4bcd47.mp3"];
    __block TTDownloadRequest *blockRequest = downloadRequest;
    [downloadRequest setCompletionProgress:^(NSProgress * _Nonnull progress) {
        // 默认下载进度描述
        NSLog(@"%@ , %@",progress.localizedAdditionalDescription,progress.localizedDescription);

        // 下载速度
//        NSLog(@"下载速度 ：%.f kb/s",ceil([progress.userInfo[NSProgressThroughputKey] integerValue] / 1000));
        
    }];
    
    [downloadRequest setCompletionBlockWithSuccess:^(TTBaseRequest * _Nonnull request) {
        NSLog(@"request :%@, message: %@",request, request.message);
    } failure:^(TTBaseRequest * _Nonnull request) {
        NSLog(@"request :%@",request.error);
    }];
    
    [downloadRequest start];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [downloadRequest suspend];
        NSLog(@"暂停下载");
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [downloadRequest resume];
        NSLog(@"恢复下载");
    });
}


@end
