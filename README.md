# TTNetwork v0.2
TTNetwork 是基于 AFNetworking 3.0 的二次封装。


## Installation

- download all the files and copy into your project

## Usage

```objective-c 

e.g.

#import "TTNetwork"
// 自定义请求，继承 TTBaseRequest,
// 上传
    TTUploadRequest *uploadRequest = [[TTUploadRequest alloc] init];
    [uploadRequest startWithConstructionBodyBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    	[formData appendPartWithFileData:[NSData data] name:@"avatarFile" fileName:@"avatar.jpg" mimeType:@"image/png"]; 
    } success:^(TTBaseRequest * _Nonnull request) { 
    	NSLog("成功");  
    } failure:^(TTBaseRequest * _Nonnull request) { 
    	NSLog("失败");   
    }];
    // 上传进度 
    [uploadRequest setCompletionProgress:^(NSProgress * _Nonnull progress) {
        NSLog(@"进度：%@",progress.localizedAdditionalDescription);
    }];
```

更多用法请参照 Demo .



## Thanks 


思路和代码借鉴来自于 [YTKNetwork](https://github.com/yuantiku/YTKNetwork) 。

感谢 [猿题库](https://github.com/yuantiku) 的分享，感谢 [AFNetworking](https://github.com/AFNetworking/AFNetworking) 的贡献！

## License

TTNetwork is released under the MIT license. See LICENSE for details.
