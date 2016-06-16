//
//  TTNetworkResponseProtocol.h
//  TTDemo
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

@optional
/**
 *  Custom parser for error
 *
 *  @param error   response error
 *  @param request
 *
 *  @return
 */
- (nullable NSError *)prettyPrintedForError:(NSError * _Nonnull)error request:(nonnull TTBaseRequest *)request;
/**
 *  Custom parser for responeObject
 *
 *  @param responseObject
 *  @param request
 *
 *  @return
 */
- (nullable id)prettyPrintedForJSONObject:(id)responseObject request:(nonnull TTBaseRequest *)request;

@end

NS_ASSUME_NONNULL_END
