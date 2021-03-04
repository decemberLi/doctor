//
//  YtSDKLogger.h
//  yt-ios-verification-sdk
//
//  Created by Marx Wang on 2019/9/25.
//  Copyright © 2019 Tencent.Youtu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define YTLOG_DEBUG(format_string, ...) \
TXYLog(@"[DEBUG] - %@", [NSString stringWithFormat:format_string,##__VA_ARGS__]);
//[YtSDKLogger logDebug:[NSString stringWithFormat:format_string,##__VA_ARGS__]]

#define YTLOG_INFO(format_string, ...) \
TXYLog(@"[INFO] - %@", [NSString stringWithFormat:format_string,##__VA_ARGS__]);
//[YtSDKLogger logInfo:[NSString stringWithFormat:format_string,##__VA_ARGS__]]

#define YTLOG_WARN(format_string, ...) \
TXYLog(@"[WARN] - %@", [NSString stringWithFormat:format_string,##__VA_ARGS__]);
//[YtSDKLogger logWarnning:[NSString stringWithFormat:format_string,##__VA_ARGS__]]

#define YTLOG_ERROR(format_string, ...) \
TXYLog(@"[ERROR] - %@", [NSString stringWithFormat:format_string,##__VA_ARGS__]);
//[YtSDKLogger logError:[NSString stringWithFormat:format_string,##__VA_ARGS__]]

#define YTLOG_DEBUG_SHOW(format_string, ...) \
[YtSDKLogger logDebug:[NSString stringWithFormat:format_string,##__VA_ARGS__]]

@interface YtSDKLogger : NSObject
+ (void)logDebug:(NSString*)message;
+ (void)logInfo:(NSString*)message;
+ (void)logWarnning:(NSString*)message;
+ (void)logError:(NSString*)message;
@end

NS_ASSUME_NONNULL_END
