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
#import "TTLoginRequest.h"
#import "TTNetworkConst.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

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

- (void)loginRequest {
    TTLoginRequest *loginRequest = [[TTLoginRequest alloc] initWithUserName:@"tofu" password:@"tofu123"];
    [loginRequest startWithCompletionBlockWithSuccess:^(TTBaseRequest * _Nonnull request) {
        NSLog(@"成功 :%@",request.responseObject);
    } failure:^(TTBaseRequest * _Nonnull request) {
        NSLog(@"失败 :%@",request.error);
    }];
}

- (void)uploadRequest {
    // 上传
    TTUploadRequest *uploadRequest = [[TTUploadRequest alloc] init];
    
    [uploadRequest startWithConstructionBodyBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:[NSData data] name:@"avatarFile" fileName:@"avatar.jpg" mimeType:@"image/png"];
    } success:^(TTBaseRequest * _Nonnull request) {
        NSLog(@"成功 :%@",request.responseObject);
    } failure:^(TTBaseRequest * _Nonnull request) {
        NSLog(@"失败 :%@",request.error);
    }];

    [uploadRequest setCompletionProgress:^(NSProgress * _Nonnull progress) {
        // 默认上传进度描述
        NSLog(@"上传进度：%@ , %@",progress.localizedAdditionalDescription,progress.localizedDescription);
    }];
}

- (void)downloadRequest {
    // 下载
    TTDownloadRequest *downloadRequest = [[TTDownloadRequest alloc] initWithURL:@"http://cdn.exp.qq.com/img/install/QQforMac_5.0_beta.dmg"];
    
    
    
    [downloadRequest startWithCompletionBlockWithSuccess:^(TTBaseRequest * _Nonnull request) {
         NSLog(@"request.success :%@, message: %@",request, request.message);
    } failure:^(TTBaseRequest * _Nonnull request) {
        NSLog(@"request.error :%@",request.error);
    }];
    
    [downloadRequest setCompletionProgress:^(NSProgress * _Nonnull progress) {
        // 默认下载进度描述
        NSLog(@"下载进度：%@ , %@",progress.localizedAdditionalDescription,progress.localizedDescription);
        
        // 下载速度
        //        NSLog(@"下载速度 ：%.f kb/s",ceil([progress.userInfo[NSProgressThroughputKey] integerValue] / 1000));
        
        
        
        //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [downloadRequest suspend];
        //        NSLog(@"暂停下载");
        //
        //    });
        //
        //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [downloadRequest resume];
        //        NSLog(@"恢复下载");
        //    });

    }];
    
}




@end
