//
//  CameraRecordDevice.h
//  FaceVideo
//
//  Created by Patrick Yang on 15/7/22.
//  Copyright © 2015年 Tencent. All rights reserved.
//
#import "CameraDevice.h"

typedef void (^onGetBrightness)(float value);
/**
 CameraRecordDevice
 */
@interface CameraRecordDevice : CameraDevice

/**
 视频预览layer
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
///onGetGrightness
@property (nonatomic, strong) onGetBrightness onGetGrightness;
///onGetGrightness_showLux
@property (nonatomic, strong) onGetBrightness onGetGrightness_showLux;

- (void)startDetectBrightness:(onGetBrightness)onGet;
- (void)stopDetectBrightness;

- (void)startDetectBrightness_showLux:(onGetBrightness)onGet;
- (void)stopDetectBrightness_showLux;

- (id)initWithPosition:(AVCaptureDevicePosition)position;

- (void)startRecord;
- (void)stopRecord;

@end
