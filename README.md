# TTNetwork v0.2
TTNetwork 是基于 AFNetworking 3.0 的二次封装。


## Installation

- download all the files and copy into your project

## Usage

#### Security Policy

```objective-c
#import TTNetworkConfig.h

- (AFSecurityPolicy *)securityPolicy {
    /*
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

    securityPolicy.allowInvalidCertificates = YES;
    
    return securityPolicy;
     */
    return nil;
}

```

#### Custom Requests based TTBaseRequest

```objective-c
#import "TTBaseRequest.h"

@interface TTUploadRequest : TTBaseRequest

@end
```

#### Subclass needs to implement

- requestMethod;
	- TTRequestMethodGet  **(by default)**
    - TTRequestMethodPost
    - TTRequestMethodHead
    - TTRequestMethodPut
    - TTRequestMethodDelete
    - TTRequestMethodPatch
- requestSerializer
	- TTJSONRequestSerializer
	- TTHTTPRequestSerializer   **(by default)**
- responseSerializer
	- TTJSONRequestSerializer   **(by default)**
	- TTHTTPRequestSerializer 
- requestUrl
- requestParemeters

#### Custom response json parser
Generally, API design will adopt a unified data structure, such as:

```objective-c
// 登录
{
	status : 0,
	message : "账号或密码不正确",
	responseData : []
}
// 注册
{
	status : 1,
	message : "注册成功",
	responseData : {
		id : 1,
		username : xxxxx ,
		passowrd : xxxx
	}
}
```

If the resolution **status**  with each request to determine whether the API success becomes more cumbersome.

So, add a custom json parser, e.g:

```objective-c 

#import "TTNetworkResponseProtocol.h"

@interface TTNetworkPrivate : NSObject<TTNetworkResponseProtocol>

@end

@implementation TTNetworkPrivate

// custom parser for responseObject

- (id)prettyPrintedForJSONObject:(id)responseObject request:(nonnull TTBaseRequest *)request { 
	if (!responseObject) {
        request.response.responseObject = nil;
        return nil;
    }
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
    	BOOL sucess = [responseObject[@"status"] boolValue];
    	if (sucess) {
    		id result =  responseObject[@"responseData"];
    		request.response.responseObject = result;
    		request.response.message = responseObject[@"message"];
    		return result;
    	} else {
    		NSError *error = ...
    		request.response.error = error;
    		request.response.message = responseObject[@"message"];
    		return nil;
    	}
    }
    
    return responseObject;
}

// custom parser for error 

- (NSError *)prettyPrintedForError:(NSError *)error request:(TTBaseRequest *)request {
    
    if (!error) {
        return nil;
    }
    
    // custom error parser
    NSError *prettyPrintedError = ....
    return prettyPrintedError;
}

@end


// implement TTNetworkConfig's `configureForJSONParser` method

@implementation TTNetworkConfig

- (id<TTNetworkResponseProtocol>)configureForJSONParser {
    return [[TTNetworkPrivate alloc] init];
}

@end

```

For more details, please see Demo.

####  Creating an Upload Task for a Multi-Part Request, with Progress

```objective-c 

    TTUploadRequest *uploadRequest = [[TTUploadRequest alloc] init];
    [uploadRequest startWithConstructionBodyBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    	[formData appendPartWithFileData:[NSData data] name:@"avatarFile" fileName:@"avatar.jpg" mimeType:@"image/png"]; 
    } success:^(TTBaseRequest * _Nonnull request) { 
    	TTLog("成功");  
    } failure:^(TTBaseRequest * _Nonnull request) { 
    	TTLog("失败");   
    }];
    // 上传进度 
    [uploadRequest setCompletionProgress:^(NSProgress * _Nonnull progress) {
        TTLog(@"进度：%@",progress.localizedAdditionalDescription);
    }];

```

For more details, please see Demo.

#### Creating a Download Task

```objective-c
TTDownloadRequest *downloadRequest = [[TTDownloadRequest alloc] initWithURL:@"http://res.61read.com/resources/3/2014023/de810b9a165351cb0cebd44b9e4bcd47.mp3"];
    
    [downloadRequest startWithCompletionBlockWithSuccess:^(TTBaseRequest * _Nonnull request) {
         TTLog(@"request.success :%@, message: %@",request, request.message);
    } failure:^(TTBaseRequest * _Nonnull request) {
        TTLog(@"request.error :%@",request.error);
    }];
    
    [downloadRequest setCompletionProgress:^(NSProgress * _Nonnull progress) {
        // 默认下载进度描述
        TTLog(@"%@ , %@",progress.localizedAdditionalDescription,progress.localizedDescription);
        
        // 下载速度
        //        NSLog(@"下载速度 ：%.f kb/s",ceil([progress.userInfo[NSProgressThroughputKey] integerValue] / 1000));
    }];
```

For more details, please see Demo.

#### Creating a Data Task

```objective-c
TTLoginRequest *loginRequest = [[TTLoginRequest alloc] initWithUserName:@"tofu" password:@"tofu123"];
    [loginRequest startWithCompletionBlockWithSuccess:^(TTBaseRequest * _Nonnull request) {
        TTLog(@"成功 :%@",request.responseObject);
    } failure:^(TTBaseRequest * _Nonnull request) {
        TTLog(@"失败 :%@",request.error);
    }];
```


For more details, please see **TTBaseRequest.h**.

## Thanks 


思路和代码借鉴来自于 [YTKNetwork](https://github.com/yuantiku/YTKNetwork) 。

感谢 [猿题库](https://github.com/yuantiku) 的分享，感谢 [AFNetworking](https://github.com/AFNetworking/AFNetworking) 的贡献！

## License

TTNetwork is released under the MIT license. See LICENSE for details.
