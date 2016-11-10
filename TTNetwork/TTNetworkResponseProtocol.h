//
//  TTNetworkResponseProtocol.h
//  QiHaoBox
//
//  Created by tofu on 6/16/16.
//  Copyright © 2016 QiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TTBaseRequest;
/**
 *  自定义 服务器返回的 JSON 解析
 */
@protocol TTNetworkResponseProtocol <NSObject>

@required
/**
 *  实现这个协议，再次解析 JSON 和 ERROR 之后返回
 *
 *  @param responseObject 服务器返回的未经处理的 JSONObject
 *  @param error          接口返回的错误信息
 *  @param message        提示信息
 *
 *  @return 二次解析后的 JSON
 */
- (id)filterJSONObjectWithResponse:(id)responseObject
                             error:(NSError  * _Nullable * _Nullable)error
                           message:(NSString * _Nullable * _Nullable)message;
@end

NS_ASSUME_NONNULL_END

