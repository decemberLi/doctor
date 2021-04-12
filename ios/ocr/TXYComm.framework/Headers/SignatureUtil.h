//
//  SigtrueUtil.h
//  sigtrue
//
//  Created by v_clvchen on 2020/3/24.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

NS_ASSUME_NONNULL_BEGIN
/**
 签名工具
 */
@interface SignatureUtil : NSObject

/**
 * 腾讯云签名
 *
 * @param signParamDict 签名参数
 * @return headers 请求头
 */
+ (NSDictionary *) signWithSignParamDict:(NSDictionary *)signParamDict;
@end

NS_ASSUME_NONNULL_END
