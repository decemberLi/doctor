//
//  QBarJsonUtil.h
//  QbarCodeRes
//
//  Created by v_clvchen on 2020/5/12.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Json conver 工具
 */
@interface TXYJsonUtil : NSObject

+ (NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
