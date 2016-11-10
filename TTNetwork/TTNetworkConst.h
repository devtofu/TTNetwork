//
//  TTNetworkConst.h
//  TTNetworkDemo
//
//  Created by tofu on 5/11/16.
//  Copyright © 2016 iOS Tofu. All rights reserved.
//

#ifndef TTNetworkConst_h
#define TTNetworkConst_h

#import <Foundation/Foundation.h>

#pragma mark - Deprecated
#define TTNetworkDeprecated(instead) __deprecated_msg(instead)

#pragma mark - TTLog

#if DEBUG
#define TTLog(format, ...) do {                                             \
                                fprintf(stderr, "<%s : line(%d)> %s\n",     \
                                [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
                                    __LINE__, __func__);                        \
                                    printf("%s\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);           \
                                    fprintf(stderr, "-------------------\n");   \
                            } while (0)
#else
#define TTLog(format, ...) nil
#endif

#endif /* TTNetworkConst_h */
