//
//  QHErrors.h
//  QiHaoBox
//
//  Created by tofu on 15/12/1.
//  Copyright © 2015年 QiHao. All rights reserved.
//

#ifndef TTErrors_h
#define TTErrors_h

typedef NS_ENUM(NSInteger, TTError) {
    TTErrorSystem = 40000,
    TTErrorCocoaData = 40001,
};

typedef NS_ENUM(NSInteger, TTURLResponseStatus) {
    /** Request Success,*/
    TTURLResponseStatusSuccess = 200,
    TTURLResponseStatusSystemError = 4646
};

typedef NS_ENUM(NSInteger, TTHTTPError) {
    // 4xx服务器错误
    
    /** Bad Request*/
    TTHTTPErrorBadRequest                  = 400,
    /** Unauthorized*/
    TTHTTPErrorUnauthorized                = 401,
    /** Payment Required `Prepare Code`*/
    TTHTTPErrorPaymentRequired             = 402,
    /** Forbidden `It was rejected by the server`*/
    TTHTTPErrorForbidden                   = 403,
    /** NotFound*/
    TTHTTPErrorNotFound                    = 404,
    /** Method Not Allowed `The Request Method Not Allowed 'PUT , DELETE' `*/
    TTHTTPErrorMethodNotAllowed            = 405,
    /** Not Acceptable */
    TTHTTPErrorNotAcceptable               = 406,
    /** Same with TTHTTPErrorUnauthorized*/
    TTHTTPErrorProxyAuthenticationRequired = 407,
    /** Request Timeout*/
    TTHTTPErrorRequestTimeout              = 408,
    /** Conflict, `Typically used for PUT requests`*/
    TTHTTPErrorConflict = 409,
    /** Gone, `Resources are unavailable`*/
    TTHTTPErrorGone = 410,
    /** Length Reuqired, `Content-Length invalid` */
    TTHTTPErrorLengthRequired = 411,
    /** Allowes User equipment prerequisites*/
    TTHTTPErrorPreconditionFailed = 412,
    /** Request Entity Too Large */
    TTHTTPErrorRequestEntityTooLarge = 413,
    /** Request-URL Tool Long*/
    TTHTTPErrorRequestURLTooLong = 414,
    /** Unsupported Media Type*/
    TTHTTPErrorUnsupportedMediaType = 415,
    /** Requested Range Not Satisfiable*/
    TTHTTPErrorRequestedRangeNotSatisfiable = 416,
    /** Expectation Failed*/
    TTHTTPErrorExpectationFailed = 417,
    /** a joke haha*/
    TTHTTPErrorImATeapot = 418,
    /** There are too many connections from your internet address */
    TTHTTPErrorTooManyConnections = 421,
    /** Unprocessable Entity */
    TTHTTPErrorUnprocessableEntity = 422,
    /** Locked */
    TTHTTPErrorLocked = 423,
    /** Failed Dependency*/
    TTHTTPErrorFailedDependency = 424,
    /** 在WebDav Advanced Collections草案中定义，但是未出现在《WebDAV顺序集协议》（RFC 3658）中 */
    TTHTTPErrorUnorderedCollection = 425,
    /** Upgrade Required, Clients switch to TLS / 1.0 */
    TTHTTPErrorUpgradeRequired = 426,
    /** Retry With, 由微软扩展，代表请求应当在执行完适当的操作后进行重试。*/
    TTHTTPErrorRetryWith = 427,
    
    // 5xx服务器错误
    /** Internal Server Error*/
    TTHTTPErrorInternalServerError = 500,
    /** Not Implemented, 服务器无法识别请求的方法，并且无法支持其对任何资源的请求。*/
    TTHTTPErrorNotImplemented = 501,
    /** Bad Gateway ,invalid response*/
    TTHTTPErrorBadGateway = 502,
    /** Service Unavailable, 服务器维护或者过载 */
    TTHTTPErrorServiceUnavailable = 503,
    /** Gateway Timeout, 代理服务器查询超时，某些代理服务器会返回 400或500 */
    TTHTTPErrorGatewayTimeout = 504,
    /** HTTP Version Not Supported*/
    TTHTTPErrorNotSupported = 505,
    /** Variant Also Negotiates, 代表服务器存在内部配置错误*/
    TTHTTPErrorVariantAlsoNegotiates = 506,
    /** Insufficient Storage*/
    TTHTTPErrorInsufficientStorage = 507,
    /** Bandwidth Limit Exceeded*/
    TTHTTPErrorBandwidthLimitExceeded = 509,
    /** Not Extended*/
    TTHTTPErrorNotExtended = 510
    
};

typedef NS_OPTIONS(NSInteger, TTURLError) {
    /***/
    TTURLErrorUnknow                = NSURLErrorUnknown,
    TTURLErrorCancelled             = NSURLErrorCancelled,
    /** Bad Request, 400*/
    TTURLErrorBadRequest            = NSURLErrorBadURL,
    /** Request Timeout, 408*/
    TTURLErrorTimeout               = NSURLErrorTimedOut,
    TTURLErrorUnsupportedURL        = NSURLErrorUnsupportedURL,
    TTURLErrorCannotFindHost        = NSURLErrorCannotFindHost,
    TTURLErrorCannotConnectToHost   = NSURLErrorCannotConnectToHost,
    TTURLErrorNetworkConnectinoLost = NSURLErrorNetworkConnectionLost,
    TTURLErrorResourceUnavailable   = NSURLErrorResourceUnavailable,
    TTURLErrorNoInternet            = NSURLErrorNotConnectedToInternet,
    /** This is equivalent to the “500 Server Error” message sent by HTTP servers.*/
    TTURLErrorBadServerResponse     = NSURLErrorBadServerResponse,
    /** Transport Security policy requires the use of a secure connection */
    TTURLErrorrTansportSecurityOlicyRequires NS_ENUM_AVAILABLE(10_11, 9_0) = NSURLErrorAppTransportSecurityRequiresSecureConnection,
    /** Json Test invalid, error code = 3840 */
    TTURLErrorJSONInvalid           = NSPropertyListReadCorruptError | NSPropertyListErrorMinimum,
    
};



#endif /* CYErrors_h */


