//
//  TTBaseRequest.h
//  TTDemo
//
//  Created by tofu on 15/12/15.
//  Copyright © 2015年 iOS Tofu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTNetworkResponse.h"
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , TTRequestMethod) {
    TTRequestMethodGet = 0,
    TTRequestMethodPost,
    TTRequestMethodHead,
    TTRequestMethodPut,
    TTRequestMethodDelete,
    TTRequestMethodPatch
};

/**
 *  request serializer type
 */
typedef NS_ENUM(NSInteger , TTRequestSerializer) {
    /**
     *  content-type: application/x-www-form-urlencoded not json type
     */
    TTHTTPRequestSerializer = 0,
    /**
     *  content-type: application/json
     */
    TTJSONRequestSerializer,
};

/**
 *  response serializer type
 */
typedef NS_ENUM(NSInteger, TTResponseSerializer) {
    /**
     *  Get the origin data from server
     */
    TTHTTPResponseSerializer = 0,
    /**
     *  JSON from server
     */
    TTJSONResponseSerializer
};

@interface TTBaseRequest : NSObject

//--------------------------------------\\
// response data
//--------------------------------------//

@property (nonatomic, strong, readonly) TTNetworkResponse *response;
@property (nonatomic, strong, readonly) id    responseObject;
@property (nonatomic, strong, readonly) NSString     *message;
@property (nonatomic, strong, readonly) NSError      *error;
@property (nonatomic, copy, nullable)  void(^requestSuccessHandler)(TTBaseRequest *);
@property (nonatomic, copy, nullable)  void(^requestFailureHandler)(TTBaseRequest *);


//--------------------------------------\\
// custom properties
//--------------------------------------//

// default is NO
@property (nonatomic, assign, readonly) BOOL useCookies;

@property (assign, nonatomic) BOOL needHeadKid;
/**
  By default, this is set to an enum of `TTHTTPRequestSerializer`.
 */
@property (nonatomic, assign) TTRequestSerializer requestSerializer;
/**
  By default, this property is set to an enum of `TTJSONResponseSerializer`.
 */
@property (nonatomic, assign) TTResponseSerializer responseSerializer;

/**
 By default, this property is set to an enum of `TTRequestMethodGet`
 */
@property (nonatomic, assign) TTRequestMethod requestMethod;

/**
 POST upload request such as file
 
 By default, the property is set to nil.
 */
@property (nonatomic, copy, nullable) void(^constructionBodyBlock)(id<AFMultipartFormData> formData);
/**
 Upload or download progress callback
 
 By default, the property is set to nil.
 */
@property (nonatomic, copy, nullable) void(^completionProgress)(NSProgress *progress);

/**
 Start request, The method must be called after `setCompletionBlockWithSuccess:failure`
 */
- (void)start;
/**
 Stop the request.
 */
- (void)stop;

/**
 To suspend a running request. 
 
 When the task is to upload, download, the method is effective.
 */
- (void)suspend;
/**
 To resume a suspended request.
 
 When the task state is `NSURLSessionTaskStateSuspended`, the method is effective.
 */
- (void)resume;


/**
 Upload or download progress callback
 */
- (void)setCompletionProgress:(nullable void(^)(NSProgress *progress))completionProgress;


/**
 Creates and runs an `TTReuqest`.
 
 @param success A block object to be executed when the request task finishes successfully. This block has no return value and takes two arguments: the request task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request task finishes successfully. This block has no return value and takes two arguments: the request task, and the response object created by the client response serializer.
 @see `TTNetworkManager` instance method -startRequest::success:failure:
 */
- (void)startWithCompletionBlockWithSuccess:(nullable void (^)(TTBaseRequest *request))success
                                    failure:(nullable void (^)(TTBaseRequest *request))failure;
/**
 Creates and runs an `TTReuqest` with a multipart `POST` request.
 
 @param block A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `AFMultipartFormData` protocol.
 @param success A block object to be executed when the request task finishes successfully. This block has no return value and takes two arguments: the request task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request task and the error describing the network or parsing error that occurred.
 
 @see `TTNetworkManager` instance method -startRequest::success:failure:
 */
- (void)startWithConstructionBodyBlock:(nullable void(^)(id<AFMultipartFormData> formData))constructionBodyBlock
                               success:(nullable void (^)(TTBaseRequest *request))success
                               failure:(nullable void (^)(TTBaseRequest *request))failure;

/**
 Break retain cycle, so you can use self in block.
 
 e.g. 
     [request setCompletionBlockWithSuccess:^(TTBaseRequest * _Nonnull request) {
         [self method];
      } failure:^(TTBaseRequest * _Nonnull request) {
         [self method];
     }];
 */
- (void)clearComplition;


//--------------------------------------\\
// base methods
//--------------------------------------//


- (nullable NSString *)baseUrl;

/**
 The Request URL
 
 @return request URL string
 */
- (nullable NSString *)requestUrl;

/**
 Request Argments
 
 By default, the property is set to nil, Subclasses need to override this method.
 
 @return argments
 */
- (id)requestParemeters;

/**
 Set request timeout interval
 
 @return The timeout
 */
- (NSTimeInterval)requestTimeoutInterval;

/**
 Set request headers

 @return headers
 */
- (nullable NSDictionary *)requestHeaderFieldValueDictionary;

/**
 Local storage file path . By default , the method return nil.
 
 This method is used only when you download the file.
 
 @return Local storage file path
 */
- (nullable NSString *)resumeDownloadPath;


@end

NS_ASSUME_NONNULL_END