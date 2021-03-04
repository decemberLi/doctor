//
//  CameraDevice.h
//  My Cam
//
//  Created by Patrick Yang on 13-5-21.
//  Copyright (c) 2013年 Microrapid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraTypes.h"


#define USE_YUV 1

@protocol YTAGReflectDeviceDelegate <NSObject>
//设置camera的曝光时间和iso
- (void)setCameraSettings:(long)expTime1000thSec iso:(int)isoValue;
//用于获取iso等摄像头信息，该接口不会进行任何device设置，只会读取device信息;
- (AVCaptureDevice *)getCaptureDevice;
@end

@protocol CameraVideoDeviceDelegate <NSObject>

- (void)cameraDeviceEvent:(CameraDeviceEvent)event withAguments:(NSDictionary *)args;

@end

/**
 CameraDevice
 */
@interface CameraDevice : NSObject<YTAGReflectDeviceDelegate>
/// CameraVideoDeviceDelegate 代理
@property (nonatomic, weak) NSObject<CameraVideoDeviceDelegate> *delegate;
/// AVCaptureSession
@property (nonatomic, retain) AVCaptureSession *session;
/// 是否运行
@property (nonatomic, assign) BOOL running;
///Camera暂停
@property (nonatomic, assign) BOOL pause;
/// AVCaptureDevicePosition
@property (nonatomic, assign) AVCaptureDevicePosition position;
///AVCaptureFocusMode
@property (nonatomic, assign) AVCaptureFocusMode focusMode;
///聚焦点
@property (nonatomic, assign) CGPoint focusPoint;
///AVCaptureExposureMode
@property (nonatomic, assign) AVCaptureExposureMode exposureMode;
///exposurePoint
@property (nonatomic, assign) CGPoint exposurePoint;
///CameraFlashMode
@property (nonatomic, assign) CameraFlashMode flashMode;
///AVCaptureWhiteBalanceMode
@property (nonatomic, assign) AVCaptureWhiteBalanceMode whiteBalanceMode;
// Added by starime
//@property (nonatomic, assign) BOOL isAdjustingWhiteBalance;
///deviceISO
@property (nonatomic, assign) CGFloat deviceISO;
///device_minISO
@property (nonatomic, assign) CGFloat device_minISO;
///device_maxISO
@property (nonatomic, assign) CGFloat device_maxISO;
///deviceAperture
@property (nonatomic, assign) CGFloat deviceAperture;
///deviceExposureDuration
@property (nonatomic, assign) CMTime deviceExposureDuration;
///isCustomExposureSupported
@property (nonatomic, assign) BOOL isCustomExposureSupported;
// Added by starime
@property (nonatomic, assign) BOOL lowLightBoost;
///是否有手电筒
@property (nonatomic, assign, readonly) BOOL hasFlash;
///是否有前置摄像头
@property (nonatomic, assign, readonly) BOOL hasFront;
///captureSession
@property (nonatomic, strong) AVCaptureSession *captureSession;


/////////////////////////////////////////////
// Public
- (id)initWithSessionPreset:(NSString *)preset cameraPosition:(AVCaptureDevicePosition)position;
+ (BOOL)deviceDenied;
- (void)startDevice;
- (void)stopDevice;
- (void)setCameraSettings:(long)expTime1000thSec iso:(int)isoValue; // Added by starime

/////////////////////////////////////////////
// Protected
- (void)restartDevcie;
- (dispatch_queue_t)deviceQueue;
- (void)beginConfiguration;
- (void)commitConfiguration;

@end
