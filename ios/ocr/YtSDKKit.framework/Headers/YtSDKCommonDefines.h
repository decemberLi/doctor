//
//  YtSDKCommonDefines.h
//  yt-ios-face-recognition-demo
//
//  Created by Marx Wang on 2019/9/11.
//  Copyright © 2019 Tencent.Youtu. All rights reserved.
//

#ifndef YT_SDKKIT_COMMON_DEFINES_H
#define YT_SDKKIT_COMMON_DEFINES_H

#define YT_SDK_EXPORT __attribute__((visibility("default")))

/// YtSDKKit日志等级
typedef NS_ENUM(NSInteger, YtSDKLogLevelType)
{
    YT_SDK_ERROR = 0,
    YT_SDK_WARN,
    YT_SDK_INFO,
    YT_SDK_DEBUG
};
/// YtSDKKit工作模式
typedef NS_ENUM(NSInteger, YtSDKKitMode)
{
    /// OCR识别模式（包含身份证和银行卡）
    YT_SDK_OCR_MODE = 0,
    /// 静默核身模式
    YT_SDK_SILENT_MODE,
    /// 动作核身模式
    YT_SDK_ACTION_MODE,
    /// 反光核身模式
    YT_SDK_REFLECT_MODE,
    /// 动作反光核身模式
    YT_SDK_ACTREFLECT_MODE,
    /// 其他模式（暂不使用）
    YT_SDK_CUSTOM_MODE,
};
/// YtSDKKit框架底层事件类型
typedef NS_ENUM(NSInteger, YtFrameworkEventType)
{
    /// UI事件类型
    YT_SDK_UI_FEVENT_TYPE,
    /// 状态事件类型
    YT_SDK_STATE_FEVENT_TYPE,
    /// @deprecated 相机事件类型（暂不使用）
    YT_SDK_CAMERA_FEVENT_TYPE,
};
/// 网络回包回调接口
/// @param result 如果没有任何异常，则将回包信息放入result数据结构中
/// @param error 如果有异常，则传入异常结果
typedef void (^OnYtNetworkResponseBlock)(NSDictionary *result, NSError *error);
/// 网络请求回调接口
/// 该接口需要实现网络请求功能
/// @param url 请求url地址
/// @param request 请求body内容
/// @param headers 请求headers内容
/// @param response 回包回调接口
typedef void (^OnYtNetworkRequestBlock)(NSString *url, NSString *request, NSDictionary *headers, OnYtNetworkResponseBlock response);
/// SDKKit框架底层事件回调接口
/// 用于处理底层抛上来的事件信息
/// @param eventType 事件类型
/// @param eventDict 事件内容
typedef void (^OnYtFrameworkEventBlock)(YtFrameworkEventType eventType, NSDictionary *eventDict);

typedef void (^OnYtFrameworkEvenBestFrameBlock)(NSString *bestFrameImage);

typedef void (^OnFrameworkEvenTimeOutBlock)(void);

//#define YtSDKLogLevelUserDefaultsDomain @"com.tencent.youtusdk.userdefaults.showlog.level"

#define YTSDK_ERROR_DOMAIN @"com.tencent.youtusdk.error"
#define USER_CANCEL_ORC @"OcrSdk.UserCancelOcr"
/// YtSDKKIt错误类型
typedef NS_ENUM(NSInteger,TXYSDKitError) {
    // 授权失败
    TXY_SDK_AUTH_FAILED_CODE                  = 100000,
    // 识别失败
    TXY_SDK_RECOGNIZE_FAILED_CODE             = 101000,
    // 参数异常
    TXY_SDK_PARAMETER_ERROR_CODE              = 100100,
    // 内部鉴权异常
    TXY_SDK_AUTH_ERROR_CODE                   = 100101,
    // 网络异常
    TXY_SDK_NETWORK_ERROR_CODE                = 100102,
    // 摄像头权限异常
    TXY_SDK_CAMEREA_PERMISSION_ERROR_CODE     = 100103,
    // 用户手动取消
    TXY_SDK_USER_CANCEL_CODE                  = 200101,
    // 识别失败-初始化异常
    TXY_SDK_VERIFY_MODEL_INIT_FAIL            = 300101,
    // 识别失败-服务解析异常
    TXY_SDK_VERIFY_SERVER_FAIL                = 300102,
    // 识别失败-分数过低
    TXY_SDK_VERIFY_SCORE_TOO_LOW              = 300103,
    // 识别失败-超时
    TXY_SDK_VERIFY_TIMEOUT                    = 300104,
    // 识别失败-人脸问题
    TXY_SDK_VERIFY_FACE_ERROR                 = 300105,
};

