//
//  CameraTypes.h
//  MyCam
//
//  Created by Patrick Yang on 13-8-28.
//  Copyright (c) 2013年 Microrapid. All rights reserved.
//

#ifndef MyCam_CameraTypes_h
#define MyCam_CameraTypes_h


//#define CameraExposureDurationBeauty    (-2)
//#define CameraExposureDurationClose     (-1)
//#define CAMERA_EXPOSURE_DURATION_AUTO      0
//#define CAMERA_EXPOSURE_DURATION1S        1
//#define CAMERA_EXPOSURE_DURATION2S        2
//#define CAMERA_EXPOSURE_DURATION4S        4
//#define CAMERA_EXPOSURE_DURATION8S        8

typedef enum {
    CameraDeviceEvent_Started = 0,
    CameraDeviceEvent_Stopped ,
    CameraDeviceEvent_Restarted,
//    CameraDeviceEvent_FrameStarted,
    CameraDeviceEvent_FrameReceived,
    CameraDeviceEvent_PositionChanged,
//    CameraDeviceEvent_FlashModeSetted,
    CameraDeviceEvent_FocusBegan,
    CameraDeviceEvent_FocusEnded,
//    CameraDeviceEvent_ExposureBegan,
//    CameraDeviceEvent_ExposureEnded,
    CameraRecordEvent_Start,
    CameraRecordEvent_Stop,
} CameraDeviceEvent;

typedef enum {
    CameraFlashModeAuto   = 0,
    CameraFlashModeOff    = 1,
    CameraFlashModeOn     = 2,
    CameraFlashModeLight  = 3,
    CameraFlashModeNone   = 4,
} CameraFlashMode;



#endif
