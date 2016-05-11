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
#ifdef DEBUG
#define TTLog(format, ...) NSLog( @"😶 %@ 🙄",[NSString stringWithFormat: format, ##__VA_ARGS__])
#else

#define TTLog(format, ...)

#endif

#endif /* TTNetworkConst_h */