//#define YtSDKAuthFailed @"yt_auth_failed"
//#define YtSDKRecognizeFailed @"yt_verify_failed"
//#define YtSDKParameterError @"yt_param_error"
//#define YtSDKNetworkError @"yt_network_error"
//#define YtSDKCameraPermissionError @"yt_camera_permission_error"
//#define YtSDKUserCancel @"yt_user_cancel"

#define TXYSDK_PARAMETER_ERROR @"txy_param_error"
#define YTSDK_USER_CANCEL @"yt_user_cancel"


// Event defines
#define YTSDK_EVENT_TIPS_TYPE @"com.tencent.youtusdk.tips"
#define YTSDK_EVENT_ACTION_TYPE @"com.tencent.youtusdk.action"
//#define YtSDKEventErrorType @"com.tencent.youtusdk.error"
#define YTSDK_EVENT_USER_INFO_TYPE @"com.tencent.youtusdk.userinfo"
//#define YtSDKEventResultInfoType @"com.tencent.youtusdk.resultinfo"
//#define YtSDKEventCmpInfoType @"com.tencent.youtusdk.cmpinfo"
//#define YtSDKEventCmpScoreType @"com.tencent.youtusdk.cmpscore"
//#define YtSDKEventPipelineSucceedFinished @"com.tencent.youtusdk.pipeline_succeedfinished"
#define YTSDK_EVENT_PIPELINE_FAILED_FINISHED @"com.tencent.youtusdk.pipeline_failedfinished"
#define YTSDK_EVENT_PIPELINE_FAILED_ERROR_CODE @"com.tencent.youtusdk.pipeline_failederrorcode"


// Tips event value defines
// Basic
#define YTSDK_TIP_VALUE_RECOGIZE_SUCCEED @"yt_verify_succeed"
//#define YtSDKTipValueWait @"yt_net_wait"

#define YTSDK_TIP_VALUE_ADVISE_CLOSER @"yt_face_closer"
#define YTSDK_TIP_VALUE_ADVISE_FARER @"yt_face_farer"

// Ocr predetect
#define YTSDK_TIP_VALUE_OCR_AUTO_DETECT_TIMEOUT @"yt_ocr_auto_timeout"
#define YTSDK_TIP_VALUE_OCR_MANUAL_DETECT_STARTING @"yt_ocr_manual_on"
#define YTSDK_TIP_VALUE_OCR_MANUAL_DETECT_FINFSHED @"yt_ocr_manual_succeed"
#define YTSDK_TIP_VALUE_CARD_IN_RECT @"yt_ocr_keep_card"
#define YTSDK_TIP_VALUE_CARD_NOT_DETECT @"yt_ocr_no_card"
#define YTSDK_TIP_VALUE_CAMERA_REFOCUS @"yt_cam_refocus"

// Action event value defines
#define YTSDK_ACT_VALUE_RECPASS @"com.tencent.youtusdk.rec_pass"
#define YTSDK_ACT_VALUE_REC_NOTPASS @"com.tencent.youtusdk.rec_notpass"
#define YTSDK_ACT_VALUE_NOT_DETECT @"com.tencent.youtusdk.not_detect"
#define YTSDK_ACT_VALUE_TOO_BLUR @"com.tencent.youtusdk.too_blur"
//#define YtSDKActValueWaitNetworkResult @"com.tencent.youtusdk.wait_network_result"
#define YTSDK_ACT_VALUE_COUNTDOWN_BEGIN @"com.tencent.youtusdk.countdown_begin"
#define YTSDK_ACT_VALUE_COUNTDOWN_CANCEL @"com.tencent.youtusdk.countdown_cancel"
//#define YtSDKActValueUIBrightnessUpdated @"com.tencent.youtusdk.ui_bright_updated"
//#define YtSDKActValueUIBackgroundUpdated @"com.tencent.youtusdk.ui_bgcolor_updated"
#define YTSDK_ACT_VALUE_STATRT_OCR_MANUAL_DETECT_MODE @"com.tencent.youtusdk.on_ocr_manual_detect_mode"

#define YTSDK_ACT_VALUE_MANUAL_SUCCEED @"com.tencent.youtusdk.manual_succeed"
#endif // YT_SDKKIT_COMMON_DEFINES_H
