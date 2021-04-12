//
//  TXYiphoneDescUtil.h
//  HuiYanSDK
//
//  Created by v_clvchen on 2020/10/15.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 TXYiphoneDescUtil 手机信息工具类
 */
@interface TXYiphoneDescUtil : NSObject

+ (NSString*)getCurrentDeviceModel;
+ (NSString*)getSystemVersion;
+ (NSString*)getUUID;
+ (NSString*)getBundleId;

+ (NSString *)getDeviceTerminalId;

@end

NS_ASSUME_NONNULL_END
