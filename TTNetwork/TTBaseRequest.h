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
 Set request callback
 
 @param success success callback
 @param failure failure callback
 */
- (void)setCompletionBlockWithSuccess:(nullable void (^)(TTBaseRequest *request))success
                              failure:(nullable void (^)(TTBaseRequest *request))failure;
/**
 Upload or download progress callback
 */
- (void)setCompletionProgress:(nullable void(^)(NSProgress *progress))completionProgress;

/**
 POST upload request such as images
 */
- (void)setConstructionBodyBlock:(nullable void(^)(id<AFMultipartFormData> formData))constructionBodyBlock;

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

/**
 unuse
 */
- (void)requestCompliteSuccess __deprecated_msg("unuse in TTNetwork 2.x");
- (void)requestCompliteFailure __deprecated_msg("unuse in TTNetwork 2.x");

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
- (id)requestArgument;

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