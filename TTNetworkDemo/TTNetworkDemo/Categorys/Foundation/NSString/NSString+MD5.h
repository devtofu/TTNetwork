//
//  NSString+MD5.h
//  QiHaoBox
//
//  Created by xiaojie on 15/12/17.
//  Copyright © 2015年 QiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

- (NSString *)md5Encrypt;

@end
